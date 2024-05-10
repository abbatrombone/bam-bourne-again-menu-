#!/bin/bash
 
clear
  
count(){
echo -n "Loading"
  spin &
  pid=$!

  for i in `seq 1 10`
  do
    sleep 1;
  done
 
  kill $pid  
  echo ""
}
 
spin(){
  while [ 1 ]
  do 
    echo -en "."
    sleep 0.2
  done
}
 
count
