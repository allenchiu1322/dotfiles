#!/bin/bash
FILE='/home/allen/tmp/sinka.txt'
RED='#[fg=brightwhite]#[bg=red]'
NC='#[fg=default]#[bg=default]' # No Color
#detect which line
LINES=3
LINE=$(( $(date +%M | sed 's/^0//') % ${LINES} ))
if [ "$LINE" -eq "0" ];then
  LOAD=$(uptime | rev | cut -d":" -f1 | rev | sed s/,//g)
  echo -e -n  "Load avg:$LOAD${NC}"
elif [ "$LINE" -eq "1" ];then
  FREE_CMD=$(free | grep ^Mem | awk '{ print $6,$3 }')
  IFS=' ' read -ra FREE_ARR <<< "$FREE_CMD"
  MEM=$(echo "scale=1; ${FREE_ARR[0]}/1024/1024" | bc)
  NOBUFF=$(echo "scale=1; ${FREE_ARR[1]}/1024/1024" | bc)
  echo -e -n  "Mem: ${MEM}G Nobuf: ${NOBUFF}G${NC}"
elif [ "$LINE" -eq "2" ];then
  DISK_THRESHOLD=95
  DF=`df -h`
  DHOME=`echo "$DF" | grep sda1 | awk '{ print $5 }'`
  echo -e -n "Disk /:"
  if [ "$(echo $DHOME | sed 's/\%//')" -gt "$DISK_THRESHOLD" ]; then
      echo -e -n "${RED}"
  fi
  echo -e -n "${DHOME}${NC}"
else
  echo -e -n "${RED}ERR${NC}"
fi
