package tests;

import static org.framework.logger.LoggingManager.logMessage;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.NoSuchElementException;
import org.framework.allureReport.TestListener;
import org.framework.pageObjects.MobilePageWrapper;
import org.testng.Reporter;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
import org.testng.asserts.SoftAssert;

import io.qameta.allure.Allure;
import io.qameta.allure.Description;
import tests.BaseTest;

@Listeners({ TestListener.class })
public class GDPR_TCFV2_MetaAppTests extends BaseTest {

	private static final DateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	String accountId = "808";
	String siteName = "tcfv2.automation.testing";
	String staggingValue = "OFF";
	String siteID = "7376";
	String pmID = "162636";
	String key = "language";
	String value = "fr";
	String authID;
	String expectedFRMessageTitle = "TCFv2 Message Title";
	String expectedFRMessageBody = "We and our partners require consent for the following purposes:";

	String expectedESMessageTitle = "TCF v2 Message Title for Language English";
	String expectedESMessageBody = "TCF V2 Message Body for Language English";

	String expectedShowOnceMessageTitle = "ShowOnce :We use cookies to give you the best experience";
	String expectedShowOnceMessageBody = "We and our partners require consent for the following purposes:";

	ArrayList<String> expectedShowOnlyMsg = new ArrayList<String>();

	public ArrayList<String> setExpectedShowOnlyMsg() {
		expectedShowOnlyMsg.add(expectedShowOnceMessageTitle);
		expectedShowOnlyMsg.add(expectedShowOnceMessageBody);
		return expectedShowOnlyMsg;
	}

	ArrayList<String> expectedFRConsentMsg = new ArrayList<String>();

	public ArrayList<String> setExpectedFRConsentMsg() {
		expectedFRConsentMsg.add(expectedFRMessageTitle);
		expectedFRConsentMsg.add(expectedFRMessageBody);
		return expectedFRConsentMsg;
	}

	ArrayList<String> expectedESConsentMsg = new ArrayList<String>();

