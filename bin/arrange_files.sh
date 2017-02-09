#!/bin/bash
#detect
THIS_OS=$(uname -s)
CURRENT_TS=$(date +%s)

#settings
OLDER_THAN=7
COMPARE_WITH=$(($CURRENT_TS - $OLDER_THAN * 86400))

#check param
if [ "$#" -ne 2 ] && [ "$#" -ne 1 ];then
    echo "Usage: $0 DIR [OLDER_THAN]"
    exit 1
fi
if [ "$#" -eq 2 ]; then
    NR='^[0-9]+$'
    if ! [[ $2 =~ $NR ]]; then
        echo "OLDER_THAN value is not a number"
        exit 2
    fi
else
    echo "OLDER_THAN not specified, use default value: $OLDER_THAN"
fi
WORKDIR=$(echo $1 | sed -e 's/\/$//g')

#files loop
FILES=$(find "$WORKDIR" -maxdepth 1 -type f)
while read -r F; do
    BF=$(basename "$F")
    #test filename
    OK="YES"
    if [ "$BF" == "" ]; then
        OK="NO"
        echo "Filename not valid."
    fi
    DOTFILES="^\..+$"
    if [[ $BF =~ $DOTFILES ]]; then
        OK="NO"
        echo "Filename starting with dot, skipping."
    fi
    if [[ $BF == "desktop.ini" ]]; then
        OK="NO"
        echo "Filename is Windows system file, skipping."
    fi
    if [ "$OK" == "YES" ]; then
        #trying to get exifdate
        EXIFDATE=$(exiftags -a "$F" 2> /dev/null | grep Created | cut -c16-)
        if [ "$EXIFDATE" != "" ]; then
            if [ "$THIS_OS" == "Darwin" ]; then
                FILETS=$(date -j -f "%Y:%m:%d %H:%M:%S" "$EXIFDATE" "+%s")
            elif [ "$THIS_OS" == "Linux" ]; then
                EXIFDATE2=$(sed -r 's#(.{4}):(.{2}):(.{2}) (.{2}):(.{2}):(.{2})#\1/\2/\3 \4:\5:\6#' <<< "$EXIFDATE")
                FILETS=$(date -d"$EXIFDATE2" "+%s")
            else
                exit 3
            fi
            PREFIX="arranged/photos"
        else
            if [ "$THIS_OS" == "Darwin" ]; then
                FILEDATE=$(stat -x -t '%F %T' "$F" | grep Modify | cut -c9-)
                FILETS=$(date -j -f "%Y-%m-%d %H:%M:%S" "$FILEDATE" "+%s")
            elif [ "$THIS_OS" == "Linux" ]; then
                FILEDATE=$(stat "$F" | grep Modify | cut -c9-27)
                FILETS=$(date -d"$FILEDATE" "+%s")
            else
                exit 4
            fi
            PREFIX="arranged/files"
            #check filename if a photo file
            PHOTOS="^IMG_.+$"
            if [[ $BF =~ $PHOTOS ]]; then
                PREFIX="arranged/photos"
            fi
            PHOTOS="^DSC_.+$"
            if [[ $BF =~ $PHOTOS ]]; then
                PREFIX="arranged/photos"
            fi
        fi
        #check file age
        if [ "$FILETS" -gt "$COMPARE_WITH" ]; then
            echo "$F is not older than $OLDER_THAN days, skipping."
        else
            if [ "$THIS_OS" == "Darwin" ]; then
                F_YEAR=$(date -r "$FILETS" +%Y)
                F_MONTH=$(date -r "$FILETS" +%m)
                F_DAY=$(date -r "$FILETS" +%d)
            elif [ "$THIS_OS" == "Linux" ]; then
                F_YEAR=$(date -d "@$FILETS" "+%Y")
                F_MONTH=$(date -d "@$FILETS" "+%m")
                F_DAY=$(date -d "@$FILETS" "+%d")
            else
                exit 5
            fi
            mkdir -p "$WORKDIR"/"$PREFIX"/"$F_YEAR"/"$F_MONTH"/"$F_DAY"
            mv -v "$F" "$WORKDIR"/"$PREFIX"/"$F_YEAR"/"$F_MONTH"/"$F_DAY"
        fi
    fi
done <<< "$FILES"
