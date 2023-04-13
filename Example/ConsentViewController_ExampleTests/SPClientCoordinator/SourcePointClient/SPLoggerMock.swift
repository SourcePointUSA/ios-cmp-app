//
//  SPLoggerMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 11.04.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

struct SPLoggerMock: SPLogger {
    func log(_ message: String) {}

    func debug(_ message: String) {}

    func error(_ message: String) {}
}
