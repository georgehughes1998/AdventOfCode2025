#/bin/bash
#
# Usage : RunUnitTests.sh [DayN] [PartN] [TestN]


if [[ $# -gt 3 ]]; then
  echo "Incorrect usage : $0 [DayNumber] [PartNumber] [TestNumber]"
  exit 1
fi

DayNumbers=${1:-ALL}
PartNumbers=${2:-ALL}
TestNumbers=${3:-ALL}

echo "Running Day(s) $DayNumber Part(s) $PartNumber Test(s) $TestNumber"

if [[ "$DayNumbers" == "ALL" ]]; then
  DayNumbers=$(echo {1..12})
fi

if [[ "$PartNumbers" == "ALL" ]]; then
  PartNumbers=$(echo {1..2})
fi

for DayNumber in $DayNumbers; do
  for PartNumber in $PartNumbers; do
    # Get the paths for the test inputs
    if [[ "$TestNumbers" == "ALL" ]]; then
      TestInputPaths="Inputs/Test/Day${DayNumber}Part${PartNumber}Test*.input.txt"
    else
      TestInputPaths="Inputs/Test/Day${DayNumber}Part${PartNumber}Test${TestNumber}.input.txt"
    fi
    
    for TestInputPath in $TestInputPaths; do
      TestExpectedPath=$(echo $TestInputPath | sed 's/input/expected/g')
      echo "-----Running Test : $TestInputPath with expected output $TestExpectedPath-----"
      
      if [[ ! -f $TestExpectedPath ]]; then
        echo "ERROR: File $TestExpectedPath does not exist"
      fi
      
      ./RunSolution.sh $DayNumber $PartNumber
      
    done

  done
done


