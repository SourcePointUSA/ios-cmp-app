//
//  TelemetryProtocol.swift
//  ConsentViewController
//
//  Created by Vilas on 12/3/19.
//

import Foundation

@objc protocol TelemetryProtocol {
    func telemetryAnalytics(error: ConsentViewControllerError)
}
