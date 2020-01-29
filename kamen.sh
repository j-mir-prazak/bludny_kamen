#!/bin/bash

Process="node"
counter=0

function terminate {

	kill -SIGINT $PROC1
	echo -e "KILLING SUB $PROC1"
	kill -SIGTERM $PROC1
	echo -e "\e[33m\n\n"
	echo -e "-----------------------------"
	echo -e "       VALVE TERMINATED.     "
	echo -e "-----------------------------"
	echo -e "\n\n"
	trap SIGTERM
	trap SIGINT
	echo -e "KILLING MAIN"
	kill -SIGTERM $$
	}

echo "setting volumes."
cards=$(cat /proc/asound/cards | grep USBSC* | sed -r 's/ ([[:digit:]]).*/\1/');
for i in $cards; do
	echo "setting volume for card $i."
	amixer -c$i set 'Speaker' 85%;
done


trap terminate SIGINT
# trap 'echo int; kill -SIGINT $PROC1' SIGINT
trap terminate SIGTERM

function looping {
	while true; do

		trap 'kill -SIGINT $PROC2; kill -SIGTERM $PROC2; break' SIGINT
		trap 'kill -SIGINT $PROC2; kill -SIGTERM $PROC2; break' SIGTERM

	  echo -e "\e[34m"
	  echo "-----------------------------"
	  echo "       Starting nodejs.      "
	  echo "-----------------------------"
	  echo ""
	  echo ""


		PROC2=""

		node index.js &

		PROC2=$!
		wait
		echo ""
	  counter=$(expr $counter + 1)
	  echo "Error. Retrying. Rerun #$counter."
	  echo  ""
	  sleep 5
	done
}

looping &
PROC1=$!
wait
