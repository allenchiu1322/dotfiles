#!/bin/bash
cat /var/log/fail2ban.log | grep Ban | awk '{ print $NF }' | sort | uniq -c | sort -n -k 1 | tac | mail -s "fail2ban weekly report" allen
