#!/bin/bash

awk '                                                                           
    NR>1 { if (length($2) >= 8 && $2 ~ /[0-9]/ && $2 ~ /[A-Z]/)
        {
            printf ""$2" - meets password strength requirements\n";
        }
    else
        {
            printf ""$2" - does NOT meet password strength requirements\n";
        }
    }' usrpwords.txt         #Used awk command to check each line of the text if the user password meets the requirements 
                            