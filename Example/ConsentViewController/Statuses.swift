//
//  Statuses.swift
//  ConsentViewController_Example
//
//  Created by Andre Herculano on 02.02.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

enum VendorStatus: String {
    case Accepted
    case Rejected
    case Unknown

    init(fromBool bool: Bool?) {
        if bool == nil {
            self = .Unknown
        } else if bool == false {
            self = .Rejected
        } else {
            self = .Accepted
        }
    }
}

enum SDKStatus: String {
    case notStarted = "Not Started"
    case running = "Running"
    case finished = "Finished"
    case errored = "Errored"
}
