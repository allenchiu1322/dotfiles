#!/bin/bash
# set variables
BACKUP_DEST="/media/sf_maria/backup/sanzenin"
MAIL_ADDRESS="allen@server.example.com"
# get system variables
WEEKDAY=`date +"%w"`
DAY=`date +"%d"`
YMD=`date +"%Y-%m-%d"`
# check backup dir exists
if [ -d "$BACKUP_DEST" ]; then
# daily
    #tar --exclude-from=/home/allen/bin/backup_exclude_list --ignore-failed-read --no-recursion -zcvpf $BACKUP_DEST/allen/allen.daily.diff.$YMD.tar.gz $(find /home/allen/ -mtime -1)
    find /home/allen/ -mtime -1 -print0 | tar --exclude-from=/home/allen/bin/backup_exclude_list --ignore-failed-read --no-recursion -zcvpf $BACKUP_DEST/allen/allen.daily.diff.$YMD.tar.gz --null -T -
# monthly on the first wednesday of a month
    if [ "$WEEKDAY" -eq "3" ] && [ "$DAY" -le "7" ]; then
        tar --exclude-from=/home/allen/bin/backup_exclude_list --ignore-failed-read -zcvpf $BACKUP_DEST/allen/allen.monthly.$YMD.tar.gz /home/allen
    fi
else
    echo "Backup dir not exists."
fi
#trace diff
mv $BACKUP_DEST/allen/this.today $BACKUP_DEST/allen/this.yesterday
find /home/allen > $BACKUP_DEST/allen/this.today
diff $BACKUP_DEST/allen/this.today $BACKUP_DEST/allen/this.yesterday > $BACKUP_DEST/allen/this.diff
/usr/bin/mail -s filediff_home_allen_$YMD $MAIL_ADDRESS < $BACKUP_DEST/allen/this.diff
# maintain logs
