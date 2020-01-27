#!/bin/bash

instances=5
rm -rf ./bangs/*
for i in $(seq 1 $instances); do mkfifo ./bangs/bang$i; done

DONE=0

killall socat

if [ $? -eq 0 ]
then
  echo "DONE"
	DONE=$(($DONE+1))
else
  echo -n ""
fi

killall mpv

if [ $? -eq 0 ]
then
  echo "DONE"
	DONE=$(($DONE+1))
else
  echo -n ""
fi

if [ $DONE -eq 2 ]
then
  echo "DONE"
  exit 0
else
  # echo "FAIL" >&2
  exit 1
fi
