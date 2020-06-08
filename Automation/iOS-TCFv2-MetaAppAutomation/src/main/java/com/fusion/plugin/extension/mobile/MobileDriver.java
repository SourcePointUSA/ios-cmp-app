package com.fusion.plugin.extension.mobile;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Stream;

import org.ini4j.Wini;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.DesiredCapabilities;

import com.cybage.frameworkutility.exception.ApplicationException;
import com.cybage.frameworkutility.exception.FrameworkException;
import com.cybage.frameworkutility.utilities.Report;
import com.cybage.frameworkutility.utilities.Report.ExceptionType;
import com.cybage.mobileFramework.BaseMobileDriver;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.ios.IOSDriver;
import io.appium.java_client.ios.IOSElement;
import io.appium.java_client.remote.AndroidMobileCapabilityType;
import io.appium.java_client.remote.AutomationName;
import io.appium.java_client.remote.IOSMobileCapabilityType;
import io.appium.java_client.remote.MobileCapabilityType;

import com.cybage.frameworkutility.utilities.CustomLogging.LogType;
import com.cybage.frameworkutility.utilities.DirectoryOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations.IniFileType;

public class MobileDriver extends BaseMobileDriver implements IMobileDriver {

	public MobileDriver(Report reporter) {
		super(reporter);
	}

	AppiumDriver<WebElement> driver = null;

	/**
	 * 
	 * Perform Enter Key operation
	 *
	 * @param element Perform the enter operation on the given Element
	 * 
	 * @since version 1.00
	 * 
	 */
	public void pressEnterKey(Object element) {
		WebElement webElement = null;
		try {
			webElement = (WebElement) element;
			webElement.sendKeys(Keys.ENTER);
			logger.Log(LogType.INFO, "Successfully, pressed Enter Key");
			reporter.LogPass("Successfully, Pressed <b>" + "Enter Key" + "</b>");
		} catch (Exception e) {
			ApplicationException ec = new ApplicationException(
					"Exception occured while pressing Enter Key. Exception details - " + e.getMessage());
			logger.Log(LogType.FATAL, ec.toString());
			reporter.LogFailwithScreenCapture(ec.toString(), getScreenShot());
			throw ec;
		}
	}

	public synchronized void setup(String udid, String testType) {
		logger.Log(LogType.INFO, "Starting setup for Device - " + udid);

		System.out.println("New ...................... Starting setup for Device - " + udid + " Thread - "
				+ String.valueOf(Thread.currentThread().getId()));

		String appType = System.getenv("type");

		String appName = null;
		String appActivity = null;
		String appPackage = null;
		String test = null;

		if (appType == null) {
			appName = DirectoryOperations.getBaseDirectoryLocation() + File.separator + "AppFile" + File.separator
					+ IniFileOperations.getValueFromIniFile(IniFileType.Execution, testType + "Testing", "AppName");
			System.out.println("Installing app :" + appName);
		} else {
			appName = DirectoryOperations.getBaseDirectoryLocation() + File.separator + "AppFile" + File.separator
					+ IniFileOperations.getValueFromIniFile(IniFileType.Execution, testType + "Testing", "AppName");
			System.out.println("Installing app :" + appName);
		}

		String platformOS = IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformOS");
		String platformName = IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "platformName");
		String url = IniFileOperations.getValueFromIniFile(IniFileType.Execution, testType + "Testing",
				"MobileBaseURL");

		logger.Log(LogType.INFO, "Device Name - " + udid);
		logger.Log(LogType.INFO, "Device platform - " + platformName);
		try {

			DesiredCapabilities caps = new DesiredCapabilities();

			caps.setCapability(MobileCapabilityType.DEVICE_NAME, udid);
			caps.setCapability(MobileCapabilityType.UDID, udid);
			caps.setCapability(MobileCapabilityType.PLATFORM_NAME, platformName);

			if (url.isEmpty()) {
				System.out.println("URL Empty.. Inside second loop....");
				logger.Log(LogType.INFO, "URL Empty.. Inside second loop....");
				logger.Log(LogType.INFO, "App Name - " + appName);

				System.out.println("Before....");
				if (udid.contains("-")) {
					logger.Log(LogType.INFO, "OS Version - " + platformOS);
					caps.setCapability(MobileCapabilityType.PLATFORM_VERSION, platformOS);

					caps.setCapability(MobileCapabilityType.AUTOMATION_NAME, "XCUITest");
					caps.setCapability("waitForQuiescence", "false");
					caps.setCapability("useNewWDA", false);
					// caps.setCapability("connectHardwareKeyboard", true);
					System.out.println("...Running on iPhone simulator");
					caps.setCapability(MobileCapabilityType.APP, appName);
				} else {
					caps.setCapability(MobileCapabilityType.AUTOMATION_NAME, "XCUITest");
					System.out.println("...Running on iPhone real device");
					caps.setCapability(MobileCapabilityType.APP, appName + ".ipa");
					caps.setCapability("fullReset", true);
					caps.setCapability("noReset", false);

				}
				caps.setCapability(MobileCapabilityType.NEW_COMMAND_TIMEOUT, "60");
				caps.setCapability("unicodeKeyboard", false);
//				caps.setCapability("resetKeyboard", true);
//				caps.setCapability("connectHardwareKeyboard", false);
				// System.setProperty("webdriver.http.factory", "apache");

				try {
					driver = new IOSDriver<>(new URL("http://localhost:4723/wd/hub"), caps);
					System.out.println("After....");
					// driver.resetApp();

					logger.Log(LogType.INFO, "Successfully, Launched the application. Application Name - " + appName);
					reporter.LogPass("Successfully, Launched the application. Application Name - " + appName
							+ " On Device - " + udid + " having OS version - " + platformOS);
				} catch (Exception ex) {
					FrameworkException fe = new FrameworkException(ex.getMessage());
					reporter.LogFail(ExceptionType.Application,
							"Exception occured while launching the Application on - " + udid + " having OS version - "
									+ platformOS + ". Exception details - " + fe.getMessage());
					throw fe;
				}

			}

			setWebDriver(driver);

			System.out.println("End - Starting setup for Device - " + udid + " Thread - "
					+ String.valueOf(Thread.currentThread().getId()));

		} catch (

		Exception ex) {
			FrameworkException fe = new FrameworkException(ex.getMessage());
			reporter.LogFail(ExceptionType.Application, "Exception occured while opening browser or Application on - "
					+ udid + " having OS version - " + platformOS + ". Exception details - " + fe.getMessage());
			throw fe;
		}
	}

	/**
	 * 
	 * Closes the Driver object and make the Object Null.
	 * 
	 * @since version 1.00
	 * 
	 */
	public void quit() {
		try {
			System.out.println("***** new quit method ******");
			System.out.println("##### Uninstalling application from device.");

			driver.removeApp("com.sourcepointmeta.app");

			logger.Log(LogType.INFO, "Killing device with version - " + getDriver().getCapabilities().getVersion());
			System.out.println("Killing device with version - " + getDriver().getCapabilities().getVersion()
					+ " Thread - " + String.valueOf(Thread.currentThread().getId()));
			getDriver().quit();
			// driverLocal.remove();
			logger.Log(LogType.INFO, "Successfully, Closed the Mobile driver..");
			System.out.println(
					"Successfully, Closed the Mobile driver..- " + String.valueOf(Thread.currentThread().getId()));
			reporter.LogPass("Successfully, Closed the Mobile driver..");

		} catch (Exception e) {
			reporter.LogFail(ExceptionType.Application,
					"Exception occured while killing Mobile driver. Exception details - " + e.getMessage());
		}
	}

}
