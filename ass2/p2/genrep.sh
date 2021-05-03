#!/bin/bash

pre="<tr><td>"                     #Variables that will be used to remove html code from text
post="<\/td><\/tr>"
mid="<\/td><td>"

cat attacks.html | grep "<td>" | sed -e "s/^$pre//g; s/$post$//g; s/$mid/ /g" | awk 'BEGIN {print "Attacks        ", "Instances(Q3)"} { printf "%-15s %-10s \n", $1, $2+$3+$4}'
#Grep searches for lines using '<td>' and then sed removes the html code from those lines. Awk is then used to format and calculate the instances for each attack

