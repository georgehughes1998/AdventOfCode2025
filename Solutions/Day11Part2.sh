#/bin/bash
#
# Usage : Solutions/Day11Part2.sh input.txt

DEBUG=
DEBUG_LOG=.tmp.day11.log.out
>$DEBUG_LOG

TMP_MEMOIZE_PATH=.tmp.memoize.out
>$TMP_MEMOIZE_PATH

graph_path=$1

# Function to emulate a map
# Usage : memoize_set node value
memoize_set() {
  [[ $# -ne 3 ]] && { echo ERROR: memoize_set takes 3 arguments; exit 1; }
  memoize_entryname="_memoize_$1_$2"
  echo $memoize_entryname $3 >> $TMP_MEMOIZE_PATH
}

# Function to emulate getting values in a 2D array
# Usage : memoize_get node
memoize_get() {
  [[ $# -ne 2 ]] && { echo ERROR: memoize_get takes 2 arguments; exit 1; }
  memoize_entryname="_memoize_$1_$2"
  cat $TMP_MEMOIZE_PATH | grep $memoize_entryname | tail -n1 | awk '{ print $2 }'
}

# Usage : count_paths $start_node $stop_node $direction
count_paths() {
  [[ "$#" -ne 2 ]] && { echo "count_paths requires 2 arguments"; exit 1; }
  local start_node="$1"
  local stop_node="$2"
  
  test $DEBUG && echo Looking at start_node: $start_node >> $DEBUG_LOG
  
  count=$(memoize_get $start_node $stop_node)
  if [[ "$start_node" == "$stop_node" ]]; then
  	test $DEBUG && echo $start_node matches stop_node >> $DEBUG_LOG
    echo 1
  elif [[ -n "$count" ]]; then
    test $DEBUG && echo "Read memoized value for $start_node: $count" >> $DEBUG_LOG
    echo $count
  else
	  next_nodes=$(cat $graph_path | grep "$start_node:" | sed "s/$start_node://g")
	  test $DEBUG && echo Expanding next_nodes from $start_node: $next_nodes >> $DEBUG_LOG
	  
	  count=$(for next_node in $next_nodes; do count_paths $next_node $stop_node; done | awk 'BEGIN { sum=0 }; { sum += $1 }; END { print sum }')
	  test $DEBUG && echo "Calculated value for $start_node: $count" >> $DEBUG_LOG
	  
	  memoize_set $start_node $stop_node $count
	  test $DEBUG && echo "Memoized value for $start_node: $(memoize_get $start_node $stop_node)" >> $DEBUG_LOG
	  echo $count
  fi
}

total=$((($(count_paths svr dac) * $(count_paths dac fft) * $(count_paths fft out)) + ($(count_paths svr fft) * $(count_paths fft dac) * $(count_paths dac out)) ))

test $DEBUG && cat $DEBUG_LOG
echo $total
 
rm $DEBUG_LOG $TMP_MEMOIZE_PATH	
