#!/bin/bash
ME=$USER
REPLACE=allen
#cp -v /home/$ME/bin/autoscreen.sh ./bin/
#cp -v /home/$ME/.tmux.conf /home/$ME/.bashrc /home/$ME/.vimrc ./
cp -v /home/$ME/.bashrc ./
sed -i "s/$ME/$REPLACE/g" ./.bashrc
cp -v /home/$ME/.vimrc ./
sed -i "s/$ME/$REPLACE/g" ./.vimrc
cp -v /home/$ME/.tmux.conf ./
sed -i "s/$ME/$REPLACE/g" ./.tmux.conf
cp -v /home/$ME/bin/autoscreen.sh ./bin/
sed -i "s/$ME/$REPLACE/g" ./bin/autoscreen.sh
echo === CHECK FILES BELOW ===
find . -type f | xargs grep -l $ME
echo === CHECK FILES ABOVE ===
git diff
