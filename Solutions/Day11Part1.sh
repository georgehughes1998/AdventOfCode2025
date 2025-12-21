#/bin/bash
#
# Usage : Solutions/Day11Part1.sh input.txt

DEBUG=

graph_path=$1

DIRECTION_FORWARD="forward"
DIRECTION_BACKWARD="backward"

# Usage : explore_node $start_node $stop_node $direction "$visited"
explore_node() {
  [[ "$#" -lt 3 ]] && { echo "$0 requires at least 3 arguments"; exit 1; }
  local start_node="$1"
  local stop_node="$2"
  local direction="$3"
  local visited="${4:-$1}"
  
  local visited_grep_args=$(echo $visited | tr ' ' '\n' | grep . | awk '{ print "-e "$0 }' | tr '\n' ' ')

  [[ -n "$visited_grep_args" ]] && visited_grep_args="-v $visited_grep_args" || visited_grep_args="."
  
  test $DEBUG && echo start_node: $start_node, visited_grep_args: $visited_grep_args
  
  if [[ "$start_node" == "$stop_node" ]]; then
    echo $visited
  else
    if [[ "$direction" == $DIRECTION_FORWARD ]]; then
	  	next_nodes=$(cat $graph_path | grep "$start_node:" | sed "s/$start_node://g" | tr ' ' '\n' | grep $visited_grep_args)
	  elif [[ "$direction" == $DIRECTION_BACKWARD ]]; then
	  	next_nodes=$(cat $graph_path | grep "$start_node" | tr ' ' '\n' | grep ":" | tr -d ':' | grep $visited_grep_args)
	  else
	  	echo "Unrecognised direction: $direction"
	  	exit 1
	  fi
	  
	  test $DEBUG && echo next_nodes: $next_nodes
	  
	  for next_node in $next_nodes; do
	    explore_node $next_node $stop_node $direction "$visited $next_node"
	  done
  fi
}

explore_node "you" "out" $DIRECTION_FORWARD | wc -l | grep -o "[0-9]\+"
