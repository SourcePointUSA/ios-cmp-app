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
public class GDPR_TCFV1_MetaAppTests extends BaseTest {

	private static final DateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	String authID;
	String accountId = "808";
	String siteName = "cybage.sp-demo.com";
	String staggingValue = "ON";
	String siteID = "3541";
	String privacyManagerID = "5cacf8d0d4c64a77183f18d6";
	String wrongAccountId = accountId + 1;
	String wrongSiteName = siteName + "abc";
	String PMId = "5cacf8d0d4c64a77183f18d6";

	String expectedMessageNoCriteriaTitle = "TEST NO TARGETING CRITERIA MET";
	String expectedMessageNoCriteriaBody = "THIS MESSAGE ONLY IF NONE OF THE TARGETING CRITERIA IN THE SCENARIO WERE MET";

	String expectedMessageShowOnlyOnceTitle = "TEST MESSAGE SHOW ONLY ONCE";
	String expectedMessageShowOnlyOnceBody = "THIS MESSAGE ONLY SHOW ONCE IF THE TARGETING CRITERIA MET";

	String expectedMessageForNoParamsTitle = "";
	String expectedMessageForNoParamBody = "This message is for mobile users";

	String expectedFRConsentMessageTitle = "TEST CONSENT MESSAGE FRENCH KEY-VALUE PAIR";
	String expectedLanguageConsentMessageBody = "To offer the best experience of relevant content, information and advertising. By clicking to continue, you accept our use of cookies.";

	String expectedENSPMessageTitle = "TEST CONSENT MESSAGE ENGLISH KEY-VALUE PAIR";

	String expectedWrongCampaignMessage = "There is no message matching the scenario based on the property info and device local data. Consider reviewing the property info or clearing the cookies. If that was intended, just ignore this message.";

//	String expectedMessageForNoCriteriaTitle = "TEST NO TARGETING CRITERIA MET";
//	String expectedMessageForNoCriteriaBody = "THIS MESSAGE ONLY IF NONE OF THE TARGETING CRITERIA IN THE SCENARIO WERE MET.";

	String key = "language";
	String value = "fr";

	ArrayList<String> expectedShowOnlyMsg = new ArrayList<String>();

	public ArrayList<String> setExpectedShowOnlyMsg() {
		expectedShowOnlyMsg.add(expectedMessageShowOnlyOnceTitle);
		expectedShowOnlyMsg.add(expectedMessageShowOnlyOnceTitle);
		return expectedShowOnlyMsg;
	}

	ArrayList<String> expectedFRConsentMsg = new ArrayList<String>();

	public ArrayList<String> setExpectedFRConsentMsg() {
		expectedFRConsentMsg.add(expectedFRConsentMessageTitle);
		expectedFRConsentMsg.add(expectedFRConsentMessageTitle);
		return expectedFRConsentMsg;
	}

	ArrayList<String> expectedENConsentMsg = new ArrayList<String>();

