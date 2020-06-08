package com.mobile.pages;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.support.PageFactory;

import com.fusion.plugin.extension.mobile.IMobileDriver;

public class SiteDebugInfoPage {
	private AppiumDriver driver;

	public SiteDebugInfoPage(IMobileDriver appiumDriver) {
		driver = appiumDriver.getDriver();
		PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	}

	// @WithTimeout(time = 30, unit = TimeUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeStaticText']")
	public MobileElement GDPRSiteDebugInfoPageTitle;
	
	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "ConsentUUIDString")
	public MobileElement GDPRConsentUUID;

	@iOSXCUITFindBy(accessibility = "EUConsentString")
	public MobileElement GDPREUConsent;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeStaticText[@name=\"noDataLabel\"]")
	public MobileElement GDPRConsentNotAvailable;
	
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeTable']")
	public List<MobileElement> GDPRConsentView;
	
	// @WithTimeout(time = 30, unit = TimeUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "Back")
	public MobileElement BackButton;

	@iOSXCUITFindBy(accessibility = "Show PM")
	public MobileElement GDPRShowPMLink;

	ArrayList<String> consentData = new ArrayList<>();

	public ArrayList<String> storeConsent(MobileElement consentUUID, MobileElement euConsent) {
		consentData.add(consentUUID.getText());
		consentData.add(euConsent.getText());
		return consentData;
	}

	public ArrayList<String> storeConsent(MobileElement consentUUID) {
		consentData.add(consentUUID.getText());
		return consentData;
	}
	
	public boolean isConsentViewDataPresent(List<MobileElement> consentView) {
		if (consentView.size() > 0){
			return true;
		} else {
			return false;
		}
	}

	public boolean checkForNoPurposeConsentData(MobileElement consentNotAvailable) {
		return consentNotAvailable.isDisplayed();
	}
}
