//
//  ConnectivityMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 17.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class ConnectivityMock: Connectivity {
    let isConnected: Bool
    init(connected: Bool) {
        isConnected = connected
    }
    func isConnectedToNetwork() -> Bool {
        return isConnected
    }
}
