#/bin/bash
#
# Usage : Solutions/Day5Part1.sh input.txt


cat $1 | grep "-" | tr '-' ' ' | awk -v numbers_string="$(cat $1 | grep [0-9] | grep -v "-" | tr '\n' ' ')" 'BEGIN { split(numbers_string, numbers, " ") }; { for (n in numbers) if (numbers[n] >= $1 && numbers[n] <= $2) print numbers[n] }' | sort -un | wc -l | grep -o "[0-9]\+"
