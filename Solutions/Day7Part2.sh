#/bin/bash
#
# Usage : Solutions/Day7Part2.sh input.txt

DEBUG=

CURRENT_BEAMS=.tmp.beams.out
>$CURRENT_BEAMS
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

# Usage : add_node step offset
add_node() {
  [[ "$#" -ne 2 ]] && { echo "add_node requires 2 arguments"; exit 1; }
  local step=$1
  local offset=$2
  node_name=$(construct_node_name $step $offset)
  grep -q "${node_name}" $GRAPH || echo "${node_name}:" >> $GRAPH
}

# Usage : add_child parent_step parent_offset child_step child_offset
add_child() {
  [[ "$#" -ne 4 ]] && { echo "add_child requires 4 arguments"; exit 1; }
  local parent_step=$1
  local parent_offset=$2
  local child_step=$3
  local child_offset=$4
  parent_node_name=$(construct_node_name $parent_step $parent_offset)
  child_node_name=$(construct_node_name $child_step $child_offset)
  sed -i -e "/${parent_node_name}:/ s/$/ ${child_node_name}/" $GRAPH
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

# Usage : add_beam step offset
add_beam() {
  [[ "$#" -ne 2 ]] && { echo "add_beam requires 2 arguments"; exit 1; }
  step=$1
  offset=$2
  grep -q "${step} ${offset}" $CURRENT_BEAMS || echo "${step} ${offset}" >> $CURRENT_BEAMS
}

# Usage : remove_beam step offset
remove_beam() {
  [[ "$#" -ne 2 ]] && { echo "remove_beam requires 2 arguments"; exit 1; }
  step=$1
  offset=$2
  sed -i -e "/${step} ${offset}/d" $CURRENT_BEAMS
}

# Usage : construct_graph input_path
construct_graph() {
  [[ "$#" -ne 1 ]] && { echo "construct_graph requires 1 argument"; exit 1; }
  input_path=$1
  
  current_step=0
  
  start_offset=$(head -n1 $input_path | grep "S" -bo | grep -o "[0-9]\+")
  add_beam $current_step $start_offset
  add_node $current_step $start_offset
  
  while read line; do
    ((current_step++))
    
    
    splitter_offsets=$(echo $line | grep "\^" -bo | grep -o "[0-9]\+")
    test $DEBUG && echo splitter_offsets: $splitter_offsets
    
    while read beam_step beam_offset; do
      test $DEBUG && echo "-->" beam_step: $beam_step, beam_offset: $beam_offset
      echo $splitter_offsets | grep -woq $beam_offset && {
        
        for child_beam_offset in $(($beam_offset + 1)) $(($beam_offset - 1)); do
          test $DEBUG && echo "---->" Adding child beam current_step: $current_step, child_beam_offset: $child_beam_offset
          add_node $current_step $child_beam_offset
          add_child $beam_step $beam_offset $current_step $child_beam_offset
          add_beam $current_step $child_beam_offset
        done

        remove_beam $beam_step $beam_offset
      }
      
    done < <(cat $CURRENT_BEAMS)
    
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

rm $GRAPH $MEMOIZE $CURRENT_BEAMS
