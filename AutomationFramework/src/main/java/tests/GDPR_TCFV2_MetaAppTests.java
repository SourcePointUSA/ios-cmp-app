package tests;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.NoSuchElementException;

import org.framework.allureReport.TestListener;
import org.framework.pageObjects.MobilePageWrapper;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.SkipException;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
import org.testng.asserts.SoftAssert;

import tests.BaseTest;

@Listeners({ TestListener.class })
public class GDPR_TCFV2_MetaAppTests extends BaseTest {

	private static final DateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	String accountId = "808";
	String siteName = "tcfv2.automation.testing";
	String staggingValue = "OFF";
	String siteID = "7376";
	String pmID = "122040";
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

	/**
	 * Given user submit valid property details and tap on Save Then the expected
	 * consent message should display And When user click on Manage PREFERENCES
	 * button Then user will see Privacy Manager screen When user select Accept All
	 * Then user will navigate to Site Info screen showing ConsentUUID, EUConsent
	 * and all Purpose Consents When user navigate back and tap on the site name And
	 * click on MANAGE PREFERENCES button from consent message Then he/she should
	 * see all purposes are selected as true
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
//	@Test(groups = { "GDPR-MetaAppTests" }, priority = 1)
	public void CheckAcceptAllFromPrivacyManage() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckAcceptAllFromPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
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

			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager page not displayed.");

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "ConsentUUID not generated.");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "EUConsent not generated.");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName,
					"Property not created.");
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(),
					"Privacy Manager not displayed.");

			// check for all purposes selected as true

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details and tap on Save Then expected
	 * consent should display When user click on MANAGE PREFERENCES button Then user
	 * will see Privacy Manager screen When user click on Cancel button Then user
	 * will navigate back to the consent message
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
//	@Test(groups = { "GDPR-MetaAppTests" }, priority = 2)
	public void CheckCancelFromPrivacyManager() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckCancleFromPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.scrollAndClick("Cancel");

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details and tap on Save Then expected
	 * consent message should display When user select Accept all Then user will
	 * navigate to Site Info screen showing ConsentUUID, EUConsent and all Vendors &
	 * Purpose Consents When user navigate back & tap on the site name and select
	 * MANAGE PREFERENCES button from consent message view Then he/she will see all
	 * vendors & purposes as selected true
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
//	@Test(groups = { "GDPR-MetaAppTests" }, priority = 3)
	public void CheckConsentOnAcceptAllFromConsentView() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out
				.println("CheckConsentOnAcceptAllFromConsentView - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details and tap on Save Then expected
	 * consent message should display When user select Reject all Then user will
	 * navigate to Site Info screen showing ConsentUUID and no EUConsent and with no
	 * Vendors & Purpose Consents When user navigate back & tap on the site name and
	 * select MANAGE PREFERENCES button from consent message view Then he/she will
	 * see all vendors & purposes as selected false
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
//	@Test(groups = { "GDPR-MetaAppTests" }, priority = 4)
	public void CheckConsentOnRejectAllFromConsentView() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out
				.println("CheckConsentOnRejectAllFromConsentView - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("REJECT ALL");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check PM data for all false
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details and tap on Save Then expected
	 * consent message should display When user tap on Accept All button Then user
	 * navigate back to Info screen showing ConsentUUID and EUConsent data When user
	 * tap on the property from property list screen And navigate to PM, all consent
	 * toggle should show as selected When user tap on Reject all Then should see
	 * same COnsentUUID and newly generated EUCONSENT data
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 5)
	public void CheckConsentOnRejectAllFromPM() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckConsentOnRejectAllFromPM - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as true

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Reject All");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "AAAAA");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available", "BBBB");
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0), "ABABA");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1), "BABA");
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details and tap on Save Then expected
	 * consent message should display When user select MANAGE PREFERENCES Then user
	 * navigate to PM And should see all toggles as false When user select Save &
	 * Exit without any change Then user should navigate back to the info screen
	 * showing no Vendors and Purposes as selected
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 6)
	public void CheckConsentOnSaveAndExitFromPM() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckConsentOnSaveAndExitFromPM - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as false

			mobilePageWrapper.privacyManagerPage.tcfv2_SaveAndExitButton.click();

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details and tap on Save Then expected
	 * consent message should display When user select MANAGE PREFERENCES and tap
	 * from Accept All button Then consent data should display on info screen When
	 * user navigate back and tap on the Property again Then he/she should not see
	 * message again When user delete cookies for the property Then he.\/she should
	 * see consent message again
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 7)
	public void CheckPurposeConsentAfterRestCookies() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckPurposeConsentAfterRestCookies - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		String value = "en";
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

			mobilePageWrapper.consentViewPage.tcfv2_ManagaePreferences.click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as false

			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Reset");

			softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());

			mobilePageWrapper.consentViewPage.YESButton.click();
			mobilePageWrapper.consentViewPage.tcfv2_ManagaePreferences.click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as false

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details and tap on Save Then expected
	 * consent message should display When user tap on Accept All Then consent data
	 * should get stored When user navigate to PM directly by clicking on Show PM
	 * link And select Reject All Then EUConsent information should get updated
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 8)
	public void CheckConsentDataFromPrivacyManagerDirect() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println(
				"CheckConsentDataFromPrivacyManagerDirect - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Reject All");

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as false
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details and tap on Save Then expected
	 * message should load When user select Accept All Then consent information
	 * should get stored When user tap on the Show link And click on Cancel Then
	 * he/she should navigate back to the info screen
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 9)
	public void CheckCancelFromDirectPrivacyManager() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckCancelFromDirectPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Cancel");

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

			// check for all purposes selected as false

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details to show message once and tap on
	 * Save Then expected message should load When user select Accept All Then
	 * consent should get stored When user tap on the property from list screen Then
	 * he/she should not see message
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 10)
	public void CheckNoConsentMessageDisplayAfterShowSiteInfo() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println(
				"CheckNoConsentMessageDisplayAfterShowSiteInfo - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		String key = "displayMode";
		String value = "appLaunch";
		setExpectedShowOnlyMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedShowOnlyMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details and tap on Save Then expected
	 * message should load When user select Reject All Then consent information
	 * should get stored When user swipe on property and choose to delete he/she
	 * should able to delete the property screen
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 11)
	public void DeleteSite() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("DeleteSite - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		String key = "language";
		String value = "fr";
		setExpectedFRConsentMsg();
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("REJECT ALL");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
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

			mobilePageWrapper.siteListPage.YESButton.click();
			softAssert.assertFalse(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details and tap on Save Then expected
	 * message should load When user select Accept All Then consent information
	 * should get stored When user swipe on property and edit the key/parameter
	 * details Then he/she should see respective message
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 12)
	public void EditSiteWithConsentGivenBefore() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("EditSiteWithConsentGivenBefore - " + String.valueOf(Thread.currentThread().getId()));
		String key = "language";
		String value = "en";
		SoftAssert softAssert = new SoftAssert();
		ArrayList<String> consentData;
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

			mobilePageWrapper.consentViewPage.tcfv2_AcceptAll.click();

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Edit");

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, "fr");
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details to show message once with AuthID and
	 * tap on Save Then expected message should load When user select Accept All
	 * Then consent information should get stored When user reset the property Then
	 * user should not see the message again
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 13)
	public void CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved()
			throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved - "
				+ String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		String key = "displayMode";
		String value = "appLaunch";
		setExpectedShowOnlyMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
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

			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedShowOnlyMsg),
					"Expected consent message not displayed");

			ArrayList<String> consentData;

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Reset");

			softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());
			mobilePageWrapper.consentViewPage.YESButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details with unique AuthID and tap on Save
	 * Then expected message should load When user navigate PM and tap on Accept All
	 * Then all consent data should be stored When user try to create new property
	 * with same details but another unique authId And navigate to PM Then he/she
	 * should not see already saved consent
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 14)
	public void CheckSavedConsentAlwaysWithSameAuthID() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckSavedConsentAlwaysWithSameAuthID - " + String.valueOf(Thread.currentThread().getId()));
		SoftAssert softAssert = new SoftAssert();
		String key = "language";
		String value = "fr";
		Date date = new Date();
		ArrayList<String> consentData;
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date1 = new Date();
			authID = sdf.format(date1);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			System.out.println("AuthID : " + authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.GDPRAddButton.click();

			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date2 = new Date();
			authID = sdf.format(date2);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			System.out.println("AuthID : " + authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// Check all consent are saves as false
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details with unique AuthID and tap on Save
	 * Then expected Message should load When user navigate to PM and tap on Accept
	 * All Then all consent data will get stored When user delete this property and
	 * create property with same details And navigate to PM Then he/she should see
	 * already saved consents
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 15)
	public void CheckConsentWithSameAuthIDAfterDeletingAndRecreate()
			throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckConsentWithSameAuthIDAfterDeletingAndRecreate - "
				+ String.valueOf(Thread.currentThread().getId()));
		String key = "language";
		String value = "fr";
		Date date = new Date();
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date1 = new Date();
			authID = sdf.format(date1);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			System.out.println("AuthID : " + authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");

			softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage());

			mobilePageWrapper.siteListPage.YESButton.click();
			softAssert.assertFalse(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName));

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

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg),
					"Expected consent message not displayed");
			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// Check all consent are save as true
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details tap on Save Then expected message
	 * should load When user dismiss the message Then he/she should see info screen
	 * with ConsentUUID details
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 16)
	public void CheckPropertDetailsOnMessageDismiss() throws InterruptedException, NoSuchElementException {

		System.out.println(" Test execution start ");
		System.out.println("CheckPropertDetailsOnMessageDismiss - " + String.valueOf(Thread.currentThread().getId()));
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
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details for loading PM as first layer
	 * message and tap on Save Then expected PM should load
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 17)
	public void CheckPMAsFirstLayerMessage() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckPMAsFirstLayerMessage - " + String.valueOf(Thread.currentThread().getId()));
		String key = "pm";
		String value = "true";
		SoftAssert softAssert = new SoftAssert();
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

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details for loading PM as first layer
	 * message and tap on Save Then expected PM should load When user select Accept
	 * All Then consent should get stored When user tap on the property from list
	 * screen And click on Cancel Then he/she should navigate back to the info
	 * screen
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 18)
	public void CheckCancelFromPMAsFirstLayerMessage() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckCancelFromPMAsFirstLayerMessage - " + String.valueOf(Thread.currentThread().getId()));
		String key = "pm";
		String value = "true";
		SoftAssert softAssert = new SoftAssert();
		Date date = new Date();
		String authID = sdf.format(date);
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
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

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check for all data saved as true

			mobilePageWrapper.privacyManagerPage.tcfv2_Cancel.click();

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * * Given user submit valid property details for loading PM as first layer
	 * message and tap on Save Then expected PM should load When user select Accept
	 * All Then consent should get stored When user tap on the Show PM link from the
	 * info screen Then he/she should navigate to PM screen showing all toggle as
	 * true
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 19)
	public void CheckConsentOnDirectPMLoadWhenPMAsMessage() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println(
				"CheckConsentOnDirectPMLoadWhenPMAsMessage - " + String.valueOf(Thread.currentThread().getId()));
		String key = "pm";
		String value = "true";
		SoftAssert softAssert = new SoftAssert();
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

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check for all data saved as true

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details for loading PM as first layer
	 * message with unique AuthID and tap on Save Then expected PM should load When
	 * user select Accept All Then consent should get stored When user tap on the
	 * property from list screen Then he/she should see all toggle as true
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 20)
	public void CheckConsentWithAuthIDFromPMAsMessage() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckConsentWithAuthIDFromPMAsMessage - " + String.valueOf(Thread.currentThread().getId()));
		String key = "pm";
		String value = "true";
		SoftAssert softAssert = new SoftAssert();
		Date date = new Date();
		String authID = sdf.format(date);
		try {
			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
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

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText());

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check for all data saved as true

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	/**
	 * Given user submit valid property details without AuthID and tap on Save Then
	 * expected consent message should display When user select Accept all Then user
	 * will navigate to Site Info screen showing ConsentUUID, EUConsent and all
	 * Vendors & Purpose Consents When user navigate back & edit property with
	 * unique AuthID Then he/she should not see message again should see given
	 * consent information
	 * 
	 * @throws InterruptedException
	 * @throws NoSuchElementException
	 */
	@Test(groups = { "GDPR-MetaAppTests" }, priority = 21)
	public void CheckNoMessageAfterLoggedInWithAuthID() throws InterruptedException, NoSuchElementException {
		System.out.println(" Test execution start ");
		System.out.println("CheckNoMessageAfterLoggedInWithAuthID - " + String.valueOf(Thread.currentThread().getId()));
		String key = "displayMode";
		String value = "appLaunch";
		Date date = new Date();
		String authID = sdf.format(date);
		SoftAssert softAssert = new SoftAssert();
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

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Edit");
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

}
