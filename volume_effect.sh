!/bin/bash

SLEEP=0;
INPUT=0;

if [[ ! -z $1 ]]; then
	SLEEP=$1;
else
	echo "no sleep time set"
	exit 1;
fi

if [[ ! -z $2 ]]; then
	INPUT=$2;
else
	echo "no input fifo set"
	exit 1;
fi

if [[ ! -p "./mpv_fifo/input"$INPUT ]]; then
	echo "fifo doesn't exist";
	exit 1;
fi

sleep 0.3;
echo "bang"
echo '{ "command" : [ "set_property", "volume", 0.'$SPEED'] }' > ./mpv_fifo/input$INPUT;
echo "done";
exit 0;
