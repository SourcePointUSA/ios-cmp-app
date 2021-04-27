//
//  IDFAStatusReportRequest.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 27.04.21.
//

import Foundation

struct AppleTrackingPayload: Codable {
    let appleMsgId: Int
    let appleChoice: SPIDFAStatus
}

struct IDFAStatusReportRequest: Codable {
    let accountId, propertyId: Int
    let uuid: String?
    let uuidType: SPCampaignType?
    let requestUUID: UUID
    let appleTracking: AppleTrackingPayload
}

extension IDFAStatusReportRequest {
    init(accountId: Int, propertyId: Int, uuid: String?, uuidType: SPCampaignType?, requestUUID: UUID, messageId: Int, idfaStatus: SPIDFAStatus) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.uuid = uuid
        self.uuidType = uuidType
        self.requestUUID = requestUUID
        appleTracking = AppleTrackingPayload(appleMsgId: messageId, appleChoice: idfaStatus)
    }
}
