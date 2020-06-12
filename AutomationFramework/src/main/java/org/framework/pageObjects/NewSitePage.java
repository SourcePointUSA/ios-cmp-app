package org.framework.pageObjects;

import static org.framework.logger.LoggingManager.logMessage;

import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.framework.enums.PlatformName;
import org.framework.helpers.Page;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileDriver;
//import io.appium.java_client.WebElement;
import io.appium.java_client.PerformsTouchActions;
import io.appium.java_client.TouchAction;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.touch.offset.PointOption;

public class NewSitePage extends Page {
	WebDriver driver;

	public NewSitePage(WebDriver driver) throws InterruptedException {
		this.driver = driver;
		PageFactory.initElements(driver, this);
		logMessage("Initializing the " + this.getClass().getSimpleName() + " elements");
		PageFactory.initElements(new AppiumFieldDecorator(driver), this);
		Thread.sleep(1000);
	}

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeTextField[@name='accountIDTextFieldOutlet']")
	public WebElement GDPRNewSitePageHeader;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeTextField[@name='accountIDTextFieldOutlet']")
	public WebElement AccountIDLabel;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "Save")
	public WebElement GDPRSaveButton;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeTextField[@name='accountIDTextFieldOutlet']")
	public WebElement GDPRAccountID;

	@iOSXCUITFindBy(accessibility = "propertyTextFieldOutlet")
	public WebElement GDPRSiteName;

	@iOSXCUITFindBy(accessibility = "isStagingSwitchOutlet")
	public WebElement GDPRToggleButton;

	@iOSXCUITFindBy(accessibility = "authIdTextFieldOutlet")
	public WebElement GDPRAuthID;

	@iOSXCUITFindBy(accessibility = "targetingParamKeyTextFieldOutlet")
	public WebElement GDPRParameterKey;

	@iOSXCUITFindBy(accessibility = "targetingParamValueTextFieldOutlet")
	public WebElement GDPRParameterValue;

	@iOSXCUITFindBy(accessibility = "addButton")
	public WebElement GDPRParameterAddButton;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
	public List<WebElement> ErrorMessage;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "OK")
	public WebElement OKButton;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "propertyIdTextFieldOutlet")
	public WebElement GDPRSiteId;

	@iOSXCUITFindBy(accessibility = "pmTextFieldOutlet")
	public WebElement GDPRPMId;

	@iOSXCUITFindBy(accessibility = "showPMSwitchOutlet")
	public WebElement GDPRShowPrivacyManager;

//	public NewSitePage(WebDriver driver) throws InterruptedException {
//        this.driver = driver;
//        PageFactory.initElements(driver, this);
//        logMessage("Initializing the "+this.getClass().getSimpleName()+" elements");
//        PageFactory.initElements(new AppiumFieldDecorator(driver), this);
//        Thread.sleep(1000);
//    }

	boolean paramFound = false;

