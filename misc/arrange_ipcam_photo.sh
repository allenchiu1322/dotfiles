#!/bin/bash
# 測試模式
DRY=0
# 要處理的目錄
IMAGE_DIR="/home/allen/Dropbox/ipcam"
VIDEO_DIR="/home/allen/Dropbox/ipcam/record"
# 不處理幾天內的檔案
D_BEFORE=2
# 每個目錄處理的檔案上限
FILE_LIMIT=1000
# 錄影資料夾處理上限
VIDEO_LIMIT=1000
# 顯示更多的訊息
VERBOSE=0

function out {
    if [ $VERBOSE -eq 1 ]
    then
        echo "$1"
    fi
}

if [ $DRY -eq 1 ]
then
    echo "Dry mode on, not actually moving files."
fi
TS="$(date +"%s")"
out "Current timestamp is $TS"
out "IMAGE_DIR is $IMAGE_DIR"
for FILE in `ls -1rt "$IMAGE_DIR" | grep \.jpg$ | head -n $FILE_LIMIT`
do
    out "Processing $FILE"
# 取得檔案建立日期
    FILESEC=`stat -c %Y "$IMAGE_DIR/$FILE"`
    DAYS="$((($TS - $FILESEC) / 86400))"
    out "The timestamp of the file is $FILESEC and is $DAYS days before. "
# 檢查日期會不會太接近
    CHECK=1
    if [ "$DAYS" -lt "$D_BEFORE" ]
    then
        CHECK=0
        out "Skipping this file because it is not earlier enough. "
        break
    fi
# 檢查日期正確性
    if [ "$CHECK" -eq 1 ]
    then
        F_YEAR=${FILE:1:4}
        F_MONTH=${FILE:6:2}
        F_DAY=${FILE:9:2}
        DATE_DIR="$F_YEAR/$F_MONTH/$F_DAY"
        DATE_CHECK=`date -d "$DATE_DIR" "+%Y/%m/%d"`
        if [ "$DATE_DIR" != "$DATE_CHECK" ]
        then
            CHECK=0
            echo "Error converting file date to path."
            echo "Filename: $FILE, Date: $DATE_DIR"
        fi
    fi
# 檢查該日期目錄在不在
    if [ "$CHECK" -eq 1 ]
    then
        if [ -d "$IMAGE_DIR/$DATE_DIR" ]
        then
            out "Directory $IMAGE_DIR/$DATE_DIR exists."
        else
            if [ "$DRY" -ne 1 ]
            then
                out "Directory $IMAGE_DIR/$DATE_DIR not exist, trying to create."
                mkdir -p "$IMAGE_DIR/$DATE_DIR"
                if [ -d "$IMAGE_DIR/$DATE_DIR" ]
                then
                    out "Directory $IMAGE_DIR/$DATE_DIR successfully created."
                else
                    out "Failed to create directory."
                    CHECK=0
                fi
            else
                out "Directory $IMAGE_DIR/$DATE_DIR not exist."
                echo "Will be run command below. "
                echo "mkdir -p $IMAGE_DIR/$DATE_DIR"
            fi
        fi
    fi
# 搬移檔案
    if [ "$CHECK" -eq 1 ]
    then
        if [ $DRY -eq 1 ]
        then
            echo "Will be run command below. "
            echo "mv -v "$IMAGE_DIR/$FILE" $IMAGE_DIR/$DATE_DIR"
        else
            mv -v "$IMAGE_DIR/$FILE" $IMAGE_DIR/$DATE_DIR
        fi
    fi
done

for V_SEQ in $(seq 1 1 $VIDEO_LIMIT)
do
    V_DIR="$VIDEO_DIR$V_SEQ"
    out "Trying to process $V_DIR"
    if [ -d "$V_DIR" ]
    then
        for FILE in `ls -1rt "$V_DIR" | grep \.avi$ | head -n $FILE_LIMIT`
        do
            out "Processing $FILE"
# 取得檔案建立日期
            FILESEC=`stat -c %Y "$V_DIR/$FILE"`
            DAYS="$((($TS - $FILESEC) / 86400))"
            out "The timestamp of the file is $FILESEC and is $DAYS days before. "
# 檢查日期會不會太接近
            CHECK=1
            if [ "$DAYS" -lt "$D_BEFORE" ]
            then
                CHECK=0
                out "Skipping this file because it is not earlier enough. "
                break
            fi
# 檢查日期正確性
            if [ "$CHECK" -eq 1 ]
            then
                F_YEAR=${FILE:0:4}
                F_MONTH=${FILE:4:2}
                F_DAY=${FILE:6:2}
                DATE_DIR="$F_YEAR/$F_MONTH/$F_DAY"
                DATE_CHECK=`date -d "$DATE_DIR" "+%Y/%m/%d"`
                if [ "$DATE_DIR" != "$DATE_CHECK" ]
                then
                    CHECK=0
                    echo "Error converting file date to path."
                    echo "Filename: $FILE, Date: $DATE_DIR"
                fi
            fi
# 檢查該日期目錄在不在
            if [ "$CHECK" -eq 1 ]
            then
                if [ -d "$VIDEO_DIR/$DATE_DIR" ]
                then
                    out "Directory $VIDEO_DIR/$DATE_DIR exists."
                else
                    if [ "$DRY" -ne 1 ]
                    then
                        out "Directory $VIDEO_DIR/$DATE_DIR not exist, trying to create."
                        mkdir -p "$VIDEO_DIR/$DATE_DIR"
                        if [ -d "$VIDEO_DIR/$DATE_DIR" ]
                        then
                            out "Directory $VIDEO_DIR/$DATE_DIR successfully created."
                        else
                            out "Failed to create directory."
                            CHECK=0
                        fi
                    else
                        out "Directory $VIDEO_DIR/$DATE_DIR not exist."
                        echo "Will be run command below. "
                        echo "mkdir -p $VIDEO_DIR/$DATE_DIR"
                    fi
                fi
            fi
# 搬移檔案
            if [ "$CHECK" -eq 1 ]
            then
                if [ $DRY -eq 1 ]
                then
                    echo "Will be run command below. "
                    echo "mv -v "$V_DIR/$FILE" $VIDEO_DIR/$DATE_DIR"
                    echo "mv -v "$V_DIR/$FILE.txt" $VIDEO_DIR/$DATE_DIR"
                else
                    mv -v "$V_DIR/$FILE" $VIDEO_DIR/$DATE_DIR
                    mv -v "$V_DIR/$FILE.txt" $VIDEO_DIR/$DATE_DIR
                fi
            fi
        done
    else
        out "Directory $V_DIR not exist"
        break
    fi
done
