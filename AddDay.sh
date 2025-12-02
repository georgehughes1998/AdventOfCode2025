#!/bin/bash
#
# Usage : AddDay.sh 1

if [[ $# != 1 ]]; then
  echo "Incorrect usage : $0 DayNumber"
  exit 1
fi

DayNumber=$1

echo Generating input and test input files
mkdir -p Inputs/Test
NEW_UNIT_TEST_PATHS=$(echo Inputs/Day${DayNumber}Part{1,2}.txt Inputs/Test/Day${DayNumber}Part{1,2}Test1.{input,expected}.txt)
touch $NEW_UNIT_TEST_PATHS
ls -lrt $NEW_UNIT_TEST_PATHS
echo

echo Generating solution scripts
mkdir -p Solutions
NEW_SOLUTION_SCRIPT_PATHS=$(echo Solutions/Day${DayNumber}Part{1,2}.sh)
touch $NEW_SOLUTION_SCRIPT_PATHS
chmod +x $NEW_SOLUTION_SCRIPT_PATHS

for SCRIPT_PATH in $NEW_SOLUTION_SCRIPT_PATHS; do 
  echo "#/bin/bash" > $SCRIPT_PATH
  echo "#" >> $SCRIPT_PATH
  echo "# Usage : ${SCRIPT_PATH} input.txt" >> $SCRIPT_PATH
  echo "" >> $SCRIPT_PATH
  echo "echo Not Implemented; exit 1" >> $SCRIPT_PATH
done

ls -lrt $NEW_SOLUTION_SCRIPT_PATHS
echo
