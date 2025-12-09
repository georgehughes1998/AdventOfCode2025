#/bin/bash
#
# Usage : RunUnitTests.sh [DayN] [PartN] [TestN]

export TESTING=1

TEST_OUTPUT_PATH=.test.out

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
      OutputExpected=$(cat $TestExpectedPath)
      
      # Timer
      start_time=$(date +%s%N | cut -b1-13)
      
      # Run the solution
      ./RunSolution.sh $DayNumber $PartNumber $TestInputPath > $TEST_OUTPUT_PATH
      
      # Timer
      end_time=$(date +%s%N | cut -b1-13)
      diff_time=$(($end_time - $start_time))
      
      # Display the output from the helper
      # cat $TEST_OUTPUT_PATH
      
      # Get the output path
      OutputPathString=$(cat $TEST_OUTPUT_PATH | grep OutputPath)
      if [[ $OutputPathString =~ (OutputPath: (.+)) ]]; then
        OutputPath=${BASH_REMATCH[2]}
        OutputActual=$(<"$OutputPath")
      else
        echo "OutputPath not found: \"$OutputPathString\""
        OutputActual=
      fi
      
      echo "Test completed in ${diff_time}ms"
      if [[ $OutputActual == $OutputExpected ]]; then
        echo "PASS: OutputActual == OutputExpected"
      else
        echo "FAIL: OutputActual != OutputExpected"
        printf 'OutputActual: %s\n' "$OutputActual"
        echo "OutputExpected: $OutputExpected"
      fi
      
    done

  done
done


