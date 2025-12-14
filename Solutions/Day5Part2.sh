#/bin/bash
#
# Usage : Solutions/Day5Part2.sh input.txt

cat $1 | grep "-" | tr '-' ' ' | xargs -P0 -n2 seq | sort -nu | wc -l | grep -o "[0-9]\+"
