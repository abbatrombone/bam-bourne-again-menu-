#!/usr/bin/env bash


gsettings set org.gnome.desktop.peripherals.keyboard repeat true;
trap "bash ~/Basg_Files/Checkbox_menu_template.sh" WINCH
echo -en "\ec\e[37;44m\e[J"


cols=$(tput cols)
Middle=$(("$cols"/2))

RED='\e[37;44m\e[J'
RESET='\e[27m'
UNMARK='\e[7m'


selections=( "[ ] 1" "[ ] 2" "[ ] 3" "[ ] 4" "done" )
printvar=()

function choose_from_menu() {
   
    local prompt="${UNMARK}$1${RESET}" outvar="$2"
    shift
    shift
    local options=("$@") 
    if [ -z "${cur}" ]; then cur=0
    fi
    count=${#options[@]}  
    index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    tput cup 1 $Middle; printf "$prompt\n";
    while true
    do
        # list all options (option list is zero-based)
        index=0 
  for o in "${options[@]}"
        do
        
            if [ "$index" == "$cur" ]
            then  tput cup $(("$index"+3)) $Middle; echo -e "\e[7m$o\e[0m"; tput cup $(("$index"+3)) # mark & highlight the current option plus 3 is to place it under the prompt
            else  tput cup $(("$index"+3)) $Middle; echo -e "${RED}$o${RESET}"; #This also off sets the code in the list it is also going down 1 by one so only plus 3 is needed here (its werid I know)
            fi    
        index=$(( $index + 1 ))
        done
        
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=$(($count -1 ))
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=0
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}

for (( x = 1; x <= 3; x++ )); do
      for (( y = 1; y <= "$COLUMNS"; y++ )); do
          if (( 1 == x && y == "$COLUMNS" )); then printf "\u2510" 
          elif (( 1 == x && y == 1 )); then printf "\u250C" fi
          elif (( 3 == x && y == 1 )); then printf "\u2514" fi
          elif (( 3 == x && y == "$COLUMNS" )); then printf "\u2518" 
        elif (( 1 == y || "$COLUMNS" == y )); then
            printf  "\u2502"
        elif ((x == 1 || 3 == x)); then
            printf '\u2500'
        else
            echo -n " "
         fi
      done
   done   

while [[ $selected_choice != "done" ]]
do

choose_from_menu "Please make a choice:" selected_choice "${selections[@]}"; 

case $selected_choice in

    "[ ] 1")
    selections[0]="[X] 1"
    ;;
    "[ ] 2")
    selections[1]="[X] 2"
    ;;
    "[ ] 3")
    selections[2]="[X] 3"
    ;;
    "[ ] 4")
    selections[3]="[X] 4"
    ;;
    "[X] 1")
    selections[0]="[ ] 1"
    ;;
    "[X] 2")
    selections[1]="[ ] 2"
    ;;
    "[X] 3")
    selections[2]="[ ] 3"
    ;;
    "[X] 4")
    selections[3]="[ ] 4"
    ;;
    "done")
    if [[ "${selections[0]}" == "[X] 1" ]];
    then printvar+=("${selections[0]}")
    fi
    if [[ "${selections[1]}" == "[X] 2" ]];
    then printvar+=("${selections[1]}")
    fi
    if [[ "${selections[2]}" == "[X] 3" ]];
    then printvar+=("${selections[2]}")
    fi
    if [[ "${selections[3]}" == "[X] 4" ]];
    then printvar+=("${selections[3]}")
    fi
    echo "you chose: ${printvar[@]}"
    ;;
esac
done
