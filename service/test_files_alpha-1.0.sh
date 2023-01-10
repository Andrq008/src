#!/bin/bash
API_KEY='5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
CHAT_ID=394151541
CHAT_ID_2=1192697423
if [[ $(find /srv/ftp_1c/copy1c/ -type f -name 'gridnine*' -cmin +3 | wc -l) > 0 ]]
then
 echo 'find files'
 if [[ $(find /srv/ftp_1c/copy1c/ -type f -name 'gridnine*' -perm 0644) ]]
 then
  chmod 666 /srv/ftp_1c/copy1c/gridnine*
 else
#  echo -e 'Subject:Test File\n\nФайлы найдены\nФайлы изменены\nФайлы не загрузились' | sendmail -v 107@maverik.ru
  curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="<b>1C: </b> Файлы не загрузились" -d parse_mode=HTML
  curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="<b>1C: </b> Файлы не загрузились" -d parse_mode=HTML
 fi
elif [[ ! $(df -h | grep '//10.15.0.1/ftp') ]]
then
#  echo -e 'Subject:Нет каталога\n\nРазмонтировался каталог\nФайлы не загрузились' | sendmail -v 107@maverik.ru
  curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="<b>1C: </b> Размонтировался каталог" -d parse_mode=HTML
  curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="<b>1C: </b> Размонтировался каталог" -d parse_mode=HTML
fi
if [[ $(find /srv/ftp_1c/copy1c/ -type f -name '*.FIL' -cmin +3 | wc -l) > 0 ]]; then
 curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="<b>1C: </b> Файлы '*.FIL' не загрузились" -d parse_mode=HTML
 curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="<b>1C: </b> Файлы '*.FIL' не загрузились" -d parse_mode=HTML
fi
