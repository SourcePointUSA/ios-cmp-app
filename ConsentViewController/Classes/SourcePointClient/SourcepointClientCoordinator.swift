//
//  SourcepointClientCoordinator.swift
//  Pods
//
//  Created by Andre Herculano on 14.09.22.
//

import Foundation

typealias MessagesAndConsentHandler = (Result<([MessageToDisplay], SPUserData), SPError>) -> Void

struct MessageToDisplay {
    let message: Message
    let metadata: MessageMetaData
    let url: URL
    let type: SPCampaignType
    let childPmId: String?
}

extension MessageToDisplay {
    init?(_ campaign: Campaign) {
        guard let message = campaign.message,
                let metadata = campaign.messageMetaData,
                let url = campaign.url
        else {
            return nil
        }

        self.message = message
        self.metadata = metadata
        self.url = url
        self.type = campaign.type
        switch campaign.userConsent {
            case .ccpa(let consents): childPmId = consents.childPmId
            case .gdpr(let consents): childPmId = consents.childPmId
            default: childPmId = nil
        }
    }
}

protocol SPClientCoordinator {
    var authId: String? { get set }

    func loadMessages(_ handler: @escaping MessagesAndConsentHandler)
    func reportAction(_ action: SPAction, handler: @escaping (Result<SPUserData, SPError>) -> Void)
}

class SourcepointClientCoordinator: SPClientCoordinator {
    struct State: Codable {
        struct GDPRMetaData: Codable {
            var additionsChangeDate, legalBasisChangeDate: SPDateCreated
        }

        struct Campaign: Codable {
            var uuid: String?
            var consentStatus: ConsentStatus?
            var applies: Bool?
            var dateCreated: SPDateCreated?
            var ccpaStatus: CCPAConsentStatus?
        }

        var gdpr, ccpa: Campaign?
        var gdprMetadata: GDPRMetaData?
        var wasSampled: Bool?
        var localState: SPJson?
        var nonKeyedLocalState: SPJson?

        mutating func udpateGDPRStatus() {
            guard
                let gdpr = gdpr,
                let gdprMetadata = gdprMetadata,
                let dateCreated = gdpr.dateCreated
            else { return }
            if dateCreated.date < gdprMetadata.additionsChangeDate.date {
                self.gdpr?.consentStatus?.vendorListAdditions = true
            }
            if dateCreated.date < gdprMetadata.legalBasisChangeDate.date {
                self.gdpr?.consentStatus?.legalBasisChanges = true
            }
            if let consentedToAll = self.gdpr?.consentStatus?.consentedAll,
               consentedToAll,
               (dateCreated.date < gdprMetadata.additionsChangeDate.date ||
                dateCreated.date < gdprMetadata.legalBasisChangeDate.date) {
                self.gdpr?.consentStatus?.granularStatus?.previousOptInAll = true
                self.gdpr?.consentStatus?.consentedAll = false
            }
        }
    }

    let accountId, propertyId: Int
    let propertyName: SPPropertyName
    var authId: String?
    let language: SPMessageLanguage
    let idfaStatus: SPIDFAStatus
    let campaigns: SPCampaigns

    let spClient: SourcePointProtocol
    var storage: SPLocalStorage

    var state: State

    /// Checks if this user has data from the previous version of the SDK (v6).
    /// This check should only done once so we remove the data stored by the older SDK and return false after that.
    var migratingUser: Bool {
        if storage.localState != nil {
            storage.localState = nil
            return true
        }
        return false
    }

    var shouldCallConsentStatus: Bool {
        authId != nil || migratingUser
    }

    var shouldCallMessages: Bool {
        (state.gdpr?.applies == true && state.gdpr?.consentStatus?.consentedAll == false) ||
        state.ccpa?.applies == true ||
        campaigns.ios14 != nil
    }

    init(
        accountId: Int,
        propertyName: SPPropertyName,
        propertyId: Int,
        authId: String? = nil,
        language: SPMessageLanguage = .BrowserDefault,
        campaigns: SPCampaigns,
        idfaStatus: SPIDFAStatus = .unknown,
        storage: SPLocalStorage = SPUserDefaults(),
        spClient: SourcePointProtocol? = nil
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.authId = authId
        self.language = language
        self.campaigns = campaigns
        self.idfaStatus = idfaStatus
        self.storage = storage

        self.state = State(
            gdpr: .init(consentStatus: ConsentStatus()),
            ccpa: .init()
        )

        guard let spClient = spClient else {
            self.spClient = SourcePointClient(
                accountId: accountId,
                propertyName: propertyName,
                campaignEnv: campaigns.environment,
                timeout: SPConsentManager.DefaultTimeout
            )
            return
        }
        self.spClient = spClient
    }

    func loadMessages(_ handler: @escaping MessagesAndConsentHandler) {
        metaData {
            self.consentStatus {
                self.state.udpateGDPRStatus()
                self.messages(handler)
            }
        }
        pvData()
    }

    func handleMetaDataResponse(_ response: MetaDataResponse) {
        if let gdprMetaData = response.gdpr {
            state.gdpr?.applies = gdprMetaData.applies
            state.gdprMetadata = .init(
                additionsChangeDate: gdprMetaData.additionsChangeDate,
                legalBasisChangeDate: gdprMetaData.legalBasisChangeDate
            )
        }
        if let ccpaMetaData = response.ccpa {
            state.ccpa?.applies = ccpaMetaData.applies
        }
    }

