
## Prerequisites and Setup:

1. <b>`Install JAVA 1.8`</b> 

	https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html
	
	Set the JAVA_HOME path on your machine. Add $JAVA_HOME/bin in PATH variable.
	
	   ``` export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home ```
         ``` export PATH=$PATH:$JAVA_HOME/bin ```
	
2. <b>`Install Homebrew`</b> 

	https://treehouse.github.io/installation-guides/mac/homebrew
    
       ``` $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ```

3. <b>`Install Node & NPM`</b>
	
	Download & install node. https://nodejs.org/en/download/
    
       ``` $ brew install node ```
    
4. <b>`Install Gradle`</b> 
	
	Install Gradle and set the GRADLE_HOME on your machine. Add $GRADLE_HOME/bin in PATH variable.
    
        ``` $ brew install carthage ```
    
        ``` export GRADLE_HOME=/usr/local/Cellar/gradle/6.5 ```
        ``` export PATH=$PATH:$GRADLE_HOME/bin ```
     
5.<b>`Install Carthage`</b>
                
        ``` $ brew install carthage ```
            
6. <b>`Install xcode from Apple store`</b>
    `https://medium.com/@LondonAppBrewery/how-to-download-and-setup-xcode-10-for-ios-development-b63bed1865c `
    
## Appium Setup:

1. <b>`Install Appium`</b> 
 
        ``` $ sudo npm install -g appium@1.17.0 ```

2. <b>`Appium Doctor`</b> - which is used to see if the appium setup is correctly done or not. Run it and fix the issues as per that.<br>
 
        ``` $ sudo npm install -g appium-doctor ```
        ``` $ appium-doctor ```

## WebDriverAgent Setup:

    Refer `https://docs.katalon.com/katalon-studio/docs/installing-webdriveragent-for-ios-devices.html`
    
1. Enter the following commands to initialize the WebDriverAgent project

        ``` $ cd /usr/local/lib/node_modules/appium/node_modules/appium-webdriveragent ```
        ``` $ mkdir -p Resources/WebDriverAgent.bundle ```
        ``` $ sh ./Scripts/bootstrap.sh -d ```

2. In Finder go to /usr/local/lib/node_modules/appium/node_modules/appium-webdriveragent 
    Open the WebDriverAgent.xcodeproj project in the appium-webdriveragent folder with Xcode

3. Under Targets, select the target WebDriverAgentLib and navigate to the General settings tab.
    Update build identifier name
    In Signing section add Team and select a valid provisioning profile.
    
4.  Follow above steps for WebDriverAgentRunner and for IntegrationApp

5.  Build the product (select appropriate simulator from top). Make sure build should be successful.

## How To Run Tests:

1.  Get the code on your machine
2.  Launch required simulator or connect real device on which you want tests should run
3.  Start appium server from terminal 
    
        ``` $ appium ```
        
4. Open iosDevice.json file (path: AutomationFramework/src/main/resources)
5. Edit and Save device details 

For running on simulator/real device update name, deviceName, platformVersion and udid as per the simulator which is launched

   "name": "iPhone 8",
   "deviceName": "iPhone 8",
   "platformName": "iOS",
   "platformVersion": "12.0",                
   "automationName": "XCuiTest",
   "udid": "C930DE28-6A9A-49F4-BE49-DAEBF0C0FF8B",
   "app": "GDPR-MetaApp.zip"          
   
   `update if want to run with other app`

6.  Edit testing.xml, if device details like name or deviceName updated in above file
7.  Add application under test. Add .zip (compressed .app file ) under /src/main/resources folder
8.  Build the JAR and run it from terminal 
    Go to project root directory "AutomationFramework"

        ``` $ gradle clean build ```
        ``` $ java -jar build/libs/AutomationFramework-1.0-SNAPSHOT.jar ```


