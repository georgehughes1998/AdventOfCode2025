#/bin/bash
#
# Usage : RunSolution.sh DayN PartN

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Incorrect usage : $0 DayNumber PartNumber [Input.txt]"
  exit 1
fi

DayNumber=$1
PartNumber=$2
InputPath=${3:-Inputs/Day${DayNumber}.txt}
ScriptPath=Solutions/Day${DayNumber}Part${PartNumber}.sh
OutputPath=.out
OutputErrorPath=.err.out
Command="$ScriptPath $InputPath"

echo "Running Day $DayNumber Part $PartNumber ($ScriptPath) with Input $InputPath"
echo ---
echo "Command: $Command"
$Command > $OutputPath 2>$OutputErrorPath
ErrorCode=$?

echo ErrorCode: $ErrorCode
echo OutputPath: $OutputPath
echo OutputErrorPath: $OutputErrorPath
echo
echo ---Output---
cat $OutputPath
echo
echo ---OutputError---
cat $OutputErrorPath
