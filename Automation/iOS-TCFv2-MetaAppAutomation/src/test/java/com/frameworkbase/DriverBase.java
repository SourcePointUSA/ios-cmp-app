package com.frameworkbase;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.lang.Runtime;

//import android.content.Intent;
import java.io.IOException;
import java.io.InputStream;

import org.ini4j.InvalidFileFormatException;
import org.ini4j.Wini;
import org.testng.ITestContext;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Listeners;

//import com.cybage.apiframework.APIDriverPlugin;
import com.cybage.apiframework.APIDrivers;
//import com.cybage.apiframework.IHTTPDriver;
import com.cybage.frameworkutility.utilities.CustomLogging;
import com.cybage.frameworkutility.utilities.CustomLogging.LogType;
import com.cybage.frameworkutility.utilities.CustomLogging.TestType;
import com.cybage.frameworkutility.utilities.CustomLoggingManager;
import com.cybage.frameworkutility.utilities.DirectoryOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations;
import com.cybage.frameworkutility.utilities.IniFileOperations.IniFileType;
import com.cybage.frameworkutility.utilities.Report;
import com.mobile.pages.*;
import com.cybage.frameworkutility.assertion.CustomLoggingAssert;
import com.cybage.frameworkutility.assertion.CustomSoftAssert;
import com.cybage.frameworkutility.datautils.DataProviders;
import com.cybage.frameworkutility.exception.ApplicationException;
import com.cybage.frameworkutility.listeners.TestListener;
import com.cybage.genericlibrary.CommonFunctions;
import com.fusion.plugin.extension.mobile.IMobileDriver;
import com.fusion.plugin.extension.mobile.MobileDriver;
//import com.cybage.genericlibrary.CommonFunctions.TestTypes;

@Listeners({ TestListener.class /* , ZapiListener.class */ })
public class DriverBase {
	ThreadLocal<IMobileDriver> mobileDriverCol = new ThreadLocal<IMobileDriver>();
	protected MobilePageWrapper mobilePageWrapper;
	protected IMobileDriver mobileDriver;
	public static Report ReportLogger;
	public static CustomLogging logger;
	public static String[] testGroup;

	// public static IDBExtensionUtilityInterface dbDriver;

	// public static IDBContextFactoryInterface dbDriver;

	public static CustomLoggingAssert hardAssert = null;
	public static CustomSoftAssert softAssert = null;

	/*
	 * public static IConnect fileDriver = null; public static IConnect noSQLDriver
	 * = null;
	 */
	public static int dbflag = 0;

	@BeforeTest(alwaysRun = true)
	public void BeforeTestRun(ITestContext context) {

		logger = CustomLoggingManager.getLogger();
//		String type = context.getSuite().getName();
		// getDBFactoryDriver(context);

	}

	private Boolean getDBValidationCheck(String section) {
		Boolean val = false;
		String dataSource = null;
		if (section.equalsIgnoreCase("DatabaseTesting")) {
			val = true;
		} else if (section.equalsIgnoreCase("FusionTesting")) {

			dataSource = IniFileOperations.getValueFromIniFile(IniFileType.Execution, section, "DataSource");
			if (!dataSource.equalsIgnoreCase(null)) {
				/*
				 * String isDB = IniFileOperations.getValueFromIniFile( IniFileType.Execution,
				 * section, "isDB");
				 */
				val = true;
			}
		}

		return val;
	}

	@BeforeSuite(alwaysRun = true)
	public void projectSetUp() {
		// Do not delete
		ReportLogger = TestListener.getReporter();
	}

	@BeforeMethod(alwaysRun = true)
	public void setUpAssertion(Method m) {
		// Do not delete
		hardAssert = TestListener.getHardAsserter();
		softAssert = TestListener.getSoftAsserter();
	}