    func metaData(next: @escaping () -> Void) {
        spClient.metaData(
            accountId: accountId,
            propertyId: propertyId,
            metadata: .init(
                gdpr: .init(
                    hasLocalData: state.gdpr?.uuid != nil,
                    dateCreated: state.gdpr?.dateCreated,
                    uuid: state.gdpr?.uuid
                ),
                ccpa: .init(
                    hasLocalData: state.ccpa?.uuid != nil,
                    dateCreated: state.ccpa?.dateCreated,
                    uuid: state.ccpa?.uuid
                )
            )
        ) { [weak self] result in
            switch result {
                case .success(let response):
                    self?.handleMetaDataResponse(response)
                case .failure(let error):
                    print(error)
            }
            next()
        }
    }

    func consentStatusMetadataFromState(_ campaign: State.Campaign?) -> ConsentStatusMetaData.Campaign? {
        guard let campaign = campaign else { return nil }
        return ConsentStatusMetaData.Campaign(
            hasLocalData: true,
            applies: campaign.applies ?? false,
            dateCreated: campaign.dateCreated,
            uuid: campaign.uuid
        )
    }

    func handleConsentStatusResponse(_ response: ConsentStatusResponse) {
        state.localState = response.localState
        if let gdpr = response.consentStatusData.gdpr {
            state.gdpr?.consentStatus = gdpr.consentStatus
            state.gdpr?.dateCreated = gdpr.dateCreated
            state.gdpr?.uuid = gdpr.uuid
            // TODO: update GDPR consents
        }
        if let ccpa = response.consentStatusData.ccpa {
            state.ccpa?.ccpaStatus = ccpa.status
            state.ccpa?.dateCreated = ccpa.dateCreated
            state.ccpa?.uuid = ccpa.uuid
            // TODO: update CCPA consents
        }
    }

    func consentStatus(next: @escaping () -> Void) {
        if shouldCallConsentStatus {
            spClient.consentStatus(
                propertyId: propertyId,
                metadata: .init(
                    gdpr: consentStatusMetadataFromState(state.gdpr),
                    ccpa: consentStatusMetadataFromState(state.ccpa)
                ),
                authId: authId
            ) { [weak self] result in
                switch result {
                    case .success(let response):
                        self?.handleConsentStatusResponse(response)
                    case .failure(let error):
                        print(error)
                }
                next()
            }
        } else {
            next()
        }
    }

    func handleMessagesResponse(_ response: MessagesResponse) {
        state.localState = response.localState
        state.nonKeyedLocalState = response.nonKeyedLocalState
    }

    func messages(_ handler: @escaping MessagesAndConsentHandler) {
        if shouldCallMessages {
            spClient.getMessages(.init(
                body: .init(
                    propertyHref: propertyName,
                    accountId: accountId,
                    campaigns: .init(
                        ccpa: .init(
                            targetingParams: campaigns.gdpr?.targetingParams,
                            hasLocalData: state.ccpa?.uuid != nil,
                            status: state.ccpa?.ccpaStatus
                        ),
                        gdpr: .init(
                            targetingParams: campaigns.gdpr?.targetingParams,
                            hasLocalData: state.gdpr?.uuid != nil,
                            consentStatus: state.gdpr?.consentStatus
                        ),
                        ios14: .init(
                            targetingParams: campaigns.ios14?.targetingParams,
                            idfaSstatus: idfaStatus
                        )
                    ),
                    localState: state.localState,
                    consentLanguage: language,
                    campaignEnv: campaigns.environment,
                    idfaStatus: idfaStatus
                ),
                metadata: .init(
                    ccpa: .init(applies: state.ccpa?.applies),
                    gdpr: .init(applies: state.gdpr?.applies)
                ),
                nonKeyedLocalState: state.nonKeyedLocalState
            )) { [weak self] result in
                switch result {
                    case .success(let response):
                        self?.handleMessagesResponse(response)
                        let messages = response.campaigns.compactMap { MessageToDisplay($0) }
                        let consents = SPUserData()
//                        let consents = SPUserData(response.campaigns) // TODO: implement this mapping
                        handler(Result.success((messages, consents)))
                    case .failure(let error):
                        handler(Result.failure(error))
                }
            }
        } else {
            let consents = SPUserData()
//            let consents = SPUserData(response.campaigns) // TODO: implement this mapping
            handler(Result.success(([], consents)))
        }
    }

    func sample(_ lambda: (Bool) -> Void, at percentage: Int = 1) {
        let hit = 1...percentage ~= Int.random(in: 1...100)
        lambda(hit)
    }

    func pvData() {
        guard let wasSampled = state.wasSampled else {
            sample { hit in
                if hit {
//                    spClient.pvData()
                }
                state.wasSampled = hit
            }
            return
        }

        if wasSampled {
//            spClient.pvData()
        }
    }

    func reportAction(_ action: SPAction, handler: @escaping (Result<SPUserData, SPError>) -> Void) {
        switch action.type {
            case .AcceptAll, .RejectAll, .SaveAndExit:
                // spClient.getChoice(action.type, pmPayload) {
//                    handleChoiceResponse
//                    handler(Result.success(SPUserData))
//              }
//                POST choice
//                flag if POST failed to sync later
                print("choice")
            default: break
        }
    }
}
