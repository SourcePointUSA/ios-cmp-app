//
//  SourcepointClientCoordinator.swift
//  Pods
//
//  Created by Andre Herculano on 14.09.22.
//

import Foundation

typealias MessagesAndConsentHandler = (Result<([MessageToDisplay]?, SPUserData), SPError>) -> Void

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

class SourcepointClientCoordinator {
    struct State {
        struct GDPRMetaData {
            var additionsChangeDate, legalBasisChangeDate: SPDateCreated
        }

        struct Campaign<StatusType> {
            var uuid: String
            var consentStatus: StatusType
            var applies: Bool
            var dateCreated: SPDateCreated
        }

        let authId: String?
        var gdpr: Campaign<ConsentStatus>?
        var ccpa: Campaign<CCPAConsentStatus>?
        var gdprMetadata: GDPRMetaData?
        var wasSampled: Bool?

        mutating func udpateGDPRStatus(_ newStatus: ConsentStatus) {
            guard let gdpr = gdpr, let gdprMetadata = gdprMetadata else { return }
            if gdpr.dateCreated.date < gdprMetadata.additionsChangeDate.date ||
                gdpr.dateCreated.date < gdprMetadata.legalBasisChangeDate.date {
                if let consentedToAll = newStatus.consentedAll, consentedToAll {
                    self.gdpr?.consentStatus.granularStatus?.previousOptInAll = true
                    self.gdpr?.consentStatus.consentedAll = false // TODO: Double check with Dan
                }
            }
        }
    }

    let accountId, propertyId: Int
    let propertyName: SPPropertyName
    let authId: String?
    let language: SPMessageLanguage
    let idfaStatus: SPIDFAStatus
    let campaigns: SPCampaigns
    let spClient: SourcePointProtocol
    var storage: SPLocalStorage
    var state: State
    var localDataComplete: Bool { false }
    var shouldCallConsentStatus: Bool {
        authId != nil ||
        ((state.gdpr?.uuid != nil || state.ccpa?.uuid != nil) && !localDataComplete)
    }
    var isNewUser: Bool {
        state.gdpr?.uuid == nil && state.ccpa?.uuid == nil // TODO: Check if this logic is correct
    }
    var shouldCallMessages: Bool {
        isNewUser ||
        (state.gdpr?.applies == true && state.gdpr?.consentStatus.consentedAll == false) ||
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
            authId: authId,
            gdpr: nil,
            ccpa: nil
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

    func loadMessage(_ handler: @escaping MessagesAndConsentHandler) {
        metaData()
        consentStatus()
        messages(handler)
        pvData()
    }

    func metaData() {
        // spClient.metadata
        // handle metadata response
        // - update vendor list info?
        // - what do I do with this info?
        // - update localState
    }

    func consentStatusMetadataFromState<T>(_ campaign: State.Campaign<T>?) -> ConsentStatusMetaData.Campaign? {
        guard let campaign = campaign else { return nil }
        return ConsentStatusMetaData.Campaign(
            hasLocalData: false, // TODO: ask Sid what `hadLocalData` mean.
            applies: campaign.applies,
            dateCreated: campaign.dateCreated,
            uuid: campaign.uuid
        )
    }

    func handleConsentStatusResponse(_ response: ConsentStatusResponse) {
        storage.localState = response.localState
        if state.gdpr?.applies == true,
           let status = response.consentStatusData.gdpr?.consentStatus {
            state.udpateGDPRStatus(status)
        }
    }

    func consentStatus() {
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
            }
        }
    }

    func handleMessagesResponse(_ response: MessagesResponse) {
        storage.localState = response.localState
        storage.nonKeyedLocalStorage = response.nonKeyedLocalState
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
                            hasLocalData: false,
                            status: state.ccpa?.consentStatus
                        ),
                        gdpr: .init(
                            targetingParams: campaigns.gdpr?.targetingParams,
                            hasLocalData: false,
                            consentStatus: state.gdpr?.consentStatus
                        ),
                        ios14: .init(
                            targetingParams: campaigns.ios14?.targetingParams,
                            idfaSstatus: idfaStatus
                        )
                    ),
                    localState: storage.localState,
                    consentLanguage: language,
                    campaignEnv: campaigns.environment,
                    idfaStatus: idfaStatus
                ),
                metadata: .init(
                    ccpa: .init(applies: state.ccpa?.applies),
                    gdpr: .init(applies: state.gdpr?.applies)
                ),
                nonKeyedLocalState: storage.nonKeyedLocalStorage
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
            handler(Result.success((nil, consents)))
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
