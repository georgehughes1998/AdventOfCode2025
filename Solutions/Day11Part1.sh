#/bin/bash
#
# Usage : Solutions/Day11Part1.sh input.txt

DEBUG=

graph_path=$1

# Usage : explore_node $node "$visited"
explore_node() {
  local visited_grep_args
  local visited
  local current_node

  current_node=$1
  visited="$2"
  visited_grep_args=$(echo $visited | tr ' ' '\n' | grep . | awk '{ print "-e "$0 }' | tr '\n' ' ')
  [[ -n "$visited_grep_args" ]] && visited_grep_args="-v $visited_grep_args" || visited_grep_args="."
  
  test $DEBUG && echo current_node: $current_node, visited_grep_args: $visited_grep_args
  
  if [[ "$current_node" == "out" ]]; then
    echo 1
  else
	  next_nodes=$(cat $graph_path | grep "$current_node:" | sed "s/$current_node://g" | grep $visited_grep_args)
	  
	  test $DEBUG && echo next_nodes: $next_nodes
	  
	  for next_node in $next_nodes; do
	    explore_node $next_node "$visited $next_node"
	  done
  fi
}

explore_node "you" "" | wc -w | grep -o "[0-9]\+"
