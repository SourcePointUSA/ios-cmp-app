## Automation Framework

## Prerequisites Installations:

1. <b>`JAVA 1.8`</b> - Install Java and set the JAVA_HOME path on your machine. Add $JAVA_HOME/bin in PATH variable.
2. <b>`Node & NPM`</b> - Download & install node. you can refer `https://nodejs.org/en/download/`.
3. <b>`Gradle`</b> - Install Gradle and set the GRADLE_HOME on your machine. Add $GRADLE_HOME/bin in PATH variable.
4. <b>`Android`</b> - Install Android Studio & set $ANDROID_HOME on your machine.
5. <b>`iOS`</b> - Install XCode on your machine.
6. <b> Allure Report - Install Allure Report library on your machine. Please follow below link to install it on MAC.
Similarly install allure-report installer on your respective machine. https://docs.qameta.io/allure/#_installing_a_commandline    

## Appium Setup:

- <b>`Install Appium`</b> 
``` 
 $ sudo npm install -g appium@1.17.0
```
- <b>`Appium Doctor`</b> - which is used to see if the appium setup is correctly done or not. Run it and fix the issues as per that.<br>
``` 
 $ sudo npm install -g appium-doctor
 $ appium-doctor
```
 
## How To Run Tests:

1. Get the code on your machine
2. Go to the folder AUtomationFramework folder on terminal
```
$ gradle clean build
$ java -jar build/libs/Automation-1.0-SNAPSHOT.jar

