#!/bin/bash

if [[ -e AllAtlantic.csv ]]; then
    rm AllAtlantic.csv
fi

cat Atlantic.txt | egrep '^19[5-9].|^200[0-6]' | cut -d ',' -f 1,5,6 | tr -d '[ NW]' | awk 'BEGIN {FS = ","; OFS = ","} {printf "%s,%.1f,%.1f\n", $1, $2, 360.0-$3}' | egrep -v '360\.|35[7-9]\.' > AllAtlantic.csv

cat AllAtlantic.csv | egrep '^19(51|57|65|72|76|82|87|97)' | cut -d ',' -f 2,3 > EPWAtlantic.csv
cat AllAtlantic.csv | egrep '^19(53|91|94)|^20(20|24)' | cut -d ',' -f 2,3 > CPWAtlantic.csv
cat AllAtlantic.csv | egrep '^19(54|55|64|73|75|88|98|99)' | cut -d ',' -f 2,3 > EPCAtlantic.csv
sed -i '' -e 's/^.........//g' AllAtlantic.csv
# '': Without creating a backup of the file, -e: Append the editing commands specified by the command argument to the list of commands.

