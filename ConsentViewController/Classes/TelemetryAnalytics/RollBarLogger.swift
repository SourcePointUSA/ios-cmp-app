//
//  RollBarLogger.swift
//  ConsentViewController
//
//  Created by Vilas on 12/3/19.
//

import Foundation
import Rollbar

public class RollBarLogger: TelemetryProtocol {
    
    private let accountId: Int
    private let propertyId: Int
    private let showPM: Bool
    private let isTelemetryEnabled: Bool
    private let campaign: String
    private let sdkVersion: String
    private let messageTimeoutInSeconds: Double
    private let logger: Logger
    
    init(accountId: Int, propertyId:Int, showPM:Bool,isTelemetryEnabled: Bool, campaign: String, sdkVersion: String, messageTimeoutInSeconds:Double) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.showPM = showPM
        self.isTelemetryEnabled = isTelemetryEnabled
        self.campaign = campaign
        self.sdkVersion = sdkVersion
        self.messageTimeoutInSeconds = messageTimeoutInSeconds
        self.logger = Logger()
    }
    
    /// This method is used to send the details to rollbar analytics about the error message with other deatils.
    internal func rollBarAnalytics(error: ConsentViewControllerError) {
        if isTelemetryEnabled {
            let configuration = RollbarConfiguration()
            configuration.crashLevel = "critical"
            configuration.environment = "production"
            Rollbar.initWithAccessToken("8c9341f5b0cd4701b43fd06237b0b660", configuration: configuration)
            Rollbar.critical(withMessage: error.description, data: [
                "SDK_VERSION": sdkVersion,
                "accountId": accountId,
                "propertyId": propertyId,
                "campaign": campaign,
                "showPM": showPM,
                "messageTimeoutInSeconds": messageTimeoutInSeconds
            ])
        }else {
            logger.log("Rollbar is disabled by client application", [])
        }
    }
}
