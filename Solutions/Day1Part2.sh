#/bin/bash
#
# Usage : Solutions/Day1Part2.sh input.txt


position=50
total=0
while read line; do
  nextPosition=$(($position + $(echo $line | grep -o '[-0-9]\+')))
  [[ $nextPosition -gt $position ]] && increment=1 || increment=-1
  number_zeros=$(seq $position $increment $nextPosition | awk '{ print $1 % 100 } ' | tr ' ' '\n' | sed '1d' | grep -cw 0)
  total=$(($total + $number_zeros))
  position=$nextPosition
done < <(cat $1 | sed 's/R//' | sed 's/L/-/')

echo $total
