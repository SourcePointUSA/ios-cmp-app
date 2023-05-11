//
//  After.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 11.05.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Nimble

func after(_ interval: DispatchTimeInterval, handler: @escaping () -> Void) {
    waitUntil { done in
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            handler()
            done()
        }
    }
}
