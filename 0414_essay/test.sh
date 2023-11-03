#!/bin/bash

cat test.txt | awk 'BEGIN {FS = ","; OFS = ","} {printf "%s,%.1f\n", $1, $2/10}' > test2.txt
