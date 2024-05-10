#!/bin/bash
 
progress_bar()
{
  local DURATION=$1
  local INT=0.25      # refresh interval
 
  local TIME=0
  local CURLEN=0
  local SECS=0
  local FRACTION=0
 
  local FB=2588       # full block
 
  trap "echo -e $(tput cnorm); trap - SIGINT; return" SIGINT
 
  echo -ne "$(tput civis)\r$(tput el)│"                # clean line
 
  local START=$( date +%s%N )
 
  while [ $SECS -lt $DURATION ]; do
    local COLS=$( tput cols )
 
    # main bar
    local L=$( bc -l <<< "( ( $COLS - 5 ) * $TIME  ) / ($DURATION-$INT)" | awk '{ printf "%f", $0 }' )
    local N=$( bc -l <<< $L                                              | awk '{ printf "%d", $0 }' )
 
    [ $FRACTION -ne 0 ] && echo -ne "$( tput cub 1 )"  # erase partial block
 
    if [ $N -gt $CURLEN ]; then
      for i in $( seq 1 $(( N - CURLEN )) ); do
        echo -ne \\u$FB
      done
      CURLEN=$N
    fi
 
    # partial block adjustment
    FRACTION=$( bc -l <<< "( $L - $N ) * 8" | awk '{ printf "%.0f", $0 }' )
 
    if [ $FRACTION -ne 0 ]; then 
      local PB=$( printf %x $(( 0x258F - FRACTION + 1 )) )
      echo -ne \\u$PB
    fi
 
    # percentage progress
    local PROGRESS=$( bc -l <<< "( 100 * $TIME ) / ($DURATION-$INT)" | awk '{ printf "%.0f", $0 }' )
    echo -ne "$( tput sc )"                            # save pos
    echo -ne "\r$( tput cuf $(( COLS - 6 )) )"         # move cur
    echo -ne "│ $PROGRESS%"
    echo -ne "$( tput rc )"                            # restore pos
 
    TIME=$( bc -l <<< "$TIME + $INT" | awk '{ printf "%f", $0 }' )
    SECS=$( bc -l <<<  $TIME         | awk '{ printf "%d", $0 }' )
 
    # take into account loop execution time
    local END=$( date +%s%N )
    local DELTA=$( bc -l <<< "$INT - ( $END - $START )/1000000000" \
                   | awk '{ if ( $0 > 0 ) printf "%f", $0; else print "0" }' )
    sleep $DELTA
    START=$( date +%s%N )
  done
 
  echo $(tput cnorm)
  trap - SIGINT
}


##############################
#         CREDITS            #
##############################

# nachoparker https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-indicator-spinner
# https://web.archive.org/web/20190203164249/https://ownyourbits.com/2017/07/16/a-progress-bar-for-the-shell/
