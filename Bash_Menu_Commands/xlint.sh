#!/usr/bin/env bash

stty sane;
gsettings set org.gnome.desktop.peripherals.keyboard repeat true;

trap "bash ~/Bash_Files/Bash_Menu_Commands/xlint.sh" WINCH

echo -en "\ec\e[37;44m\e[J"

cols=$(tput cols)
Middle=$(("$cols"/2))

RED='\e[37;44m\e[J'
RESET='\e[27m'
UNMARK='\e[7m'
CSOUND(){ mpv ~/Bash_Files/Bash_Sounds/CursorMove.wav --no-terminal ;} 
SSOUND(){ mpv ~/Bash_Files/Bash_Sounds/SelectSound.wav --no-terminal ;} #Custom

selections=( $(cd && shopt -s nullglob && cd Java_Files && find . -maxdepth 1 -type f -name "*.java") )
readarray -t sorted_selections < <(IFS=$'\n'; sort <<<"${selections[*]}")
for ((i=0; i<${#sorted_selections[@]}; i++)); do
  sorted_selections[$i]=${sorted_selections[$i]:2}
  sorted_selections[$i]=${sorted_selections[$i]//.java/}
done
sorted_selections+=('Go Back')

function choose_from_menu() {
   
    local prompt="${UNMARK}$1${RESET}" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]}  index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
      tput cup 1 $Middle; printf "$prompt\n";
    while true
    do
        # list all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
        
            if [ "$index" == "$cur" ]
            then  tput cup $(("$index"+3)) $Middle; echo -e " \e[7m$o\e[0m"; tput cup $(("$index"+3)) # mark & highlight the current option plus 3 is to place it under the prompt
            else  tput cup $(("$index"+3)) $Middle; echo -e "${RED}  $o${RESET}"; #This also off sets the code in the list it is also going down 1 by one so only plus 3 is needed here (its werid I know)
            fi    
        index=$(( $index + 1 ))
        done
        
        read -s -n3 key && stty -echo # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
        CSOUND;
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

choose_from_menu "Please select a file:" selected_choice "${sorted_selections[@]}"
echo "Selected choice: $selected_choice"

file=$selected_choice
fileclass=$file
filejava=$file

filejava+=".java"
fileclass+=".class"

clear;

subselections=(
"Xlint:unchecked"
"Xlint:deprecation"
"Xlint:all"
"Help"
"Go Back"
)

function choose_from_submenu() {

    local prompt="${UNMARK}$1${RESET}" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]}  index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    tput cup 1 $Middle; printf "$prompt\n";
    while true
    do
        # list all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
        
            if [ "$index" == "$cur" ]
            then  tput cup $(("$index"+3)) $Middle; echo -e " \e[7m$o\e[0m"; tput cup $(("$index"+3)) # mark & highlight the current option plus 3 is to place it under the prompt
            else  tput cup $(("$index"+3)) $Middle; echo -e "${RED}  $o${RESET}"; #This also off sets the code in the list it is also going down 1 by one so only plus 3 is needed here (its werid I know)
            fi    
        index=$(( $index + 1 ))
        done
        
        read -s -n3 key && stty -echo # wait for user to key in arrows or ENTER
       if [[ $key == $esc[A ]] # up arrow
        then cur=$(( cur - 1 )) && clear
            [ "$cur" -lt 0 ] && cur=$(($count -1 )) # count starts at 1 but arrays start at 0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( cur + 1 )) && clear
            [ "$cur" -ge "$count" ] && cur=0
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
        CSOUND;
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

choose_from_submenu "Please select a compile type:" subselected_choice "${subselections[@]}"
echo "Selected choice: file: $file compile type: $subselected_choice"

case "$subselected_choice" in
     
     "Xlint:unchecked") stty sane echo && cd && cd Java_Files && javac -Xlint:unchecked $filejava ;;
     "Xlint:deprecation") cd && cd Java_Files && javac -Xlint:deprecation $filejava & stty  ;;
     "Xlint:all")  cd && cd Java_Files && javac -Xlint:all $filejava & stty ;;
     "Help") echo "-Xlint:unchecked: Warns about unchecked conversions and assignments" && echo "-Xlint:deprecation: Warns about the use of deprecated APIs" && echo "-Xlint:all: Enables all available warnings.";;
     "Go Back") gsettings set org.gnome.desktop.peripherals.keyboard repeat false && echo -en "\e" & stty;;

esac


#This tells you if a file is new within the last min and stores it into newfiletset variable
newfiletest=( $(cd && cd ~/Java_Files && find . -maxdepth 1 -type f -mmin -1 ) )
newfiletest=${newfiletest:2}

file=${file//.java/}

if [[ $newfiletest == "$fileclass" ]] then echo "file successfully compiled" && cd && cd ~/Java_Files && java $file 
else echo "failed to compile"~
fi






 



