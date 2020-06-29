package tests;

import org.framework.allureReport.TestListener;
import org.framework.appium.AppiumServer;
import org.framework.drivers.IOSDriverBuilder;
import org.framework.enums.PlatformName;
import org.framework.helpers.Page;
import org.openqa.selenium.WebDriver;
import org.testng.annotations.*;
import static org.framework.logger.LoggingManager.logMessage;
import java.io.IOException;

@Listeners({ TestListener.class })
public class BaseTest extends Page {
	public WebDriver driver = null;
	
	@BeforeTest
	public void startAppiumServer() throws IOException {
			if (AppiumServer.appium == null || !AppiumServer.appium.isRunning()) {
				AppiumServer.start();
				logMessage("Appium server has been started");
			}
		}

	@AfterTest
	public void stopAppiumServer() throws IOException {
			if (AppiumServer.appium != null || AppiumServer.appium.isRunning()) {
				AppiumServer.stop();
				logMessage("Appium server has been stopped");
			}
		}

	@Parameters({ "platformName", "model" })
	@BeforeMethod
	public void setupDriver(String platformName, @Optional String model) throws IOException {
		try {
				setupMobileDriver(platformName, model);
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