## Prerequisites Installations:

## JAVA 1.8
- Install Java
- Set JAVA_HOME path on your machine 
- Add $JAVA_HOME/bin in PATH variable.

## Node & NPM
- Download & install node. you can refer `https://nodejs.org/en/download/`

## Install Gradle
$brew install gradle
- Set the GRADLE_HOME on your machine. 
- Add $GRADLE_HOME/bin in PATH variable.

## Install XCode on your machine.

## Appium Setup
Install appium
$sudo npm install -g appium@1.17.0

## Install appium doctor
Appium Doctor which is used to see if the appium setup is correctly done or not. Run it and fix the issues as per that

$sudo npm install -g appium-doctor
$appium-doctor

## Set WebDriverAgent 
$cd /usr/local/lib/node_modules/appium/node_modules/appium-webdriveragent 
$mkdir -p Resources/WebDriverAgent.bundle
$sh ./Scripts/bootstrap.sh -d

In Finder go to /usr/local/lib/node_modules/appium/node_modules/appium-webdriveragent 
Open the WebDriverAgent.xcodeproj project in the appium-webdriveragent folder with Xcode

Under Targets, select the target WebDriverAgentLib and navigate to the General settings tab.
- Update build identifier name
- In Signing section add Team and select a valid provisioning profile.
	
Follow above steps for WebDriverAgentRunner and for IntegrationApp

Build the product (select appropriate simulator from top). Make sure build should be successful.

Start Simulator and execute below command. Replace the udid with your simulator udid. Make sure WebDriverAgent installed on simulator without fail
$cd /usr/local/lib/node_modules/appium/node_modules/appium-webdriveragent
$xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination 'id=<udid>' test

## How To Run Tests:
1. Start appium from terminal (In next phase will add code to start and stop appium server from framework itself)
type following command
$appium

wait till appium starts

2. Get the code on your machine
3. Set the iOS device details in iOSDevice.json file in resources directory as shown below
- Update name, deviceName, platformVersion and udid specific to the device. Update application name if want to run tests on other app.
		"name": "iphone8",
		"deviceName": "iPhone 8",
		"platformName": "iOS",
		"platformVersion": "13.3",
		"automationName": "XCuiTest",
		"udid": "C930DE28-6A9A-49F4-BE49-DAEBF0C0FF8B",
		"reset": true,
		"app": "TCFv1_GDPR-MetaApp.zip"
	

5. If device details (name/deviceName) updated in above file need to update model parameter from testng.xml file 

6. Add application ‘.zip’ file under /src/main/resources folder

7. Build the JAR and run it 
From terminal go to project root directory "AutomationFramework"
$gradle clean build
$java -jar build/libs/AutomationFramework-1.0-SNAPSHOT.jar


