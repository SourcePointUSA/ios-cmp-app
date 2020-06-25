package org.framework.pageObjects;

import static org.framework.logger.LoggingManager.logMessage;

import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class SiteDebugInfoPage {

	WebDriver driver;

	 public SiteDebugInfoPage(WebDriver driver) throws InterruptedException {
	        this.driver = driver;
	        PageFactory.initElements(driver, this);
	        logMessage("Initializing the "+this.getClass().getSimpleName()+" elements");
	        PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	        Thread.sleep(1000);
	    } 
	 
	 @WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeStaticText']")
	public WebElement GDPRSiteDebugInfoPageTitle;
	
	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "ConsentUUIDString")
	public WebElement GDPRConsentUUID;

	@iOSXCUITFindBy(accessibility = "EUConsentString")
	public WebElement GDPREUConsent;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeStaticText[@name=\"noDataLabel\"]")
	public WebElement GDPRConsentNotAvailable;
	
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeTable']")
	public List<WebElement> GDPRConsentView;
	
	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "Back")
	public WebElement BackButton;

	@iOSXCUITFindBy(accessibility = "Show PM")
	public WebElement GDPRShowPMLink;

	ArrayList<String> consentData = new ArrayList<>();

	public ArrayList<String> storeConsent(WebElement consentUUID, WebElement euConsent) {
		consentData.add(consentUUID.getText());
		consentData.add(euConsent.getText());
		return consentData;
	}

	public ArrayList<String> storeConsent(WebElement consentUUID) {
		consentData.add(consentUUID.getText());
		return consentData;
	}
	
	public boolean isConsentViewDataPresent(List<WebElement> consentView) {
		if (consentView.size() > 0){
			return true;
		} else {
			return false;
		}
	}

	public boolean checkForNoPurposeConsentData(WebElement consentNotAvailable) {
		return consentNotAvailable.isDisplayed();
	}
}
