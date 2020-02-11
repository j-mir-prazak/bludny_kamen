!/bin/bash

VOLUME=0;
INPUT=0;

if [[ ! -z $1 ]]; then
	VOLUME=$1;
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

sleep 0.01;
echo "bang"
echo '{ "command" : [ "set_property", "volume", 0.'$VOLUME'] }' > ./mpv_fifo/input$INPUT;
echo "done";
exit 0;
