cd /d %1
set classpath=%classpath%;.;selenium-server-standalone-3.0.jar;IEDriverServer_win64.exe;chromedriver.exe;IEDriverServer_win32.exe;
java %~2 -jar selenium-server-standalone-3.0.jar -port %3 -role node -hub %4 -browser "browserName=%~5, version=ANY, maxInstances=%6, platform=WINDOWS"