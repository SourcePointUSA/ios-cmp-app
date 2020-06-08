#!/bin/bash

echo "Starting CybageFusion initial setup, this may take a while (depending upon required application/package setup)"

## Update package lists
sudo apt-get update -y


## Check if required Java package installed
if type -p javac; then
	echo Found java executable in PATH
	InstallJava=No
	_java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/javac" ]];  then
    echo Found java executable in JAVA_HOME     
    InstallJava=No
    _java="$JAVA_HOME/bin/java"
else
	InstallJava=Yes
fi

if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo version "$version"
	if [[ $version != *"1.8"* ]]; then
		echo Java version 1.8 is not installed or configured
		InstallJava=Yes
	fi
fi


## Java installations
if [[ "$InstallJava" == "Yes" ]]; then
	echo "Installing Open Jdk8...";

	## Java installation steps
	sudo apt-get install -y openjdk-8-jdk
	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
	export PATH=$JAVA_HOME/bin:$PATH
	
	echo "Java installed and configured";
fi;



## Check if required maven package installed
if type -p mvn; then
	echo Found maven executable in PATH
	InstallMaven=No
	_maven=mvn
elif [[ -n "$M2_HOME" ]] && [[ -x "$M2_HOME/bin/mvn" ]];  then
    echo Found java executable in M2_HOME
    InstallMaven=No
    _maven="$M2_HOME/bin/mvn"
else
	InstallMaven=Yes
fi


## Maven installations
if [[ "$InstallMaven" == "Yes" ]]; then
	echo "Installing Apache Maven...";
	
	## Maven installation steps
	sudo apt-get install -y maven
	export M2_HOME=/usr/share/maven
	export M2=$M2_HOME/bin
	export PATH=$M2:$PATH
	echo "Maven installed";
fi;


## Java and maven configuration/path update
echo "Updating Java and maven configuration/path in environment and profile files...";
if [[ "$JAVA_HOME" || "$M2_HOME" ]]; then
	sudo bash update-env.sh $JAVA_HOME $M2_HOME
	sudo bash update-profile.sh $JAVA_HOME $M2_HOME
fi

## Install and start openssh server
echo "Install and start openssh server...";
sudo apt-get install -y openssh-server
sudo service ssh start

## Create group, add logged-in user and update file permission
echo "Create group, add logged-in user and update file permission...";
sudo groupadd -g 12321 fusion
sudo usermod -a -G fusion $(whoami)

sudo chown -R $(whoami):fusion .
sudo chmod -R 755 .
sudo cp setupfiles/Fusion/*_LINUX /usr/bin/
cd /usr/bin
sudo mv geckodriver_LINUX geckodriver
sudo mv chromedriver_LINUX chromedriver

## Install xvfb
echo "Install and start the xvfb service...";
sudo apt-get -y install xvfb
sudo service Xvfb start

echo "Java installed version...";
java -version
echo "JAVA_HOME set as..." $JAVA_HOME;

echo "Maven installed version...";
mvn -version
echo "M2_HOME set as..." $M2_HOME;

echo "Initial setup completed."

sudo -s
source /etc/profile

exit 0
