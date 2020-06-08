package com.mobile.pages;

import java.time.Duration;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileBy;
import io.appium.java_client.MobileElement;
import io.appium.java_client.PerformsTouchActions;
import io.appium.java_client.TouchAction;
import io.appium.java_client.android.AndroidElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.touch.WaitOptions;
import io.appium.java_client.touch.offset.PointOption;

import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.interactions.touch.TouchActions;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.stringtemplate.v4.compiler.CodeGenerator.conditional_return;
import org.testng.Assert;

import com.cybage.frameworkutility.utilities.IniFileOperations;
import com.cybage.frameworkutility.utilities.Report;
import com.cybage.frameworkutility.utilities.IniFileOperations.IniFileType;
import com.fusion.plugin.extension.mobile.IMobileDriver;
import com.gargoylesoftware.htmlunit.ElementNotFoundException;

public class ConsentViewPage {

	private AppiumDriver driver;

	public ConsentViewPage(IMobileDriver appiumDriver) {
		driver = appiumDriver.getDriver();
		PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	}

	protected Report reporter = null;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	public MobileElement ConsentMessageView;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	public MobileElement ConsentMessageTitleText;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	public MobileElement ConsentMessageBodyText;

	@iOSXCUITFindBy(accessibility = "Close")
	public MobileElement CloseButton;

	@iOSXCUITFindBy(accessibility = "Continue")
	public MobileElement ContinueButton;

	@iOSXCUITFindBy(accessibility = "Accept all cookies")
	public MobileElement AcceptallCookiesButton;

	@iOSXCUITFindBy(accessibility = "Accept All cookies")
	public MobileElement AcceptAllCookiesButton;

	@iOSXCUITFindBy(accessibility = "Reject all cookies")
	public MobileElement RejectAllCookiesButton;

	@iOSXCUITFindBy(accessibility = "Show Purposes")
	public MobileElement ShowPurposesButton;

	@WithTimeout(time = 80, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
	public List<MobileElement> ConsentMessage;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	public MobileElement ErrorMessageView;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
	public List<MobileElement> WrongCampaignErrorText;

	@iOSXCUITFindBy(accessibility = "SHOW SITE INFO")
	public MobileElement ShowSiteInfoButton;

	@iOSXCUITFindBy(accessibility = "CLEAR COOKIES")
	public MobileElement ClearCookiesButton;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
	public List<MobileElement> DeleteCookiesMessage;

	@iOSXCUITFindBy(accessibility = "YES")
	public MobileElement YESButton;

	@iOSXCUITFindBy(accessibility = "NO")
	public MobileElement NOButton;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "NO")
	public List<MobileElement> ConsentButtons;

	////////////////// TCFv2 application elements

