#!/bin/bash

cat bst_all.txt | egrep '(^[5-9][0-9][0-9][0-9][0-9][0-9])|(^0[0-6][0-9][0-9][0-9][0-9])(00|06|12|18)' | cut -d ' ' -f 1,4,5 | tr -s ' ' ',' | awk 'BEGIN {FS = ","; OFS = ","} {printf "%s,%.1f,%.1f\n", $1, $2/10, $3/10}' > AllWestPacific.csv
cat AllWestPacific.csv | egrep '^(51|57|65|72|76|82|87|97)' | cut -d ',' -f 2,3 > EPWWestPacific.csv
cat AllWestPacific.csv | egrep '^(53|91|94|20|24)' | cut -d ',' -f 2,3 > CPWWestPacific.csv
cat AllWestPacific.csv | egrep '^(54|55|64|73|75|88|98|99)' | cut -d ',' -f 2,3 > EPCWestPacific.csv
sed -i '' -e 's/^.........//g' AllWestPacific.csv

