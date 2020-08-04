//
//  SourcePointMetaAppUITests.swift
//  SourcePointMetaAppUITests
//
//  Created by Vilas on 28/07/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
import CoreData
@testable import GDPR_MetaApp

class SourcePointMetaAppUITests: QuickSpec {
    var app: MetaApp!
    var properyData = PropertyData()

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = MetaApp()
            Nimble.AsyncDefaults.Timeout = 20
            Nimble.AsyncDefaults.PollInterval = 0.5
        }

        afterSuite {
            Nimble.AsyncDefaults.Timeout = 1
            Nimble.AsyncDefaults.PollInterval = 0.01
        }

        beforeEach {
            self.app.relaunch(clean: true)
        }

        func initialSetup() {
            deleteProperty()
            expect(self.app.propertyList).to(showUp())
            self.app.addPropertyButton.tap()
            expect(self.app.newProperty).to(showUp())
            self.app.accountIDTextFieldOutlet.tap()
            self.app.accountIDTextFieldOutlet.typeText(self.properyData.accountId)
            self.app.propertyIdTextFieldOutlet.tap()
            self.app.propertyIdTextFieldOutlet.typeText(self.properyData.propertyId)
            self.app.propertyTextFieldOutlet.tap()
            self.app.propertyTextFieldOutlet.typeText(self.properyData.propertyName)
            self.app.pmTextFieldOutlet.tap()
            self.app.pmTextFieldOutlet.typeText(self.properyData.pmID)
        }

        func deleteProperty() {
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.deletePropertyButton.tap()
                if self.app.alertYesButton.exists {
                    self.app.alertYesButton.tap()
                }
            }
        }

        func dateFormatterForAuthID() -> String {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d yyyy, h:mm:ss"
            let formattedDateInString = formatter.string(from: date)
            return formattedDateInString
        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user select Accept all then user will navigate to Site Info screen showing ConsentUUID, EUConsent and all Vendors & Purpose Consents when user navigate back & tap on the site name and select MANAGE PREFERENCES button from consent message view then user will see all vendors & purposes as selected")
         */
        it("3. Accept all from Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 1).to(beTrue())

        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user select Reject all then user will navigate to Site Info screen showing ConsentUUID and no EUConsent and with no Vendors & Purpose Consents when user navigate back & tap on the site name and select MANAGE PREFERENCES button from consent message view then user will see all vendors & purposes as not selected/rejected")
         */
        it("4. Reject all from Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.rejectAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 0).to(beTrue())
        }

        /**
         @Description - User submit valid property details and tap on save then the expected consent message should display and when user click on MANAGE PREFERENCES/show options button then user will see Privacy Manager screen when user select Accept All then user will navigate to Site Info screen showing ConsentUUID, EUConsent and all Purpose Consents when user navigate back and tap on the site name And click on MANAGE PREFERENCES button from consent message then user should see all purposes are selected
         */
        it("1. Accept all from Privacy Manager via Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 1).to(beTrue())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user select MANAGE PREFERENCES then user navigate to PM and should see all toggles as false when user select Save & Exit without any change then user should navigate back to the info screen showing no Vendors and Purposes as selected
         */
        it("6. Save and Exit without any purposes selected from Privacy Manager via Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.saveAndExitButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 0).to(beTrue())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user tap on Accept All button then user navigate back to Info screen showing ConsentUUID and EUConsent data when user tap on the property from property list screen and navigate to PM, all consent toggle should show as selected when user tap on Reject all then should see same ConsentUUID and newly generated EUCONSENT data
         */

        it("5. Reject all from Privacy Manager via Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 1).to(beTrue())
            self.app.rejectAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 0).to(beTrue())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user select MANAGE PREFERENCES and tap from Accept All button then consent data should display on info screen when user navigate back and tap on the Property again then user should not see message again when user delete cookies for the property then user should see consent message again.
         */

        it("7. Show purpose consents after reset cookies") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingEnglishValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.resetPropertyButton.tap()
                if self.app.alertYesButton.exists {
                    self.app.alertYesButton.tap()
                }
            }
            expect(self.app.consentMessage).to(showUp())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user tap on Accept All then consent data should get stored when user navigate to PM directly by clicking on Show PM link and select Reject All then EUConsent information should get updated
         */
        it("8. Reject all from Privacy Manager directly") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 1).to(beTrue())
            self.app.rejectAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 0).to(beTrue())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected message should load when user select Accept All then consent information should get stored when user tap on the Show PM link and click on Cancel then user should navigate back to the info screen
         */

        it("9. Cancel from Privacy Manager directly") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.cancelButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }

        /**
         @Description - User submit valid property details to show message once and tap on Save then expected message should load when user select Accept All then consent should get stored when user tap on the property from list screen then user should not see message again
         */

        it("10. Show Message once with Accept all from Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKeyShowOnce)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingValueShowOnce)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected message should load When user select Reject All then consent information should get stored when user swipe on property and choose to delete user should able to delete the property screen
         */

        it("11. Delete Property from property list") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.rejectAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            deleteProperty()
            expect(self.app.propertyItem).notTo(showUp())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected message should load when user select Accept All then consent information should get stored when user swipe on property and edit the key/parameter details then user should see respective message
         */

        it("12. Edit Property from property list") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingEnglishValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.editPropertyButton.tap()
                expect(self.app.editProperty).to(showUp())
                self.app.targetingParamKeyTextFieldOutlet.tap()
                self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
                self.app.targetingParamValueTextFieldOutlet.tap()
                self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
                self.app.swipeUp()
                self.app.addTargetingParamButton.tap()
                self.app.savePropertyButton.tap()
                expect(self.app.consentMessage).to(showUp())
            }
        }

        /**
         @Description - User submit valid property details to show message once with AuthID and tap on Save Then expected message should load When user select Accept All then consent information should get stored when user reset the property then user should not see the message again
         */

        it("13. No Message shown with show once criteria when consent already saved with AuthID") {
            initialSetup()
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(dateFormatterForAuthID())
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingEnglishValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.resetPropertyButton.tap()
                if self.app.alertYesButton.exists {
                    self.app.alertYesButton.tap()
                }
            }
            expect(self.app.consentMessage).notTo(showUp())
        }


        /**
         @Description - User submit valid property details with unique AuthID and tap on Save then expected message should load when user navigate to PM and tap on Accept All then all consent data should be stored when user try to create new property with same details but another unique authId and navigate to PM then user should not see already saved consent
         */

        it("14. Changing AuthID will change the consents too") {
            initialSetup()
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(dateFormatterForAuthID())
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.addPropertyButton.tap()
            expect(self.app.newProperty).to(showUp())
            self.app.accountIDTextFieldOutlet.tap()
            self.app.accountIDTextFieldOutlet.typeText(self.properyData.accountId)
            self.app.propertyIdTextFieldOutlet.tap()
            self.app.propertyIdTextFieldOutlet.typeText(self.properyData.propertyId)
            self.app.propertyTextFieldOutlet.tap()
            self.app.propertyTextFieldOutlet.typeText(self.properyData.propertyName)
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(dateFormatterForAuthID())
            self.app.pmTextFieldOutlet.tap()
            self.app.pmTextFieldOutlet.typeText(self.properyData.pmID)
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 0).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 0).to(beTrue())
        }

        /**
         @Description - User submit valid property details with unique AuthID and tap on Save then expected Message should load when user navigate to PM and tap on Accept All then all consent data will get stored when user delete this property and create property with same details and navigate to PM then user should see already saved consents
         */

        it("15. Check consents with same AuthID after deleting and recreating property") {
            initialSetup()
            let authID = dateFormatterForAuthID()
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(authID)
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            initialSetup()
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(authID)
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 1).to(beTrue())
        }

        /**
         @Description - User submit valid property details tap on Save then expected message should load When user dismiss the message then user should see info screen with ConsentUUID details
         */
        it("16. Check ConsentUUID on Message Dismiss") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingEnglishValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.dismissMessageButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }

        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load
         */
        it("17. PM as first layer Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKeyForPMAsFirstLayer)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingValueForPMAsFirstLayer)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.privacyManager).to(showUp())

        }

        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load when user select Accept All then consent should get stored when user tap on the property from list screen and click on Cancel then user should navigate back to the info screen
         */
        it("18. Cancel from PM as first layer Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKeyForPMAsFirstLayer)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingValueForPMAsFirstLayer)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.cancelButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }

        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load when user select Accept All then consent should get stored when user tap on the Show PM link from the info screen then user should navigate to PM screen showing all toggle as selected
         */
        it("19. Consents for PM as first layer Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKeyForPMAsFirstLayer)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingValueForPMAsFirstLayer)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 1).to(beTrue())
        }


        /**
         @Description - User submit valid property details for loading PM as first layer message with unique AuthID and tap on Save then expected PM should load when user select Accept All then consent should get stored when user tap on the property from list screen then user should see all toggle as true
         */
        it("20. Consents with AuthID for PM as first layer Message") {
            initialSetup()
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(dateFormatterForAuthID())
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKeyForPMAsFirstLayer)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingValueForPMAsFirstLayer)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.privacyManager).to(showUp())
            expect(Int(self.app.PersonalisationSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.PersonalisedAdsSwitch.value as! String) == 1).to(beTrue())
            expect(Int(self.app.DeviceInformationSwitch.value as! String) == 1).to(beTrue())
        }

        /**
          @Description - User submit valid property details without AuthID and tap on Save then expected consent message should display when user select Accept all then user will navigate to Site Info screen showing ConsentUUID, EUConsent and all Vendors & Purpose Consents when user navigate back & edit property with unique AuthID then user should not see message again should see given consent information
         */

        it("21. When consents already given then Message will not appear with AuthID and consents will attach with AuthID") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKeyShowOnce)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingValueShowOnce)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.editPropertyButton.tap()
                expect(self.app.editProperty).to(showUp())
                self.app.authIdTextFieldOutlet.tap()
                self.app.authIdTextFieldOutlet.typeText(dateFormatterForAuthID())
                self.app.targetingParamKeyTextFieldOutlet.tap()
                self.app.savePropertyButton.tap()
                expect(self.app.propertyDebugInfo).to(showUp())
            }
        }


        /**
         @Description - User submit valid property details and tap on save then expected consent message should display when user click on MANAGE PREFERENCES/show options button then user will see Privacy Manager screen when user click on Cancel button then user will navigate back to the consent message
         */
        it("2. Cancel from privacy Manager via Message") {
            initialSetup()
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKey)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingFrenchValue)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.cancelButton.tap()
            expect(self.app.consentMessage).to(showUp())
        }

    }
}


