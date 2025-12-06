#/bin/bash
#
# Usage : Solutions/Day3Part1.sh input.txt

input=$(cat $1)

DEBUG=

NUMBER_INDEXES=12

running_total=0

for battery in $input; do
  test $DEBUG && echo Battery: $battery

  # Setup
  joltage_string=
  index=0

  # Battery line numbers
  echo $battery | sed 's/\([0-9]\)/\1\n/g' | nl | sed '$d' > .tmp.out
  number_lines=$(wc -l < .tmp.out )

  # get Nth Number
  for i in $(seq $NUMBER_INDEXES 1); do
    keep_lines=$(($number_lines - $i + 1))
    read index number < <(cat .tmp.out | awk -v ix=$index -v keep_lines=$keep_lines '{ if (NR > ix && NR <= keep_lines) print  $0 }' | sort -k2r -k1  | head -n1)

    test $DEBUG && echo Index: $index, Number: $number, i: $i, Keep_lines: $keep_lines

    joltage_string+=$number
  done
  
  test $DEBUG && echo Joltage: $joltage_string

  running_total=$(($running_total+$joltage_string))
done

echo $running_total