#!/bin/bash

ass1=(12 18 20 10 12 16 15 19 8 11)     #Creating array 1
ass2=(22 29 30 20 18 24 25 26 29 30)    #Creating array 2
val=1                                   #Setting value for counter

for (( i=0; i< ${#ass1[@]} ; i++ )); do     #C-style for loop that loops for every item in array 1

    value=$((ass1[i] + ass2[i]))            #adding specific value from each array
    echo "Student_$val Result: $value"      #printing resul
    val=$((val+1))                          
    
doneinit