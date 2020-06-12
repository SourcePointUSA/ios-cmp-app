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
import org.testng.SkipException;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
import org.testng.asserts.SoftAssert;

import tests.BaseTest;

@Listeners({ TestListener.class })
public class GDPR_TCFV2_MetaAppTests extends BaseTest {

	SoftAssert softAssert = new SoftAssert();

	private static final DateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	String accountId = "808";
	String siteName = "tcfv2.automation.testing";
	String staggingValue = "OFF";
	String siteID = "7376";
	String pmID = "122040";
	String key = "language";
	String value = "fr";
	String authID;
	String expectedTCFv2MessageTitle = "TCFv2 Message Title";
	String expectedTCFv2MessageBody = "We and our partners require consent for the following purposes:";

	String expectedESTCFv2MessageTitle = "TCF v2 Message Title for Language English";
	String expectedESTCFv2MessageBody = "TCF V2 Message Body for Language English";

	String expectedShowOnceTCFv2MessageTitle = "ShowOnce :We use cookies to give you the best experience";
	String expectedShowOnceTCFv2MessageBody = "We and our partners require consent for the following purposes:";

	ArrayList<String> expectedTCFv2Message = new ArrayList<String>();
	ArrayList<String> expectedESTCFv2Message = new ArrayList<String>();
	ArrayList<String> expectedShowOnceTCFv2Message = new ArrayList<String>();

	public void setExpectedTCFv2Message(ArrayList<String> expectedTCFv2Message) {
		if (expectedTCFv2Message != null) {
			expectedTCFv2Message.add(expectedTCFv2MessageTitle);
			expectedTCFv2Message.add(expectedTCFv2MessageBody);
			this.expectedTCFv2Message = expectedTCFv2Message;
		}
	}

	public ArrayList<String> getExpectedTCFv2Message() {
		return expectedShowOnceTCFv2Message;
	}

	public void setExpectedESTCFv2Message(ArrayList<String> expectedESTCFv2Message) {
		expectedESTCFv2Message.add(expectedESTCFv2MessageTitle);
		expectedESTCFv2Message.add(expectedESTCFv2MessageBody);
		this.expectedESTCFv2Message = expectedESTCFv2Message;
	}