	public ArrayList<String> setExpectedENConsentMsg() {
		expectedENConsentMsg.add(expectedENSPMessageTitle);
		return expectedENConsentMsg;
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 1)
	public void CheckAcceptAllFromPrivacyManage() throws InterruptedException, NoSuchElementException {

		SoftAssert softAssert = new SoftAssert();
		try {

			System.out.println(" Test execution start ");
			System.out.println("CheckAcceptAllFromPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv1_AcceptAllButton.click();

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName);

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check for all purposes selected as true

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 2)
	public void CheckCancelFromPrivacyManager() throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckCancleFromPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.tcfv1_CancelButton.click();

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage1.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 3)
	public void CheckConsentOnAcceptAllFromConsentView() throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();

		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckConsentOnAcceptAllFromConsentView - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("I Accept").click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName);

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check PM data for all true

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 4)
	public void CheckConsentOnRejectAllFromConsentView() throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();

		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckConsentOnRejectAllFromConsentView - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);

			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("I Reject").click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName);

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// check PM data for all false

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 5)
	public void CheckConsentOnRejectAllFromPM() throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		String key = "language";
		String value = "fr";
		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckConsentOnRejectAllFromPM - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("I Accept").click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName);

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			// check for all purposes selected as true

			mobilePageWrapper.privacyManagerPage.tcfv1_RejectAllButton.click();
			Thread.sleep(5000);
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 6)
	public void CheckPurposeConsentAfterRestCookies() throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();

		try {
			String key = "displayMode";
			String value = "appLaunch";
			System.out.println(" Test execution start ");
			System.out
					.println("CheckPurposeConsentAfterRestCookies - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedShowOnlyMsg));

			mobilePageWrapper.consentViewPage.AcceptAllCookiesButton.click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

//			softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//					.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Reset");

			softAssert.assertTrue(mobilePageWrapper.consentViewPage.verifyDeleteCookiesMessage());

			mobilePageWrapper.consentViewPage.YESButton.click();
			softAssert.assertTrue(consentMessage.containsAll(expectedShowOnlyMsg));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 7)
	public void CheckConsentDataFromPrivacyManagerDirect() throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();

		try {
			System.out.println(" Test execution start ");
			System.out.println(
					"CheckConsentDataFromPrivacyManagerDirect - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("I Accept").click();

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

//			softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//					.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv1_RejectAllButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

//			softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//					.checkForNoPurposeConsentData(mobilePageWrapper.siteDebugInfoPage.GDPRConsentNotAvailable));

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

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 8)
	public void CheckCancelFromDirectPrivacyManager() throws InterruptedException, NoSuchElementException {

		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();
		try {
			System.out.println(" Test execution start ");
			System.out
					.println("CheckCancelFromDirectPrivacyManager - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("I Accept").click();

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
//			softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//					.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));
			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);

			mobilePageWrapper.siteDebugInfoPage.GDPRShowPMLink.click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.tcfv1_CancelButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));
//			softAssert.assertTrue(mobilePageWrapper.siteDebugInfoPage
//					.isConsentViewDataPresent(mobilePageWrapper.siteDebugInfoPage.GDPRConsentView));

			// check for all purposes selected as false

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 9)
	public void CheckNoConsentMessageDisplayAfterShowSiteInfo() throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedShowOnlyMsg();

		try {
			String key = "displayMode";
			String value = "appLaunch";
			System.out.println(" Test execution start ");
			System.out.println("CheckNoConsentMessageDisplayAfterShowSiteInfo - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> actualConsentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();

			softAssert.assertTrue(actualConsentMessage.containsAll(expectedShowOnlyMsg));

			mobilePageWrapper.consentViewPage.AcceptAllCookiesButton.click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			ArrayList<String> consentData = mobilePageWrapper.siteDebugInfoPage.storeConsent(
					mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID,
					mobilePageWrapper.siteDebugInfoPage.GDPREUConsent);
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			// softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(),
			// siteName);
			mobilePageWrapper.siteListPage.tapOnSite_gdpr(siteName);
			Thread.sleep(3000);
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0));
			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(), consentData.get(1));

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 10)
	public void DeleteSite() throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();

		try {
			String key = "language";
			String value = "fr";
			System.out.println(" Test execution start ");
			System.out.println("DeleteSite - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("I Reject").click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");

			// softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage());

			mobilePageWrapper.siteListPage.NOButton.click();

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");
			// softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage());

			mobilePageWrapper.siteListPage.YESButton.click();

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 11)
	public void EditSiteWithConsentGivenBefore() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "en";
		SoftAssert softAssert = new SoftAssert();
		setExpectedENConsentMsg();
		setExpectedFRConsentMsg();

		ArrayList<String> consentData;
		try {
			System.out.println(" Test execution start ");
			System.out.println("EditSiteWithConsentGivenBefore - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedENConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("I Accept").click();

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
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("I Accept").click();

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

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 12)
	public void CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved()
			throws InterruptedException, NoSuchElementException {
		SoftAssert softAssert = new SoftAssert();
		setExpectedShowOnlyMsg();

		try {
			String key = "displayMode";
			String value = "appLaunch";
			System.out.println(" Test execution start ");
			System.out.println("CheckNoMessageWithShowOnceCriteriaWhenConsentAlreadySaved - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date = new Date();
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(sdf.format(date));

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentData;

			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedShowOnlyMsg));

			mobilePageWrapper.consentViewPage.AcceptAllCookiesButton.click();

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "Data not created");
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
			Thread.sleep(3000);

			softAssert.assertEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(), consentData.get(0),
					"Data not matching");

			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

