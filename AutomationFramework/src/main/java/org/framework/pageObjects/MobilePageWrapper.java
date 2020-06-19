package org.framework.pageObjects;

import org.openqa.selenium.WebDriver;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileDriver;

public class MobilePageWrapper {
	public SiteListPage siteListPage;
	public NewSitePage newSitePage;
	public ConsentViewPage consentViewPage;
	public ConsentViewPage consentViewPage1;
	//public EditSitePage editSitePage;
	public SiteDebugInfoPage siteDebugInfoPage;
	public PrivacyManagerPage privacyManagerPage;
	
	public MobilePageWrapper(WebDriver driver) throws InterruptedException {
		siteListPage = new SiteListPage(driver);
		newSitePage = new NewSitePage(driver);
		consentViewPage = new ConsentViewPage(driver);
		consentViewPage1 = new ConsentViewPage(driver);
		//editSitePage = new EditSitePage(mobileDriver);
		siteDebugInfoPage = new SiteDebugInfoPage(driver);	
		privacyManagerPage = new PrivacyManagerPage(driver);
	}
}
