#!/usr/bin/env bash

## https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
## https://web.archive.org/web/20180130222805/http://pro-toolz.net/data/programming/bash/Bash_fancy_menu.html
## The power of echo command: Bash console drawing methods and some useful tput-like functions
## https://top-scripts.blogspot.com/2011/01/power-of-echo-command-bash-console.html

##for sub menu
## http://invisible-island.net/dialog/dialog.html


### echo -e means: Enable interpretation of the following backslash-escaped characters in each String:
####      \a    Alert (bell)
####      \b    Backspace
####      \c    Suppress trailing newline
####      \e    Escape
####      \E    Escape
####      \f    Form feed
####      \n    New line
####      \r    Carriage return
####      \t    Horizontal tab
####      \v    Vertical tab
####      \\    Backslash
####      \0nnn   The eight-bit character whose value is the octal value nnn (zero to three octal digits)
####              if nnn is not a valid octal number, it is printed literally.
####      \xHH    The eight-bit character whose value is the hex value HH (one or two hex digits)
####      \uHHHH    The Unicode (ISO/IEC 10646) character whose value is the hex value HHHH (one to four hex digits)
####      \UHHHHHHHH  The Unicode (ISO/IEC 10646) character whose value is the hex value HHHHHHHH (one to eight hex digits)

# At the end of script, you will find numbered lines, where can you put your commands or even functions.
# If you will use custom functions, they need to be defined at the start of this script. Or you can also call them from another file this way (also at the beginning of menu script):
# . /path/to/functions-file
## 'Dot' should be separated from 'slash'. This way you will call all custom settings into current environment.

#Note basic gnome-terminal is 24 units tall

#stty -echo stops the user inputs from printing
#stty echo renables seeing what you  input

 E='echo -e';  # shortened echo command variable
 e='echo -en'; # shortened echo command variable
 Header="BASH GAME MENU"
 Footer="ENTER - SELECT,NEXT"
 M0String="Minesweeper"
 M1String="Pong"
 M2String="Snake"
 M3String="Exit"

 trap "R;SCREEN;INIT;SC;" WINCH
 trap "R;exit" 2

 bottom=13

    ESC=$( $e "\e") # variable containing escaped value
 EXIT(){ stty sane echo && gsettings set org.gnome.desktop.peripherals.keyboard repeat true && exit 0; }; #Custom
   TPUT(){ $e "\e[${1};${2}H";} # terminal put (x and y position)
  CLEAR(){ $e "\ec";} # clear screen
  CIVIS(){ $e "\e[?25l";} # hide cursor
   DRAW(){ $e "\e%@\e(0";} # switch to 'garbage' mode to be able to draw
  WRITE(){ $e "\e(B";} # return to normal (reset)
   MARK(){ $e "\e[7m";} # select current line text
 UNMARK(){ $e "\e[27m";} # normalize current line text
      R(){ CLEAR ;stty sane;$e "\ec\e[37;42m\e[J";};         # Makes screen green 
 SCREEN () {
   clear

   top=2
   right=$(("$COLUMNS"/2))
   up=$(($LINES/2))

for (( x = 1; x <= $LINES; x++ )); do
      for (( y = 1; y <= "$COLUMNS"; y++ )); do
          if (( 1 == x && y == "$COLUMNS" )); then printf "\u2510" 
          elif (( 1 == x && y == 1 )); then printf "\u250C" fi
          elif (( 3 == x && y == 1 )); then printf "\u251C" fi
          elif (( 3 == x && y == "$COLUMNS" || $(("$LINES"-2)) == x && y == "$COLUMNS")); then printf "\u2524" fi
          elif (( $(("$LINES"-2)) == x && y == 1 )); then printf "\u251C" fi
          elif (( "$LINES" == x && y == "$COLUMNS" )); then printf "\u2518" fi
          elif (( "$LINES" == x && y == 1 )); then printf "\u2514" 
        elif (( 1 == y || "$COLUMNS" == y )); then
            printf  "\u2502"
        elif ((x == 1 || 3 == x || x == "$LINES" || x == $(("$LINES"-2)) )); then
            printf '\u2500'
        else
            echo -n " "
         fi
      done
   done 
}
   HEAD(){ DRAW;SCREEN                                              # This makes the Bash selection menu title at the top
           WRITE;MARK;TPUT $top $(($right-$((${#Header}/2))))                           # How far down, how far to the right the text below it displays.
           $E "$Header";UNMARK;}
           i=0; CLEAR; CIVIS;NULL=/dev/null;
   FOOT(){ MARK;TPUT $((LINES-1)) $(($right-$((${#Footer}/2))))                                    # How far the footer is down, and right
           printf "$Footer";UNMARK;} # This makes the Eneter - Select,Next at the bottom
  ARROW(){ read -s -n3 key 2>/dev/null >&2 && stty -echo                             # This takes in account user arrow key movement
           if [[ $key = $ESC[A ]];then echo up;fi                       # moves cursor up
           if [[ $key = $ESC[B ]];then echo dn;fi }                     # moves cursor down
     M0(){ TPUT  $(($up-2)) $(($right-$((${#M0String}/2)))); $e "$M0String";}                                       # Each of these M#() are the options seen on screen
     M1(){ TPUT  $(($up-1)) $(($right-$((${#M1String}/2)))); $e "$M1String";} # y,x
     M2(){ TPUT  $up $(($right-$((${#M2String}/2)))); $e "$M2String";}
     M3(){ TPUT  $(($up+1)) $(($right-$((${#M3String}/2)))); $e "$M3String";}
     LM=3  #'LM' variable, which is just a number of all menus.
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}             # This function locates and manages menu selection positions.
    POS(){ if [[ $cur == up ]];then ((i--));fi                     # Without this one you will get an error when cursor keys will be pressed too many times.
           if [[ $cur == dn ]];then ((i++));fi                     # Instead of that, this function gives you a nice rotating effect.
           if [[ $i -lt 0   ]];then i=$LM;fi                       # When you come to the end of menus you can press down arrow-key one more time and you will be returned to the start.
           if [[ $i -gt $LM ]];then i=0;fi;}                       # The same applies if you go from another direction.
   REFRESH(){ after=$((i+1)); before=$((i-1))                      # To prevent too much refreshing, I constructed a simple hack that will refresh only menus at the neighbors positions.
           if [[ $before -lt 0  ]];then before=$LM;fi                             # Without that full screen might need to be refreshed for each your action.
           if [[ $after -gt $LM ]];then after=0;fi                                # What it actually does is the following: for every pressed up or down arrow-key, it 'repaints' menu options this way:
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi    # sets normal layout for options in front and after selected option, paints selected option with the inverted color scheme.
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
        UNMARK;M$before;M$after;fi;j=$i;UNMARK;M$before;M$after;};
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
     ES(){ MARK;INIT;};INIT #$e "ENTER = main menu ";$b;read; was removed after mark and before INIT
  while [[ "$O" != " " ]]; do case $i in
        0) S=M0;SC;if [[ $cur == "" ]];then R;bash ~/Bash_Files/Bash_Menu_Commands/./mine.sh;ES;fi;;
        1) S=M1;SC;if [[ $cur == "" ]];then R;bash ~/Bash_Files/Bash_Menu_Commands/./pong.sh;ES;fi;;
        2) S=M2;SC;if [[ $cur == "" ]];then R;bash ~/Bash_Files/Bash_Menu_Commands/./snake.sh;ES;fi;;
        3) S=M3;SC;if [[ $cur == "" ]];then R;CLEAR;EXIT;exit;fi;;
  esac;POS;done
