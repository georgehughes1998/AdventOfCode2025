#/bin/bash
#
# Usage : Solutions/Day6Part2.sh input.txt

DEBUG=
GLOBIGNORE="*"

declare columns

i=0
while IFS= read line; do
  test $DEBUG && echo line: "[$line]"
  for ((j=0; j<${#line}; j++)); do
    columns[$j]+="${line:$j:1}"
  done
  ((i++))
done < <(cat $1 | tail -n1 ; cat $1 | sed '$d')

echo ${columns[@]} | sed 's/\([*+]\)/\n\1 /g' | sed '1d' > .tmp.realigned.out

running_total=0
while read line; do
  operation=$(echo $line | grep [*+] -o)
  numbers=${line:2:${#line}}
  result=$(($(echo $numbers | tr ' ' $operation)))
  running_total=$(($running_total + $result))
  
  test $DEBUG && echo operation: $operation, numbers: $numbers, result: $result
done < .tmp.realigned.out

echo $running_total