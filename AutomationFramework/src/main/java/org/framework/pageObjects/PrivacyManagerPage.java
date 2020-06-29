package org.framework.pageObjects;

import static org.framework.logger.LoggingManager.logMessage;

import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.framework.helpers.Page;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class PrivacyManagerPage extends Page {

	WebDriver driver;

	public PrivacyManagerPage(WebDriver driver) throws InterruptedException {
		this.driver = driver;
		PageFactory.initElements(driver, this);
		logMessage("Initializing the " + this.getClass().getSimpleName() + " elements");
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
	public WebElement tcfv2_Cancel;

	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText[@name='Off'])[1]")
	public WebElement tcfv2_On;

	@WithTimeout(time = 80, chronoUnit = ChronoUnit.SECONDS)
	public List<WebElement> ONToggleButtons;

	public void scrollAndClick(String text) throws InterruptedException {
		JavascriptExecutor js = (JavascriptExecutor) driver;
		HashMap<String, String> scrollObject = new HashMap<String, String>();

		scrollObject.put("direction", "down");
		js.executeScript("mobile: scroll", scrollObject);
		js.executeScript("mobile: scroll", scrollObject);
		WebElement ele = driver.findElement(By.xpath("//XCUIElementTypeButton[@name='" + text + "']"));
		try {
			ele.click();
		} catch (Exception ex) {
			throw ex;
		}

	}

	boolean privacyManageeFound = false;

	public boolean isPrivacyManagerViewPresent() throws InterruptedException {
		waitForElement(tcfv2_AcceptAll, timeOutInSeconds);
		try {
			if (driver.findElements(By.xpath("//XCUIElementTypeStaticText[contains(@name,'Privacy Manager')]"))
					.size() > 0)
				privacyManageeFound = true;

		} catch (Exception e) {
			privacyManageeFound = false;
			throw e;
		}
		return privacyManageeFound;
	}

	public void waitForElement(WebElement ele, int timeOutInSeconds) {
		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
		wait.until(ExpectedConditions.visibilityOf(ele));
	}
}
