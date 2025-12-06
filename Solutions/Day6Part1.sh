#/bin/bash
#
# Usage : Solutions/Day6Part1.sh input.txt

DEBUG=

declare operations
declare running_totals

i=0
GLOBIGNORE="*"
for operation in $(cat $1 | tail -n 1); do
  operations[$i]=$operation
  
  if [[ "$operation" == "*" ]]; then
    running_totals[$i]=1
  else
    running_totals[$i]=0
  fi

  i=$((i+1))
done

test $DEBUG && echo Operations: "${operations[@]}"

while read line; do
  i=0
  for number in $line; do
    
    current_value="${running_totals[$i]}"
    operation="${operations[$i]}"

    running_totals[$i]=$(($current_value $operation $number))
    
    #test $DEBUG && echo i: $i number: $number
    i=$((i+1))
  done
done < <(cat $1 | sed '$d')

echo "${running_totals[@]}" | tr ' ' '\n' | awk 'BEGIN { sum=0 }; { sum+=$1 }; END { print sum }'
