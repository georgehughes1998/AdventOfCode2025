#/bin/bash
#
# Usage : Solutions/Day10Part1.sh input.txt

DEBUG=

QUEUE=.tmp.queue.out
DEBUG_PATH=.debug.out

> $DEBUG_PATH

total=0
while read machine; do

  test $DEBUG && echo Machine: $machine | tee -a $DEBUG_PATH

  target_state=$(echo $machine | grep -o "[.#]" | grep -n "#" | grep -ow "[0-9]\+" | awk '{ sum += 2^($1 - 1)}; END { print sum }')
  buttons=$(echo $machine | grep -o "([0-9,]\+)" | sed 's/[()]//g' | tr ',' ' ' | awk '{ total=0; for (i=1; i<=NF; i++) total+=2^$i; print total}')

  test $DEBUG && echo target_state: $target_state, buttons: $buttons | tee -a $DEBUG_PATH

  echo 0 0 > $QUEUE
  states_seen=0
  while [[ "$state" -ne "$target_state" ]]; do
    if [[ $(wc -l < $QUEUE) -eq 0 ]]; then
      echo "ERROR: The queue is empty" | tee -a $DEBUG_PATH
      break
    fi
    read state count < <(head -n1 $QUEUE)
    sed -i -e '1d' $QUEUE

    for button in $buttons; do
      next_state=$(($state ^ $button))
      next_count=$(($count + 1))

      echo $states_seen | grep -w $next_state >/dev/null || echo $next_state $next_count >> $QUEUE
      states_seen="$states_seen $next_state"
    done
  done

  total=$(($total + $count))

done < $1

rm $QUEUE

echo $total
