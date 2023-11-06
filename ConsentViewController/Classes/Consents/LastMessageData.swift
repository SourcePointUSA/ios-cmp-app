//
//  LastMessageData.swift
//  Pods
//
//  Created by Andre Herculano on 06.11.23.
//

import Foundation

struct LastMessageData: Codable {
    var id, categoryId, subCategoryId: Int
    var partitionUUID: String
}

extension LastMessageData {
    init?(from metadata: MessageMetaData?) {
        guard let metadata = metadata else { return nil }

        id = Int(metadata.messageId) ?? 0
        categoryId = metadata.categoryId.rawValue
        subCategoryId = metadata.subCategoryId.rawValue
        partitionUUID = metadata.messagePartitionUUID ?? ""
    }
}