//	public void addNewSiteWithOutParameter(String accountId, String siteName, String staggingValue)
//			throws InterruptedException {
//		AccountID.sendKeys(accountId);
//		SiteName.sendKeys(siteName);
//
//		if (staggingValue.equals("ON")) {
//			Point point = ToggleButton.getLocation();
//			TouchAction touchAction = new TouchAction((PerformsTouchActions) driver);
//
//			touchAction.tap(PointOption.point(point.x + 20, point.y + 20)).perform();
//		}
//
//		SaveButton.click();
//		Thread.sleep(3000);
//	}
//
//	public void addNewSite(String accountId, String siteName, String staggingValue) throws InterruptedException {
//		AccountID.clear();
//		AccountID.sendKeys(accountId);
//		//SiteName.clear();
//		SiteName.sendKeys(siteName);
//
//		if (staggingValue.equals("ON")) {
//			System.out.println("########inside########");
//			Point point = ToggleButton.getLocation();
//			
//			TouchAction touchAction = new TouchAction((PerformsTouchActions) driver);
//
//			touchAction.tap(PointOption.point(point.x + 20, point.y + 20)).perform();
//		}
//	}
//
//	public void addTargetingParameter(String key, String value) {
//		ParameterKey.clear();
//		ParameterKey.sendKeys(key);
//		ParameterValue.clear();
//		ParameterValue.sendKeys(value);
//		ParameterAddButton.click();
//
//	}
//
//	public void removeTargetingParameter() {
//
//	}
//
//	public boolean isParameterAdded(String key, String value) {
//		try {
//			String data = TargetingParam.getText();
//			if (data.split(" : ")[0].equals(key) && data.split(" : ")[1].equals(value))
//				paramFound = true;
//			System.out.println(key + " : " + value + " is present.");
//		} catch (Exception e) {
//			paramFound = false;
//		}
//		return paramFound;
//	}
//
//	public void isParameterRemoved() {
//
//	}
//
//	public void isParameterUpdated() {
//
//	}
//
//	public boolean verifyError(String pName) throws InterruptedException {
//		boolean check = false;
//		// waitForElement(ErrorMessage, 10);
//		Thread.sleep(3000);
//		int i = ErrorMessage.size();
//		
//		String errorMsg = ErrorMessage.get(ErrorMessage.size() - 1).getText();
//		
//		if (pName.equalsIgnoreCase(PlatformName.ANDROID.toString())) {
//			if (errorMsg.equals("Please enter targeting param Key/Value"))
//				check = true;				
//		}else {
//			if (errorMsg.equals("Please enter targeting parameter key and value"))
//				check = true;				
//		}
//		return check;
//	}
//
//	public String verifyErrorMsg() throws InterruptedException {
//		Thread.sleep(3000);
//		int i = ErrorMessage.size();
//		
//		return ErrorMessage.get(ErrorMessage.size() - 1).getText();
//	}
//	
//	public void waitForElement(WebElement ele, int timeOutInSeconds) {
//		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
//		wait.until(ExpectedConditions.visibilityOf(ele));
//	}
//	
//	public void clearAccountId() {
//		AccountID.clear();
//	}
//
//	public void clearSiteName() {
//		SiteName.clear();
//	}

	public void selectCampaign(WebElement ele, String staggingValue) throws InterruptedException {

		if (staggingValue.equals("ON")) {
			Point point = ele.getLocation();
			TouchAction touchAction = new TouchAction((PerformsTouchActions) driver);

			touchAction.tap(PointOption.point(point.x + 20, point.y + 20)).perform();
		}
		Thread.sleep(3000);
	}

	public void addTargetingParameter(WebElement paramKey, WebElement paramValue, String key, String value)
			throws InterruptedException {

		JavascriptExecutor js = (JavascriptExecutor) driver;
		HashMap<String, String> scrollObject = new HashMap<String, String>();
		scrollObject.put("direction", "up");
		js.executeScript("mobile: scroll", scrollObject);

		paramKey.sendKeys(key);

		scrollObject.put("direction", "up");
		js.executeScript("mobile: scroll", scrollObject);

		paramValue.sendKeys(value);

		scrollObject.put("direction", "up");
		js.executeScript("mobile: scroll", scrollObject);

	}

	public String getError() throws InterruptedException {
		boolean check = false;
		// waitForElement(ErrorMessage, 10);
		Thread.sleep(5000);
		int i = ErrorMessage.size();

		String errorMsg = ErrorMessage.get(ErrorMessage.size() - 1).getText();
		return errorMsg;
	}

	public boolean verifyError() throws InterruptedException {
		boolean check = false;
		// waitForElement(ErrorMessage, 10);
		Thread.sleep(3000);
		int i = ErrorMessage.size();

		String errorMsg = ErrorMessage.get(ErrorMessage.size() - 1).getText();
		if (errorMsg.equals("Please enter targeting parameter key and value")) {
			check = true;
		}
		return check;
	}

//	public boolean verifyError() {
//		return paramFound;
//
//	}

	public void waitForElement(WebElement ele, int timeOutInSeconds) {
		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
		wait.until(ExpectedConditions.visibilityOf(ele));
	}

	public boolean verifyErrorMsg(String udid) throws InterruptedException {
		boolean check = false;
		// waitForElement(ErrorMessage, 10);
		Thread.sleep(3000);
		int i = ErrorMessage.size();

		String errorMsg = ErrorMessage.get(ErrorMessage.size() - 1).getText();

		if (errorMsg.equals("Please enter property details")) {
			check = true;
		}
		return check;
	}
}
