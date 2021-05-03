#!/bin/bash

getprop()                       #Creation of function
{
    file=$1                                                         #Setting file name variable
    word_count=$(wc -w < $file)                                     #Checking wordcount of file and storing in word_count variable
    file_size=$(stat -c%s $file)                                    #Checking file and storing in file_size variable
    last_modified_date=$(date -r $file "+%e-%m-%Y %H:%M:%S")        #Checking last modified date and storing it in a variable
    echo "The file $file contains $word_count words and is "$file_size"K in size and was last modified $last_modified_date"      #printing results
}
read -p "File to check: " filename
getprop $filename       #Calling function 