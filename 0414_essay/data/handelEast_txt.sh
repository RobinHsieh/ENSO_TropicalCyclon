#!/bin/bash

if [[ -e AllEastPacific.csv ]]; then
    rm AllEastPacific.csv
fi

fileAllEast=($(cat NortheastandNorthCentralPacific.txt | egrep '^19[5-9].|^200[0-6]' | cut -d ',' -f 1,5,6 | tr -d '[ NE]' | tr -s '\n' ' '))

for line in ${fileAllEast[*]}
do
    utc=$(echo $line | cut -d ',' -f 1)
    lat=$(echo $line | cut -d ',' -f 2)
    lon=$(echo $line | cut -d ',' -f 3)
    judge=$(echo $lon | grep 'W')
    if [[ "$judge" != '' ]]; then
	lon=$(echo "360-${lon%W}" | bc)  # bc: An arbitrary precision calculator
    fi
    echo "$utc,$lat,$lon" >> AllEastPacific.csv
done

cat AllEastPacific.csv | egrep '^19(51|57|65|72|76|82|87|97)' | cut -d ',' -f 2,3 > EPWEastPacific.csv
cat AllEastPacific.csv | egrep '^19(53|91|94)|^20(20|24)' | cut -d ',' -f 2,3 > CPWEastPacific.csv
cat AllEastPacific.csv | egrep '^19(54|55|64|73|75|88|98|99)' | cut -d ',' -f 2,3 > EPCEastPacific.csv
sed -i '' -e 's/^.........//g' AllEastPacific.csv
# '': Without creating a backup of the file, -e: Append the editing commands specified by the command argument to the list of commands.

