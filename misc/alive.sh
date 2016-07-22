#!/bin/bash
#alive for linux by allen
#test on ubuntu and raspberry pi
group=allen
myip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
host=`/bin/cat /etc/hostname`
/usr/bin/wget -O - http://server.example.com/~allen/allenlab/index.php/device_uptime/update/$group/$host/$myip-$RANDOM > /dev/null
