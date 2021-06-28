//
//  Constants.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 3/22/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import UIKit

// sourcepoint notification Identifiers
struct SourcepointNotificationIdentifier {
    static let managedObjectsContextDidChangeNotificationIdentiifer = "managedObjectsContextDidChangeNotificationIdentiifer"
    static let managedObjectsUpdatedInContextNotificationIdentiifer = "managedObjectsUpdatedInContextNotificationIdentiifer"
    static let newManagedObjectsInsertedInContextNotificationIdentifier = "newManagedObjectsInsertedInContextNotificationIdentifier"
    static let contextDeletedManagedObjectsNotificationIdentifier = "contextDeletedManagedObjectsNotificationIdentifier"
}

struct SPMetaError {
    var code: Int = 0
    let description: String
    let message: String
}

struct SPLiteral {
    static let emptyString = ""
    static let accountID = "Account ID: "
    static let campaign = "Campaign: "
    static let consentUUID = "ConsentUUID not available"
    static let euConsentID = "EUConsent not available"
    static let stageEnv = "Stage"
    static let publicEnv = "Public"
    static let webMessage = "Web Message"
    static let nativeMessage = "Native Message"
    static let alertView = "alertView"
    static let gdprCampaign = "GDPR Campaign"
    static let ccpaCampaign = "CCPA Campaign"
    static let iOS14Campaign = "iOS14 Campaign"
    static let CampaignTableViewCell = "CampaignTableViewCell"
    static let CampaignListCell = "CampaignListCell"
    static let gdprPMId = "GDPR PM ID:"
    static let ccpaPMId = "CCPA PM ID:"
    static let pmID = "PM ID:"
    static let pmTab = "PM Tab:"
    static let campaignsTableViewHeight: CGFloat = 150
    static let campaignsTableViewExpandedHeight: CGFloat = 500
    static let iOS14CampaignviewHeight: CGFloat = 400
    static let campaignsTableViewRowHeight: CGFloat = 350
    static let iOS14CampaignRowHeight: CGFloat = 250
    static let headerViewHeight: CGFloat = 44
    static let campaignsTableView = 1
    static let campaignListTableview = 2
    static let pmIdTextField = 11
    static let pmTabTextField = 12
    static let targetingKeyTextField = 13
    static let targetingValueTextField = 14

    static func attributedString() -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: "This will clear data for ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                attributedText.append(NSAttributedString(string: "all properties", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
            }else {
                attributedText.append(NSAttributedString(string: "all properties", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]))
            }
        } else {
            attributedText.append(NSAttributedString(string: "all properties", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]))
        }
        attributedText.append(NSAttributedString(string: "\nDo you want to proceed?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        return attributedText
    }
}

// MARK: - Alert Constants
struct Alert {

    static let messageForPropertyUnavailability = NSLocalizedString("Please enter property details", comment: "")
    static let messageForUnknownError = NSLocalizedString("Something went wrong, please try again", comment: "")
    static let messageForWrongAccountId = NSLocalizedString("Please enter correct Account Id", comment: "")
    static let consentMessageShown = NSLocalizedString("Consent message is already shown", comment: "")
    static let messageForPropertyStored = NSLocalizedString("Property details are already stored", comment: "")
    static let messageStagingCompaignIncorrectData  = NSLocalizedString("Staging compaign data is incorrect", comment: "")
    static let messageAlreadyShown  = NSLocalizedString("There is no message matching the scenario based on the property info and device local data. \nConsider reviewing the property info or clearing the cookies. \nIf that was intended, just ignore this message.", comment: "")
    static let messageAlreadyShownOrIncorrectCampaign  = NSLocalizedString("Message will not be shown.\nEither the scenario decided that no message should be displayed or \n the property you're creating has a public|staging campaign and you set it as staging|public", comment: "")
    static let messageForEmptyTargetingParamError = NSLocalizedString("Please enter targeting parameter key and value", comment: "")
    static let messageForDeletingPropertyData = NSLocalizedString("Are you sure you want to delete this property?", comment: "")
    static let messageForSaveCampaign = NSLocalizedString("This will save the campaign data \nDo you want to proceed?", comment: "")

    // Alert actions
    static let alert = NSLocalizedString("Alert", comment: "")
    static let ok = NSLocalizedString("Ok".uppercased(), comment: "")
    static let cancel = NSLocalizedString("Cancel".uppercased(), comment: "")
    static let yes = NSLocalizedString("YES".uppercased(), comment: "")
    static let no = NSLocalizedString("NO".uppercased(), comment: "")
    static let message = NSLocalizedString("Message".uppercased(), comment: "")
    static let showPropertyInfo = NSLocalizedString("Show Property Info".uppercased(), comment: "")
    static let clearCookies = NSLocalizedString("Clear Cookies".uppercased(), comment: "")

}
