#!/bin/bash
 
clear
spinner=(◰ ◳ ◲ ◱);
  
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
      tput cup 12 19; echo -ne "\r$i";
      sleep 0.2;
    done;
  done
}
 
count
