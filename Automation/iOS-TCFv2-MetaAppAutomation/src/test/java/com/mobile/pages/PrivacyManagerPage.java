package com.mobile.pages;

import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.hadoop.util.PlatformName;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Point;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.cybage.frameworkutility.utilities.IniFileOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations.IniFileType;
import com.fusion.plugin.extension.mobile.IMobileDriver;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileBy;
import io.appium.java_client.MobileElement;
import io.appium.java_client.PerformsTouchActions;
import io.appium.java_client.TouchAction;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.touch.offset.PointOption;

public class PrivacyManagerPage {

	private AppiumDriver driver;

	public PrivacyManagerPage(IMobileDriver appiumDriver) {
		driver = appiumDriver.getDriver();
		PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	}

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	public MobileElement PrivacyManagerView;

	public MobileElement eleButton;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	public List<MobileElement> AllButtons;

	// TCFV2 application elements
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Accept All']")
	public MobileElement tcfv2_AcceptAll;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Save & Exit']")
	public MobileElement tcfv2_SaveAndExitButton;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Reject All']")
	public MobileElement tcfv2_RejectAll;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Cancel']")
	@AndroidFindBy(xpath = "//android.widget.Button[@text='Cancel']")
	public MobileElement tcfv2_Cancel;

	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText[@name='Off'])[1]")
	public MobileElement tcfv2_On;

	@WithTimeout(time = 80, chronoUnit = ChronoUnit.SECONDS)
	public List<MobileElement> ONToggleButtons;

	public void scrollDown(String udid) throws InterruptedException {
		JavascriptExecutor js = (JavascriptExecutor) driver;
		HashMap<String, String> scrollObject = new HashMap<String, String>();

		if (!IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			scrollObject.put("direction", "down");
			js.executeScript("mobile: scroll", scrollObject);
			js.executeScript("mobile: scroll", scrollObject);
		}
		Thread.sleep(2000);
	}

	public void scrollAndClick(String udid, String text) throws InterruptedException {

		driver.hideKeyboard();

		if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {

			Thread.sleep(8000);
			driver.findElement(MobileBy.AndroidUIAutomator(
					"new UiScrollable(new UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().textContains(\""
							+ text + "\").instance(0))"))
					.click();

		} else {
			JavascriptExecutor js = (JavascriptExecutor) driver;
			HashMap<String, String> scrollObject = new HashMap<String, String>();

			scrollObject.put("direction", "down");
			js.executeScript("mobile: scroll", scrollObject);
			js.executeScript("mobile: scroll", scrollObject);
			Thread.sleep(2000);
			driver.findElement(By.xpath("//XCUIElementTypeButton[@name='" + text + "']")).click();
		}
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

	public boolean isPrivacyManagerViewPresent(String udid) throws InterruptedException {
		Thread.sleep(8000);

		try {
			if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
					.equalsIgnoreCase("Android")) {
				// if
				// (driver.findElements(By.xpath("//*[@resource-id='__genieContainer']")).size()
				// > 0)
				if (driver.findElements(By.xpath("//*[@class='android.webkit.WebView']")).size() > 0)
					privacyManageeFound = true;
			} else {
				// if (driver.findElements(By.xpath("//XCUIElementTypeStaticText[@name='FRENCH
				// Privacy Manager']")).size() > 0)
				if (driver.findElements(By.xpath("//XCUIElementTypeStaticText[contains(@name,'Privacy Manager')]"))
						.size() > 0)
					privacyManageeFound = true;
			}

		} catch (Exception e) {
			privacyManageeFound = false;
			throw e;
		}
		return privacyManageeFound;
	}

	public MobileElement eleButton(String udid, String buttonText) {

		if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			for (MobileElement button : AllButtons) {
				if (button.getAttribute("text") != null && button.getAttribute("text").equals(buttonText)) {
					eleButton = (MobileElement) driver
							.findElement(By.xpath("//android.view.View[@text='" + buttonText + "']"));
				} else if (button.getAttribute("content-desc") != null
						&& button.getAttribute("content-desc").equals(buttonText)) {
					System.out.println("testing");
					eleButton = (MobileElement) driver.findElement(By.xpath("//[@content-desc='" + buttonText + "']"));
				}
			}
		} else {

			eleButton = (MobileElement) driver.findElement(By.id("+buttonText+"));

		}
		return eleButton;

	}

}
