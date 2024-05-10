#!/bin/bash
 
 BWhite='\033[1;37m'       # Bold White
 BGreen='\033[1;32m'       # Bold Green
 BRed='\033[1;31m'         # Bold Red
 BYellow='\033[1;33m'      # Bold Yellow
 BPurple='\033[1;35m'      # Bold Purple
 Color_Off='\033[0m'       # Text Reset
 
clear
spinner=( ${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}°${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}°${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}°${Color_Off}${BYellow}.${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}°${Color_Off}${BPurple}.${Color_Off} 
${BWhite}.${Color_Off}${BGreen}.${Color_Off}${BRed}.${Color_Off}${BYellow}.${Color_Off}${BPurple}°${Color_Off} );
  
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
    for i in ${spinner[@]}; 
    do 
      echo -ne "\r$i"; # you can also have it be echo -ne "${BWhite}\r$i${Color_Off}" for the whole line (or any other color)
      sleep 0.2;
    done;
  done
}
 
count
