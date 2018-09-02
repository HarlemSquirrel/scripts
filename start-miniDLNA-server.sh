#!/bin/bash

#sudo systemctl start minidlna
#sleep 1
#sudo systemctl status minidlna -l
#sleep 3
#exit

printf "Starting ReadyMedia (MiniDLNA) as current user..."

minidlnad -f ~/.config/minidlna/minidlna.conf -P ~/.config/minidlna/minidlna.pid && printf "ready!\n" || printf "something when wrong :(\n"
