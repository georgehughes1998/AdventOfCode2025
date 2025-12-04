#/bin/bash
#
# Usage : Solutions/Day2Part1.sh input.txt

IFS=","

input=$(cat $1)

total=0

for i in $input; do
  if [[ $i =~ ^([0-9]+)-([0-9]+)$ ]]; then
    N1=${BASH_REMATCH[1]}
    N2=${BASH_REMATCH[2]}

    total=$((total + $(seq $N1 $N2 | grep "^\([0-9]\+\)\1$" | awk 'BEGIN { sum = 0}; { sum += $1 }; END { print sum } ')))
  fi
done

echo $total