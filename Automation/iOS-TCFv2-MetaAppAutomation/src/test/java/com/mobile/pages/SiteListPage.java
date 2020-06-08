package com.mobile.pages;

import java.io.File;
import java.time.Duration;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.management.MalformedObjectNameException;

import jnr.ffi.Struct.mode_t;
import jnr.ffi.Struct.time_t;
import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;
import io.appium.java_client.PerformsTouchActions;
import io.appium.java_client.TouchAction;
//import io.appium.java_client.android.AndroidKeyCode;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.pagefactory.WithTimeout;
//import io.appium.java_client.pagefactory.iOSFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.touch.WaitOptions;
import io.appium.java_client.touch.offset.PointOption;

import org.apache.commons.collections.functors.ExceptionClosure;
import org.apache.hadoop.util.PlatformName;
import org.openqa.selenium.By;
import org.openqa.selenium.Point;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.cybage.frameworkutility.utilities.DirectoryOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations.IniFileType;
import com.fusion.plugin.extension.mobile.IMobileDriver;
import com.fusion.plugin.extension.mobile.MobileDriver;
import com.sun.org.apache.bcel.internal.ExceptionConstants;

public class SiteListPage {

	private AppiumDriver driver;
	String platformName = System.getProperty("os.name");

	public SiteListPage(IMobileDriver appiumDriver) {
		driver = appiumDriver.getDriver();
		PageFactory.initElements(new AppiumFieldDecorator(driver), this);
	}

	@iOSXCUITFindBy(accessibility = "Add")
	public MobileElement GDPRAddButton;

	@iOSXCUITFindBy(accessibility = "Add")
	public MobileElement GDPRTCFv2AddButton;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeOther[contains(@name, 'Property List')]")
	public MobileElement GDPRSiteListPageHeader;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeStaticText[@name=\'Site List\']")
	public MobileElement GDPRSiteListView;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Edit']")
	public MobileElement GDPREditButton;

	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Reset']")
	public MobileElement GDPRResetButton;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "//XCUIElementTypeButton[@name='Trash']")
	public MobileElement GDPRDeleteButton;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText[@name=\'propertyCell\'])")
	public List<MobileElement> GDPRSiteList;

	@WithTimeout(time = 30, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(accessibility = "propertyName")
	public MobileElement GDPRSiteName;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeButton)")
	public List<MobileElement> ActionButtons;

	@WithTimeout(time = 50, chronoUnit = ChronoUnit.SECONDS)
	@iOSXCUITFindBy(xpath = "(//XCUIElementTypeStaticText)")
	public List<MobileElement> ErrorMessage;

	@iOSXCUITFindBy(accessibility = "YES")
	public MobileElement YESButton;

	@iOSXCUITFindBy(accessibility = "NO")
	public MobileElement NOButton;

	boolean siteFound = false;

	public boolean isSitePressent_gdpr(String siteName, String udid, List<MobileElement> siteList)
			throws InterruptedException {

		siteFound = false;

		if (driver.findElement(By.xpath("//XCUIElementTypeStaticText[@name='propertyCell']")).getText()
				.equals(siteName)) {
			siteFound = true;
		}
//		
//		for (MobileElement siteEntry : siteList) {
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

		// for(MobileElement actionButton : ActionButtons) {
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

	public void tapOnSite_gdpr(String siteName, String udid, List<MobileElement> siteList) throws InterruptedException {
		Thread.sleep(3000);

		driver.findElement(By.xpath("//XCUIElementTypeStaticText[@name='propertyCell']")).click();

//		MobileElement aa = null;
//	//	for (MobileElement siteEntry : siteList) {
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

//	public void swipeHorizontaly_gdpr(String siteName, String udid, List<MobileElement> siteList)
//			throws InterruptedException {
//		System.out.println("Swipe on " + siteName);
//		MobileElement aa = null;
//		for (MobileElement siteEntry : siteList) {
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
		MobileElement aa = (MobileElement) driver
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

	public void waitForElement(MobileElement ele, int timeOutInSeconds) {
		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
		wait.until(ExpectedConditions.visibilityOf(ele));
	}

	public boolean verifyDeleteSiteMessage(String udid) {
		if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			return ErrorMessage.get(ErrorMessage.size() - 1).getText().contains("Do you want to delete this property?");
		} else {
			return ErrorMessage.get(ErrorMessage.size() - 1).getText().contains("Are you sure you want to");
		}
	}

	public void removeGDPRApp() {
		driver.removeApp("com.sourcepointmeta.app");
	}

	public void removeCCPAApp() {
		driver.removeApp("com.sourcepointccpa.app");
	}

	public void installApp(String udid) {
		String appType = System.getenv("type");
		String appName = null;
		String test = null;

		if (appType == null) {
			appName = DirectoryOperations.getBaseDirectoryLocation() + File.separator + "AppFile" + File.separator
					+ IniFileOperations.getValueFromIniFile(IniFileType.Execution, "Mobile" + "Testing", "AppName");
			System.out.println("Installing app :" + appName);
		} else {
			if (appType.split("-")[1].contains("TCFv2")) {
				test = appType.split("-")[1].replace("TCFv2", "");
			} else {
				test = appType.split("-")[1];
			}
			appName = test + "-MetaApp";

			appName = DirectoryOperations.getBaseDirectoryLocation() + File.separator + "AppFile" + File.separator
					+ appName;
			System.out.println("Installing app :" + appName);
		}

		if (IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName")
				.equalsIgnoreCase("Android")) {
			driver.installApp(appName + ".apk");
			driver.launchApp();
		} else {
			driver.installApp(appName + ".app");
			driver.launchApp();
		}

	}
}
