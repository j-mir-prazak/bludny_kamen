
while true;
        do
        sleep 0.001;
        I=999;
	echo $I
        while [[ $I > 969 ]]; do
        sleep 0.1;
	I=$(($I-1));
        echo $I;
	echo '{ "command" : [ "set_property", "speed", 0.'$I'] }' > ./mpv_fifo/input1
	done
        while [[ $I < 973 ]]; do
        sleep 0.1
        I=$(($I+1));
        echo $I;
	echo '{ "command" : [ "set_property", "speed", 0.'$I'] }' > ./mpv_fifo/input1
        done

done
	#echo '{ "command" : [ "set_property", "speed", 0.4983799] }' > ./mpv_fifo/input1












