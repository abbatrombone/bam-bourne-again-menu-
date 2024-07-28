
# BAM (Bourne Again Menu)

## Why Use #!/usr/bin/env bash ? 
There are multiple different ways to go about this, and each menu that has been set up helps showcase some of the different approaches. Starting with the game.sh file you will notice `#!/usr/bin/env bash` rather than the typical `#!/bin/bash`. This is because it is more flexible and portable way to specify the interpreter that the shell is going to use. Even if the interpreter is installed in atypical location the script should work. This also has the upside of working on different systems with bash without modification as long as the interpreter is installed in the systems PATH. This is also suppose to be a more secure method as it is less vulnerable to traversal attacks. This comes with a few downsides though mainly it is more complex to de-bug and due to the flexibility the behavior might change if the location of the interpreter changes.

## The Power of the echo Command
Each script also uses the echo command which can just repeat or echo what you tell it. The command takes two arguements e and n. Typically if you have `echo "H" echo "I"` it would print each on its ownline `-n` is there to prevent this. The `-e` allows for the command to interpret backslash-escaped characters like `\n for next line` or `\t for tab`. This is also the reason why the text and background are different colors. There are several other uses for `-e` which are 
* \a    Alert (bell) 
* \b    Backspace
* \c    Suppress trailing newline
* \e    Escape
* \f    Form feed
* \r    Carriage return
* \v    Vertical tab
* \\    Backslash
* \0nnn   The eight-bit character whose value is the octal value nnn (zero to three octal digits) if nnn is not a valid octal number, it is printed literally 
* \xHH    The eight-bit character whose value is the hex value HH (one or two hex digits)
* \uHHHH    The Unicode (ISO/IEC 10646) character whose value is the hex value HHHH (one to four hex digits)
* \UHHHHHHHH  The Unicode (ISO/IEC 10646) character whose value is the hex value HHHHHHHH (one to eight hex digits). The echo command is more powerful then it initially looks and is used frequently throughout the script so it is shorted as a variable with `$e` and `$E` for `-e` and `-en`.

## The Trap Command and Signals
The next command to cover is the trap command. This looks for a signal and then when send signal occurs the logic in the quotes happens. `WINCH` is when the terminal size is changed, and `2` is looking for the close command or `^C` as you might see it. Inside the trap command for the menus are not commands but functions that are specified in the script. 

## Conjunction Conjunction What's Your Function?
The function names should be fairly self explanatory but will be covered in case they are not. 

* `Exit` is there to close the program and every subprocess it might have which changes per menu and menu screen. 
* `stty sane` restores the default behavior on the terminal so the script does not have to worry about quirks on each system. 
* `TPUT` cans where the echo statement prints on its x and y position or `$LINES` and `$COLUMNS`. The `1` and `2` are positional parameters which save the custom console input.
* `CLEAR` clears the screen. 
* `CIVIS` hides the cursor from blinking on the screen.
* `DRAW` if typed raw into the command looks like garbage at first, and is not a bug. What DRAW does is load the default console font charters that you need to draw lines. To return the code to normal use `echo -en "\033(B"` which is what the `WRITE` function does. 
* `Write` This is what allows for all of the different colors to occur on screen. To show this the screens look different on linux.sh vs the others. 
* `MARK` selects the current line
* `UNMARK` makes the line normal again. 
* `R` clears the screen to wipe prior commands, and colors based on the echo commands input. 
* `SCREEN` draws the screen using two for loops to using Unicode charters specified with the `\u` in the `printf` command which is like `echo`. 
* `HEAD` calls `DRAW`, `SCREEN`, `WRITE`, `MARK`, and `TPUT` and places the header in the specified location. Its exact set up will be explained later. 
* `FOOT` is similar but with the footer at the bottom of the menu. 
* `ARROW` uses the read command to find if the user has moved the cursor up or down. If you needed left and right the codes are `^[[D` for left and `^[[C` for right. The `read -s` states that the input should not be echoed onto the terminal, and `-n3` is return after reaching 3 charters rather than wait for a new line unless the end of the file is encounter or read times out, ignoring any delimiter. This was used over the `dd` command as escape charters become more complicated to handle. If needed you can try:   
```
# constructed by oTo
ESC=$(echo -en "\033")                                
                                 sttyvar="stty -echo  cbreak"
if [ "`uname`" = "HP-UX" ]; then sttyvar="stty  echo -icanon"; fi
if [ "`uname`" = "SunOS" ]; then sttyvar="stty -echo  icanon"; fi

GetKey(){                                                               # type dd, wait for input and...
    first=`dd bs=1 count=1 2>/dev/null`; case "$first" in $ESC)         # intercept first character
   second=`dd bs=1 count=1 2>/dev/null`; case "$second" in '['|'0'|'O') # intercept second one (different for some consoles)
    third=`dd bs=1 count=1 2>/dev/null`; case "$third" in               # intercept the third character in a string
                        A|OA) first=UP;;                                # decision for up
                        B|OB) first=DN;;                                # decision for down arrow-keys
                          *) first="$first$second$third";; esac;;       # all the other combinations send to eternity ;)
                          *) first="$first$second";;
esac ;; esac; echo "$first";}
ARROW(){ stty -echo cbreak;Key=`GetKey`
           case "$Key" in
               UP) echo "UP";;                                          # on key up print UP
               DN) echo "DN";;                                          # on key down print DN
                *) echo "`echo \"$Key\" | dd  2>/dev/null`";;           # ignore the rest
           esac;}
