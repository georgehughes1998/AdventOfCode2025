#/bin/bash
#
# Usage : Solutions/Day9Part1.sh input.txt

DEBUG=

declare positions_x
declare positions_y

while read id x y; do
  positions_x[${id}]=$(echo $x | grep -o '[0-9]\+')
  positions_y[${id}]=$(echo $y | grep -o '[0-9]\+')
  test $DEBUG && echo "id: $id, x: ${positions_x[${id}]}, y: ${positions_y[${id}]}"
done < <(cat $1 | tr ',' ' ' | nl -v0)

ids="${!positions_x[@]}"
test $DEBUG && echo ids: $ids

for id1 in $ids; do
  for id2 in $(echo $ids | tr ' ' '\n' | awk -v limit=$id1 '{ if (NR > limit+1) print $0 }'); do
    x1="${positions_x[${id1}]}"
    y1="${positions_y[${id1}]}"
    
    x2="${positions_x[${id2}]}"
    y2="${positions_y[${id2}]}"

    [[ $x1 -gt $x2 ]] && { xMax=$x1; xMin=$x2; } || { xMax=$x2; xMin=$x1; }
    [[ $y1 -gt $y2 ]] && { yMax=$y1; yMin=$y2; } || { yMax=$y2; yMin=$y1; }

    area=$((($xMax - $xMin + 1) * ($yMax - $yMin + 1)))

    [[ $area -gt $maxArea ]] && maxArea=$area
    
    test $DEBUG && echo "id1: $id1, id2: $id2, positionMax: ($xMax,$yMax), positionMin: ($xMin,$yMin), area: $area", maxArea: $maxArea
  done
done

echo $maxArea