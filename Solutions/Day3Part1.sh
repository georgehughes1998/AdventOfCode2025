#/bin/bash
#
# Usage : Solutions/Day3Part1.sh input.txt

input=$(cat $1)

running_total=0
for battery in $input; do
  echo $battery | sed 's/\([0-9]\)/\1\n/g' | nl | sed '$d' > .tmp.out
  read first_index first_number < <(cat .tmp.out | sed '$d' | sort -k2r -k1  | head -n1)
  
  second_number=$(cat .tmp.out | awk -v condition=$first_index '{ if (NR > condition) print $2 }' | sort -r | head -n1)
  running_total=$(($running_total+${first_number}${second_number}))
done

echo $running_total