	public MobileElement eleButton;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
	public List<MobileElement> AllButtons;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='MANAGE PREFERENCES']")
	public MobileElement tcfv2_ManagaePreferences;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='ACCEPT ALL']")
	public MobileElement tcfv2_AcceptAll;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='REJECT ALL']")
	public MobileElement tcfv2_RejectAll;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeStaticText[@name='X']")
	public MobileElement tcfv2_Dismiss;

	boolean errorFound = false;

	public MobileElement eleButton(String udid, String buttonText) throws InterruptedException {

		if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			for (MobileElement button : AllButtons) {
				if (button.getAttribute("text") != null && button.getAttribute("text").equals(buttonText)) {
					eleButton = (MobileElement) driver
							.findElement(By.xpath("//android.widget.Button[@text='" + buttonText + "']"));
				} else if (button.getAttribute("content-desc") != null
						&& button.getAttribute("content-desc").equals(buttonText)) {
					System.out.println("testing");
					eleButton = (MobileElement) driver
							.findElement(By.xpath("//android.widget.Button[@content-desc='" + buttonText + "']"));
				}
			}
		} else {
			eleButton = (MobileElement) driver
					.findElement(By.xpath("//XCUIElementTypeButton[@name='" + buttonText + "']"));
			Thread.sleep(3000);
			// eleButton = (MobileElement) driver.findElement(By.("+buttonText+"));

		}
		return eleButton;

	}

	public void closeConsentView() {

	}

	public void switchToWebView() {

	}

	public void loadTime() {
		try {

			long startTime = System.currentTimeMillis();
			new WebDriverWait(driver, 120).until(ExpectedConditions.presenceOfElementLocated(
					By.xpath("//android.webkit.WebView[contains(@text,'Notice Message App')]")));
			// new WebDriverWait(driver,
			// 60).until(ExpectedConditions.presenceOfElementLocated(By.xpath("//android.widget.Button[contains(@text,'Privacy
			// Setting')]")));
			long endTime = System.currentTimeMillis();
			long totalTime = endTime - startTime;
			System.out.println("**** Total Message Load Time: " + totalTime + " milliseconds");
		} catch (Exception ex) {
			System.out.println(ex);
			throw ex;
		}

	}

	public void scrollAndClick(String udid, String text) throws InterruptedException {
		JavascriptExecutor js = (JavascriptExecutor) driver;
		HashMap<String, String> scrollObject = new HashMap<String, String>();

		scrollObject.put("direction", "down");
		js.executeScript("mobile: scroll", scrollObject);
		js.executeScript("mobile: scroll", scrollObject);
		Thread.sleep(2000);
		
		//driver.findElement(By.xpath("//XCUIElementTypeButton[@name='" + text + "']")).click();
		try {
		//	long startTime = System.currentTimeMillis();
//			new WebDriverWait(driver, 120).until(ExpectedConditions.presenceOfElementLocated(
//					By.xpath("//XCUIElementTypeButton[@name='" + text + "']")));
//			
			driver.findElement(By.xpath("//XCUIElementTypeButton[@name='" + text + "']")).click();
		}catch(ElementNotFoundException ex){
			throw ex;
		}
		
		
	}

	public void scrollDown() {
		Dimension dimension = driver.manage().window().getSize();

		Double scrollHeightStart = dimension.getHeight() * 0.5;
		int scrollStart = scrollHeightStart.intValue();

		Double scrollHeightEnd = dimension.getHeight() * 0.8;
		int scrollEnd = scrollHeightEnd.intValue();

		new TouchAction((PerformsTouchActions) driver).press(PointOption.point(0, scrollStart))
				.waitAction(WaitOptions.waitOptions(Duration.ofSeconds(2))).moveTo(PointOption.point(0, scrollEnd))
				.release().perform();
	}

	ArrayList<String> consentMsg = new ArrayList<String>();

	ArrayList<String> expectedList = new ArrayList<String>();

	public void expectedList() {
		expectedList.add("");
		expectedList.add("");
	}

	public ArrayList<String> getConsentMessageDetails(String udid) throws InterruptedException {
		Thread.sleep(8000);
		Thread.sleep(10000);
		for (MobileElement msg : ConsentMessage) {
			consentMsg.add(msg.getText());
			// consentMsg.add(msg.getAttribute("value"));
		}
		return consentMsg;
	}

	public void getLocation() {
		for (MobileElement msg : ConsentMessage) {
			Point point = msg.getLocation();
			TouchAction touchAction = new TouchAction((PerformsTouchActions) driver);
			System.out.println("******************");
			System.out.println((point.x) + (msg.getSize().getWidth()));
			System.out.println((point.y) + (msg.getSize().getWidth()));
			System.out.println("******************");
		}
	}

	public String verifyWrongCampaignError() throws InterruptedException {
		Thread.sleep(3000);
		try {
			return WrongCampaignErrorText.get(WrongCampaignErrorText.size() - 1).getText();
		} catch (Exception e) {
			throw e;
		}
	}

	public void waitForElement(MobileElement ele, int timeOutInSeconds) {
		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
		wait.until(ExpectedConditions.visibilityOf(ele));
	}

	public void clickOnButton(String buttonName) {
		for (MobileElement button : ConsentButtons) {
			if (button.getText().equals(buttonName)) {
				button.click();
				break;
			}
		}
	}

	public boolean verifyDeleteCookiesMessage() {
		return DeleteCookiesMessage.get(DeleteCookiesMessage.size() - 1).getText()
				.contains("Cookies for all properties will be");
	}

}
