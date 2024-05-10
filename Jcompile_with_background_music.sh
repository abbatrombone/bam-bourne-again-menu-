#! /bin/bash

mpv -v ~/Bash_Files/Bash_Sounds/StartUpMenu.mp4 -vo caca;
mpv --loop=inf ~/Bash_Files/Bash_Sounds/MenuLoop.wav --no-terminal & bash ~/Bash_Files/Jcompile_Menu.sh
