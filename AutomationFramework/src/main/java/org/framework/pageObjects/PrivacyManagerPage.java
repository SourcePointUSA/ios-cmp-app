package org.framework.pageObjects;

import static org.framework.logger.LoggingManager.logMessage;

import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.framework.enums.PlatformName;
import org.framework.helpers.Page;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import io.appium.java_client.PerformsTouchActions;
import io.appium.java_client.TouchAction;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.touch.offset.PointOption;

public class PrivacyManagerPage extends Page {

	WebDriver driver;

	 public PrivacyManagerPage(WebDriver driver) throws InterruptedException {
	        this.driver = driver;
	        PageFactory.initElements(driver, this);
	        logMessage("Initializing the "+this.getClass().getSimpleName()+" elements");
	        PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	        Thread.sleep(1000);
	    } 
	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	public WebElement PrivacyManagerView;

	public WebElement eleButton;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	public List<WebElement> AllButtons;

	// TCFV2 application elements
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Accept All']")
	public WebElement tcfv2_AcceptAll;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Save & Exit']")
	public WebElement tcfv2_SaveAndExitButton;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Reject All']")
	public WebElement tcfv2_RejectAll;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Cancel']")
	@AndroidFindBy(xpath = "//android.widget.Button[@text='Cancel']")
	public WebElement tcfv2_Cancel;

	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText[@name='Off'])[1]")
	public WebElement tcfv2_On;

	@WithTimeout(time = 80, chronoUnit = ChronoUnit.SECONDS)
	public List<WebElement> ONToggleButtons;

//	public void scrollDown(String udid) throws InterruptedException {
//		JavascriptExecutor js = (JavascriptExecutor) driver;
//		HashMap<String, String> scrollObject = new HashMap<String, String>();
//
//		if (!IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
//				.equalsIgnoreCase("Android")) {
//			scrollObject.put("direction", "down");
//			js.executeScript("mobile: scroll", scrollObject);
//			js.executeScript("mobile: scroll", scrollObject);
//		}
//		Thread.sleep(2000);
//	}

	public void scrollAndClick(String text) throws InterruptedException {

		// driver.hideKeyboard();

		JavascriptExecutor js = (JavascriptExecutor) driver;
		HashMap<String, String> scrollObject = new HashMap<String, String>();

		scrollObject.put("direction", "down");
		js.executeScript("mobile: scroll", scrollObject);
		js.executeScript("mobile: scroll", scrollObject);
		Thread.sleep(2000);
		driver.findElement(By.xpath("//XCUIElementTypeButton[@name='" + text + "']")).click();

	}

	public void loadTime() {
		long startTime = System.currentTimeMillis();
		new WebDriverWait(driver, 60).until(
				ExpectedConditions.presenceOfElementLocated(By.xpath("//android.widget.Button[@text='Cancel']")));
		long endTime = System.currentTimeMillis();
		long totalTime = endTime - startTime;
		System.out.println("**** Total Privacy Manager Load Time: " + totalTime + " milliseconds");
	}

	boolean privacyManageeFound = false;

	public boolean isPrivacyManagerViewPresent() throws InterruptedException {
		Thread.sleep(8000);

		try {
			// if (driver.findElements(By.xpath("//XCUIElementTypeStaticText[@name='FRENCH
			// Privacy Manager']")).size() > 0)
			if (driver.findElements(By.xpath("//XCUIElementTypeStaticText[contains(@name,'Privacy Manager')]"))
					.size() > 0)
				privacyManageeFound = true;

		} catch (Exception e) {
			privacyManageeFound = false;
			throw e;
		}
		return privacyManageeFound;
	}

	public WebElement eleButton(String udid, String buttonText) {
		eleButton = (WebElement) driver.findElement(By.id("+buttonText+"));
		return eleButton;

	}

}
