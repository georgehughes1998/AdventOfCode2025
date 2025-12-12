#/bin/bash
#
# Usage : Solutions/Day12Part1.sh input.txt

DEBUG=

i=0
while read size; do
  sizes[$i]=$size
  test $DEBUG && echo i: $i, size: $size, sizes="${sizes[@]}"
  ((i++))
done < <(cat $1 | grep "^[0-9]\+:" --after-context=3 | tr -d '\n' | sed 's/--/\n/g' | sed 's/[0-9:.]//g' | awk '{ print length }')

total=0
while read width height counts; do
  area=$(($width * $height))
  tiles=$(i=0; while read size; do echo $(($size * ${sizes[$i]})); ((i++)); done < <(echo $counts | tr ' ' '\n') | awk '{ sum+=$1 }; END { print sum }')

  [[ $tiles -lt $area ]] && ((total++))

  test $DEBUG && echo width: $width, height: $height, area: $area, tiles: $tiles, counts: $counts
done < <(cat $1 | grep "[0-9]\+x[0-9]\+:" | tr -d ':' | tr 'x' ' ')

echo $total
