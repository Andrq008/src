#!/bin/bash


DAY_MONTH=$(date +%d)
DAY_WEEK=$(date +%u)
CURRENT_FILE="$(date +%F -d "yesterday")*"

echo 'Обзначаются переменные'

DAY_PATH_1C="/mnt/datastore/wd8tb2/data/vip_1c/archive/backup/daily/"
WEEK_PATH_1C="/mnt/datastore/wd8tb2/data/vip_1c/archive/backup/week/"
MONTH_PATH_1C="/mnt/datastore/wd8tb2/data/vip_1c/archive/backup/month/"

DAY_PATH_1C_BASE="/mnt/datastore/wd8tb2/data/vip_1c/archive/backup_base/daily/"
WEEK_PATH_1C_BASE="/mnt/datastore/wd8tb2/data/vip_1c/archive/backup_base/week/"
MONTH_PATH_1C_BASE="/mnt/datastore/wd8tb2/data/vip_1c/archive/backup_base/month/"

DAY_PATH_LK="/mnt/datastore/wd8tb2/data/lk_new/backup/daily/"
WEEK_PATH_LK="/mnt/datastore/wd8tb2/data/lk_new/backup/week/"
MONTH_PATH_LK="/mnt/datastore/wd8tb2/data/lk_new/backup/month/"

DAY_PATH_LK_BASE="/mnt/datastore/wd8tb2/data/lk_new/backup_base/daily/"
WEEK_PATH_LK_BASE="/mnt/datastore/wd8tb2/data/lk_new/backup_base/week/"
MONTH_PATH_LK_BASE="/mnt/datastore/wd8tb2/data/lk_new/backup_base/month/"

DAY_PATH_VPS="/mnt/datastore/wd8tb2/data/vip_1c/archive/ftp_adminvps/1cv8/daily/"
WEEK_PATH_VPS="/mnt/datastore/wd8tb2/data/vip_1c/archive/ftp_adminvps/1cv8/week/"
MONTH_PATH_VPS="/mnt/datastore/wd8tb2/data/vip_1c/archive/ftp_adminvps/1cv8/month/"

DAY_PATH_V_S="/mnt/datastore/wd8tb2/data/v_s/backup/daily/"
WEEK_PATH_V_S="/mnt/datastore/wd8tb2/data/v_s/backup/week/"
MONTH_PATH_V_S="/mnt/datastore/wd8tb2/data/v_s/backup/month/"

DAY_PATH_FTP="/mnt/datastore/wd8tb2/data/vip_1c/archive/ftp_1c_bk/"

echo 'Перемещаются недельные и месячные архивы'

if [ $DAY_WEEK -eq 1 ]; then
        echo "It's time to week backup!"
        mv $DAY_PATH_1C$CURRENT_FILE $WEEK_PATH_1C
        mv $DAY_PATH_1C_BASE$CURRENT_FILE $WEEK_PATH_1C_BASE
        mv $DAY_PATH_LK$CURRENT_FILE $WEEK_PATH_LK
        mv $DAY_PATH_LK_BASE$CURRENT_FILE $WEEK_PATH_LK_BASE
        mv $DAY_PATH_VPS$CURRENT_FILE $WEEK_PATH_VPS
fi
if [ $DAY_MONTH -eq 2 ]; then
        echo "It's time to month backup!"
        mv $DAY_PATH_1C$CURRENT_FILE $MONTH_PATH_1C
        mv $DAY_PATH_1C_BASE$CURRENT_FILE $MONTH_PATH_1C_BASE
        mv $DAY_PATH_LK$CURRENT_FILE $MONTH_PATH_LK
        mv $DAY_PATH_LK_BASE$CURRENT_FILE $MONTH_PATH_LK_BASE
        mv $DAY_PATH_VPS$CURRENT_FILE $MONTH_PATH_VPS
fi

echo 'Удаление архивов'

find $DAY_PATH_1C -type f -mtime +2 -daystart -exec rm -r {} \;
find $DAY_PATH_1C_BASE -type f -mtime +3 -daystart -exec rm -r {} \;
find $DAY_PATH_LK -type f -mtime +2 -daystart -exec rm -r {} \;
find $DAY_PATH_LK_BASE -type f -mtime +3 -daystart -exec rm -r {} \;
find $DAY_PATH_V_S -type f -mtime +8 -daystart -exec rm -r {} \;
find $DAY_PATH_VPS -type f -mtime +3 -daystart -exec rm -r {} \;
find $DAY_PATH_FTP -type d -mtime +62 -daystart -exec rm -r {} \;

find $WEEK_PATH_1C -type f -mtime +30 -daystart -exec rm -r {} \;
find $WEEK_PATH_1C_BASE -type f -mtime +31 -daystart -exec rm -r {} \;
find $WEEK_PATH_LK -type f -mtime +30 -daystart -exec rm -r {} \;
find $WEEK_PATH_LK_BASE -type f -mtime +31 -daystart -exec rm -r {} \;
find $WEEK_PATH_V_S -type f -mtime +30 -daystart -exec rm -r {} \;
find $WEEK_PATH_VPS -type f -mtime +31 -daystart -exec rm -r {} \;

find $MONTH_PATH_1C -type f -mtime +180 -daystart -exec rm -r {} \;
find $MONTH_PATH_1C_BASE -type f -mtime +365 -daystart -exec rm -r {} \;
find $MONTH_PATH_LK -type f -mtime +180 -daystart -exec rm -r {} \;
find $MONTH_PATH_LK_BASE -type f -mtime +365 -daystart -exec rm -r {} \;
find $MONTH_PATH_V_S -type f -mtime +180 -daystart -exec rm -r {} \;
find $MONTH_PATH_VPS -type f -mtime +365 -daystart -exec rm -r {} \;

echo 'Перемещение и очистка завершены'