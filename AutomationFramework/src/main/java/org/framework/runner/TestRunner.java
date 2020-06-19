package org.framework.runner;

import org.framework.utils.FileUtility;
import org.testng.TestNG;
import org.testng.collections.Lists;

import static org.framework.logger.LoggingManager.logMessage;

import java.io.IOException;
import java.util.List;

public class TestRunner {
	 public static String MODE;
    public static void main(String[] args) throws IOException {
        TestNG testng = new TestNG();

        if (args.length == 0) {
            MODE = "functional";
            logMessage("Image Comparison arguments not passed; Running tests in functional mode");
        } 
//        else if (args[0].equalsIgnoreCase("compare")) {
//            MODE = "visual";
//            logMessage("Running tests in visual compare mode");
//            ImageComparator.COMPARE = true;
//        } else if (args[0].equalsIgnoreCase("capture")) {
//            MODE = "visual";
//            logMessage("Running tests in visual capture mode");
//            ImageComparator.COMPARE = false;
//        }
        List<String> suites = Lists.newArrayList();
        suites.add(FileUtility.getFile("testng.xml").getAbsolutePath());
        testng.setTestSuites(suites);
        testng.run();
    }
}
