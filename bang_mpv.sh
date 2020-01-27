#!/bin/bash



# sleep 2
# if [[ $1 == "play" ]]; then
# 	echo '{ "command" : [ "set_property", "pause", false ] }' | socat - ./bangs/bang1 &
# 	echo '{ "command" : [ "set_property", "pause", false ] }' | socat - ./bangs/bang2 &
# 	echo '{ "command" : [ "set_property", "pause", false ] }' | socat - ./bangs/bang3 &
# 	echo '{ "command" : [ "set_property", "pause", false ] }' | socat - ./bangs/bang4 &
# elif [[ $1 == "pause" ]]; then
# 	echo '{ "command" : [ "set_property", "pause", true ] }' | socat - ./bangs/bang1 &
# 	echo '{ "command" : [ "set_property", "pause", true ] }' | socat - ./bangs/bang2 &
# 	echo '{ "command" : [ "set_property", "pause", true ] }' | socat - ./bangs/bang3 &
# 	echo '{ "command" : [ "set_property", "pause", true ] }' | socat - ./bangs/bang4 &
# fi

# sleep 1
# if [[ $1 == "play" ]]; then
#
# 	echo '{ "command" : [ "seek", "0", "absolute" ] }' | ncat -U ./bangs/soc-bang1 &
# 	echo '{ "command" : [ "seek", "0", "absolute" ] }' | ncat -U ./bangs/soc-bang2 &
# 	echo '{ "command" : [ "seek", "0", "absolute" ] }' | ncat -U ./bangs/soc-bang3 &
# 	echo '{ "command" : [ "seek", "0", "absolute" ] }' | ncat -U ./bangs/soc-bang4 &
#
# 	sleep 1
#
#
# 	echo '{ "command" : [ "set_property", "pause", false ] }' | ncat -U ./bangs/soc-bang1 &
# 	echo '{ "command" : [ "set_property", "pause", false ] }' | ncat -U ./bangs/soc-bang2 &
# 	echo '{ "command" : [ "set_property", "pause", false ] }' | ncat -U ./bangs/soc-bang3 &
# 	echo '{ "command" : [ "set_property", "pause", false ] }' | ncat -U ./bangs/soc-bang4 &
# elif [[ $1 == "pause" ]]; then
# 	echo '{ "command" : [ "set_property", "pause", true ] }' | ncat -U ./bangs/soc-bang1 &
# 	echo '{ "command" : [ "set_property", "pause", true ] }' | ncat -U ./bangs/soc-bang2 &
# 	echo '{ "command" : [ "set_property", "pause", true ] }' | ncat -U ./bangs/soc-bang3 &
# 	echo '{ "command" : [ "set_property", "pause", true ] }' | ncat -U ./bangs/soc-bang4 &
# fi
#

sleep 1

if [[ $1 == "play" ]]; then

	echo '{ "command" : [ "seek", "0", "absolute" ] }' > ./mpv_fifo/input1 &
	echo '{ "command" : [ "seek", "0", "absolute" ] }' > ./mpv_fifo/input2 &

	echo '{ "command" : [ "set_property", "volume", 0 ] }' > ./mpv_fifo/input2 &


	sleep 1

	echo '{ "command" : [ "set_property", "pause", false ] }' > ./mpv_fifo/input1 &
	echo '{ "command" : [ "set_property", "pause", false ] }' > ./mpv_fifo/input2 &




elif [[ $1 == "pause" ]]; then

	echo '{ "command" : [ "set_property", "pause", true ] }' > ./mpv_fifo/input1 &
	echo '{ "command" : [ "set_property", "pause", true ] }' > ./mpv_fifo/input2 &

fi

exit 0
