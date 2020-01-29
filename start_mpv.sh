#!/bin/bash

function terminate {

 kill -SIGTERM $PROC1 2>/dev/null
 kill -SIGINT $PROC1 2>/dev/null

 echo -e "MPV TERMINATED."

 trap SIGINT
 trap SIGTERM
 kill $$ 2>/dev/null
 }

trap terminate SIGINT
trap terminate SIGTERM



sleep 1;




index=1;
if [[ ! -z $1 ]]; then
	index=$1
fi

rm -rf "./mpv_fifo/input"$index;
mkfifo "./mpv_fifo/input"$index;
file="the_sea.flac"
if [[ ! -z $2 ]]; then
  file=$2
fi

af=""
pause="--pause=yes"
ad="--audio-device=alsa"

#index=5

# case $index in
# 1)
#   af=--af="lavfi=[pan=stereo|FL=FL|FR=FR]"

# 	;;
# 2)
#   af=--af="lavfi=[pan=stereo|FL=FC|FR=LFE]"
#   ;;
# 3)
#   af=--af="lavfi=[pan=stereo|FL=BL|FR=BR]"
#   ;;
# 4)
#   af=--af="lavfi=[pan=stereo|FL=SL|FR=SR]"
#   ;;
# 5)
#   af=""
#   ;;
# *)
#   af=--af="lavfi=[pan=stereo|FL<FL+FC+BL+SL|FR<FR+LFE+BR+SR]"
#   ;;
# esac

#index=1


# case $index in
# 1)
#   ad=--audio-device="alsa/MixerUSBSC1"
# 	;;
# 2)
#   ad=--audio-device="alsa/MixerUSBSC2"
#   ;;
# 3)
#   ad=--audio-device="alsa/MixerUSBSC3"
#   ;;
# 4)
#   ad=--audio-device="alsa/MixerUSBSC4"
#   ;;
# 5)
#   ad=--audio-device="alsa/usbcluster"
#   pause="--pause=no"
#   ;;
# *)
#   ad=""
#   ;;
# esac

# echo $af

#sleep by index
# sleep $(($1))

mpv $pause --alsa-ignore-chmap --alsa-non-interleaved --cache-secs=5 --demuxer-readahead-secs=5 --audio-buffer=0.5 --input-file=./mpv_fifo/input$index --audio-device="alsa/dmix:CARD=Device,DEV=0" $af -msg-level=ao/alsa=debug "$file" --no-video --no-audio-display --audio-pitch-correction=no &

PROC1=$!

wait


if [ $? -eq 0 ]
then
  echo "DONE"
  exit 0
else
  echo "FAIL" >&2
  exit 1
fi
