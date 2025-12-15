#/bin/bash
#
# Usage : Solutions/Day5Part2.sh input.txt


RANGES_FILE=.tmp.ranges.out

touch $RANGES_FILE
while read lower upper; do
  found=
  while read lower2 upper2; do
    [[ $lower -lt $lower2 ]] && { minLower=$lower; maxLower=$lower2; } || { minLower=$lower2; maxLower=$lower; }
    [[ $upper -lt $upper2 ]] && { minUpper=$upper; maxUpper=$upper2; } || { minUpper=$upper2; maxUpper=$upper; }
    
    
    if [[ $minUpper -ge $maxLower ]]; then
      sed -i -e "s/$lower2 $upper2/$minLower $maxUpper/" $RANGES_FILE
      found=1
    fi
  done < <(cat $RANGES_FILE)
  
  [[ -z "$found" ]] && echo $lower $upper >> $RANGES_FILE
  
done < <(cat $1 | grep "-" | tr '-' ' ' | sort -n)

cat $RANGES_FILE | awk '{ sum += $2 - $1 + 1} ; END {print sum}'

rm $RANGES_FILE
