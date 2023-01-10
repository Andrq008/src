#!/bin/bash

API_KEY='5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
CHAT_ID=394151541
CHAT_ID_2=1192697423

DATE=$(date +%Y-%m-%d)

in_files=$(find /mnt/c/Users/seligenenko/port/ -type f -mmin -10)

for i in $in_files; do
    j=$(echo $i | cut -d'/' -f7)
    echo $DATE -- $j
    size=$(ls -l $i | cut -d ' ' -f5)
    echo $size
    if [ $size == 0 ]; then
        TG_MESSAGE="<b>TEST: </b> Нулевой файл!  $j"
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
        # ssh -p2200 root@62.113.96.14 'unzip -d /srv/ftp/copy1c/ /srv/portbilet/archive/$DATE.zip $j'
    fi
done
