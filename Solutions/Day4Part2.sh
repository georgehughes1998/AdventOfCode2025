#/bin/bash
#
# Usage : Solutions/Day4Part2.sh input.txt


DEBUG=

# Function to emulate settings values in a 2D array
# Usage : set_at x y value
set_at() {
  [[ $# -ne 3 ]] && { echo ERROR: set_at takes 3 arguments; exit 1; }
  position_variable="x${1}_y${2}"
  eval $position_variable=$3
}

# Function to emulate getting values in a 2D array
# Usage : set_at x y
get_at() {
  [[ $# -ne 2 ]] && { echo ERROR: get_at takes 2 arguments; exit 1; }
  position_variable="x${1}_y${2}"
  echo ${!position_variable}
}


width=$(($(cat $1 | head -n1 | wc -c) - 1))
height=$(cat $1 | wc -l | grep -o '[0-9]\+')

test $DEBUG && echo width: $width, height: $height

while read y line; do
  while read x character; do
    [[ "$character" == "@" ]] && value=1 || value=0
    set_at $x $y $value
  done < <(echo $line | grep . -o | nl -v0)
done < <(cat $1 | nl -v0)

total=0
to_remove=1
while [[ -n "$to_remove" || "$total" -eq 0 ]]; do
  to_remove=
  for ((y=0; y<$height; y++)); do
    for ((x=0; x<$width; x++)); do
      test $DEBUG && echo x: $x, y: $y, value: $(get_at $x $y)
      count_neighbours=0
  
      [[ "$(get_at $x $y)" -ne 1 ]] && continue
  
      while read dy dx; do
        y2=$(($y + $dy)); x2=$(($x + $dx))
        value2=$(get_at $x2 $y2); value2=${value2:-0}
        count_neighbours=$((count_neighbours + $value2))
  
        test $DEBUG && echo x2: $x2, y2: $y2, value2: $value2
      done < <(echo $(echo {-1..1},{-1..1}) | tr ' ' '\n' | tr ',' ' ' | grep -v "0 0")
      
      test $DEBUG && echo count_neighbours: $count_neighbours -----------
      [[ "$count_neighbours" -lt 4 ]] && { ((total++)); to_remove="$to_remove $x,$y" ; }
    done
  done
  
  test $DEBUG && echo to_remove: $to_remove 
  
  [[ -n "$to_remove" ]] && while read x y; do
    set_at $x $y 0
  done < <(echo $to_remove | tr ' ' '\n' | tr ',' ' ')
done

echo $total
