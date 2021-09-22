//
//  AppInfo.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 08/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

struct iTunesInfo: Decodable {
    var results: [AppInfo]
}

struct AppInfo: Decodable {
    var version: Version
    var trackId: Int
}

struct Version: Decodable {

    enum VersionError: Error {
        case invalidFormat
    }

    let major: Int
    let minor: Int
    let patch: Int

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            let version = try container.decode(String.self)
            try self.init(from: version)
        } catch {
            throw VersionError.invalidFormat
        }
    }

    init(from version: String) throws {
        let versionComponents = version.components(separatedBy: ".").map { Int($0) }
        guard versionComponents.count == 3 else {
            throw VersionError.invalidFormat
        }
        guard let major = versionComponents[0], let minor = versionComponents[1], let patch = versionComponents[2] else {
                throw VersionError.invalidFormat
        }
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

