!/bin/bash

SLEEP=0;
SPEED=0;
INPUT=0;

if [[ ! -z $1 ]]; then
	SLEEP=$1;
else
	echo "no sleep time set"
	exit 1;
fi

if [[ ! -z $2 ]]; then
	SPEED=$2;
else
	echo "no speed time set"
	exit 1;
fi

if [[ ! -z $3 ]]; then
	INPUT=$3;
else
	echo "no input fifo set"
	exit 1;
fi

if [[ ! -p "./mpv_fifo/input"$INPUT ]]; then
	echo "fifo doesn't exist";
	exit 1;
fi

sleep $SLEEP;
echo "bang"
echo '{ "command" : [ "set_property", "speed", 0.'$SPEED'] }' > ./mpv_fifo/input$INPUT;
echo "done";
exit 0;
