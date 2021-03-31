#!/bin/bash

directory=$1    #Setting command line result as directory to be checked
fullfi=0        #Initializing all file values
emptyfi=0
fulldi=0
emptydi=0

for item in $directory/*; do            #For loop that checks every item in the directory

    if [ -f "$item" ]; then             #If loop that checks if the item is a file
        if [ -s "$item" ]; then         #Check if file contains data
            fullfi=$(( fullfi+1 ))      #Adds one to fullfi when file is full
        else
            emptyfi=$(( emptyfi+1 ))    #Adds one to emptyfi when file is empty
        fi
            
    elif [ -d "$item" ]; then           #Checks if item is a directory
        if [ "$(ls -A $item)" ]; then   #Checks if directory containts data
            fulldi=$(( fulldi+1 ))      #Adds one to fulldi when directory is full
        else
            emptydi=$(( emptydi+1 ))    #Adds one to emptydi when directory is empty
        fi
    fi
    
done

echo "The $1 directory contains:"       #Prints results
echo "$fullfi files that contain data"
echo "$emptyfi files that are empty"
echo "$fulldi non-empty directories"
echo "$emptydi empty directories"

exit 0
