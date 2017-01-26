#!/bin/bash
#check param
echo "$0: checking params ...."
PARAM="OK"
# check param count
if [ "$#" -ne 2 ]; then
    PARAM="NO"
fi
# check first param is dir or file
if ! [ -f "$1" ] && ! [ -d "$1" ]; then
    PARAM="NO"
fi
# check second param is dir
if ! [ -d "$2" ]; then
    PARAM="NO"
fi
# output check result
if [ "$PARAM" != "OK" ]; then
    echo "Usage: $0 SRC DST"
    exit 1
fi
#copy operation
echo "$0: copying files ...."
if [ -d "$1" ]; then
    cp -rvi "$1" "$2" || read -e -p "Press ENTER to continue ..."
elif [ -f "$1" ]; then
    cp -vi "$1" "$2" || read -e -p "Press ENTER to continue ..."
fi
#verify on target
echo "$0: compare files ...."
if [ -d "$1" ]; then
    diff "$1" "$2$(basename "$1")" || read -e -p "Press ENTER to continue ..."
#    diff -r --brief "$1" "$2"
elif [ -f "$1" ]; then
    diff "$1" "$2$(basename "$1")" || read -e -p "Press ENTER to continue ..."
else
    exit 3
fi
exit $?
