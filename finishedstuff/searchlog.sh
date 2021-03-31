#!/bin/bash
#Dylan Immelman
#10525787

while true; do      #Infinite  that stops when all lines have been read

    read -p "Pattern to be searched: " pattern         
    read -p "(whole) or (any) match: " match
    read -p "Inverted match (y/n): " inverted

    if [ $match = 'any' ]; then                     #Checks user input if whole flag wants to be used
        if [ $inverted = 'y' ]; then                #Checks user input if reverse flag wants to be used
            grep -vi "$pattern" access_log.txt      #Searches and prints lines with pattern with the reverse flag on
        else
            grep -i "$pattern" access_log.txt       #Searches and prints lines with pattern in it
        fi
        
    else
        if [ $inverted = 'y' ]; then
            grep -wvi "$pattern" access_log.txt     #Searches and prints lines with pattern with the reverse and whole flags on
        else
            grep -wi "$pattern" access_log.txt      #Searches and prints lines with pattern with the whole flag on
        fi       
    fi    


    read -p "Exit? (y/n): " userexit                

    if [ $userexit = 'y' ]; then                    #exits if user input equals "y"
        exit 0
    fi

done