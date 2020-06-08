package com.mobile.pages;

import java.io.File;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;

import jnr.ffi.Struct.mode_t;
import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;
import io.appium.java_client.PerformsTouchActions;
import io.appium.java_client.TouchAction;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
//import io.appium.java_client.pagefactory.iOSFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.touch.offset.PointOption;

import org.apache.maven.model.Site;
//import org.apache.tools.ant.taskdefs.Tar;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.Point;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.cybage.frameworkutility.utilities.DirectoryOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations.IniFileType;
import com.frameworkbase.DriverBase;
import com.fusion.plugin.extension.mobile.IMobileDriver;

public class NewSitePage {

	private AppiumDriver driver;

	public NewSitePage(IMobileDriver appiumDriver) {
		driver = appiumDriver.getDriver();
		PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	}
	
	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeTextField[@name='accountIDTextFieldOutlet']")
	public MobileElement GDPRNewSitePageHeader;
		
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeTextField[@name='accountIDTextFieldOutlet']")
	public MobileElement AccountIDLabel;
	
	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "Save")
	public MobileElement GDPRSaveButton;
		
	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeTextField[@name='accountIDTextFieldOutlet']")
	public MobileElement GDPRAccountID;
	
	@iOSXCUITFindBy(accessibility = "propertyTextFieldOutlet")
	public MobileElement GDPRSiteName;
	
	@iOSXCUITFindBy(accessibility = "isStagingSwitchOutlet")
	public MobileElement GDPRToggleButton;

	@iOSXCUITFindBy(accessibility = "authIdTextFieldOutlet")
	public MobileElement GDPRAuthID;

	@iOSXCUITFindBy(accessibility = "targetingParamKeyTextFieldOutlet")
	public MobileElement GDPRParameterKey;

	@iOSXCUITFindBy(accessibility = "targetingParamValueTextFieldOutlet")
	public MobileElement GDPRParameterValue;

	@iOSXCUITFindBy(accessibility = "addButton")
	public MobileElement GDPRParameterAddButton;
		
	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
	public List<MobileElement> ErrorMessage;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "OK")
	public MobileElement OKButton;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "propertyIdTextFieldOutlet")
	public MobileElement GDPRSiteId;
	
	@iOSXCUITFindBy(accessibility = "pmTextFieldOutlet")
	public MobileElement GDPRPMId;

	@iOSXCUITFindBy(accessibility = "showPMSwitchOutlet")
	public MobileElement GDPRShowPrivacyManager;

	boolean paramFound = false;

	public void selectCampaign(MobileElement ele, String staggingValue)
			throws InterruptedException {
	
		if (staggingValue.equals("ON")) {
			Point point = ele.getLocation();
			TouchAction touchAction = new TouchAction((PerformsTouchActions) driver);

			touchAction.tap(PointOption.point(point.x + 20, point.y + 20)).perform();
		}
		Thread.sleep(3000);
	}

	public void addTargetingParameter(MobileElement paramKey, MobileElement paramValue, String key, String value, String udid) throws InterruptedException {

		JavascriptExecutor js = (JavascriptExecutor) driver;
		HashMap<String, String> scrollObject = new HashMap<String, String>();

		if (!IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			scrollObject.put("direction", "up");
			js.executeScript("mobile: scroll", scrollObject);
		}
		paramKey.sendKeys(key);

		if (!IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			scrollObject.put("direction", "up");
			js.executeScript("mobile: scroll", scrollObject);
		}
		paramValue.sendKeys(value);
		
		if (!IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			scrollObject.put("direction", "up");
			js.executeScript("mobile: scroll", scrollObject);
		}
	}

	public String getError() throws InterruptedException {
		boolean check = false;
		// waitForElement(ErrorMessage, 10);
		Thread.sleep(5000);
		int i = ErrorMessage.size();

		String errorMsg = ErrorMessage.get(ErrorMessage.size() - 1).getText();
		return errorMsg;
	}

	public boolean verifyError(String udid) throws InterruptedException {
		boolean check = false;
		// waitForElement(ErrorMessage, 10);
		Thread.sleep(3000);
		int i = ErrorMessage.size();

		String errorMsg = ErrorMessage.get(ErrorMessage.size() - 1).getText();

		if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			if (errorMsg.equals("Please enter targeting param Key/Value"))
				check = true;
		} else {
			if (errorMsg.equals("Please enter targeting parameter key and value"))
				check = true;
		}
		return check;
	}

	public boolean verifyError() {
		return paramFound;

	}

	public void waitForElement(MobileElement ele, int timeOutInSeconds) {
		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
		wait.until(ExpectedConditions.visibilityOf(ele));
	}

	public boolean verifyErrorMsg(String udid) throws InterruptedException {
		boolean check = false;
		// waitForElement(ErrorMessage, 10);
		Thread.sleep(3000);
		int i = ErrorMessage.size();

		String errorMsg = ErrorMessage.get(ErrorMessage.size() - 1).getText();

		if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			if (errorMsg.equals("Please enter Account ID, Property ID, Property Name, Privacy Manager ID"))
				check = true;
		} else {
			if (errorMsg.equals("Please enter property details"))
				check = true;
		}
		return check;
	}

}
