#!/bin/bash
FILE='/home/allen/tmp/sinka.txt'
RED='#[fg=brightwhite]#[bg=red]'
NC='#[fg=default]#[bg=default]' # No Color
CPU_THRESHOLD=65
FAN_THRESHOLD=1900
CPU=`cat $FILE | sed 's/ /\n/g' | grep t_cpu | cut -d':' -f2`
FAN=`cat $FILE | sed 's/ /\n/g' | grep fan | cut -d':' -f2`
if [ "$CPU" -gt "$CPU_THRESHOLD" ]; then
    echo -e -n "${RED}"
fi
echo -e -n "$CPU${NC} "
if [ "$FAN" -gt "$FAN_THRESHOLD" ]; then
    echo -e -n "${RED}"
fi
echo -e -n "$FAN${NC}"
