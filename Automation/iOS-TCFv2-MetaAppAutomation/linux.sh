#!/bin/bash
#cd /home/navin/testing/TCoEGit/AutomationTestProject
DIR=$(dirname $0)
echo ${DIR}
cd ${DIR}
mvn clean
mvn compile exec:java