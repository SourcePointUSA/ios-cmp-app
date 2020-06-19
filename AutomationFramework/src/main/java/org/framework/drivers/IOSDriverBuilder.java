package org.framework.drivers;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileDriver;
import io.appium.java_client.ios.IOSDriver;
import io.appium.java_client.remote.MobileCapabilityType;

import org.framework.config.DeviceConfig;
import org.framework.config.IOSDeviceModel;
import org.framework.utils.FileUtility;
import org.openqa.selenium.remote.DesiredCapabilities;

import static org.framework.logger.LoggingManager.logMessage;

import java.io.IOException;
import java.net.URL;
import java.util.concurrent.TimeUnit;

public class IOSDriverBuilder extends DeviceConfig {

	IOSDriver driver;

    public IOSDriver setupDriver(String model) throws IOException {
        DesiredCapabilities iosCapabilities = new DesiredCapabilities();
        IOSDeviceModel device = readIOSDeviceConfig().getIOSDeviceByName(model);
        logMessage("Received the " + model + " device configuration for execution");
        setExecutionPlatform(model);

        iosCapabilities.setCapability(MobileCapabilityType.DEVICE_NAME, device.getDeviceName());
        iosCapabilities.setCapability(MobileCapabilityType.PLATFORM_NAME, device.getPlatformName());
        iosCapabilities.setCapability(MobileCapabilityType.PLATFORM_VERSION, device.getPlatformVersion());
        iosCapabilities.setCapability(MobileCapabilityType.AUTOMATION_NAME, device.getAutomationName());
        iosCapabilities.setCapability(MobileCapabilityType.UDID, device.getUdid());
  //      iosCapabilities.setCapability(MobileCapabilityType.FULL_RESET, device.fullReset());
        iosCapabilities.setCapability(MobileCapabilityType.APP, FileUtility.getFile(device.getApp()).getAbsolutePath());
        System.setProperty("webdriver.http.factory", "apache");
        driver = new IOSDriver(new URL("http://localhost:4723/wd/hub"), iosCapabilities);
        driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
        logMessage("IOS driver has been created for the " + model + " device");
        return driver;
    }
}
