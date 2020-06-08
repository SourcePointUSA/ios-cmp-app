package com.invocation;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Stream;
import java.nio.file.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.maven.shared.invoker.DefaultInvocationRequest;
import org.apache.maven.shared.invoker.DefaultInvoker;
import org.apache.maven.shared.invoker.InvocationRequest;
import org.apache.maven.shared.invoker.InvocationResult;
import org.apache.maven.shared.invoker.Invoker;
import org.apache.maven.shared.invoker.MavenInvocationException;
import org.ini4j.Wini;
import org.testng.TestNG;
import org.testng.xml.XmlGroups;
import org.testng.xml.XmlSuite;

import com.cybage.frameworkutility.executionInvocation.Invoke;
import com.cybage.frameworkutility.utilities.CustomLogging;
import com.cybage.frameworkutility.utilities.CustomLogging.LogType;
import com.cybage.frameworkutility.utilities.IniFileOperations.IniFileType;
import com.gargoylesoftware.htmlunit.javascript.host.Map;

import io.appium.java_client.service.local.AppiumDriverLocalService;
import io.appium.java_client.service.local.AppiumServiceBuilder;
import io.appium.java_client.service.local.flags.GeneralServerFlag;

import com.cybage.frameworkutility.utilities.CustomLoggingManager;
import com.cybage.frameworkutility.utilities.DirectoryOperations;
import com.cybage.frameworkutility.utilities.EmailSending;
import com.cybage.frameworkutility.utilities.IniFileOperations;

/**
 * The class is responsible for Invoking the execution. Any changes to the main
 * function will harm the entire execution.
 *
 * @author Harshal Chikhale
 * @version 1.00, 8 Feb 2017
 */
public class KickOff {