	public void setExpectedShowOnceTCFv2Message() {
		expectedShowOnceTCFv2Message.add(expectedShowOnceTCFv2MessageTitle);
		expectedShowOnceTCFv2Message.add(expectedShowOnceTCFv2MessageBody);
		// this.expectedShowOnceTCFv2Message = expectedShowOnceTCFv2Message;
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckAcceptAllFromPrivacyManage() throws InterruptedException, NoSuchElementException {

		try {

			System.out.println(" Test execution start ");
			System.out.println("CheckAcceptAllFromPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(8000);
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
			Thread.sleep(10000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");
			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);

			Thread.sleep(8000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check for all purposes selected as true

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckCancelFromPrivacyManager() throws InterruptedException, NoSuchElementException {
		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckCancleFromPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(8000);
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
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			Thread.sleep(5000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Cancel");

			Thread.sleep(5000);

//				ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage1.getConsentMessageDetails(udid);
//				if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
//						.equalsIgnoreCase("Android")) {
//					softAssert.assertTrue(consentMessage1.containsAll(expectedTCFv2Message));
//				} else {
//					softAssert.assertEquals(consentMessage1.get(11), expectedTCFv2MessageTitle);
//					softAssert.assertEquals(consentMessage1.get(12), expectedTCFv2MessageBody);
//				}

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentOnAcceptAllFromConsentView() throws InterruptedException, NoSuchElementException {
		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckConsentOnAcceptAllFromConsentView - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			Thread.sleep(5000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentOnRejectAllFromConsentView() throws InterruptedException, NoSuchElementException {

		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckConsentOnRejectAllFromConsentView - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);

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
			Thread.sleep(10000);

			mobilePageWrapper.consentViewPage.scrollAndClick("REJECT ALL");
			Thread.sleep(3000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.checkForNoPurposeConsentData(mobilePageWrapper.siteDebugInfoPage.GDPRConsentNotAvailable));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			Thread.sleep(5000);
			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			Thread.sleep(5000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			Thread.sleep(5000);

			// check PM data for all false

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentOnRejectAllFromPM() throws InterruptedException, NoSuchElementException {

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckConsentOnRejectAllFromPM - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(5000);

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
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			// check or purpose data //
//				softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage //
//						.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, mobilePageWrapper.siteListPage.GDPRSiteList);
			Thread.sleep(3000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			Thread.sleep(8000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as true

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Reject All");

			Thread.sleep(3000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			Thread.sleep(3000);
			softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
					.checkForNoPurposeConsentData(mobilePageWrapper.siteDebugInfoPage.GDPRConsentNotAvailable));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckPurposeConsentAfterRestCookies() throws InterruptedException, NoSuchElementException {
		try {
			String value = "en";
			System.out.println(" Test execution start ");
			System.out
					.println("CheckPurposeConsentAfterRestCookies - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(8000);

			mobilePageWrapper.consentViewPage.tcfv2_ManagaePreferences.click();

			Thread.sleep(5000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as false

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");

			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Reset");
//				mobilePageWrapper.siteListPage.GDPRResetButton);

			softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());

			mobilePageWrapper.consentViewPage.YESButton.click();
			Thread.sleep(8000);
			mobilePageWrapper.consentViewPage.tcfv2_ManagaePreferences.click();

			Thread.sleep(5000);
			System.out.println("passed");
			// check for all purposes selected as false

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentDataFromPrivacyManagerDirect() throws InterruptedException, NoSuchElementException {

		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckConsentDataFromPrivacyManagerDirect - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(4000);
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
			Thread.sleep(8000);

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

//				softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//						.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();
			Thread.sleep(3000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Reject All");

			Thread.sleep(5000);
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

			softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
					.checkForNoPurposeConsentData(mobilePageWrapper.siteDebugInfoPage.GDPRConsentNotAvailable));

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

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckCancelFromDirectPrivacyManager() throws InterruptedException, NoSuchElementException {
		try {
			System.out.println(" Test execution start ");
			System.out
					.println("CheckCancelFromDirectPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(8000);

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
//				softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//						.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();
			Thread.sleep(3000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Cancel");

			Thread.sleep(5000);

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));
//				softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//						.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));

//			mobilePageWrapper.siteDebugInfoPage.BackButton);
//
//			softAssert.assertEquals(mobilePageWrapper.siteListPage.SiteName.getText(), siteName);
//			mobilePageWrapper.siteListPage.tapOnSite(siteName, udid);
//			Thread.sleep(8000);
//			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

			// check for all purposes selected as false

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckNoConsentMessageDisplayAfterShowSiteInfo() throws InterruptedException, NoSuchElementException {

		try {
			String key = "displayMode";
			String value = "appLaunch";
			System.out.println(" Test execution start ");
			System.out.println("CheckNoConsentMessageDisplayAfterShowSiteInfo - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(10000);

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			Thread.sleep(5000);
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
			Thread.sleep(5000);

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void DeleteSite() throws InterruptedException, NoSuchElementException {

		try {
			String key = "language";
			String value = "fr";
			System.out.println(" Test execution start ");
			System.out.println("DeleteSite - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("REJECT ALL");
			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			// mobilePageWrapper.siteListPage.GDPRDeleteButton);
			// softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage(udid));

			mobilePageWrapper.siteListPage.NOButton.click();
//				softAssert.assertTrue(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName, udid,
//						mobilePageWrapper.siteListPage.GDPRSiteList));
			Thread.sleep(3000);
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");
			// mobilePageWrapper.siteListPage.GDPRDeleteButton);
			// softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage(udid));

			mobilePageWrapper.siteListPage.YESButton.click();
//				softAssert.assertFalse(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName, udid,
//						mobilePageWrapper.siteListPage.GDPRSiteList));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void EditSiteWithConsentGivenBefore() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "en";

		ArrayList<String> consentData;
		try {
			System.out.println(" Test execution start ");
			System.out.println("EditSiteWithConsentGivenBefore - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(5000);

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
			// mobilePageWrapper.siteListPage.GDPREditButton);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, "fr");
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			Thread.sleep(3000);

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

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved() throws InterruptedException, NoSuchElementException {

		try {
			String key = "displayMode";
			String value = "appLaunch";
			System.out.println(" Test execution start ");
			System.out.println("CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			ArrayList<String> consentData;

			Thread.sleep(10000);
			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");
			Thread.sleep(5000);
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

			// mobilePageWrapper.siteListPage.GDPRResetButton);

			softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());
			mobilePageWrapper.consentViewPage.YESButton.click();
			Thread.sleep(8000);

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

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckSavedConsentAlwaysWithSameAuthID() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "fr";
		Date date = new Date();
		ArrayList<String> consentData;

		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckSavedConsentAlwaysWithSameAuthID - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			Thread.sleep(3000);
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
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			Thread.sleep(5000);

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");

			Thread.sleep(5000);
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
			Thread.sleep(10000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			Thread.sleep(5000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// Check all consent are saves as false
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

//	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentWithSameAuthIDWithNewInstallation() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "fr";
		Date date = new Date();

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckConsentWithSameAuthIDWithNewInstallation - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			Thread.sleep(8000);

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");

			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			System.out.println("Uninstall app");
			// mobilePageWrapper.siteListPage.removeGDPRApp();

			System.out.println("Install app");
			// mobilePageWrapper.siteListPage.installApp();

			MobilePageWrapper mobilePageWrapper1 = new MobilePageWrapper(driver);
			Thread.sleep(3000);
			mobilePageWrapper1.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper1.newSitePage.GDPRSaveButton.click();
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			softAssert.assertTrue(mobilePageWrapper1.privacyManagerPage.isPrivacyManagerViewPresent());

			// Check all consent are save as true
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

//	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckSavedConsentAlwaysWithSameAuthIDCrossPlatform() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "fr";

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckSavedConsentAlwaysWithSameAuthIDCrossPlatform - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date1 = new Date();
			authID = sdf.format(date1);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			Thread.sleep(8000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");
			Thread.sleep(5000);

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");

			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			// String baseDir = DirectoryOperations.getProjectRootPath();
			// System.setProperty("webdriver.chrome.driver", baseDir +
			// "/setupfiles/Fusion/chromedriver_MAC");

			WebDriver driver1 = new ChromeDriver(); // init chrome driver

			driver1.get("https://in-app-messaging.pm.sourcepoint.mgr.consensu.org/v2.0.html?\r\n" + "\r\n"
					+ "_sp_accountId=" + accountId + "&_sp_writeFirstPartyCookies=true&_sp_msg_domain=mms.sp-\r\n"
					+ "\r\n" + "prod.net&_sp_debug_level=OFF&_sp_pmOrigin=production&_sp_siteHref=https%3A%2F%2F"
					+ siteName + "\r\n" + "\r\n" + "%2F&_sp_msg_targetingParams=\r\n" + "\r\n" + "%7B\"" + key
					+ "\"%3A\"" + value + "\"%7D&_sp_authId=" + authID + "&_sp_cmp_inApp=true&_sp_msg_stageCampaign="
					+ staggingValue + "&_sp_cmp_origin=%2F\r\n" + "\r\n" + "%2Fsourcepoint.mgr.consensu.org");

			Thread.sleep(3000);
			driver1.findElement(By.id("Show Purposes")).click();
			Thread.sleep(3000);
//			WebDriverWait wait = new WebDriverWait(webDriver, 30);
//			wait.until(ExpectedConditions.presenceOfElementLocated(By.className("priv_main_parent")));
// Check all consent are save as true

			driver1.quit();
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentWithSameAuthIDAfterDeletingAndRecreate() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "fr";
		Date date = new Date();

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckConsentWithSameAuthIDAfterDeletingAndRecreate - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(5000);

			mobilePageWrapper.consentViewPage.scrollAndClick("MANAGE PREFERENCES");

			Thread.sleep(8000);

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.scrollAndClick("Accept All");

			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");

			// mobilePageWrapper.siteListPage.GDPRDeleteButton);
			// softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage(udid));

			mobilePageWrapper.siteListPage.YESButton.click();
//				softAssert.assertFalse(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName, udid,
//						mobilePageWrapper.siteListPage.GDPRSiteList));

			// MobilePageWrapper mobilePageWrapper1 = new MobilePageWrapper(driver);
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
			Thread.sleep(5000);

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

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckPropertDetailsOnMessageDismiss() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "en";

		try {
			System.out.println(" Test execution start ");
			System.out
					.println("CheckPropertDetailsOnMessageDismiss - " + String.valueOf(Thread.currentThread().getId()));

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
			ArrayList<String> consentData;

			Thread.sleep(20000);

			mobilePageWrapper.consentViewPage.tcfv2_Dismiss.click();
			// driver.hideKeyboard();
			Thread.sleep(8000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
//				softAssert
//						.assertTrue(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText().contains("EUConsent"));
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckPMAsMEssage() throws InterruptedException, NoSuchElementException {
		String key = "pm";
		String value = "true";

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckPMAsMEssage - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);

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
			ArrayList<String> consentData;

			Thread.sleep(20000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckCancelFromPMAsMEssage() throws InterruptedException, NoSuchElementException {
		String key = "pm";
		String value = "true";

		Date date = new Date();
		String authID = sdf.format(date);

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckPMAsMEssageWithAuthID - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(8000);

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

			Thread.sleep(15000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			Thread.sleep(5000);
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
			Thread.sleep(8000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check for all data saved as true

			mobilePageWrapper.privacyManagerPage.tcfv2_Cancel.click();

			Thread.sleep(5000);
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentOnDirectPMLoadWhenPMAsMEssage() throws InterruptedException, NoSuchElementException {
		String key = "pm";
		String value = "true";

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckPMAsMEssageWithAuthID - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);

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

			Thread.sleep(15000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			Thread.sleep(5000);
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

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentWithAuthIDFromPMAsMessage() throws InterruptedException, NoSuchElementException {
		String key = "pm";
		String value = "true";

		Date date = new Date();
		String authID = sdf.format(date);

		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckConsentWithAuthIDFromPMAsMessage - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);

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

			Thread.sleep(15000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll.click();
			Thread.sleep(5000);
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
			Thread.sleep(3000);
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check for all data saved as true

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckNoMessageAfterLoggedInWithAuthID() throws InterruptedException, NoSuchElementException {
		String key = "displayMode";
		String value = "appLaunch";
		Date date = new Date();
		String authID = sdf.format(date);

		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckNoMessageAfterLoggedInWithAuthID - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			Thread.sleep(3000);
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
			Thread.sleep(8000);

			mobilePageWrapper.consentViewPage.scrollAndClick("ACCEPT ALL");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Edit");
			// mobilePageWrapper.siteListPage.GDPREditButton);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			Thread.sleep(5000);

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			Thread.sleep(5000);
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
