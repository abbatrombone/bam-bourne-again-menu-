#!/usr/bin/env bash

trap "echo "It maybe worth checking documentation on the help, --help, or info pages for your command. As there maybe differences." " EXIT
trap "echo "It maybe worth checking documentation on the help, --help, or info pages for your command. As there maybe differences." " QUIT

if dpkg -l | grep -qw fzf; then
  compgen -c | fzf | xargs man
else
  echo "You will need to install fzf with this command.";
  sleep 1;
  echo "This the command to install will depend on your distro but will be something like:";
  echo "sudo apt install fzf";
  sleep 1;
  echo "Attempt install?"
  read -r ans
  
  	if [[ $ans =~ ^[yY] ]]; then sudo apt install fzf;
  	else echo "Sorry"
  	fi
  fi

#help
#info
#man
