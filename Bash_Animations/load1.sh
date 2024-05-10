#!/bin/bash

#Replace sleep 20 with something for example cd Java_Files && javac Clock.java 
sleep 20 & PID=$! #simulate a long process

echo "THIS MAY TAKE A WHILE, PLEASE BE PATIENT WHILE ______ IS RUNNING..."
printf "["
# While process is running...
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 1
done
printf "] done!"

##############################
#         CREDITS            #
##############################

# cosbor11 https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-indicator-spinner
