//
//  IDFAStatusReportRequest.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 27.04.21.
//

import Foundation

struct AppleTrackingPayload: Codable {
    let appleChoice: SPIDFAStatus
    let appleMsgId: Int?
    let messagePartitionUUID: String?

    enum CodingKeys: String, CodingKey {
        case appleChoice, appleMsgId
        case messagePartitionUUID = "partition_uuid"
    }
}

struct IDFAStatusReportRequest: Codable {
    let accountId: Int
    let propertyId: Int?
    let uuid: String?
    let uuidType: SPCampaignType?
    let requestUUID: UUID
    let iosVersion: String
    let appleTracking: AppleTrackingPayload
}

extension IDFAStatusReportRequest {
    init(
        accountId: Int,
        propertyId: Int?,
        uuid: String?,
        uuidType: SPCampaignType?,
        requestUUID: UUID,
        messageId: Int?,
        idfaStatus: SPIDFAStatus,
        iosVersion: String,
        messagePartitionUUID: String
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.uuid = uuid
        self.uuidType = uuidType
        self.requestUUID = requestUUID
        self.iosVersion = iosVersion
        appleTracking = AppleTrackingPayload(appleChoice: idfaStatus, appleMsgId: messageId, messagePartitionUUID: messagePartitionUUID)
    }
}
