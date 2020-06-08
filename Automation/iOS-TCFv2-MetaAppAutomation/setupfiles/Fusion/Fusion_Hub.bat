cd /d %1
set classpath=%classpath%;.;selenium-server-standalone-3.0.jar
java -jar selenium-server-standalone-3.0.jar -role hub -port %2