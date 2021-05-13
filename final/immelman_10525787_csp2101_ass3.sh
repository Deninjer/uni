#!/bin/bash
#Dylan Immelman 
#10525787

#creating global variables
declare -a logs
declare -a finalFields
declare byteOp
declare packetsOp
declare bytesVar
declare packetsVar
declare protocolVal
declare srcpVal
declare srcIp
declare destpVal
declare destIp
declare criteriaOne
declare criteriaTwo
declare criteriaThree
declare criteriaOneVal
declare criteriaTwoVal
declare criteriaThreeVal
logPatrn="serv_acc_log." #for creating log array
exitval=0                #for exiting code

#Case function used to select operators 
doCase()
{
    read -p "Which operation to search $1: `echo $'\n(1)-EQUALS TO (2)-GREATER THAN (3)-LESS THAN (4)-NOT EQUAL TO\n> '`" choice
    case $choice in
        1 )  echo "==";;
        2 )  echo ">";;
        3 )  echo "<";;
        4 )  echo "!=";;
    esac
}

#Function that checks search criteria that will be used by awk
checkCriteria()
{
    if [[ $criteriaOne == 0 ]]; then
        criteriaOne="/$1/"
        criteriaOneVal=$2

    elif [[ $criteriaTwo == 0 ]]; then
        criteriaTwo="/$1/"
        criteriaTwoVal=$2
    else
        criteriaThree="/$1/"
        criteriaThreeVal=$2
    fi
}

