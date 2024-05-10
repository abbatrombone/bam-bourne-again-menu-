#!/bin/bash

#https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-indicator-spinner
progressBarWidth=20

# Function to draw progress bar
progressBar () {

  # Calculate number of fill/empty slots in the bar
  progress=$(echo "$progressBarWidth/$taskCount*$tasksDone" | bc -l)  
  fill=$(printf "%.0f\n" $progress)
  if [ $fill -gt $progressBarWidth ]; then
    fill=$progressBarWidth
  fi
  empty=$(($fill-$progressBarWidth))

  # Percentage Calculation
  percent=$(echo "100/$taskCount*$tasksDone" | bc -l)
  percent=$(printf "%0.2f\n" $percent)
  if [ $(echo "$percent>100" | bc) -gt 0 ]; then
    percent="100.00"
  fi

  # Output to screen
  ## https://unix.stackexchange.com/questions/664055/how-to-print-utf-8-symbols this is why %s and %b are used
  ## ORGINAL
  ##printf "\r["
  ##printf "%${fill}s" '' | tr ' ' ▉
  ##printf "%${empty}s" '' | tr ' ' ░
  ##printf "] $percent%% - $text "
  
  #This is for GNU users as UNICODE charaters do not work on their terminal
  printf "\r["
  printf "%${fill}s" '' | sed 's/ /\o342\o226\o210/g'
  printf "%${empty}s" '' | sed 's/ /\o342\o226\o221/g'
  printf "] $percent%% - $text "
}



## Collect task count
taskCount=33
tasksDone=0

while [ $tasksDone -le $taskCount ]; do

  # Do your task
  (( tasksDone += 1 ))

  # Can add some friendly output
  # text=$(echo "somefile-$tasksDone.dat")

  # Draw the progress bar
  progressBar $taskCount $taskDone $text

  sleep 0.01
done

echo

##############################
#         CREDITS            #
##############################

# F1LT3R (https://gist.github.com/F1LT3R/fa7f102b08a514f2c535)
# oofnikj (fix on GNU unicode issue)
