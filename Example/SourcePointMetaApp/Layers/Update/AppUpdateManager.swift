//
//  AppUpdateManager.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 08/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

protocol BundleType {
    func object(forInfoDictionaryKey key: String) -> Any?
}

extension Bundle: BundleType {}

class AppUpdateManager {

    // MARK: - Enumerations
    enum Status {
        case optional
        case noUpdate
    }

    private let bundle: BundleType

    init(bundle: BundleType = Bundle.main) {
        self.bundle = bundle
    }

    func updateStatus(for bundleId: String) -> (Status, Int?) {

        let appVersionKey = "CFBundleShortVersionString"
        guard let appVersionValue = bundle.object(forInfoDictionaryKey: appVersionKey) as? String else {
            return (.noUpdate, nil)
        }
        guard let appVersion = try? Version(from: appVersionValue) else {
            return (.noUpdate, nil)
        }

        // Get app info from App Store
        let iTunesURL = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleId)")
        guard let url = iTunesURL, let data = NSData(contentsOf: url) else {
            return (.noUpdate, nil)
        }
        guard let response = try? JSONDecoder().decode(iTunesInfo.self, from: data as Data) else {
            return (.noUpdate, nil)
        }

        guard response.results.count == 1, let appInfo = response.results.first else {
            return (.noUpdate, nil)
        }

        let appStoreVersion = appInfo.version
        if appStoreVersion.major > appVersion.major || appStoreVersion.minor > appVersion.minor ||  appStoreVersion.patch > appVersion.patch {
            return (.optional, appInfo.trackId)
        }
        return (.noUpdate, nil)
    }
}
