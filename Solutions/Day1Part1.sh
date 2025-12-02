#/bin/bash
#
# Usage : Solutions/Day1Part1.sh input.txt

cat $1 | sed 's/R//' | sed 's/L/-/' | awk 'BEGIN { total=50 }; { total=((100 + total + $1) % 100) ; print total }' | grep ^0$ -c