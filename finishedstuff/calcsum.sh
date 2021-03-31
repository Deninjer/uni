#!/bin/bash
#Dylan Immelman
#10525787

sum=$(($1 + $2 + $3))       #calculates sum of the 3 command line inputs

if [ $sum -le 30 ];         #Checks if the sum is less than 30
then
    echo "The sum of $1 and $2 and $3 is $sum"      #prints sum
else
    echo "Sum exceeds maximum allowable"            #prints error when over 30
fi

exit 0 