//	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 13)
	public void CheckSavedConsentAlwaysWithSameAuthID() throws InterruptedException, NoSuchElementException {

		SoftAssert softAssert = new SoftAssert();
		setExpectedFRConsentMsg();

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
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
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
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			mobilePageWrapper.privacyManagerPage.tcfv1_AcceptAllButton.click();
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
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date2 = new Date();
			authID = sdf.format(date2);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			System.out.println("AuthID : " + authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage1.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();
			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// Check all consent are saves as false
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

//	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority=14)
	public void CheckConsentWithSameAuthIDWithNewInstallation() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "fr";
		setExpectedFRConsentMsg();

		Date date = new Date();
		SoftAssert softAssert = new SoftAssert();

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckConsentWithSameAuthIDWithNewInstallation - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
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

			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privact Settings").click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.tcfv1_AcceptAllButton.click();
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
			mobilePageWrapper1.siteListPage.GDPRAddButton.click();
			mobilePageWrapper1.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper1.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper1.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper1.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper1.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton,
					staggingValue);
			mobilePageWrapper1.newSitePage.GDPRAuthID.sendKeys(authID);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper1.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper1.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper1.newSitePage.GDPRSaveButton.click();

			ArrayList<String> consentMessage1 = mobilePageWrapper1.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privact Settings").click();

			softAssert.assertTrue(mobilePageWrapper1.privacyManagerPage.isPrivacyManagerViewPresent());

			// Check all consent are save as true
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

//	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority=15)
	public void CheckSavedConsentAlwaysWithSameAuthIDCrossPlatform()
			throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "fr";
		setExpectedFRConsentMsg();
		SoftAssert softAssert = new SoftAssert();

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckSavedConsentAlwaysWithSameAuthIDCrossPlatform - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			Date date1 = new Date();
			authID = sdf.format(date1);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);
			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.tcfv1_AcceptAllButton.click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);
