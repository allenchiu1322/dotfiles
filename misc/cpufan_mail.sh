#!/bin/bash
FILE='/home/allen/tmp/sinka.txt'
MAIL_ADDRESS="allen@server.example.com"
TITLE="ALERT: High Device Temperature on `/bin/cat /etc/hostname`"
CPU_THRESHOLD=65
CPU=`cat $FILE | sed 's/ /\n/g' | grep t_cpu | cut -d':' -f2`
if [ "$CPU" -gt "$CPU_THRESHOLD" ]; then
    echo "Current CPU Temperature: $CPU" | /usr/bin/mail -s "$TITLE" $MAIL_ADDRESS
fi
