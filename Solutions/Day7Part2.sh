#/bin/bash
#
# Usage : Solutions/Day7Part2.sh input.txt

DEBUG=1

GRAPH=.tmp.graph.out
> $GRAPH
MEMOIZE=.tmp.memoize.out
> $MEMOIZE

# Usage : construct_node_name step offset
construct_node_name() {
  [[ "$#" -ne 2 ]] && { echo "construct_node_name requires 2 arguments"; exit 1; }
  local step=$1
  local offset=$2
  echo s${step}o${offset}
}

# Usage : add_node step offset children_offsets
add_node() {
  [[ "$#" -ne 3 ]] && { echo "add_node requires 3 arguments"; exit 1; }
  local step=$1
  local offset=$2
  local children_offsets=$3
  local children=$(for child_offset in $children_offsets; do construct_node_name $((step + 1)) $child_offset; done )
  echo $(construct_node_name $step $offset): ${children} >> $GRAPH
}

# Usage : get_head
get_head() {
  [[ "$#" -ne 0 ]] && { echo "get_children requires 0 arguments"; exit 1; }
  head -n1 $GRAPH | grep -wo ".\+:" | tr -d ':'
}

# Usage : get_children node
get_children() {
  [[ "$#" -ne 1 ]] && { echo "get_children requires 1 argument"; exit 1; }
  node=$1
  cat $GRAPH | grep "$node:" | sed "s/$node://g"
}

# Usage : construct_graph input_path
construct_graph() {
  [[ "$#" -ne 1 ]] && { echo "construct_graph requires 1 argument"; exit 1; }
  input_path=$1
  
  current_beams=$(head -n1 $input_path | grep "S" -bo | grep -o "[0-9]\+")

  step=0
  while read line; do
    offsets=$(echo $line | grep "\^" -bo | grep -o "[0-9]\+")
    
    beams_matched=$(echo $current_beams | grep -wo $(echo $offsets | tr ' ' '\n' | awk '{ print "-e "$0 }'))
    beams_non_matched=$(echo $current_beams | tr ' ' '\n' | grep -wv $(echo $offsets | tr ' ' '\n' | awk '{ print "-e "$0 }'))
    
    split_beams=
    for offset in $beams_matched; do
      new_offsets="$(($offset + 1)) $(($offset - 1))"
      add_node $step $offset "$new_offsets"
      split_beams="$split_beams $new_offsets"
      test $DEBUG && echo offset: $offset, new_offsets: $new_offsets
    done
  
    test $DEBUG && echo "-->" beams_matched: $beams_matched, beams_non_matched: $beams_non_matched, split_beams: $split_beams
  
    current_beams=$(echo "$split_beams $beams_non_matched" | tr ' ' '\n' | sort -nu)
    ((step++))
  done < <(cat $input_path | grep "\^")
}

# Function to emulate a map
# Usage : memoize_set node value
memoize_set() {
  [[ $# -ne 2 ]] && { echo ERROR: memoize_set takes 2 arguments; exit 1; }
  memoize_entryname="_memoize_$1"
  echo $memoize_entryname $2 >> $MEMOIZE
}

# Function to emulate a map
# Usage : memoize_get node
memoize_get() {
  [[ $# -ne 1 ]] && { echo ERROR: memoize_get takes 1 argument; exit 1; }
  memoize_entryname="_memoize_$1"
  cat $MEMOIZE | grep $memoize_entryname | tail -n1 | awk '{ print $2 }'
}

# Usage : count_paths $start_node
count_paths() {
  [[ "$#" -ne 1 ]] && { echo "count_paths requires 1 argument"; exit 1; }
  local current_node="$1"
  
  local count=$(memoize_get $current_node)
  local children=$(get_children $current_node)
  
  if [[ -n "$count" ]]; then
    echo $count
  elif [[ -z "$children" ]]; then
    echo 1
  else
	  count=$(for child in $children; do count_paths $child; done | awk 'BEGIN { sum=0 }; { sum += $1 }; END { print sum }')
	  memoize_set $current_node $count
	  echo $count
	fi
}


construct_graph $1
count_paths $(get_head)

cat $GRAPH

rm $GRAPH $MEMOIZE
