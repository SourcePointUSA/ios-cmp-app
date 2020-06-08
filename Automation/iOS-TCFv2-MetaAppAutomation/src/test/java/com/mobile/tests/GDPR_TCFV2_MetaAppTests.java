package com.mobile.tests;

import java.lang.reflect.Method;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.SkipException;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Parameters;
import org.testng.annotations.Test;

import com.cybage.frameworkutility.utilities.DirectoryOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations.IniFileType;
import com.frameworkbase.DriverBase;
import com.fusion.plugin.extension.mobile.IMobileDriver;
import com.mobile.pages.MobilePageWrapper;

import io.appium.java_client.android.AndroidElement;

public class GDPR_TCFV2_MetaAppTests extends DriverBase {

	@Parameters({ "udid" })
	@BeforeMethod(alwaysRun = true)
	public void mobileSetUp(String udid, Method m) {
		createMobileDriver(udid, "Mobile");
		System.out.println("Done with b4 method...");
	}

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
	//	this.expectedShowOnceTCFv2Message = expectedShowOnceTCFv2Message;
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckAcceptAllFromPrivacyManage(String udid) throws InterruptedException {
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
								
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckAcceptAllFromPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(8000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(10000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Accept All");
				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
				ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
				mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, udid,
						mobilePageWrapper.siteListPage.GDPRSiteList);
				
				Thread.sleep(8000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				// check for all purposes selected as true

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckCancelFromPrivacyManager(String udid) throws InterruptedException {
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println("CheckCancleFromPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(8000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton); //
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				Thread.sleep(5000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Cancel");

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
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentOnAcceptAllFromConsentView(String udid) throws InterruptedException {
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckConsentOnAcceptAllFromConsentView - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "ACCEPT ALL");

				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
				ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
				mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, udid,
						mobilePageWrapper.siteListPage.GDPRSiteList);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				Thread.sleep(5000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentOnRejectAllFromConsentView(String udid) throws InterruptedException {
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckConsentOnRejectAllFromConsentView - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);

				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(10000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "REJECT ALL");
				Thread.sleep(3000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.checkForNoPurposeConsentData(mobilePageWrapper.siteDebugInfoPage.GDPRConsentNotAvailable));
				ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
				mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, udid,
						mobilePageWrapper.siteListPage.GDPRSiteList);
				Thread.sleep(5000);
				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				Thread.sleep(5000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));
				Thread.sleep(5000);

				// check PM data for all false

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentOnRejectAllFromPM(String udid) throws InterruptedException {

		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println("CheckConsentOnRejectAllFromPM - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(5000);

				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "ACCEPT ALL");

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

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
				mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, udid,
						mobilePageWrapper.siteListPage.GDPRSiteList);
				Thread.sleep(3000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				Thread.sleep(10000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));
				// check for all purposes selected as true

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Reject All");

				Thread.sleep(3000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");
				Thread.sleep(3000);
				softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
						.checkForNoPurposeConsentData(mobilePageWrapper.siteDebugInfoPage.GDPRConsentNotAvailable));
				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						consentData.get(0));
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						consentData.get(1));

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckPurposeConsentAfterRestCookies(String udid) throws InterruptedException {
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				String value = "en";
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckPurposeConsentAfterRestCookies - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(8000);

				driver.clickOn(mobilePageWrapper.consentViewPage.tcfv2_ManagaePreferences);

				Thread.sleep(5000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));
				// check for all purposes selected as false

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Accept All");

				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
				ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
				mobilePageWrapper.siteListPage.selectAction("Reset");
//				driver.clickOn(mobilePageWrapper.siteListPage.GDPRResetButton);

				softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());

				driver.clickOn(mobilePageWrapper.consentViewPage.YESButton);
				Thread.sleep(8000);
				driver.clickOn(mobilePageWrapper.consentViewPage.tcfv2_ManagaePreferences);

				Thread.sleep(5000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));
				System.out.println("passed");
				// check for all purposes selected as false

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentDataFromPrivacyManagerDirect(String udid) throws InterruptedException {

		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These Tests shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckConsentDataFromPrivacyManagerDirect - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(4000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(8000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "ACCEPT ALL");

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
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink);
				Thread.sleep(3000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Reject All");

				Thread.sleep(5000);
				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						consentData.get(0));
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						consentData.get(1));

				softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
						.checkForNoPurposeConsentData(mobilePageWrapper.siteDebugInfoPage.GDPRConsentNotAvailable));

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink);

				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				// check for all purposes selected as false

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckCancelFromDirectPrivacyManager(String udid) throws InterruptedException {
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckCancelFromDirectPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(8000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "ACCEPT ALL");

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

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink);
				Thread.sleep(3000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Cancel");

				Thread.sleep(5000);

				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						consentData.get(0));
				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						consentData.get(1));
//				softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//						.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));

//			driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);
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
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckNoConsentMessageDisplayAfterShowSiteInfo(String udid) throws InterruptedException {
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				String key = "displayMode";
				String value = "appLaunch";
				System.out.println(" Test execution start ");
				System.out.println("CheckNoConsentMessageDisplayAfterShowSiteInfo - "
						+ String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(10000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "ACCEPT ALL");

				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");
				ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
				mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, udid,
						mobilePageWrapper.siteListPage.GDPRSiteList);
				Thread.sleep(5000);

				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						consentData.get(0));
				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						consentData.get(1));
			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void DeleteSite(String udid) throws InterruptedException {

		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				String key = "language";
				String value = "fr";
				System.out.println(" Test execution start ");
				System.out.println("DeleteSite - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "REJECT ALL");
				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
				mobilePageWrapper.siteListPage.selectAction("Delete");

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

		//		driver.clickOn(mobilePageWrapper.siteListPage.GDPRDeleteButton);
		//		softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage(udid));

				driver.clickOn(mobilePageWrapper.siteListPage.NOButton);
//				softAssert.assertTrue(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName, udid,
//						mobilePageWrapper.siteListPage.GDPRSiteList));
				Thread.sleep(3000);
				mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
				mobilePageWrapper.siteListPage.selectAction("Delete");
		//		driver.clickOn(mobilePageWrapper.siteListPage.GDPRDeleteButton);
		//		softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage(udid));

				driver.clickOn(mobilePageWrapper.siteListPage.YESButton);
//				softAssert.assertFalse(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName, udid,
//						mobilePageWrapper.siteListPage.GDPRSiteList));

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void EditSiteWithConsentGivenBefore(String udid) throws InterruptedException {
		String key = "language";
		String value = "en";
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			ArrayList<String> consentData;
			try {
				System.out.println(" Test execution start ");
				System.out
						.println("EditSiteWithConsentGivenBefore - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				driver.clickOn(mobilePageWrapper.consentViewPage.tcfv2_AcceptAll);

				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
				mobilePageWrapper.siteListPage.selectAction("Edit");
			//	driver.clickOn(mobilePageWrapper.siteListPage.GDPREditButton);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, "fr", udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(3000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "ACCEPT ALL");

				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						consentData.get(0));
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

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved(String udid) throws Exception {
		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				String key = "displayMode";
				String value = "appLaunch";
				System.out.println(" Test execution start ");
				System.out.println("CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved - "
						+ String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				Date date = new Date();
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(sdf.format(date));

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				ArrayList<String> consentData;

				Thread.sleep(10000);
				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "ACCEPT ALL");
				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");
				consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
				mobilePageWrapper.siteListPage.selectAction("Reset");

		//		driver.clickOn(mobilePageWrapper.siteListPage.GDPRResetButton);

				softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());
				driver.clickOn(mobilePageWrapper.consentViewPage.YESButton);
				Thread.sleep(8000);

				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						consentData.get(0));
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

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckSavedConsentAlwaysWithSameAuthID(String udid) throws Exception {
		String key = "language";
		String value = "fr";
		Date date = new Date();
		ArrayList<String> consentData;

		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckSavedConsentAlwaysWithSameAuthID - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				Thread.sleep(3000);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				Date date1 = new Date();
				authID = sdf.format(date1);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
				System.out.println("AuthID : " + authID);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				Thread.sleep(5000);

				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Accept All");

				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");
				consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);
				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);

				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				Date date2 = new Date();
				authID = sdf.format(date2);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
				System.out.println("AuthID : " + authID);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(10000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				Thread.sleep(5000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				// Check all consent are saves as false
			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
//	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentWithSameAuthIDWithNewInstallation(String udid) throws Exception {
		String key = "language";
		String value = "fr";
		Date date = new Date();

		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println("CheckConsentWithSameAuthIDWithNewInstallation - "
						+ String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				Date date1 = new Date();
				authID = sdf.format(date1);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
				System.out.println("AuthID : " + authID);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				Thread.sleep(8000);

				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Accept All");

				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);
				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				System.out.println("Uninstall app");
				mobilePageWrapper.siteListPage.removeGDPRApp();

				System.out.println("Install app");
				mobilePageWrapper.siteListPage.installApp(udid);

				MobilePageWrapper mobilePageWrapper1 = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper1.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				driver.clickOn(mobilePageWrapper1.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				softAssert.assertTrue(mobilePageWrapper1.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				// Check all consent are save as true
			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
//	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckSavedConsentAlwaysWithSameAuthIDCrossPlatform(String udid) throws Exception {
		String key = "language";
		String value = "fr";

		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println("CheckSavedConsentAlwaysWithSameAuthIDCrossPlatform - "
						+ String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				Date date1 = new Date();
				authID = sdf.format(date1);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(8000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");
				Thread.sleep(5000);

				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Accept All");

				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);
				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				String baseDir = DirectoryOperations.getProjectRootPath();
				System.setProperty("webdriver.chrome.driver", baseDir + "/setupfiles/Fusion/chromedriver_MAC");

				WebDriver driver1 = new ChromeDriver(); // init chrome driver

				driver1.get("https://in-app-messaging.pm.sourcepoint.mgr.consensu.org/v2.0.html?\r\n" + "\r\n"
						+ "_sp_accountId=" + accountId + "&_sp_writeFirstPartyCookies=true&_sp_msg_domain=mms.sp-\r\n"
						+ "\r\n" + "prod.net&_sp_debug_level=OFF&_sp_pmOrigin=production&_sp_siteHref=https%3A%2F%2F"
						+ siteName + "\r\n" + "\r\n" + "%2F&_sp_msg_targetingParams=\r\n" + "\r\n" + "%7B\"" + key
						+ "\"%3A\"" + value + "\"%7D&_sp_authId=" + authID
						+ "&_sp_cmp_inApp=true&_sp_msg_stageCampaign=" + staggingValue + "&_sp_cmp_origin=%2F\r\n"
						+ "\r\n" + "%2Fsourcepoint.mgr.consensu.org");

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
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentWithSameAuthIDAfterDeletingAndRecreate(String udid) throws Exception {
		String key = "language";
		String value = "fr";
		Date date = new Date();

		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println("CheckConsentWithSameAuthIDAfterDeletingAndRecreate - "
						+ String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				Date date1 = new Date();
				authID = sdf.format(date1);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
				System.out.println("AuthID : " + authID);
				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				Thread.sleep(8000);

				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));
				mobilePageWrapper.privacyManagerPage.scrollAndClick(udid, "Accept All");

				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);
				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
				mobilePageWrapper.siteListPage.selectAction("Delete");

		//		driver.clickOn(mobilePageWrapper.siteListPage.GDPRDeleteButton);
		//		softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage(udid));

				driver.clickOn(mobilePageWrapper.siteListPage.YESButton);
//				softAssert.assertFalse(mobilePageWrapper.siteListPage.isSitePressent_gdpr(siteName, udid,
//						mobilePageWrapper.siteListPage.GDPRSiteList));

				// MobilePageWrapper mobilePageWrapper1 = new MobilePageWrapper(driver);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(5000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "MANAGE PREFERENCES");

				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				// Check all consent are save as true
			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}
	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckPropertDetailsOnMessageDismiss(String udid) throws Exception {
		IMobileDriver driver = getMobileDriver();
		String key = "language";
		String value = "en";

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckPropertDetailsOnMessageDismiss - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);

				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				ArrayList<String> consentData;

				Thread.sleep(20000);

				driver.clickOn(mobilePageWrapper.consentViewPage.tcfv2_Dismiss);
				driver.hideKeyboard();
				Thread.sleep(8000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
//				softAssert
//						.assertTrue(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText().contains("EUConsent"));
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}

	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckPMAsMEssage(String udid) throws Exception {
		IMobileDriver driver = getMobileDriver();
		String key = "pm";
		String value = "true";

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println("CheckPMAsMEssage - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);

				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				ArrayList<String> consentData;

				Thread.sleep(20000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}

	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckCancelFromPMAsMEssage(String udid) throws Exception {
		IMobileDriver driver = getMobileDriver();
		String key = "pm";
		String value = "true";

		Date date = new Date();
		String authID = sdf.format(date);

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println("CheckPMAsMEssageWithAuthID - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(8000);

				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				// mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);

				Thread.sleep(15000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				driver.clickOn(mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll);
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
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);
				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, udid,
						mobilePageWrapper.siteListPage.GDPRSiteList);
				Thread.sleep(8000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				// check for all data saved as true

				driver.clickOn(mobilePageWrapper.privacyManagerPage.tcfv2_Cancel);

				Thread.sleep(5000);
				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						consentData.get(0));
				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						consentData.get(1));

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}

	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentOnDirectPMLoadWhenPMAsMEssage(String udid) throws Exception {
		IMobileDriver driver = getMobileDriver();
		String key = "pm";
		String value = "true";

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println("CheckPMAsMEssageWithAuthID - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);

				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);

				Thread.sleep(15000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				driver.clickOn(mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll);
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
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink);

				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				// check for all data saved as true

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}

	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckConsentWithAuthIDFromPMAsMessage(String udid) throws Exception {
		IMobileDriver driver = getMobileDriver();
		String key = "pm";
		String value = "true";

		Date date = new Date();
		String authID = sdf.format(date);

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckConsentWithAuthIDFromPMAsMessage - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);

				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);

				Thread.sleep(15000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				driver.clickOn(mobilePageWrapper.privacyManagerPage.tcfv2_AcceptAll);
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
				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);
				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

				mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName, udid,
						mobilePageWrapper.siteListPage.GDPRSiteList);
				Thread.sleep(3000);
				softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent(udid));

				// check for all data saved as true

			} catch (Exception e) {
				System.out.println(e);
				throw e;
			} finally {
				softAssert.assertAll();
			}
		}

	}

	@Parameters({ "udid" })
	@Test(groups = { "GDPR-MetaAppTests" })
	public void CheckNoMessageAfterLoggedInWithAuthID(String udid) throws Exception {
		String key = "displayMode";
		String value = "appLaunch";
		Date date = new Date();
		String authID = sdf.format(date);

		IMobileDriver driver = getMobileDriver();

		if (driver == null) {
			throw new SkipException("These tests are meant to run on "
					+ IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					+ " and shouldn't be run for other platform");
		} else {

			try {
				System.out.println(" Test execution start ");
				System.out.println(
						"CheckNoMessageAfterLoggedInWithAuthID - " + String.valueOf(Thread.currentThread().getId()));

				MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
				Thread.sleep(3000);
				driver.clickOn(mobilePageWrapper.siteListPage.GDPRAddButton);
				mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
				mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
				mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
				mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(pmID);
				mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
						staggingValue);

				mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
						mobilePageWrapper.newSitePage.GDPRParameterValue, key, value, udid);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRParameterAddButton);
				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);
				Thread.sleep(8000);

				mobilePageWrapper.consentViewPage.scrollAndClick(udid, "ACCEPT ALL");

				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						"EUConsent not available");

				// softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
				ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
						mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
						mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

				driver.clickOn(mobilePageWrapper.siteDebugInfoPage.BackButton);

				softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
				mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
				mobilePageWrapper.siteListPage.selectAction("Edit");
			//	driver.clickOn(mobilePageWrapper.siteListPage.GDPREditButton);
				mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
				Thread.sleep(5000);

				driver.clickOn(mobilePageWrapper.newSitePage.GDPRSaveButton);

				Thread.sleep(5000);
				softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						"ConsentUUID not available");
				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
						consentData.get(0));
				softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
						consentData.get(1));
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
}
