#! /bin/bash

mkdir -p target/tmp
mkdir -p target/surefire-reports

./Build junit_test
RETURN_TEST=$?


mv surefire.tmp target/tmp/


csplit -q -n 4 -f target/tmp/surefire-split target/tmp/surefire.tmp '/<testsuite /' {*}
rm target/tmp/surefire-split0000

for FILE in `find target/tmp/surefire-split*`
do
	FINAL_FILE=`head -1 $FILE | sed -e 's/.*name="src\/test\/scripts\/\([^"]*\)[.][a-zA-Z0-9]*".*/TEST-\1/'`
	FINAL_FILE=`echo $FINAL_FILE | sed -e 's/\//./g'`
	FINAL_FILE=$FINAL_FILE".xml"
	
	sed 's/\([a-zA-Z0-9]\)\//\1./g' $FILE > target/surefire-reports/$FINAL_FILE
	sed -i 's/[.]t"/"/g' target/surefire-reports/$FINAL_FILE
	sed -i 's/<\/testsuites>//g' target/surefire-reports/$FINAL_FILE
	sed -i 's/src[.]test[.]scripts[.]//g' target/surefire-reports/$FINAL_FILE
	sed -i 's/\(testcase name="[a-zA-Z0-9]*\)[ ][\(][0-9]\+[\)]/\1/g' target/surefire-reports/$FINAL_FILE

	rm $FILE	
done


rm target/tmp/surefire.tmp
rmdir target/tmp

if [ $RETURN_TEST -ne 0 ]
then
        exit 0;
fi