	public static void main(String[] args) throws IOException, InterruptedException {
		CustomLogging myLog = null;
		String param = null;
		try {

			// Handling executionUIConfigFilePath based on runtime parameters, set to
			// default if not provided.
			String executionUIConfigFilePath;
			if (args.length > 0)
				executionUIConfigFilePath = args[0];
			else {
				executionUIConfigFilePath = System.getProperty("user.dir") + File.separator + "CommonFrameworkTest_Run"
						+ File.separator + "Configuration" + File.separator + "executionRunConfig.ini";
			}

			// Below line belongs to Logger functionality to place LOG folder in respective
			// execution folder.

			DirectoryOperations.setLogFolderLocation(executionUIConfigFilePath);
			myLog = CustomLoggingManager.getLogger();

			String currentDirectory = System.getProperty("user.dir") + File.separator + "pom.xml";
			System.out.println("POM location - " + currentDirectory);
			myLog.Log(LogType.INFO, "POM location - " + currentDirectory);
			System.out.println("Starting Setup.....");
			myLog.Log(LogType.INFO, "Starting Setup..");
			
			// Get and store booted simulator details in mobile.ini

			String txtPath = System.getProperty("user.dir") + "/remote-mac-devicejar/iniDir/ios.txt";
			String cmd = "xcrun simctl list 'devices' 'booted' >> " + txtPath;
			
			Process p1 = Runtime.getRuntime().exec(new String[] { "bash", "-c", cmd });
			String deviceData = null;
			String deviceVersion = null;
		System.out.println("######## Getting device details ");
			Thread.sleep(20000);
			try {
				List<String> allLines = Files.readAllLines(Paths.get(txtPath));
				for (String line : allLines) {					
					if (line.toString().contains("Booted")) {
						deviceData = line.toString();
						break;
					}
					deviceVersion = line.toString();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			if (deviceData!=null) {
				try {
					String platformName;
					Wini ini = new Wini(
							new File(System.getProperty("user.dir") + "/remote-mac-devicejar/iniDir/mobile.ini"));

					String[] argList = deviceData.trim().split("\\(");
					String [] versionList = deviceVersion.trim().split(" ");
					
					String blockName = argList[1].trim().split("\\)")[0];
					ini.add(blockName, "platformName", "iOS");
					ini.add(blockName, "deviceName", argList[0].trim());
					ini.put(blockName, "platformOS", versionList[2]);
					ini.add(blockName, "udid", blockName);
					ini.store();
					System.out.println("######## Got device details : " + argList[0].trim() + " " + versionList[2]);
				} catch (Exception e) {
					System.err.println(e.getMessage());
				}
				// To catch basically any error related to writing to the file
				// (The system cannot find the file specified)

			}
			

					
			/**
			 * store application name to be tested in executionRunConfig.ini
			 * 
			 */
			
			File f = null;
			String appFileName = null;
			f = new File(System.getProperty("user.dir") + "/CommonFrameworkTest_Run/AppFile");
			File[] listOfFiles = f.listFiles();
			for (int i = 0; i < listOfFiles.length; i++) {
				if (!listOfFiles[i].getName().contains("Store")) {
					if (!listOfFiles[i].getName().contains("zip")) {
						appFileName = listOfFiles[i].getName();
						System.out.println("******* Application Name : " + appFileName);
					}
				}
			}
			
			Wini ini = new Wini(new File(System.getProperty("user.dir") + "/CommonFrameworkTest_Run/Configuration/executionRunConfig.ini"));
			String appName = appFileName.split("\\.")[0];
			ini.add("MobileTesting", "TestGroupsToInclude", appName+"Tests");
			ini.add("MobileTesting", "AppName", appFileName);
			ini.store();

//			param = System.getenv("type");
//			if (param != null) {
//				try {
//					if (appFileName.contains("TCFv1")) {
//						System.out.println("******* It is TCFv1 GDPR Application");
//
//						Wini ini = new Wini(new File(System.getProperty("user.dir")
//								+ "/CommonFrameworkTest_Run/Configuration/executionRunConfig.ini"));
//						ini.add("MobileTesting", "TestGroupsToInclude", "TCFV1_GDPRSDKTests,TCFV1_GDPRMetaAppTests");
//						ini.add("MobileTesting", "AppName", appFileName);
//						ini.store();
//					} else {
//						System.out.println("******* It is TCFv2 GDPR/CCPA Application");
//
//						Wini ini = new Wini(new File(System.getProperty("user.dir")
//								+ "/CommonFrameworkTest_Run/Configuration/executionRunConfig.ini"));
//						ini.add("MobileTesting", "TestGroupsToInclude",
//								param.split("-")[1] + "MetaAppTests," + param.split("-")[1] + "SDKTests");
//						ini.add("MobileTesting", "AppName", appFileName);
//
//						ini.store();
//					}
//				} catch (Exception e) {
//					System.err.println(e.getMessage());
//				}
//			}else {
//				
//			}

			// Set Execution env;
			Invoke.trigger(executionUIConfigFilePath, currentDirectory);

			System.out.println("Done Setup..Done Setup");
			myLog.Log(LogType.INFO, "Done Setup..Done Setup");
			System.out.println("Started with POM operation...");
			myLog.Log(LogType.INFO, "Started with POM operation...");

			// Call updated POM xml.
			InvocationResult result = null;

			InvocationRequest request = new DefaultInvocationRequest();
			request.setPomFile(new File(currentDirectory));
			request.setGoals(Arrays.asList("clean", "install", "test"));

			Invoker invoker = new DefaultInvoker();
		//	System.out.println("M2_HOME - " + System.getenv("M2_HOME"));

			invoker.setMavenHome(new File("/usr/local/Cellar/maven/3.6.3_1/libexec"));

			try {
				result = invoker.execute(request);
				System.out.println("Result - " + result);
			} catch (MavenInvocationException e) {
				e.printStackTrace();
			}

			if (result.getExitCode() != 0) {
				throw new IllegalStateException("Build failed.");
			}

			System.out.println("Done the execution...");
		} catch (Exception e) {
			System.out.println("Exception occured in main method. Exception details - " + e.getMessage());
			throw e;
		} finally {
			Invoke.shutDown();
			myLog.Log(LogType.INFO, "Down the environment successfully...");
			System.out.println("Down the environment successfully...");
			// for email sending
			if (IniFileOperations.getValueFromIniFile(IniFileType.Execution, "ExecutionParameters", "RunAs")
					.equals("UI")
					&& !IniFileOperations.getValueFromIniFile(IniFileType.Execution, "ExecutionParameters", "Email")
							.isEmpty()) {
				StringBuilder emailBodyContents = new StringBuilder();
				// System.out.println("Inside email sending block as execution is happening
				// through UI");
				// emailBodyContents can be used if some text is expected to be shown inside
				// email body.
				emailBodyContents.append("<h1>Test Automation Report</h1>");
				String htmlReportLocation = DirectoryOperations.getBaseDirectoryLocation() + File.separator + "Report"
						+ File.separator
						+ StringUtils.substringAfterLast(DirectoryOperations.getBaseDirectoryLocation(), File.separator)
						+ ".html";
				if (new File(htmlReportLocation).exists()) {
					EmailSending.composeEmail(emailBodyContents, htmlReportLocation);
				} else {
					myLog.Log(LogType.ERROR, "Unable to email report as report file does not exist.");
				}
			}
			System.out.println("Test execution Completed sucessfully");
		}

	}

}
