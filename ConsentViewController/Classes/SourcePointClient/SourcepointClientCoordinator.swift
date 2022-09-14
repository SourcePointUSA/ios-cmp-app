//
//  SourcepointClientCoordinator.swift
//  Pods
//
//  Created by Andre Herculano on 14.09.22.
//

import Foundation

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
        state.gdpr?.uuid != nil || state.ccpa?.uuid != nil // TODO: Check if this logic is correct
    }
    var shouldFetchMessage: Bool {
        isNewUser // TODO: Todo
    }

    init(
        accountId: Int,
        propertyName: SPPropertyName,
        propertyId: Int,
        authId: String? = nil,
        campaigns: SPCampaigns,
        idfaStatus: SPIDFAStatus = .unknown,
        storage: SPLocalStorage = SPUserDefaults(),
        spClient: SourcePointProtocol? = nil
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.authId = authId
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

    func loadMessage() {
        metaData()
        consentStatus()
    }

    func metaData() {
        // spClient.metadata
        // handle metadata response
        // - update vendor list info?
        // - what do I do with this info?
    }

    func consentStatusMetadataFromState<T>(_ campaign: State.Campaign<T>?) -> ConsentStatusMetaData.Campaign? {
        guard let campaign = campaign else { return nil }
        return ConsentStatusMetaData.Campaign(
            hasLocalData: true, // TODO: ask Sid what `hadLocalData` mean.
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
                metadata: ConsentStatusMetaData(
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
}
