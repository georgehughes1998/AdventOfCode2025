#/bin/bash
#
# Usage : Solutions/Day8Part2.sh input.txt

DEBUG=

test $TESTING && NUMBER_CONNECTIONS=10 || NUMBER_CONNECTIONS=1000

test $DEBUG && echo "Using NUMBER_CONNECTIONS=$NUMBER_CONNECTIONS"

OUT_DISTANCES=.tmp.distances.out
OUT_BC_COMMAND=.tmp.bc_commands.out
OUT_CONNECTIONS=.tmp.connections.out
OUT_COUNTS=.tmp.counts.out

# positions_{$x,$y,$z}[$id]=0
declare positions_x
declare positions_y
declare positions_z

while read id x y z; do
  positions_x[${id}]=$(echo $x | grep -o '[0-9]\+')
  positions_y[${id}]=$(echo $y | grep -o '[0-9]\+')
  positions_z[${id}]=$(echo $z | grep -o '[0-9]\+')
  test $DEBUG && echo "id: $id, x: ${positions_x[${id}]}, y: ${positions_y[${id}]}, z: ${positions_z[${id}]}"
done < <(cat $1 | tr ',' ' ' | nl -v0)

ids="${!positions_x[@]}"
test $DEBUG && echo ids: $ids

> $OUT_DISTANCES
> $OUT_BC_COMMAND
for id1 in $ids; do
  for id2 in $(echo $ids | tr ' ' '\n' | awk -v limit=$id1 '{ if (NR > limit+1) print $0 }'); do
    x1="${positions_x[${id1}]}"
    y1="${positions_y[${id1}]}"
    z1="${positions_z[${id1}]}"
    
    x2="${positions_x[${id2}]}"
    y2="${positions_y[${id2}]}"
    z2="${positions_z[${id2}]}"
    
    echo 'print "'$id1'", " ", "'$id2'", " ", sqrt(('$x1' - '$x2')^2 + ('$y1' - '$y2')^2 + ('$z1' - '$z2')^2), "\n" ' >> $OUT_BC_COMMAND
    
    test $DEBUG && echo "id1: $id1, id2: $id2, position1: ($x1,$y1,$z1), position2: ($x2,$y2,$z2)"
  done &
done
wait

bc < $OUT_BC_COMMAND > $OUT_DISTANCES


cat $OUT_DISTANCES | sort -nk3 | awk '{ print $1" "$2 }' > $OUT_CONNECTIONS

rm .tmp.circuits.*.out
for id in $ids; do
  echo $id > .tmp.circuits.$id.out
done

> $OUT_COUNTS
while read id1 id2; do
  circuit_set_paths=$(grep -lw -e $id1 -e $id2 .tmp.circuits.*.out)
  
  if [[ $? == 0 ]]; then
    circuit_set_path=$(echo $circuit_set_paths | cut -d' ' -f1)
    echo $id1 >> $circuit_set_path
    echo $id2 >> $circuit_set_path
    
    if [[ $(echo $circuit_set_paths | wc -w) -gt 1 ]]; then
      merge_paths=$(echo $circuit_set_paths | cut -d' ' -f2-)
      test $DEBUG && echo Merging $merge_paths into $circuit_set_paths
      for merge_path in $merge_paths; do
        cat $merge_path >> $circuit_set_path
        rm $merge_path
      done
    fi
  else
    circuit_set_path=.tmp.circuits.$id1.out
    echo $id1 >> $circuit_set_path
    echo $id2 >> $circuit_set_path
  fi

  sort -nu -o $circuit_set_path $circuit_set_path
  counts=$(echo .tmp.circuits.*.out | wc -w)
  echo $id1 $id2 $counts >> $OUT_COUNTS

  if [[ $counts -eq 1 ]]; then
    break
  fi

  test $DEBUG && echo "Connection: $id1 <-> $id2 (in tmp file $circuit_set_path)"
done < $OUT_CONNECTIONS

read id1 id2 _ < <(cat $OUT_COUNTS | uniq -f2 | tail -n1)
echo $((${positions_x[$id1]} * ${positions_x[$id2]}))

rm $OUT_DISTANCES $OUT_CONNECTIONS $OUT_BC_COMMAND $OUT_COUNTS .tmp.circuits.*.out