//
//				String baseDir = DirectoryOperations.getProjectRootPath();
//				System.setProperty("webdriver.chrome.driver", baseDir + "/setupfiles/Fusion/chromedriver_MAC");
//
//				WebDriver driver1 = new ChromeDriver(); // init chrome driver
//
//				driver1.get("https://in-app-messaging.pm.sourcepoint.mgr.consensu.org/v2.0.html?\r\n" + "\r\n"
//						+ "_sp_accountId=" + accountId + "&_sp_writeFirstPartyCookies=true&_sp_msg_domain=mms.sp-\r\n"
//						+ "\r\n" + "prod.net&_sp_debug_level=OFF&_sp_pmOrigin=production&_sp_siteHref=https%3A%2F%2F"
//						+ siteName + "\r\n" + "\r\n" + "%2F&_sp_msg_targetingParams=\r\n" + "\r\n" + "%7B\"" + key
//						+ "\"%3A\"" + value + "\"%7D&_sp_authId=" + authID
//						+ "&_sp_cmp_inApp=true&_sp_msg_stageCampaign=" + staggingValue + "&_sp_cmp_origin=%2F\r\n"
//						+ "\r\n" + "%2Fsourcepoint.mgr.consensu.org");
//
//				Thread.sleep(3000);
//				driver1.findElement(By.id("Show Purposes")).click();
//				Thread.sleep(3000);
//			WebDriverWait wait = new WebDriverWait(webDriver, 30);
//			wait.until(ExpectedConditions.presenceOfElementLocated(By.className("priv_main_parent")));
// Check all consent are save as true

			// driver1.quit();
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 16)
	public void CheckConsentWithSameAuthIDAfterDeletingAndRecreate()
			throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "fr";
		Date date = new Date();
		setExpectedFRConsentMsg();

		SoftAssert softAssert = new SoftAssert();

		try {
			System.out.println(" Test execution start ");
			System.out.println("CheckConsentWithSameAuthIDAfterDeletingAndRecreate - "
					+ String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
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

			softAssert.assertTrue(consentMessage.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());
			mobilePageWrapper.privacyManagerPage.tcfv1_AcceptAllButton.click();
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available");
			System.out.println(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText());
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPREUConsent.getText(),
					"EUConsent not available");

			mobilePageWrapper.siteDebugInfoPage.BackButton.click();
			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

			mobilePageWrapper.siteListPage.swipeHorizontaly_gdpr(siteName);
			mobilePageWrapper.siteListPage.selectAction("Delete");
			// softAssert.assertTrue(mobilePageWrapper.siteListPage.verifyDeleteSiteMessage());

			mobilePageWrapper.siteListPage.YESButton.click();
			mobilePageWrapper.siteListPage.GDPRAddButton.click();
			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);
			mobilePageWrapper.newSitePage.GDPRAuthID.sendKeys(authID);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();
			mobilePageWrapper.newSitePage.GDPRSaveButton.click();

			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.eleButton("Privacy Settings").click();

			softAssert.assertTrue(mobilePageWrapper.privacyManagerPage.isPrivacyManagerViewPresent());

			// Check all consent are save as true
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

	@Test(groups = { "TCFv1_GDPR-MetaAppTests" }, priority = 17)
	public void CheckPropertDetailsOnMessageDismiss() throws InterruptedException, NoSuchElementException {
		String key = "language";
		String value = "fr";
		SoftAssert softAssert = new SoftAssert();

		setExpectedENConsentMsg();
		try {
			System.out.println(" Test execution start ");
			System.out
					.println("CheckPropertDetailsOnMessageDismiss - " + String.valueOf(Thread.currentThread().getId()));

			MobilePageWrapper mobilePageWrapper = new MobilePageWrapper(driver);
			mobilePageWrapper.siteListPage.GDPRAddButton.click();

			mobilePageWrapper.newSitePage.GDPRAccountID.sendKeys(accountId);
			mobilePageWrapper.newSitePage.GDPRSiteId.sendKeys(siteID);
			mobilePageWrapper.newSitePage.GDPRSiteName.sendKeys(siteName);
			mobilePageWrapper.newSitePage.GDPRPMId.sendKeys(PMId);
			mobilePageWrapper.newSitePage.selectCampaign(mobilePageWrapper.newSitePage.GDPRToggleButton, staggingValue);

			mobilePageWrapper.newSitePage.addTargetingParameter(mobilePageWrapper.newSitePage.GDPRParameterKey,
					mobilePageWrapper.newSitePage.GDPRParameterValue, key, value);
			mobilePageWrapper.newSitePage.GDPRParameterAddButton.click();

			mobilePageWrapper.newSitePage.GDPRSaveButton.click();
			ArrayList<String> consentMessage1 = mobilePageWrapper.consentViewPage.getConsentMessageDetails();
			softAssert.assertTrue(consentMessage1.containsAll(expectedFRConsentMsg));

			mobilePageWrapper.consentViewPage.Dismiss.click();
			Thread.sleep(5000);
			softAssert.assertNotEquals(mobilePageWrapper.siteDebugInfoPage.GDPRConsentUUID.getText(),
					"ConsentUUID not available", "Data not present");
			mobilePageWrapper.siteDebugInfoPage.BackButton.click();

			softAssert.assertEquals(mobilePageWrapper.siteListPage.GDPRSiteName.getText(), siteName);

		} catch (Exception e) {
			System.out.println(e);
			throw e;
		} finally {
			softAssert.assertAll();
		}
	}

}
