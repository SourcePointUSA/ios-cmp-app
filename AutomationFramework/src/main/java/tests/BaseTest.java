package tests;

import org.framework.appium.AppiumServer;
import org.framework.drivers.IOSDriverBuilder;
import org.framework.enums.PlatformName;
import org.framework.enums.PlatformType;
import org.framework.helpers.Page;
import org.openqa.selenium.WebDriver;
import org.testng.annotations.*;

import static org.framework.logger.LoggingManager.logMessage;

import java.io.IOException;

public class BaseTest extends Page {
	public WebDriver driver = null;

	@Parameters({ "platformType", "platformName" })
	@BeforeTest
	public void startAppiumServer(String platformType, @Optional String platformName) throws IOException {
		if (platformType.equalsIgnoreCase(PlatformType.MOBILE.toString())) {
			if (AppiumServer.appium == null || !AppiumServer.appium.isRunning()) {
				AppiumServer.start();
				logMessage("Appium server has been started");
			}
		}
	}

	@Parameters({ "platformType", "platformName" })
	@AfterTest
	public void stopAppiumServer(String platformType, @Optional String platformName) throws IOException {
		if (platformType.equalsIgnoreCase(PlatformType.MOBILE.toString())) {
			if (AppiumServer.appium != null || AppiumServer.appium.isRunning()) {
				AppiumServer.stop();
				logMessage("Appium server has been stopped");
			}
		}
	}

	@Parameters({ "platformType", "platformName", "model" })
	@BeforeMethod
	public void setupDriver(String platformType, String platformName, @Optional String model) throws IOException {
		try {
			if (platformType.equalsIgnoreCase(PlatformType.MOBILE.toString())) {
				setupMobileDriver(platformName, model);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void setupMobileDriver(String platformName, String model) throws IOException {
		try {
			if (platformName.equalsIgnoreCase(PlatformName.IOS.toString())) {
				driver = new IOSDriverBuilder().setupDriver(model);
			}
			logMessage(model + " driver has been created for execution");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@AfterMethod
	public void teardownDriver() {
		try {
			driver.quit();
			logMessage("Driver has been quit from execution");
		} catch (Exception e) {
			System.out.println("Exception occured - " + e.getMessage());
			throw e;
		}
	}

}