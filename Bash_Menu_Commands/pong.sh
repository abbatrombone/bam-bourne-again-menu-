#!/usr/bin/env bash

echo "Player 1 use q and a. Player 2 use p and l. Best of 1, may the best ponger WIN!!!!"
sleep 1;
clear;

TIMEOUT=.1
ARG=$1
[ ${ARG} ] && [ ${ARG} -gt 0 ] && [ ${ARG} -le 20 ] && TIMEOUT=$(echo "2/${ARG}"|bc -l)

F_LOC_L=0
F_LOC_R=0
B_LOC_X=45
B_LOC_Y=20
B_SPEED=1 ## Better not to change this one.. ball will not bounce
DIRECTION_X=-1
DIRECTION_Y=1


FLAP_SZ_X=2
FLAP_SZ_Y=5

YX=$(/bin/stty -a |grep row |awk '{print $5$7}'|awk -F';' '{print $1" "$2}')
W_SZ_X=${YX##* }
W_SZ_Y=${YX%% *}

B_SZ_X=6
B_SZ_Y=4

## Area safe for a left-top ball corner to move
W_SAFE_X=$[${W_SZ_X}-${B_SZ_X}]
W_SAFE_Y=$[${W_SZ_Y}-${B_SZ_Y}]


GAMEOVER=0

printBallAtXY(){
	[ -z $2 ] && return
	local X=$1
	local Y=$2
	echo -ne "\033[$[${Y}+0];${X}f #### \033[$[${Y}+1];${X}f######\033[$[${Y}+2];${X}f######\033[$[${Y}+3];${X}f #### "
#	{ [ ${X} -gt ${W_SAFE_X} ] || [ ${X} -lt ${FLAP_SZ_X} ] ; } && { echo GAMEOVER; GAMEOVER=1; }

}

printFlapLY(){
	[ -z $1 ] && return
	local Y=$1
	echo -ne "\033[$[${Y}+0];0f▓▓\033[$[${Y}+1];0f▓▓\033[$[${Y}+2];0f▓▓\033[$[${Y}+3];0f▓▓\033[$[${Y}+4];0f▓▓"
}

printFlapRY(){
        [ -z $1 ] && return
        local Y=$1
	local X=$[${W_SZ_X}-1]
        echo -ne "\033[$[${Y}+0];${X}f▓▓\033[$[${Y}+1];${X}f▓▓\033[$[${Y}+2];${X}f▓▓\033[$[${Y}+3];${X}f▓▓\033[$[${Y}+4];${X}f▓▓"
}



echo -e "\033c"
while [ ${GAMEOVER} -eq 0 ] ; do
	
	read -n 1 -t ${TIMEOUT} direction
	case "${direction}" in
		q) F_LOC_L=$[${F_LOC_L}-1];;
		a) F_LOC_L=$[${F_LOC_L}+1];;
		p) F_LOC_R=$[${F_LOC_R}-1];;
		l) F_LOC_R=$[${F_LOC_R}+1];;
	esac

	{ [ ${F_LOC_L} -lt 0 ] && F_LOC_L=0 ; } || { [ ${F_LOC_L} -gt ${W_SZ_Y} ] && F_LOC_L=${W_SZ_Y} ; }
	{ [ ${F_LOC_R} -lt 0 ] && F_LOC_R=0 ; } || { [ ${F_LOC_R} -gt ${W_SZ_Y} ] && F_LOC_R=${W_SZ_Y} ; }

	
	{ [ ${B_LOC_Y} -eq 0 ] || [ ${B_LOC_Y} -eq ${W_SAFE_Y} ] ; } && { DIRECTION_Y=$[${DIRECTION_Y}*(-1)] ; }

	if [ ${B_LOC_X} -eq ${W_SAFE_X} ] || [ ${B_LOC_X} -eq ${FLAP_SZ_X} ] ; then 
		if ## Ball has hit either left or right side of safe window

			[ ${B_LOC_X} -eq ${FLAP_SZ_X} ] && 		## // is it at left side?
			[ ${B_LOC_Y} -ge ${F_LOC_L}   ] && 		## // is it below top of the left flapper?
			[ ${B_LOC_Y} -le $[${F_LOC_L}+${FLAP_SZ_Y}] ] ; ## // is it above bottom of the left flapper?

		then ## If above is TRUE, then change horizontal direction
			echo "bump"
			DIRECTION_X=$[${DIRECTION_X}*(-1)] ;
			TEMPVAL=AAAA
		elif ## If ball has NOT hit left

			[ ${B_LOC_X} -eq ${W_SAFE_X}  ] && 		## // Is it at the right side of the scree?
			[ ${B_LOC_Y} -ge ${F_LOC_R}   ] && 		## // is it below top of the right flapper?
			[ ${B_LOC_Y} -le $[${F_LOC_R}+${FLAP_SZ_Y}] ] ; ## // is it above bottom of the right flapper?

		then 
			echo "bump"
			DIRECTION_X=$[${DIRECTION_X}*(-1)] ; 
		else
			GAMEOVER=1
		fi ; 
	fi;

	echo -e "\033c"
	B_LOC_X=$[ ${B_LOC_X} + $[ ${B_SPEED} * ${DIRECTION_X} ] ]
	B_LOC_Y=$[ ${B_LOC_Y} + $[ ${B_SPEED} * ${DIRECTION_Y} ] ]

	printBallAtXY ${B_LOC_X} ${B_LOC_Y}
	printFlapLY ${F_LOC_L}
	printFlapRY ${F_LOC_R}

<< DEBUG
echo "TIMEOUT=$TIMEOUT"
echo "DIRECTION_X=$DIRECTION_X"
echo "DIRECTION_Y=$DIRECTION_Y"
echo "B_LOC_X=B_LOC_X+(B_SPEED*DIRECTION_X)   ==  ${B_LOC_X}+(${B_SPEED}*${DIRECTION_X})"
echo "B_LOC_X=$B_LOC_X"
echo "B_LOC_Y=$B_LOC_Y"
echo "W_SAFE_X=$W_SAFE_X"
echo "F_LOC_R=$F_LOC_R"
echo "F_LOC_R+FLAP_SZ_Y=$[${F_LOC_R}+${FLAP_SZ_Y}]"

echo "FLAP_SZ_X=$FLAP_SZ_X"
echo "F_LOC_L=$F_LOC_R"
echo "F_LOC_L+FLAP_SZ_Y=$[${F_LOC_L}+${FLAP_SZ_Y}]"
DEBUG


done

echo GAME OVER
