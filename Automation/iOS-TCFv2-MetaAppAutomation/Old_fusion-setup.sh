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
	echo "Installing Oracle Jdk8 (choose 'Y' to continue OR 'N' to exit the setup)";
	read -p "Do you want to Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

	## Java installation steps
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update -y
	sudo apt-get install oracle-java8-installer
	
	export JAVA_HOME=/usr/lib/jvm/java-8-oracle
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
	echo "Installing Apache Maven (choose 'Y' to continue OR 'N' to exit the setup)";
	read -p "Do you want to Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
	
	## Maven installation steps
	sudo apt-get install maven
	export M2_HOME=/usr/share/maven
	export M2=$M2_HOME/bin
	export PATH=$M2:$PATH
	echo "Maven installed";
fi;

##export JAVA_HOME='/usr/lib/jvm/java-8-oracle'
##export M2_HOME='/usr/share/maven'

## Java and maven configuration/path update
if [[ "$JAVA_HOME" || "$M2_HOME" ]]; then
	sudo bash update-env.sh $JAVA_HOME $M2_HOME
	sudo bash update-profile.sh $JAVA_HOME $M2_HOME
fi

## Install and start openssh server
sudo apt-get install -y openssh-server
sudo service ssh start

## Create group, add logged-in user and update file permission
sudo groupadd -g 12321 fusion
sudo usermod -a -G fusion $(whoami)

sudo chown -R $(whoami):fusion .
sudo chmod -R 755 .
sudo cp setupfiles/Fusion/*_LINUX /usr/bin/
cd /usr/bin/
sudo mv chromedriver_LINUX chromedriver
sudo mv geckodriver_LINUX geckodriver

## Install xvfb
sudo apt-get -y install xvfb
sudo service Xvfb start

echo "Initial setup completed."

exit 0