	public void createDriver(String udid, String testType) {
		if (udid.isEmpty()) {
			try {
				Wini ini = new Wini(new File(
						"/Users/vrushalideshpande/Documents/MetaAppAutomation/remote-mac-devicejar/iniDir/mobile.ini"));
			} catch (InvalidFileFormatException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			udid = IniFileOperations.getValueFromIniFile(IniFileType.Mobile, udid, "udid");
		}
		logger.Log(LogType.INFO, "In Mobile Driver");
		System.out.println("createMobileDriver for - " + udid);

		IMobileDriver mobileDriver = getMobileDriver();
		if (mobileDriver == null) {
			System.out.println("Mobile Driver is Null....");
			mobileDriver = new MobileDriver(ReportLogger);
			setMobileDriver(mobileDriver);
		} else {
			if (mobileDriver.getDriver().getSessionId() == null
					|| mobileDriver.getDriver().getSessionId().toString().isEmpty()) {
				try {
					System.out.println("Session Id for - " + String.valueOf(Thread.currentThread().getId())
							+ " Thread - " + mobileDriver.getDriver().getSessionId());
					System.out.println("Mobile Driver is not null - " + udid);
					mobileDriver = new MobileDriver(ReportLogger);
					setMobileDriver(mobileDriver);
				} catch (Exception e) {
					System.out.println(" Session Null Exception.....");
					mobileDriver = new MobileDriver(ReportLogger);
					setMobileDriver(mobileDriver);
				}
			}
		}

		getMobileDriver().setup(udid, testType);

		System.out.println("Done createMobileDriver for - " + udid);
	}

	public void createMobileDriver(String udid, String testType) {

		String appType = System.getenv("type");
		if (appType != null) {
			if (appType.contains("Android") && udid.length() < 15) {
				createDriver(udid, testType);
			} else if (appType.contains("iOS") && udid.length() > 15) {
				createDriver(udid, testType);
			}
		}
		else {
			createDriver(udid, testType);
		}
	}

	public void setMobileDriver(IMobileDriver mobileDriver) {
		System.out.println("Set - " + String.valueOf(Thread.currentThread().getId()));
		mobileDriverCol.set(mobileDriver);
		System.out.println("End Set - " + String.valueOf(Thread.currentThread().getId()));
	}

	public IMobileDriver getMobileDriver() {
		return mobileDriverCol.get();
	}

	@DataProvider(name = "TestDataFile")
	public static Object[][] getTestData(Method method, ITestContext context) throws Exception {
		Object[][] retObjArr = null;
		String myTestClass = method.getDeclaringClass().getSimpleName();
		String myTestMethod = method.getName();
		try {
			retObjArr = DataProviders.readData(method);
			if (retObjArr == null) {
				throw new NullPointerException("'Test Data not found'");
			}
		} catch (Exception e) {
			String exceptionMessage = "Exception for test -" + myTestClass + "." + myTestMethod
					+ " against DataProvider - DriverBase.getTestData -" + e.getMessage();

			System.out.println(exceptionMessage);
			logger.internalLog(LogType.ERROR, method, exceptionMessage);
			throw new ApplicationException(exceptionMessage, e.getCause(), true, false);

		}
		return retObjArr;
	}

	@AfterMethod(alwaysRun = true)
	public void TestDestroy(ITestContext context) {
		if (context.getSuite().getName().contains("Mobile") || context.getSuite().getName().contains("Fusion")) {
			if (getMobileDriver() != null) {
				System.out.println(
						"Calling Mobile Quit In After Method..." + String.valueOf(Thread.currentThread().getId()));
				System.out.println("AfterMethod session Id - " + getMobileDriver().getDriver().getSessionId());

				getMobileDriver().quit();
				mobileDriverCol.set(null);
				System.out.println("Exit - Calling Mobile Quit In After Method..."
						+ String.valueOf(Thread.currentThread().getId()));

			}
		}
	}

	@AfterSuite(alwaysRun = true)
	public void projectDestroy(ITestContext context) {

	}

	@AfterTest(alwaysRun = true)
	public void AfterTestRun(ITestContext context) {

		String type = context.getSuite().getName();
		if ((type.equalsIgnoreCase("Database") || type.equalsIgnoreCase("Fusion") || type.contains("API")
				|| type.contains("Web") || type.contains("Mobile")) && (dbflag != 0)) {

		}

	}

	public static void removeApp() throws IOException, InterruptedException {

	}

	public static void installApp() {

	}
}
