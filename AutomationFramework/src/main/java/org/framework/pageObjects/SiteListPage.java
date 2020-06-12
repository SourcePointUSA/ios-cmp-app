package org.framework.pageObjects;

import static org.framework.logger.LoggingManager.logMessage;

import java.time.Duration;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.framework.enums.PlatformName;
import org.framework.helpers.Page;
import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileDriver;
import io.appium.java_client.PerformsTouchActions;
import io.appium.java_client.TouchAction;
import io.appium.java_client.touch.WaitOptions;
import io.appium.java_client.touch.offset.PointOption;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
import io.appium.java_client.pagefactory.iOSFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class SiteListPage extends Page {

	WebDriver driver;
	
	 public SiteListPage(WebDriver driver) throws InterruptedException {
	        this.driver = driver;
	        PageFactory.initElements(driver, this);
	        logMessage("Initializing the "+this.getClass().getSimpleName()+" elements");
	        PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	        Thread.sleep(1000);
	    }
	 
	@iOSXCUITFindBy(accessibility = "Add")
	public WebElement GDPRAddButton;

	@iOSXCUITFindBy(accessibility = "Add")
	public WebElement GDPRTCFv2AddButton;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeOther[contains(@name, 'Property List')]")
	public WebElement GDPRSiteListPageHeader;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeStaticText[@name=\'Site List\']")
	public WebElement GDPRSiteListView;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Edit']")
	public WebElement GDPREditButton;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Reset']")
	public WebElement GDPRResetButton;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Trash']")
	public WebElement GDPRDeleteButton;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText[@name=\'propertyCell\'])")
	public List<WebElement> GDPRSiteList;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "propertyName")
	public WebElement GDPRSiteName;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeButton)")
	public List<WebElement> ActionButtons;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
	public List<WebElement> ErrorMessage;

	@iOSXCUITFindBy(accessibility = "YES")
	public WebElement YESButton;

	@iOSXCUITFindBy(accessibility = "NO")
	public WebElement NOButton;

	boolean siteFound = false;

	public boolean isSitePressent_gdpr(String siteName, String udid, List<WebElement> siteList)
			throws InterruptedException {

		siteFound = false;

		if (driver.findElement(By.xpath("//XCUIElementTypeStaticText[@name='propertyCell']")).getText()
				.equals(siteName)) {
			siteFound = true;
		}
//		
//		for (WebElement siteEntry : siteList) {
//			try {
//				if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
//						.equalsIgnoreCase("Android")) {
//					if (siteEntry.findElement(By.id("com.sourcepointmeta.app:id/propertyNameTextView")).getText()
//							.equals(siteName))
//						siteFound = true;
//
//				} else {
//					if (siteEntry.findElement(By.xpath("//XCUIElementTypeOther[@name='propertyName']")).getText()
//							.equals(siteName))
//						siteFound = true;
//
//				}
//				System.out.println(siteName + " is present.");
//			} catch (Exception e) {
//				siteFound = false;
//			}
//			break;
//		}
		System.out.println(siteFound);
		return siteFound;
	}

	public void selectAction(String action) throws InterruptedException {
		Thread.sleep(3000);

		// for(WebElement actionButton : ActionButtons) {
		if (action.equalsIgnoreCase("Reset")) {
			ActionButtons.get(1).click();
		} else if (action.equalsIgnoreCase("Edit")) {
			ActionButtons.get(2).click();
		} else if (action.equalsIgnoreCase("Delete")) {
			ActionButtons.get(3).click();
		}
		// }

	}

	public boolean isSitePressent(String siteName) throws InterruptedException {
		return siteFound;

	}

	public void tapOnSite_gdpr(String siteName, List<WebElement> siteList) throws InterruptedException {
		Thread.sleep(3000);

		driver.findElement(By.xpath("//XCUIElementTypeStaticText[@name='propertyCell']")).click();

//		WebElement aa = null;
//	//	for (WebElement siteEntry : siteList) {
//			try {
//				if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
//						.equalsIgnoreCase("Android")) {
//					aa = driver.findElement(By.id("com.sourcepointmeta.app:id/propertyNameTextView"));
//				} else {
//					aa = driver.findElement(By.xpath("//XCUIElementTypeOther[@name='propertyName']"));
//				}
//				if (aa.getText().equals(siteName))
//					siteEntry.click();
//				Thread.sleep(3000);
//			} catch (Exception e) {
//
//			}
//			break;
//		}

	}

//	public void swipeHorizontaly_gdpr(String siteName, String udid, List<WebElement> siteList)
//			throws InterruptedException {
//		System.out.println("Swipe on " + siteName);
//		WebElement aa = null;
//		for (WebElement siteEntry : siteList) {
//			int a = siteList.size();
//			if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
//					.equalsIgnoreCase("Android")) {
//				aa = siteEntry.findElement(By.id("com.sourcepointmeta.app:id/propertyNameTextView"));
//			} else {
//				aa = siteEntry.findElement(By.xpath("//XCUIElementTypeOther[@name='propertyName']"));
//			}
//			if (aa.getText().equals(siteName)) {
//				System.out.println();
//				Point point = siteEntry.getLocation();
//				TouchAction action = new TouchAction((PerformsTouchActions) driver);
//
//				int[] rightTopCoordinates = { aa.getLocation().getX() + aa.getSize().getWidth(),
//						aa.getLocation().getY() };
//				int[] leftTopCoordinates = { aa.getLocation().getX(), aa.getLocation().getY() };
//				action.press(PointOption.point(rightTopCoordinates[0] - 1, rightTopCoordinates[1] + 1))
//						.waitAction(WaitOptions.waitOptions(Duration.ofMillis(3000)))
//						.moveTo(PointOption.point(leftTopCoordinates[0] + 1, leftTopCoordinates[1] + 1)).release()
//						.perform();
//
//				Thread.sleep(3000);
//
//				break;
//			}
//		}
//	}

	public void swipeHorizontaly_gdpr(String siteName) throws InterruptedException {
		System.out.println("Swipe on " + siteName);
		WebElement aa = (WebElement) driver
				.findElement(By.xpath("//XCUIElementTypeStaticText[@name='propertyCell']"));

		Point point = aa.getLocation();
		TouchAction action = new TouchAction((PerformsTouchActions) driver);

		int[] rightTopCoordinates = { aa.getLocation().getX() + aa.getSize().getWidth(), aa.getLocation().getY() };
		int[] leftTopCoordinates = { aa.getLocation().getX(), aa.getLocation().getY() };
		action.press(PointOption.point(rightTopCoordinates[0] - 1, rightTopCoordinates[1] + 1))
				.waitAction(WaitOptions.waitOptions(Duration.ofMillis(3000)))
				.moveTo(PointOption.point(leftTopCoordinates[0] + 1, leftTopCoordinates[1] + 1)).release().perform();

		Thread.sleep(8000);
	}

	public void waitForElement(WebElement ele, int timeOutInSeconds) {
		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
		wait.until(ExpectedConditions.visibilityOf(ele));
	}

	public boolean verifyDeleteSiteMessage(String udid) {
			return ErrorMessage.get(ErrorMessage.size() - 1).getText().contains("Are you sure you want to");
		
	}

//	public void removeGDPRApp() {
//		driver.removeApp("com.sourcepointmeta.app");
//	}
//
//	public void removeCCPAApp() {
//		driver.removeApp("com.sourcepointccpa.app");
//	}

//	public void installApp(String udid) {
//		String appType = System.getenv("type");
//		String appName = null;
//		String test = null;
//
//		if (appType == null) {
//			appName = DirectoryOperations.getBaseDirectoryLocation() + File.separator + "AppFile" + File.separator
//					+ IniFileOperations.getValueFromIniFile(IniFileType.Execution, "Mobile" + "Testing", "AppName");
//			System.out.println("Installing app :" + appName);
//		} else {
//			if (appType.split("-")[1].contains("TCFv2")) {
//				test = appType.split("-")[1].replace("TCFv2", "");
//			} else {
//				test = appType.split("-")[1];
//			}
//			appName = test + "-MetaApp";
//
//			appName = DirectoryOperations.getBaseDirectoryLocation() + File.separator + "AppFile" + File.separator
//					+ appName;
//			System.out.println("Installing app :" + appName);
//		}
//
//		if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
//				.equalsIgnoreCase("Android")) {
//			driver.installApp(appName + ".apk");
//			driver.launchApp();
//		} else {
//			driver.installApp(appName + ".app");
//			driver.launchApp();
//		}



//	@iOSXCUITFindBy(accessibility = "Add")
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/action_addWebsite")
//	public WebElement AddButton;
//
//	@iOSFindBy(xpath = "//XCUIElementTypeOther[contains(@name, 'Site List')]")
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/toolbar_title")
//	public WebElement SiteListPageHeader;
//
//	@iOSXCUITFindBy(xpath = "//XCUIElementTypeStaticText[@name=\'Site List\']")
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/websiteListRecycleView")
//	public WebElement SiteListView;
//
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/websiteNameTextView")
//	public WebElement WebSiteName;
//
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/details_button")
//	public WebElement DetailsButton;
//
//	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Edit']")
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/edit_button")
//	public WebElement EditButton;
//
//	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Reset']")
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/reset_button")
//	public WebElement ResetButton;
//
//	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
//	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Trash']")
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/delete_button")
//	public WebElement DeleteButton;
//
//	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
//	@iOSXCUITFindBy(accessibility = "websiteCell")
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/item_view")
//	public List<WebElement> SiteList;
//
//	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
//	@iOSXCUITFindBy(accessibility = "websiteName")
//	@AndroidFindBy(id = "com.sourcepointmeta.app:id/websiteNameTextView")
//	public WebElement SiteName;
//
//	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
//	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
//	@AndroidFindBy(id = "android:id/message")
//	public List<WebElement> ErrorMessage;
//
//	@iOSXCUITFindBy(accessibility = "YES")
//	@AndroidFindBy(id = "android:id/button1")
//	public WebElement YESButton;
//
//	@iOSXCUITFindBy(accessibility = "NO")
//	@AndroidFindBy(id = "android:id/button2")
//	public WebElement NOButton;
//
//	boolean siteFound = false;
//
//	public SiteListPage(WebDriver driver) throws InterruptedException {
//		this.driver = driver;
//		PageFactory.initElements(driver, this);
//		logMessage("Initializing the " + this.getClass().getSimpleName() + " elements");
//		PageFactory.initElements(new AppiumFieldDecorator(driver), this);
//		Thread.sleep(1000);
//	}
//
//	public String getHeader() {
//		return SiteListPageHeader.getText();
//	}
//
//	public void chooseAdd() {
//		clickElement(AddButton);
//	}
//
//	public boolean isSitePressent(String siteName, String platformName) throws InterruptedException {
//		siteFound = false;
//		for (WebElement siteEntry : SiteList) {
//			try {
//				if (platformName.equalsIgnoreCase("Android")) {
//					if (siteEntry.findElement(By.id("com.sourcepointmeta.app:id/websiteNameTextView")).getText()
//							.equals(siteName))
//						siteFound = true;
//
//				} else {
//					if (siteEntry.findElement(By.xpath("//XCUIElementTypeOther[@name='websiteName']")).getText()
//							.equals(siteName))
//						siteFound = true;
//
//				}
//				System.out.println(siteName + " is present.");
//			} catch (Exception e) {
//				siteFound = false;
//			}
//			break;
//		}
//		System.out.println(siteFound);
//		return siteFound;
//	}
//
//	public void tapOnSite(String siteName, String pName) throws InterruptedException {
//		Thread.sleep(3000);
//		WebElement aa = null;
//		for (WebElement siteEntry : SiteList) {
//			try {
//				if (pName.equalsIgnoreCase(PlatformName.ANDROID.toString())) {
//					aa = siteEntry.findElement(By.id("com.sourcepointmeta.app:id/websiteNameTextView"));
//				} else {
//					aa = siteEntry.findElement(By.xpath("//XCUIElementTypeOther[@name='websiteName']"));
//				}
//				if (aa.getText().equals(siteName))
//					siteEntry.click();
//				Thread.sleep(3000);
//			} catch (Exception e) {
//
//			}
//			break;
//		}
//	}
//
//	public void swipeHorizontaly(String siteName, String pName) throws InterruptedException {
//		System.out.println("Swipe on " + siteName);
//		WebElement aa = null;
//		for (WebElement siteEntry : SiteList) {
//			int a = SiteList.size();
//			if (pName.equalsIgnoreCase(PlatformName.ANDROID.toString())) {
//				aa = siteEntry.findElement(By.id("com.sourcepointmeta.app:id/websiteNameTextView"));
//			} else {
//				aa = siteEntry.findElement(By.xpath("//XCUIElementTypeOther[@name='websiteName']"));
//			}
//			if (aa.getText().equals(siteName)) {
//				System.out.println();
//				Point point = siteEntry.getLocation();
//				TouchAction action = new TouchAction((PerformsTouchActions) driver);
//
//				int[] rightTopCoordinates = { aa.getLocation().getX() + aa.getSize().getWidth(),
//						aa.getLocation().getY() };
//				int[] leftTopCoordinates = { aa.getLocation().getX(), aa.getLocation().getY() };
//				action.press(PointOption.point(rightTopCoordinates[0] - 1, rightTopCoordinates[1] + 1))
//						.waitAction(WaitOptions.waitOptions(Duration.ofMillis(3000)))
//						.moveTo(PointOption.point(leftTopCoordinates[0] + 1, leftTopCoordinates[1] + 1)).release()
//						.perform();
//
//				// action.press(PointOption.point(point.getX() +
//				// (siteEntry.getSize().getWidth()),
////						point.getY() + (siteEntry.getSize().getHeight()))).waitAction()
////						.moveTo(PointOption.point(point.getX() + (siteEntry.getSize().getWidth() / 80),
////								point.getY() + (siteEntry.getSize().getWidth() / 2)))
////						.release().perform();
//
//				Thread.sleep(3000);
////			     waitForElement(DeleteButton, 5);
//
//				break;
//			}
//		}
//	}
//
////	/**
////     * Swipe left on an element
////     * @param element WebElement to swipe on
////     * @param duration duration of the swipe in milliseconds
////     */
////	public void swipeHorizontaly(String siteName, String pName) {
////        TouchAction action = new TouchAction((PerformsTouchActions) driver);
////        List rightTopCoordinates = [element.getLocation().getX() + element.getSize().getWidth(), element.getLocation().getY()]
////        List leftTopCoordinates = [element.getLocation().getX(), element.getLocation().getY()]
////        action.press(PointOption.point(rightTopCoordinates[0] - 1, rightTopCoordinates[1] + 1)).waitAction(WaitOptions.waitOptions(Duration.ofMillis(durationInMs))).moveTo(PointOption.point(leftTopCoordinates[0] + 1, leftTopCoordinates[1] + 1)).release().perform()
////    }
//
////	public void swipeHorizontaly(String siteName, String pName) {
////		System.out.println("Swipe on " + siteName);
////		WebElement aa = null;
////		for (WebElement siteEntry : SiteList) {
////			int a = SiteList.size();
////			 if (pName.equalsIgnoreCase(PlatformName.ANDROID.toString())) {
////			 aa = siteEntry.findElement(By.id("com.sourcepointmeta.app:id/websiteNameTextView"));
////			}else {
////				aa=siteEntry.findElement(By.xpath("//XCUIElementTypeOther[@name='websiteName']"));
////			}
////			if (aa.getText().equals(siteName)) {
////				TouchAction action = new TouchAction((PerformsTouchActions) driver);
////				System.out.println();
////				Dimension size = aa.getSize();
////				
////				int x2 = (int) (size.width * 0.80);
////				action.press(aa).moveTo(x2,580).release().perform();
////				        
////				waitForElement(DeleteButton, 5);
////
////				break;
////			}
////		}
////	}
//
//	public void waitForElement(WebElement deleteButton2, int timeOutInSeconds) {
//		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
//		wait.until(ExpectedConditions.visibilityOf(deleteButton2));
//	}
//
//	public boolean verifyDeleteSiteMessage() {
//		return ErrorMessage.get(ErrorMessage.size() - 1).getText().equals("Do you want to delete this site?");
//
//	}
}
