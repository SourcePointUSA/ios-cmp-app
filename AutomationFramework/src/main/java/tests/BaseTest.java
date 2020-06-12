package tests;

import org.framework.appium.AppiumServer;
import org.framework.drivers.AndroidDriverBuilder;
import org.framework.drivers.IOSDriverBuilder;
import org.framework.drivers.WebDriverBuilder;
import org.framework.enums.PlatformName;
import org.framework.enums.PlatformType;
import org.framework.helpers.Page;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.testng.annotations.*;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileDriver;

import static org.framework.logger.LoggingManager.logMessage;

import java.io.IOException;

public class BaseTest extends Page{
    public WebDriver driver = null;

//    @Parameters({"platformType", "platformName"})
//    @BeforeTest
//    public void startAppiumServer(String platformType, @Optional String platformName) throws IOException {
//        if (platformType.equalsIgnoreCase(PlatformType.MOBILE.toString())) {
//            killExistingAppiumProcess();
//            if (AppiumServer.appium == null || !AppiumServer.appium.isRunning()) {
//                AppiumServer.start();
//                logMessage("Appium server has been started");
//            }
//        }
//    }
//
//    @Parameters({"platformType", "platformName"})
//    @AfterTest
//    public void stopAppiumServer(String platformType, @Optional String platformName) throws IOException {
//        if (platformType.equalsIgnoreCase(PlatformType.MOBILE.toString())) {
//            if (AppiumServer.appium != null || AppiumServer.appium.isRunning()) {
//                AppiumServer.stop();
//                logMessage("Appium server has been stopped");
//            }
//        }
//    }

    @Parameters({"platformType", "platformName", "model"})
    @BeforeMethod
    public void setupDriver(String platformType, String platformName, @Optional String model) throws IOException {
    	if (platformType.equalsIgnoreCase(PlatformType.WEB.toString())) {
            setupWebDriver(platformName);
        } else if (platformType.equalsIgnoreCase(PlatformType.MOBILE.toString())) {
            setupMobileDriver(platformName, model);
        }
    }

    public void setupMobileDriver(String platformName, String model) throws IOException {
        if (platformName.equalsIgnoreCase(PlatformName.ANDROID.toString())) {
            driver = new AndroidDriverBuilder().setupDriver(model);
        } else if (platformName.equalsIgnoreCase(PlatformName.IOS.toString())) {
            driver = new IOSDriverBuilder().setupDriver(model);
        }
        logMessage(model + " driver has been created for execution");
    }

    public void setupWebDriver(String platformName) {
        if (platformName.equalsIgnoreCase(PlatformName.CHROME.toString())) {
            driver = new WebDriverBuilder().setupDriver(platformName);
        } else if (platformName.equalsIgnoreCase(PlatformName.FIREFOX.toString())) {
            driver = new WebDriverBuilder().setupDriver(platformName);
        }
        logMessage(platformName + " driver has been created for execution");
        driver.get("https://www.wordpress.com");
    }

    @AfterMethod
    public void teardownDriver() {
        driver.quit();
        logMessage("Driver has been quit from execution");
    }

    private void killExistingAppiumProcess() throws IOException {
        Runtime.getRuntime().exec("killall node");
        logMessage("Killing existing appium process");
    }

}