cursor=$(ARROW)
reset                                                                   # screen reset is required or you will notice
     if [[ "$cursor" = "UP" ]]; then echo UP; fi                        # some confused behavior after script ends.
     if [[ "$cursor" = "DN" ]]; then echo DN; 
```
You will also notice a `/dev/null` any data written here is instantly sent to the end of file (EOF) to the program, and discards all data written to it but reports that the write operation succeeded. The next parts are the M functions which is the text for each menu item. 
* `MENU` is just a function that locates all of the position of each M function. 
* `POS` keeps track of the position and does not describe what this program is (hopefully). 
* `REFRESH` redraw the item before and after to accurately show where the cursor is. 
* `INIT` calls `R`, `HEAD`, `FOOT`, and `MENU` to have the occur in one function. 
* `SC` or scan is a function that utilizes `REFRESH` and `MARK` to find where the cursor is line by line. `S` is the current menu item, and `b` is how the highlighting works. If you have `SC & TPUT 1 1 && echo "$b"` what will happen is on the row you did that to it should show the value in the top left corner of the terminal what you will see is that row is not highlighted. 
* `ES` or escape is the function that returns you to the main menu after hitting enter. This is used to keep the output for users to read. If it was not there the command would run and you would return to the main menu without seeing anything at all. 

## Centering Text
Centering text is annoying in bash and the method used was the best iteration I could make. Each thing that needs to be printed needs to be stored in a variable so its length can be found with `${$var}` and to find half the length `$(())` is used for math in bash. To center is you need to know how long you screen is and how long the word is. Having it print at half the columns means the work starts at the center so the difference is taken between the length of the string and the number of columns, each of which is divided by two to find its center. That is why `$(($up-2)) $(($right-$((${#M0String}/2))))` is written the way it is.

## While
The while statement uses the variable I to keep track of your cursor location if the input is not using the enter key. If it is using the enter key you go into that menu. Anything before the if statement happens when your cursor is over that option. If the if statement is true then it does what the logic tells it to. For example run a basic command or play a sound when selected and a command. To play a sound you will need to use something outside the shell. In the provided example `Jcompile_Menu.sh` `mpv` is used to make sounds. Remember bash or any other shell script goes line by line which means it will wait for the sound to finish if before going on. A user can input buffer by holding down the arrow key, which can cause some issues.

## Autocomplete and Buffering Inputs
If buffering inputs is an issue there is a command that can disable what is called autocomplete. For GNU or gnome users the command is gsettings set org.gnome.desktop.peripherals.keyboard repeat false to turn it off and true for allowing autocomplete to occur. Otherwise `xev` and `showkey` can be used to find the keyboard event. I would recommend disabling this if you have sound occur for moving the cursor as it will wait for each sound to play and then move to the next as shell scripts are line by line. A long queue of sounds can be annoying and make using a GUI less preferable. GUIs should be easy and nice to use for users. 

## Static VS Dynamic Menu
There is a glaring flaw in the set up of the menus thusfar: only static menu options can exist. If you needed a list of files to be an option you would have to hard code it. There is a different menu option which is shown in `jrun.sh` and `xlint.sh`. These put the options in the selections variable from a command. It then sorts the `array` with the `readarray` command, and adds go back afterwards so it is not alphabetized. The choose_from_menu function does the rest of the work with `UNMARK` and `RESET` being variables to change the text. `$@` is an array of all positional parameters (command-line arguments). The rest is just the logic based on what was chosen like before. In the case of the `xlint.sh` file it goes into a sub-menu which runs after an option has been picked.

## Use Cases
This set up can be used to help new users with basic day to day needs or even more advanced needs. Both commercial and everyday usage can benefit from GUI's to easier manage their system. The provided 3 examples are just the beginning of what this could be and showcase something on their own. `Linux.sh` shows that you can have each command just be functions and contained on one script. `Game.sh` shows differences in color formatting, and `Jcompile_Menu.sh` shows how to reach out to other files and run commands, animations and use sub menus.

A potential use for this on a multi-user system would be: when logged on to have a menu pop-up for them in a controlled environment. Based on certain users  user IDs this could populate on the terminal. For a hypothetical example, lets say for one user (Steve) we want them to have access to a menu when they log on. First, we need to change the permissions of the script to have after we will need to then and rights. Then we need to edit the users `bashrc` file, in this case `~steve/.bashrc`. Then at the end will need our script and for the purposes of this example we will call `MENU.sh`. The following line would need to be added at the end of the file: `exec MENU.sh`. Once saved anytime the user logs on that script should run. Be sure that you have the `^C` command trapped so they do not gain access to the command line and any `quit/exit` command built into the script exits full as well or they will have access to the terminal. 

## Animations
Animations can also be used and several examples are in the `Bash_Animation` folder. There is even a random animation option which will change each time you run the animation. These are set to run for a set amount of time to show what they look like. For an example look at `jjar.sh` where it uses a loading animation. The only way to do this is to hard code the length of the animation. Run the logic multiple times with `time(Logic)` to see how long it takes for the command to run, and use that as the timer. For example `time(echo "hi")`. If it is multiple stages you could potentially update the progress based on if a command completed or not. I do not have a working example of this. 

Sounds can be used if the `mpv` library is used. The use-case is niche at best for this, and is only there to show how it could be used. The main goal of this is to rely on little as needed for a positive user experience in this case bash. Best of luck on your endeavors creating menus. If anything is wrong in this guide or confusing please let me know so it can be updated!

## Check boxes
* Radio buttons tend to be round so to make it clear to the user this is a check box i used a square which usually how check boxes are displayed.
* To maintain the current location of the cursor without resetting it to the beginning the following logic is used: 
```
if [ -z "${cur}" ]; then cur=0
fi
```
This simply means if cur is empty, does not have a value, make it 0. If this was not there the cursor would return to the top every time a user hit enter.

* Currently the template does not do anything but is there to show you how the code would look should you need it.

# Credits
* `oTo` for the static menu design: https://web.archive.org/web/20180130222805/http://pro-toolz.net/data/programming/bash/Bash_fancy_menu.html
* `Guss` forstatic menu desgin: https://askubuntu.com/users/6537/guss
* `Feherke` for Minesweeper: https://github.com/feherke/Bash-script/blob/master/minesweeper/minesweeper.sh
* `pjhades` for Snake: https://github.com/pjhades/bash-snake
* `netikras` for Pong: https://github.com/netikras/bash_ping-pong
* `Abbatrombone` for: Compiling and Code Editing
* And Other Contrubiters, feel free to add your name here after contrbiting to the project :D 

I am new to git hub so if anything is not current please let me know so it can be corrected.
