#!/bin/bash
FILE='/home/allen/tmp/sinka.txt'
RED='#[fg=brightwhite]#[bg=red]'
NC='#[fg=default]#[bg=default]' # No Color
#detect which line
LINES=5
LINE=$(( $(date +%M | sed 's/^0//') % ${LINES} ))
if [ "$LINE" -eq "0" ];then
  CPU_THRESHOLD=65
  FAN_THRESHOLD=1900
  CPU=`cat $FILE | sed 's/ /\n/g' | grep t_cpu | cut -d':' -f2`
  FAN=`cat $FILE | sed 's/ /\n/g' | grep fan | cut -d':' -f2`
  echo -e -n "CPU Temp:"
  if [ "$CPU" -gt "$CPU_THRESHOLD" ]; then
      echo -e -n "${RED}"
  fi
  echo -e -n "$CPU${NC} "
  echo -e -n "FAN RPM:"
  if [ "$FAN" -gt "$FAN_THRESHOLD" ]; then
      echo -e -n "${RED}"
  fi
  echo -e -n "$FAN${NC}"
elif [ "$LINE" -eq "1" ];then
  LOAD=$(uptime | rev | cut -d":" -f1 | rev | sed s/,//g)
  echo -e -n  "Load avg:$LOAD${NC}"
elif [ "$LINE" -eq "2" ];then
  MEM=$(echo "scale=1; $(cat $FILE | sed 's/ /\n/g' | grep ^mem\: | cut -d':' -f2)/1024/1024" | bc)
  NOBUFF=$(echo "scale=1; $(cat $FILE | sed 's/ /\n/g' | grep ^memnobuff\: | cut -d':' -f2)/1024/1024" | bc)
  echo -e -n  "Mem: ${MEM}G Nobuf: ${NOBUFF}G${NC}"
elif [ "$LINE" -eq "3" ];then
  WIRED=$(echo "scale=1; $(cat $FILE | sed 's/ /\n/g' | grep wired\: | cut -d':' -f2)/1024/1024" | bc)
  ACTIVE=$(echo "scale=1; $(cat $FILE | sed 's/ /\n/g' | grep active\: | cut -d':' -f2)/1024/1024" | bc)
  echo -e -n  "Wired: ${WIRED}G Active: ${ACTIVE}G${NC}"
elif [ "$LINE" -eq "4" ];then
  DISK_THRESHOLD=95
  DF=`df -h`
  DHOME=`echo "$DF" | grep sda6 | awk '{ print $5 }'`
  DMARIA=`echo "$DF" | grep maria | awk '{ print $5 }'`
  echo -e -n "Disk ~:"
  if [ "$(echo $DHOME | sed 's/\%//')" -gt "$DISK_THRESHOLD" ]; then
      echo -e -n "${RED}"
  fi
  echo -e -n "${DHOME}${NC}"
  echo -e -n " maria:"
  if [ "$(echo $DMARIA | sed 's/\%//')" -gt "$DISK_THRESHOLD" ]; then
      echo -e -n "${RED}"
  fi
  echo -e -n "${DMARIA}${NC}"
else
  echo -e -n "${RED}ERR${NC}"
fi
