#!/bin/bash
THRESHOLD=10247680
MOUNTON="/media/sf_maria"
MAIL_ADDRESS="allen@server.example.com"
TITLE="ALERT: Low disk space on $MOUNTON on `/bin/cat /etc/hostname`"
CHECK=`/bin/df | /bin/grep $MOUNTON | /usr/bin/awk '{ print $4 }'`
if [ "$CHECK" -lt "$THRESHOLD" ]; then
    /bin/df -h | /usr/bin/mail -s "$TITLE" $MAIL_ADDRESS
fi