#Function to choose fields and any other data associated with those fields
chooseFields(){
    fields=("PROTOCOL" "SRC IP" "SRC PORT" "DEST IP" "DEST PORT" "PACKETS" "BYTES")     
    finalFields=()                   #Array to hold fields chosen
    endwhile=0
    regNum='^[0-9]{1}$'
    byteVar=0
    packetsVar=0

#Will repeat untill user exits or 3 fields are chosen
    while [[ $endwhile != 1 ]];
    do
        count=1 
        fieldAmount=${#fields[*]}
        echo "Fields available:"
        for (( i=0; i<$fieldAmount; i++ )); do      #C-Style loop to print fields with associating field number
            echo -e " ($count) ${fields[$i]}"
            (( count++ ))
        done

        #Choose which field to search
        regNumField='^[1-'$fieldAmount']{1}$'
        read -p "Choose field to search: " choice
        while [[ ! "$choice" =~ $regNumField ]]       #valid awnser check
        do 
            read -p 'Invalid number try agian: ' choice
        done
        finalFields+=("${fields[$choice-1]}")       #Adds field to the final fields list

        idx=$(( choice-1 ))                         #Used for bytes and packets

        #Code for when BYTES is chosen as a field
        if [[ "${fields[$idx]}" = "BYTES" ]]; then
            export byteVar=1
            read -p "What value would you like search for: " byteVal
            regNumB='[0-9]{4}'
            until [[ ! "$byteVal" =~ $regNumB ]]; do        #valid awnser check    
                read -p "Invalid Input, Try Again: " byteVal
            done
            byteOp=$(doCase "BYTES")                #gets operator
            echo "Operation selected: '$byteOp'"
            byteOp="$byteOp$byteVal"                #forms new string with operator and byte val joined, to be used in awk
            
        #Code for when PACKETS is chosen
        elif [[ "${fields[$idx]}" = "PACKETS" ]];then
            export packetsVar=1
            regNumP='[0-9]{4}'
            read -p "What value would you like search for: " packetVal
            until [[ ! "$packetVal" =~ $regNumP ]]; do                  #valid awnser check
                read -p "Invalid Input, Try Again: " packetVal
            done
            packetsOp=$(doCase "PACKETS")
            echo "Operation selected: '$packetsOp'"
            packetsOp="$packetsOp$packetVal"

        #Code for when PROTOCOL is chosen
        elif [[ "${fields[$idx]}" = "PROTOCOL" ]];then
            regNum='^[1-3]{1}$'
            read -p "What Protocol would you like to search for: `echo $'\n (1)-TCP (2)-UDP (3)-ICMP: '`" protocolVal
            while [[ ! $protocolVal =~ $regNum ]]; do              #valid awnser check
                read -p "Invalid Input, Try Again: " protocolVal
            done
            if [[ $protocolVal == 1 ]]; then                    #user choses from these options
                protocolVal="TCP"
            elif [[ $protocolVal == 2 ]]; then
                protocolVal="UDP"
            else
                protocolVal="ICMP"
            fi
            checkCriteria $protocolVal "3"          

        #Code for when DEST PORT is chosen
        elif [[ "${fields[$idx]}" = "DEST PORT" ]];then
            read -p "What port would you like to search: `echo $'\n> '`" destpVal
            regNum='^[0-9A-Z_]{4}$'
            until [[ ! "$destpVal" =~ $regNum ]]; do                   #valid awnser check
                read -p "Invalid Input, Try Again: " destpVal
            done
            checkCriteria $destpVal "7"

        #Code for when SRC PORT is chosen
        elif [[ "${fields[$idx]}" = "SRC PORT" ]];then
            regNum='^[0-9A-Z_]{4}$'
            read -p "What port would you like to search: `echo $'\n> '`" srcpVal   
            until [[ ! "$srcpVal" =~ $regNum ]]; do                    #valid awnser check
                read -p "Invalid Input, Try Again: " srcpVal
            done
            checkCriteria $srcpVal "5"

        #Code for when DEST IP is chosen
        elif [[ "${fields[$idx]}" = "DEST IP" ]];then
            read -p "What Destination IP would you like to search? `echo $'\n> '`" destIp
            regNum='^[0-9]{6}$'
            until [[ ! "$destIp" =~ $regNum ]]; do                     #valid awnser check
                read -p "Invalid Input, Try Again: " destIp
            done
            checkCriteria $destIp "6"

        #Code for when SRC IP is chosen
        elif [[ "${fields[$idx]}" = "SRC IP" ]];then
            regNum='^[0-9]{6}$'
            read -p "What Source IP would you like to search: `echo $'\n> '`" srcIp  
            until [[ ! $srcIp =~ $regNum ]]; do                      #valid awnser check
                read -p "Invalid Input, Try Again: " srcIp
            done
            checkCriteria  $srcIp  "4"
        fi

        #Re-creates array to remove any blank spaces
        fields=( "${fields[@]:0:$((choice-1))}" "${fields[@]:$choice}" )
        echo -e "\nFields chosen:\n ${finalFields[@]}\n"

        #Checks if 3 fields are chosen or if user wants to exit
        if [[ ${#finalFields[*]} -eq 3 ]]; then 
            echo -e "\nTotal amount of fields selected!"
            endwhile=1
        else
            regNum='^[1-2]{1}$'
            read -p "(1)-Add one more field (2)-Continue `echo $'\n> '`" cont
            while [[ ! "$cont" =~ $regNum ]]                      #valid awnser check
            do 
                read -p 'Invalid number try agian: ' cont
            done
            if [[ $cont = 2 ]]; then
                endwhile=1
            fi
        fi
    done
}

#Funtion where user choses to search on or all logs
allOrOne()
{
    read -p " (1)-Search all logs`echo $'\n '`(2)-Search one log`echo $'\n> '`" choice
    regNum='^[1-2]{1}$'
    while [[ ! "$choice" =~ $regNum ]]   #valid awnser check
    do 
        read -p 'Invalid number try agian: ' choice
    done
    echo $choice
}

#Function where user choses which log to search
chooseLog()
{
    for log in ${logs[@]}; do echo $log 
    done
    read -p "Choose which log to " choice
    regNum='^[1-5]{1}$'
    until [[ ! "$choice" =~ $regNum ]]   #valid awnser check
    do 
        read -p 'Invalid number try agian: ' choice
    done
}

#function that does the search using awk
search()
{
    formatString="%-6s %-11s %-6s %-11s %-6s %-6s %-6s %-10s "           #Sets format string
    formatVariables=",\$3, \$4, \$5, \$6, \$7, \$8, \$9, \$13"              

    #adds all logs into one text file
    for log in ${logs[@]}; do
        grep "suspicious" $log > tempfile.txt       #Searches only for lines containing suspicious
    done

    #Begin of awk
    awk 'BEGIN {FS=","; packetsTotal=0; bytesTotal=0} 
        {   
            criteriaTrim=$'$criteriaOneVal'
            criteriaTrim2=$'$criteriaTwoVal'    
            criteriaTrim3=$'$criteriaThreeVal'
            
                

            if (criteriaTrim ~ '$criteriaOne' && ( "'$criteriaTwo'" == 0  || ("'$criteriaTwo'" != 0 && criteriaTrim2 ~ '$criteriaTwo')) && ( "'$criteriaThree'" == 0 || ("'$criteriaThree'" != 0 && criteriaTrim3 ~ '$criteriaThree'))){
                if ('"$byteVar"'==1 && '"$packetsVar"'==1)
                {
                    if ((int($9)'$byteOp' && int($8)'$packetsOp')){
                        printf "'"$formatString"'\n"'"$formatVariables"';
                        packetsTotal=packetsTotal+$8
                        bytesTotal=bytesTotal+$9
                    }
                }
                else if ('"$byteVar"'==1)
                {
                    if ((int($9)'$byteOp')){
                        printf "'"$formatString"'\n"'"$formatVariables"';
                        bytesTotal=bytesTotal+$9
                    }
                }
                else if ('"$packetsVar"'==1)
                {
                    if ((int($8)'$packetsOp')){
                        printf "'"$formatString"'\n"'"$formatVariables"';
                        packetsTotal=packetsTotal+$8
                    }
                }
                else
                {
                    printf "'"$formatString"'\n"'"$formatVariables"';
                }
            }
        }
    END { 
        if ('"$byteVar"'==1 && '"$packetsVar"'==1)
            print "Total packets:", packetsTotal" Total bytes:", bytesTotal;
        else if ('"$byteVar"'==1)
            print "Total bytes:", bytesTotal;
        else if ('"$packetsVar"'==1)
            print "Total packets:", packetsTotal
    }
    ' tempfile.txt > result.txt
    cat result.txt 
    exp result.txt #Sends result to export funtions
}

#Export funtion
exp()
{
    read -p "Where do you wish to store results: " choice
    echo $choice
    if [ -d "`eval echo ${choice//>}`" ]; then      #Checks if directory exists
        cat result.txt > $choice/$1
        echo "File store in $choice"
    else
        mkdir -p AccessLogSearchResults
        cat result.txt > AccessLogSearchResults/$1
        echo "Directory not found! New directory created."
    fi
}

#main 
while true
do
    #adding all logs in directory into a list
    for file in *; do
        if [[ $file =~ $logPatrn ]]; then
            logs+=($file)
        fi
    done

    #Counting length if log list
    logAmount=${#logs[*]}

    #Defining search fields
    criteriaOneVal=1
    criteriaTwoVal=1
    criteriaThreeVal=1
    criteriaOne=0
    criteriaTwo=0
    criteriaThree=0
    chooseFields
    
    #Choices

    if [[ "$(allOrOne)" = 1 ]]; then
        search
    else
        count=1
        echo "Logs available:"
        for log in ${logs[@]}; do 
            echo -e "($count) $log"
            (( count++ ))
        done
        read -p "Which log would you like to search: " choice
        regNum='^[1-5]{1}$'
        while [[ ! "$choice" =~ $regNum ]]; do
            read -p "Invalid Input, Try Again: " choice
        done
        for (( i=0; i<${#logs[*]}; i++ )); do
            if [[ i != $choice-1 ]]; then
                unset 'logs[i]'
            fi
        done
        search 
    fi

    #Checks if user wants to continue or exit
    regNum='^[1-2]{1}$'
    read -p "Do another search: `echo $'\n (1)-Yes (2)-No '``echo $'\n> '`" choice
    until [[ "$choice" =~ $regNum ]]; do
        read -p "Invalid Input, Try Again: " choice
    done
    if [[ $choice == 2 ]];then
        exit 0
    fi

done
