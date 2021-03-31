#!/bin/bash

re='^[0-9]+$'       #variable that contains search for a two digit number between 10 and 99
read -p 'Enter a two digit numeric code that is equal to either 20 or 40. ' var1

while ! [[ $var1 =~ $re && $var1 -eq '40' || $var1 -eq '20' ]]; do      #loops until correct values are entered
    read -p 'Invalid input. Please try again. ' var1
done

echo 'Success! Input is equal to 20 or 40'

exit 0