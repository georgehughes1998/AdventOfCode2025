#/bin/bash
#
# Usage : Solutions/Day7Part1.sh input.txt

DEBUG=1

offsets=
total=0
while read line; do
  next_offsets=$(echo $line| grep "\^" -b -o | grep -o "[0-9]\+")
  if [[ -z "$next_offsets" ]]; then
    continue
  elif [[ -z "$offsets" ]]; then
    offsets=$next_offsets
    ((total++))
    continue
  fi
  
  match_filter_args=$(for v in $offsets; do echo "-e $((v-1)) -e $((v+1))"; done | tr '\n' ' ')
  non_match_filter_args=$(for v in $next_offsets; do echo "-e $((v-1)) -e $((v+1))"; done | tr '\n' ' ')

  next_offsets_matched=$(echo $next_offsets | tr ' ' '\n' | grep -w $match_filter_args -o  | sort -nu)
  offsets_non_matched=$(echo $offsets | tr ' ' '\n' | grep -wov $non_match_filter_args | sort -nu)
  
  number_matches=$(echo $next_offsets_matched | wc -w)
  total=$(($total + $number_matches))
  
  test $DEBUG && echo Offsets: $offsets, next_offsets: $next_offsets, next_offsets_matched: $next_offsets_matched, offsets_non_matched: $offsets_non_matched, total: $total

  offsets=$(echo "$next_offsets_matched $offsets_non_matched" | tr ' ' '\n' | sort -nu)
done < $1

echo $total