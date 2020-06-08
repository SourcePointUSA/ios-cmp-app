package com.mobile.pages;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

import java.util.concurrent.TimeUnit;

import org.openqa.selenium.support.PageFactory;

import com.fusion.plugin.extension.mobile.IMobileDriver;

public class EditSitePage {
	private AppiumDriver driver;

	public EditSitePage(IMobileDriver appiumDriver) {
		driver = appiumDriver.getDriver();
		PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	}
	
	//@WithTimeout(time=30, unit=TimeUnit.SECONDS)
	@iOSXCUITFindBy(xpath="//XCUIElementTypeStaticText']")
	public MobileElement GDPREditSitePageHeader;
	
	@iOSXCUITFindBy(xpath="//XCUIElementTypeStaticText']")
	public MobileElement CCPAEditSitePageHeader;
	
}
