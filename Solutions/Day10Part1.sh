#/bin/bash
#
# Usage : Solutions/Day10Part1.sh input.txt

DEBUG=1

QUEUE=.tmp.queue.out

while read machine; do

  test $DEBUG && echo Machine: $machine

  target_state=$(echo $machine | rev | grep -o "[.#]" | grep -n "#" | grep -o [0-9] | awk '{ sum += 2^($1 - 1)}; END { print sum }')
  buttons=$(echo $machine | grep -o "([0-9,]\+)" | sed 's/[()]//g' | tr ',' ' ' | awk '{ total=0; for (i=1; i<=NF; i++) total+=2^$i; print total}')

  test $DEBUG && echo target_state: $target_state, buttons: $buttons

  echo 0 0 > $QUEUE
  states_visited=
  while [[ "$state" -ne "$target_state" ]]; do
    read state count < <(head -n1 $QUEUE)
    sed -i -e '1d' $QUEUE

    for button in $buttons; do
      next_state=$(($state ^ $button))
      next_count=$((count + 1))

      echo $states_visited | grep $next_state || echo $next_state $next_count >> $QUEUE
      states_visited=$states_visited $next_state
    done
    
    test $DEBUG && echo state: $state, count: $count, states_visited: $states_visited
    #state=$target_state
  done
  cat $QUEUE

done < $1

rm $QUEUE

echo Not Implemented; exit 1