	public ArrayList<String> setExpectedESConsentMsg() {
		expectedESConsentMsg.add(expectedESMessageTitle);
		expectedESConsentMsg.add(expectedESMessageBody);
		return expectedESConsentMsg;
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 1)
	@Description("Given user submit valid property details and tap on Save Then the expected \n"
			+ "	 consent message should display And When user click on MANAGE PREFERENCES \n"
			+ "	 button Then user will see Privacy Manager screen When user select Accept All \n"
			+ "	 Then user will navigate to Site Info screen showing ConsentUUID, EUConsent \n"
			+ "	 and all Purpose Consents When user navigate back and tap on the site name And \n"
			+ "	 click on MANAGE PREFERENCES button from consent message Then he/she should  \n"
			+ "	 see all purposes are selected")
	public void CheckAcceptAllFromPrivacyManage() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start :CheckAcceptAllFromPrivacyManager ");
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for expected message and navigate to Privacy Manager ");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");
			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");
			logMessage("Check for Privacy Manager");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager page not displayed.");

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated.");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated.");

			logMessage("Navigate back to the Privacy Manager and check for toggle buttons");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName,
					"Property not created.");
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not displayed.");

			// check for all purposes selected as true

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 2)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 consent should display When user click on MANAGE PREFERENCES button Then user\n"
			+ "	 will see Privacy Manager screen When user click on Cancel button Then user\n"
			+ "	 will navigate back to the consent message")
	public void CheckCancelFromPrivacyManager() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start :CheckCancleFromPrivacyManager");
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and navigatetp Privacy Manager screen");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			logMessage("Tap on Cancel from PM and verify user navigate back to message ");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not displayed");
			mobilePageWrapper.privacyManagerPage.scrollAndClick("Cancel");

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 3)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 consent message should display When user select Accept all Then user will\n"
			+ "	 navigate to Site Info screen showing ConsentUUID, EUConsent and all Vendors &\n"
			+ "	 Purpose Consents When user navigate back & tap on the site name and select\n"
			+ "	 MANAGE PREFERENCES button from consent message view Then he/she will see all\n"
			+ "	 vendors & purposes as selected")
	public void CheckConsentOnAcceptAllFromMessage() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start :CheckConsentOnAcceptAllFromMessage ");
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and tap on Accept All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			logMessage("Tap on the property agai and navigate to the PM");
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName,
					"Property not present");
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");
			logMessage("Verify all toggel buttons displayed as true");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not displayed");
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 4)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 consent message should display When user select Reject all Then user will\n"
			+ "	 navigate to Site Info screen showing ConsentUUID and no EUConsent and with no\n"
			+ "	 Vendors & Purpose Consents When user navigate back & tap on the site name and\n"
			+ "	 select MANAGE PREFERENCES button from consent message view Then he/she will\n"
			+ "	 see all vendors & purposes as selected")
	public void CheckConsentOnRejectAllFromMessage() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckConsentOnRejectAllFromMessage");
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and tap on Reject All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("REJECT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			logMessage("Tap on the property agian and navigate to PM");
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName,
					"Property not present");
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			logMessage("Verify all toggle button displated as false");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not displayed");

			// check PM data for all false
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 5)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 consent message should display When user tap on Accept All button Then user\n"
			+ "	 navigate back to Info screen showing ConsentUUID and EUConsent data When user\n"
			+ "	 tap on the property from property list screen And navigate to PM, all consent\n"
			+ "	 toggle should show as selected When user tap on Reject all Then should see\n"
			+ "	 same COnsentUUID and newly generated EUCONSENT data")
	public void CheckConsentOnRejectAllFromPM() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckConsentOnRejectAllFromPM");
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details..");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for the message and tap on Accept All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			logMessage("Tap on the property and navigate to PM");
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			logMessage("Verify all toggles are displayed as true");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");
			// check for all purposes selected as true

			logMessage("Tap on Reject All and verify for generated consent information");
			mobilePageWrapper.privacyManagerPage.scrollAndClick("Reject All");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not matching.");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not matching");
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0),
					"ConsentUUID not matching");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1),
					"EUConsent not matching");
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 6)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 consent message should display When user select MANAGE PREFERENCES Then user\n"
			+ "	 navigate to PM And should see all toggles as false When user select Save &\n"
			+ "	 Exit without any change Then user should navigate back to the info screen\n"
			+ "	 showing no Vendors and Purposes as selected")
	public void CheckConsentOnSaveAndExitFromPM() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckConsentOnSaveAndExitFromPM");
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and navigate to PM");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");
			// check for all purposes selected as false

			logMessage("Tap on Save & Exit and verify generated consent information");
			mobilePageWrapper.privacyManagerPage.tcfv2_SaveAndExitButton.click();
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 7)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 consent message should display When user select MANAGE PREFERENCES and tap\n"
			+ "	 from Accept All button Then consent data should display on info screen When\n"
			+ "	 user navigate back and tap on the Property again Then he/she should not see\n"
			+ "	 message again When user delete cookies for the property Then he.\\/she should\n"
			+ "	 see consent message again")
	public void CheckPurposeConsentAfterResetCookies() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckPurposeConsentAfterRestCookies");
		SoftAssert softAssert = new SoftAssert();
		String value = "en";
		setExpectedESConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and navigate to PM");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedESConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.tcfv2_ManagaePreferences.click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as false
			logMessage("Tap on Accept All");
			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "'ConsentUUID not matching");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not matching");
			logMessage("Reset property consent information and check all toggles are displayed as false ");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Reset");

			softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());

			mobilePageWrapper.consentViewPage.YESButton.click();
			mobilePageWrapper.consentViewPage.tcfv2_ManagaePreferences.click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");
			// check for all purposes selected as false

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 8)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 consent message should display When user tap on Accept All Then consent data\n"
			+ "	 should get stored When user navigate to PM directly by clicking on Show PM\n"
			+ "	 link And select Reject All Then EUConsent information should get updated")
	public void CheckConsentDataFromPrivacyManagerDirect() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckConsentDataFromPrivacyManagerDirect");
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details..");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and tap on Accept All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			logMessage("Tap on Show PM link and naviagte to PM direct");
			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

			logMessage("Tap on Reject all and verify consent information");
			mobilePageWrapper.privacyManagerPage.scrollAndClick("Reject All");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();
			logMessage("Verify all toggles as false by navigating to PM directly on clicking on Show PM link");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");
			// check for all purposes selected as false
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 9)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 message should load When user select Accept All Then consent information\n"
			+ "	 should get stored When user tap on the Show link And click on Cancel Then\n"
			+ "	 he/she should navigate back to the info screen")
	public void CheckCancelFromDirectPrivacyManager() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckCancelFromDirectPrivacyManager");
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and tap on Accept All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			logMessage("Navigate to PM directly on click of Show Link");
			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Cancel");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0),
					"ConsentUUID not matching");
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1),
					"EUConsent not matching");

			// check for all purposes selected as false

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 10)
	@Description("Given user submit valid property details to show message once and tap on\n"
			+ "	 Save Then expected message should load When user select Accept All Then\n"
			+ "	 consent should get stored When user tap on the property from list screen Then\n"
			+ "	 he/she should not see message again")
	public void CheckNoConsentMessageDisplayAfterShowSiteInfo() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start CheckNoConsentMessageDisplayAfterShowSiteInfo: ");
		SoftAssert softAssert = new SoftAssert();
		String key = "displayMode";
		String value = "appLaunch";
		setExpectedShowOnlyMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and tap on Accept All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedShowOnlyMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not matching");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not matching");
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			logMessage("Tap on the property again and check no message displayed");
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0),
					"ConsentUUID not matching");
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1),
					"EUConsent not matching");
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 11)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 message should load When user select Reject All Then consent information\n"
			+ "	 should get stored When user swipe on property and choose to delete he/she\n"
			+ "	 should able to delete the property screen")
	public void DeleteSite() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : DeleteSite");
		SoftAssert softAssert = new SoftAssert();
		String key = "language";
		String value = "fr";
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and click on Reject All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("REJECT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage());
			mobilePageWrapper.siteListPage.NOButton.click();

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");
			softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage());
			logMessage("Delete property and check property not present in list");

			mobilePageWrapper.siteListPage.YESButton.click();
			softAssert.assertFalse(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName));

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 12)
	@Description("Given user submit valid property details and tap on Save Then expected\n"
			+ "	 message should load When user select Accept All Then consent information\n"
			+ "	 should get stored When user swipe on property and edit the key/parameter\n"
			+ "	 details Then he/she should see respective message")
	public void EditSiteWithConsentGivenBefore() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : EditSiteWithConsentGivenBefore");
		String key = "language";
		String value = "en";
		SoftAssert softAssert = new SoftAssert();
		ArrayList<String> consentData;
		setExpectedESConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter proeprty details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and tap on Accept All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedESConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.tcfv2_AcceptAll.click();
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			logMessage("Update property with new details");
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Edit");

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, "fr");
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check message as per updated property details an tap on Accept All");
			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0),
					"ConSentUUID not matching");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not matching");
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 13)
	@Description("Given user submit valid property details to show message once with AuthID and\n"
			+ "	 tap on Save Then expected message should load When user select Accept All\n"
			+ "	 Then consent information should get stored When user reset the property Then\n"
			+ "	 user should not see the message again")
	public void CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved()
			throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start ; CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved");

		SoftAssert softAssert = new SoftAssert();
		String key = "displayMode";
		String value = "appLaunch";
		setExpectedShowOnlyMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details with unique authentication...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date = new Date();
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(sdf.format(date));

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for message and tap on Accept All");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedShowOnlyMsg),
					"Expected consent message not displayed");

			ArrayList<String> consentData;

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			logMessage("Reset property consent information and check for no message ");
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Reset");

			softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());
			mobilePageWrapper.consentViewPage.YESButton.click();
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 14)
	@Description("Given user submit valid property details with unique AuthID and tap on Save\n"
			+ "	 Then expected message should load When user navigate PM and tap on Accept All\n"
			+ "	 Then all consent data should be stored When user try to create new property\n"
			+ "	 with same details but another unique authId And navigate to PM Then he/she\n"
			+ "	 should not see already saved consent")
	public void CheckSavedConsentAlwaysWithSameAuthID() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start :CheckSavedConsentAlwaysWithSameAuthID");
		SoftAssert softAssert = new SoftAssert();
		String key = "language";
		String value = "fr";
		Date date = new Date();
		ArrayList<String> consentData;
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter proeprty details with unique authentication");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date1 = new Date();
			authID = sdf.format(date1);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			logMessage("Unique AuthID : " + authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			logMessage("Check for message and tap on Accept All from Privacy Manager");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not displayed");

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			logMessage("Create new property with same details but some other unique authentication");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();

			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date2 = new Date();
			authID = sdf.format(date2);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			logMessage("Unique AuthID : " + authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			logMessage("Check for message and check all toggles displyed as false from PM");
			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

			// Check all consent are saves as false
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 15)
	@Description("Given user submit valid property details with unique AuthID and tap on Save\n"
			+ "	 Then expected Message should load When user navigate to PM and tap on Accept\n"
			+ "	 All Then all consent data will get stored When user delete this property and\n"
			+ "	 create property with same details And navigate to PM Then he/she should see\n"
			+ "	 already saved consents")
	public void CheckConsentWithSameAuthIDAfterDeletingAndRecreate()
			throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start :CheckConsentWithSameAuthIDAfterDeletingAndRecreate");
		String key = "language";
		String value = "fr";
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details with unique authentication....");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date1 = new Date();
			authID = sdf.format(date1);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			logMessage("Unique AuthID : " + authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			logMessage("Check for message and tap on Accept All from PM");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			logMessage("Delete property");
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");

			softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage());

			mobilePageWrapper.siteListPage.YESButton.click();
			softAssert.assertFalse(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName));

			logMessage("Create property again with same Authentication details");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			logMessage("Check for all toggels as true from PM");
			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");
			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

			// Check all consent are save as true
		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 16)
	@Description("Given user submit valid property details tap on Save Then expected message\n"
			+ "	 should load When user dismiss the message Then he/she should see info screen\n"
			+ "	 with ConsentUUID details")
	public void CheckPropertDetailsOnMessageDismiss() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckPropertDetailsOnMessageDismiss");
		String key = "language";
		String value = "en";
		SoftAssert softAssert = new SoftAssert();
		setExpectedESConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedESConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.tcfv2_Dismiss.click();
			logMessage("Generated consent data : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 17)
	@Description("iven user submit valid property details for loading PM as first layer\n"
			+ "	 message and tap on Save Then expected PM should load")
	public void CheckPMAsFirstLayerMessage() throws InterruptedException, NoSuchElementException {
		logMessage("Test execution start : CheckPMAsFirstLayerMessage");
		String key = "pm";
		String value = "true";
		SoftAssert softAssert = new SoftAssert();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details to laod Privacy Manager as first layer message");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			logMessage("Check for Privacy Managre displated as first layer message");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 18, enabled = false)
	@Description("Given user submit valid property details for loading PM as first layer message and tap on Save \n"
			+ "	 Then expected PM should load \n" + "	 When user select Accept All Then consent should get stored \n"
			+ "	 When user tap on the property from list screen And click on Cancel \n"
			+ "	 Then he/she should navigate back to the info screen")
	public void CheckCancelFromPMAsFirstLayerMessage() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start :CheckCancelFromPMAsFirstLayerMessage");
		String key = "pm";
		String value = "true";
		SoftAssert softAssert = new SoftAssert();
		Date date = new Date();
		String authID = sdf.format(date);
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details to load Privacy Manager as first layer message");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			// mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check Privacy Manager displayed as first layer message");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

			logMessage("Tap on Accept All from Privacy Manager");
			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			logMessage("Generated consent data : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			logMessage("Tap on property to load it again");
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

			// check for all data saved as true
			logMessage("Tap on Cancel from Privacy Manager");
			mobilePageWrapper.privacyManagerPage.tcfv2_Cancel.click();
			logMessage("Generated consent data : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0),
					"CosentUUID not matching");
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1),
					"EUConsent not matching");

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 19)
	@Description("Given user submit valid property details for loading PM as first layer\n"
			+ "	 message and tap on Save Then expected PM should load When user select Accept\n"
			+ "	 All Then consent should get stored When user tap on the Show PM link from the\n"
			+ "	 info screen Then he/she should navigate to PM screen showing all toggle as selected")
	public void CheckConsentOnDirectPMLoadWhenPMConfiguredAsMessage()
			throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckConsentOnDirectPMLoadWhenPMConfiguredAsMessage");
		String key = "pm";
		String value = "true";
		SoftAssert softAssert = new SoftAssert();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details...");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for Privacy Manager as first layer message");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

			logMessage("Tap on Accept All from Privacy Manager");
			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();

			logMessage("Generated consent data : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");

			logMessage("Tap on Show Link to load Privacy Manager directand check given consent");
			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not present");

			// check for all data saved as true

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 20)
	@Description(" Given user submit valid property details for loading PM as first layer\n"
			+ "	 message with unique AuthID and tap on Save Then expected PM should load When\n"
			+ "	 user select Accept All Then consent should get stored When user tap on the\n"
			+ "	 property from list screen Then he/she should see all toggle as true")
	public void CheckConsentWithAuthIDFromPMAsMessage() throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start :CheckConsentWithAuthIDFromPMAsMessage ");
		String key = "pm";
		String value = "true";
		SoftAssert softAssert = new SoftAssert();
		Date date = new Date();
		String authID = sdf.format(date);
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details..");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			logMessage("Check for Privacy Manager as first layer message");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			logMessage("Tap on Accept All from Privacy Manager");
			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			logMessage("Generated consent data : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			logMessage("Tap on property again and check for consent data from Privacy Manager");
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check for all data saved as true

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" }, priority = 21)
	@Description("Given user submit valid property details without AuthID and tap on Save Then\n"
			+ "	 expected consent message should display When user select Accept all Then user\n"
			+ "	 will navigate to Site Info screen showing ConsentUUID, EUConsent and all\n"
			+ "	 Vendors & Purpose Consents When user navigate back & edit property with\n"
			+ "	 unique AuthID Then he/she should not see message again should see given\n" + "	 consent information")
	public void CheckNoMessageAfterLoggedInWithAuthIDWhenConsentAlreadyGiven()
			throws InterruptedException, NoSuchElementException {
		logMessage(" Test execution start : CheckNoMessageAfterLoggedInWithAuthIDWhenConsentAlreadyGiven");
		String key = "displayMode";
		String value = "appLaunch";
		Date date = new Date();
		String authID = sdf.format(date);
		SoftAssert softAssert = new SoftAssert();
		setExpectedShowOnlyMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			logMessage("Enter property details configured to show message once");
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			logMessage("Check for expected message");
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedShowOnlyMsg),
					"Expected consent message not displayed");
			logMessage("Select Accept All from message");
			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			logMessage("Generated consent data : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			logMessage("Edit and save property details with unique authentication");
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Edit");
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			logMessage("Get consent information : ConsentUUID: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText() + " EUConsent: "
					+ mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated");
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0),
					"ConsentUUID not matching with expected ConsentUUID");
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1),
					"EUConsent not matching with expected EUConsent");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated");

		} catch (Exception e) {
			logMessage("Exception: " + e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

}
