file=/etc/environment

JAVA_HOME=$1
M2_HOME=$2

if grep -q JAVA_HOME= $file; then
	sed -i "s:JAVA_HOME=.*:JAVA_HOME=$JAVA_HOME:" $file
else
	echo "JAVA_HOME=$JAVA_HOME" >> $file
fi

if grep -q M2_HOME= $file; then
	sed -i "s:M2_HOME=.*:M2_HOME=$M2_HOME:" $file
else
	echo "M2_HOME=$M2_HOME" >> $file
fi
