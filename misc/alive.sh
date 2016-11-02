#!/bin/bash
#alive for linux by allen
#test on ubuntu and raspberry pi
group=allen
myip=`/sbin/ifconfig enp0s3 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
host=`/bin/cat /etc/hostname`
/usr/bin/wget -O - http://server.example.com/~allen/allenlab/index.php/device_uptime/update/$group/$host/$myip-$RANDOM > /dev/null
#mail when network fails
/bin/ping -c 1 168.95.1.1 || echo 'host unreachable' | mail -s 'host unreachable' $USER
