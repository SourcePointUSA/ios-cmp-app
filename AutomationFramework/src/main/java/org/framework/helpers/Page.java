package org.framework.helpers;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import io.appium.java_client.AppiumDriver;

public class Page {

	public int timeOutInSeconds = 30;
	WebDriver driver;

	public void clickElement(WebElement element) {
		element.click();
	}

	public String getText(WebElement element) {
		return element.getText();
	}

	public void enterText(WebElement element, String value) {
		element.sendKeys(value);
	}

	public void waitForElement(WebElement ele, int timeOutInSeconds) {
		WebDriverWait wait = new WebDriverWait(driver, timeOutInSeconds);
		wait.until(ExpectedConditions.visibilityOf(ele));
	}

}
