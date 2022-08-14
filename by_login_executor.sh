#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo The root privileges are needed in order to run this script.
  exit 1
fi

user=$(logname)

printf "Hello $user, please insert as many commands as you want and then insert ctrl+c to quit.\nWith rebooting your system, the commands will run automatically forever.\n"

prev_commands_file=/etc/profile.d/"$user"_command_executor.sh
if [ -e "$prev_commands_file" ]; then
  echo "There are some other commands from the previous time you used the script. These are:"
  while read line; do
    echo $line
  done <$prev_commands_file
  echo "Do you want to overwrite them or add some new commands to them?[y/N]"
  read cmd
  if [[ $cmd == "y" ]]; then
    sudo rm -rf /etc/profile.d/"$user"_command_executor.sh
  fi
fi

i=0
while :; do
  ((i++))
  echo Your command number "$i":
  read cmd
  sudo echo "$cmd &" >>/etc/profile.d/"$user"_command_executor.sh
done
