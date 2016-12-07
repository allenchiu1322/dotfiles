#!/bin/bash
if [ "$TERM" != "screen" ]; then
#    screen -ls
#    tmux ls
#    read -p "Press x to drop to prompt or any other key to activate screen session." -t 10 -n 1 orz
    read -p "1) screen 2) tmux 0) shell" -n 1 orz
    if [ "$orz" == "1" ]; then
      if [ -z "$STY" ]; then
        SCREENLIST=`screen -ls | grep 'No Sockets found'`
        if [ -z "$SCREENLIST" ]; then
          screen -x
        else
          screen
        fi
      else
          echo "You are already in a screen session. "
      fi
    elif [ "$orz" == "2" ];then
      if [ -z "$TMUX" ]; then
        SCREENLIST=`tmux ls`
        if [ -z "$SCREENLIST" ]; then
          tmux new-session -d -n 'd' -s homura 'tail -f /var/log/dmesg'
          tmux new-window -n 'sys' -t homura 'tail -f /var/log/syslog'
          tmux new-window -t homura 'bash'
          tmux attach-session -t homura
        else
          tmux attach-session -t homura
        fi
      else
          echo "You are already in a tmux session. "
      fi
    else
        echo ""
    fi
else
    /bin/bash /home/$USER/bin/hourlyweather.sh
fi
