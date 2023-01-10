#!/bin/bash
DATE=`date +%Y-%m-%d`
PID=$(ps aux | grep -m1 portbilet-sort_alfa.sh | grep -v 'grep' | awk '{print $2}')
# API_KEY='5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
# CHAT_ID=394151541
# CHAT_ID_2=1192697423
#S_FOLDER=`find /srv/ftp/upload/ -cmin +1 -type f -name 'gridnine--*'`
#IN_FOLDER='/srv/ftp/upload'
#IN_FOLDER='/mnt/portbilet/maverik'
IN_FOLDER='/srv/portbilet/mount'
OUT_FOLDER='/srv/portbilet-company'
COPY_FOLDER='/srv/ftp/copy1c/'
ARCH_FOLDER="/srv/portbilet/archive"
ERR_FOLDER='/srv/portbilet-company/err-send/'
if [[ -n $PID ]]; then
#  if egrep '[0-9]{1,6}' <<< $PID; then
#  if (($(ps -p $PID -o etimes | egrep -o '[0-9:]*') > 120)); then
#    TG_MESSAGE="<b>SCRIPTS: </b> Скрипт Портбилета завис!  Происходит попытка завершить процесс!"
#    curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
#    curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
#    pkill -f portbilet-sort_alfa.sh
#  elif (($(ps -p $PID -o etimes | egrep -o '[0-9:]*') > 1)); then#
  if (($(ps -p $PID -o etimes | egrep -o '[0-9]*') > 2)); then
    exit
  fi
fi
NAME_COMPANY=(	"Региональный центр бронирования"
		"Регион24 ООО"
		"Регион24"
		"Ираэросервис ООО"
		"Авиабизнес ООО"
		"Кий Авиа Крым"
		"Крымавиасервис ЛТД Фирма"
		"Фирма Крымавиасервис ЛТД")
IFS=""
FTP_COMPANY='{	"Регион24 ООО":["ftp://remote:1cNewPassword1!@109.226.192.9:59960"],
		"Регион24":["ftp://vipservice:vX8yK=9JgH@109.226.192.9:7006"],
		"Региональный центр бронирования":["ftp://portbiletftp:9384893848@rcr-travel.ru"],
		"Ираэросервис ООО":["ftp://irairservice:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"],
		"Авиабизнес ООО":["ftp://aviabusiness:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"],
		"Кий Авиа Крым":["ftp://maverik:6eMxwj%i@195.49.206.90/portbilet"],
		"Крымавиасервис ЛТД Фирма":["ftp://maverik:zTv6a4OXi8@194.135.1.219"],
		"Фирма Крымавиасервис ЛТД":["ftp://maverik:zTv6a4OXi8@194.135.1.219"]}'
for i in $IN_FOLDER/*.xml
#for i in $S_FOLDER
do
	sleep 2
	a=`echo $i | cut -d '/' -f5`
	for j in ${NAME_COMPANY[*]}
	do
		if grep $j $i > /dev/null
		then
			y=`echo $j | tr ' ' '_'`
			if [ -d "$OUT_FOLDER/$y" ]
			then
				echo $a
				if [[ -e "$OUT_FOLDER/$y/$a" ]]
				then
					echo 'файл есть'
					break
				else
					ff=$(jq -r ".\"${j}\"[]" <<< ${FTP_COMPANY})
					echo "Выгружается: $ff"
					echo "put $i" | lftp $ff
					if [ $? != 0 ]
        				then
						echo 'Повторить выгрузку из err-send'
#                				cp $i $ERR_FOLDER
						if [ -d "$ERR_FOLDER/$y" ]
						then
							cp $IN_FOLDER "$ERR_FOLDER/$y"
						else
							mkdir -p "$ERR_FOLDER/$y"
							cp $IN_FOLDER "$ERR_FOLDER/$j"
						fi
        				fi
#					cp $i "$OUT_FOLDER/$y"
					zip -j -q $OUT_FOLDER/$y/$DATE.zip $i
				fi
			else
				mkdir -p "$OUT_FOLDER/$y"
				ff=$(jq -r ".\"${j}\"[]" <<< "${FTP_COMPANY}")
				echo "Выгружается: $j"
				echo "put $i" | lftp $ff
				if [ $? != 0 ]
				then
					echo 'Повторить выгрузку из err-send'
#					cp $i $ERR_FOLDER
					if [ -d "$ERR_FOLDER/$y" ]
					then
						cp $IN_FOLDER "$ERR_FOLDER/$y"
					else
						mkdir -p "$ERR_FOLDER/$y"
						cp $IN_FOLDER "$ERR_FOLDER/$y"
					fi
				fi
#				cp $i "$OUT_FOLDER/$y"
				zip -j -q $OUT_FOLDER/$y/$DATE.zip $i
			fi
		fi
	done
cp $i $COPY_FOLDER
#	for i in `find /srv/ftp/copy1c/ -type f -name '*.xml'`; do chmod 666 $i; done
zip -j -m -q $ARCH_FOLDER/$DATE.zip $i
#echo 'Перемещено в архив'
unset i
unset j
#sleep 1
done
