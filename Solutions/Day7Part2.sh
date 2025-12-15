#/bin/bash
#
# Usage : Solutions/Day7Part2.sh input.txt

DEBUG=

current_beams=$(head -n1 $1 | grep "S" -bo | grep -o "[0-9]\+")

total_timelines=1
while read line; do
  offsets=$(echo $line | grep "\^" -bo | grep -o "[0-9]\+")
  
  beams_matched=$(echo $current_beams | grep -wo $(echo $offsets | tr ' ' '\n' | awk '{ print "-e "$0 }'))
  beams_non_matched=$(echo $current_beams | tr ' ' '\n' | grep -wv $(echo $offsets | tr ' ' '\n' | awk '{ print "-e "$0 }'))
  
  split_beams=$(echo $beams_matched | tr ' ' '\n' | grep '.\+' | awk '{ print $1-1" "$1+1 }')
  count_matched=$(echo $beams_matched | wc -w | tr -d ' ')
  total_timelines=$(($total_timelines + $count_matched))
    
  test $DEBUG && echo current_beams: $current_beams, offsets: $offsets, count_matched: $count_matched
  test $DEBUG && echo "-->" beams_matched: $beams_matched, beams_non_matched: $beams_non_matched, split_beams: $split_beams
  test $DEBUG && echo

  current_beams="$split_beams $beams_non_matched"
done < <(cat $1 | grep "\^")

echo $total_timelines
