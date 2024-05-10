#!/bin/bash
 
clear

 BWhite='\033[1;37m'       # Bold White
 BGreen='\033[1;32m'       # Bold Green
 BRed='\033[1;31m'         # Bold Red
 BYellow='\033[1;33m'      # Bold Yellow
 BPurple='\033[1;35m'      # Bold Purple
 Color_Off='\033[0m'       # Text Reset
 
case $(($RANDOM % 17)) in
0) spinner=( Ooooo oOooo ooOoo oooOo ooooO oooOo ooOoo oOooo);;
1) spinner=( Ooooo oOooo ooOoo oooOo ooooO);;
2) spinner=( '|' '/' '-' '\');;
3) spinner=( '.' ' ');;
4) spinner=( . o 0 ° 0 o );;
5) spinner=( ${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}°${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}°${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}°${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}°${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}°${Color_Off} );;
6) spinner=( ${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}°${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}°${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}°${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}°${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}°${Color_Off} );;
7) spinner=(⠁ ⠂ ⠄ ⡀ ⢀ ⠠ ⠐ ⠈);;
8) spinner=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▇ ▆ ▅ ▄ ▃ ▂ ▁);;
9) spinner=(▉ ▊ ▋ ▌ ▍ ▎ ▏ ▎ ▍ ▌ ▋ ▊ ▉);;
10) spinner=(← ↖ ↑ ↗ → ↘ ↓ ↙);;
11) spinner=(▖ ▘ ▝ ▗);;
12) spinner=(┤ ┘ ┴ └ ├ ┌ ┬ ┐);;
13) spinner=(◢ ◣ ◤ ◥);;
14) spinner=(◰ ◳ ◲ ◱);;
15) spinner=(◐ ◓ ◑ ◒);;
16) spinner=(⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷);;
17) spinner=( '.  ' '.. ' '...' ' ..' '  .' '   ' );;
18) spinner=( '[    ]' '[=   ]' '[==  ]' '[=== ]' '[ ===]' '[  ==]' '[   =]' );;
19) spinner=( ☰ ☱ ☳ ☶ ☴ );;
20) spinner=( ▹▹▹▹▹ ▸▹▹▹▹ ▹▸▹▹▹ ▹▹▸▹▹ ▹▹▹▸▹ ▹▹▹▹▸ ▹▹▹▹▹ ▹▹▹▹▹ ▹▹▹▹▹ ▹▹▹▹▹ ▹▹▹▹▹ ▹▹▹▹▹ ▹▹▹▹▹ );;
21) spinner=( ∙∙∙ ●∙∙ ∙●∙ ∙∙● );;
22) spinner=( ▰▱▱▱▱▱▱ ▰▰▱▱▱▱▱ ▰▰▰▱▱▱▱ ▱▰▰▰▱▱▱ ▱▱▰▰▰▱▱ ▱▱▱▰▰▰▱ ▱▱▱▱▰▰▰ ▱▱▱▱▱▰▰ ▱▱▱▱▱▱▰ ▱▱▱▱▱▱▱ ▱▱▱▱▱▱▱ ▱▱▱▱▱▱▱ ▱▱▱▱▱▱▱);;
23) spinner=( '💣   ' ' 💣  ' '  💣 ' '   💣' '   💣' '   💣' '   💣' '   💣' '   💥' '    ' '    ');;

esac
  
count(){
  spin &
  pid=$!
 
  for i in `seq 1 10`
  do
    sleep 1;
  done
 
  kill $pid  
}
 
spin(){
  while [ 1 ]
  do 
    for i in "${spinner[@]}"; 
    do 
      echo -ne "\r[$i]";
      sleep 0.2;
    done;
  done
}
 
count

##############################
#         CREDITS            #
##############################

# Kris Occhipinti (0-2) https://www.youtube.com/watch?v=93i8txD0H3Q&t=654s
# Abbatromone (3-6)
# Jonas Eberle (7-16)  https://unix.stackexchange.com/questions/225179/display-spinner-while-waiting-for-some-process-to-finish
# Silejonu (17-22) https://github.com/Silejonu/bash_loading_animations/tree/main

