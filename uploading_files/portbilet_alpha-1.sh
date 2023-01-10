#!/bin/bash
DATE=`date +%Y-%m-%d`
S_FOLDER=`find /srv/ftp/upload/ -cmin +1 -name '*.xml'`
IN_FOLDER='/srv/ftp/upload'
OUT_FOLDER='/srv/portbilet-company'
COPY_FOLDER='/srv/ftp/copy1c/'
ERR_FOLDER='/srv/portbilet-company/err-send/'
NAME_COMPANY=(	"Региональный центр бронирования"
		"Регион24 ООО"
		"Регион24"
		"Ираэросервис ООО"
		"Кий Авиа Крым"
		"Крымавиасервис ЛТД Фирма"
		"Фирма Крымавиасервис ЛТД")
IFS=""
FTP_COMPANY='{	"Регион24 ООО":["ftp://remote:1cNewPassword1!@109.226.192.9:59960"],
		"Регион24":["ftp://vipservice:vX8yK=9JgH@109.226.192.9:7006"],
		"Региональный центр бронирования":["ftp://portbiletftp:9384893848@rcr-travel.ru"],
		"Ираэросервис ООО":["ftp://irairservice:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"],
		"Кий Авиа Крым":["ftp://maverik:maverik!@#$%%@195.49.206.90"],
		"Крымавиасервис ЛТД Фирма":["ftp://maverik:zTv6a4OXi8@194.135.1.219"],
		"Фирма Крымавиасервис ЛТД":["ftp://maverik:zTv6a4OXi8@194.135.1.219"]}'
for i in $IN_FOLDER/*.xml
#for i in $S_FOLDER
do
	sleep 3
	a=`echo $i | cut -d '/' -f5`
	for j in ${NAME_COMPANY[*]}
	do
		if grep $j $i > /dev/null
		then
			if [ -d "$OUT_FOLDER/$j" ]
			then
				echo $a
				if [[ -e "$OUT_FOLDER/$j/$a" ]]
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
                				cp $i $ERR_FOLDER
        				fi
					cp $i "$OUT_FOLDER/$j"
				fi
			else
				mkdir -p "$OUT_FOLDER/$j"
				ff=$(jq -r ".\"${j}\"[]" <<< "${FTP_COMPANY}")
				echo "Выгружается: $j"
				echo "put $i" | lftp $ff
				if [ $? != 0 ]
				then
					echo 'Повторить выгрузку из err-send'
					cp $i $ERR_FOLDER
				fi
				cp $i "$OUT_FOLDER/$j"
			fi
		fi
	done
cp $i $COPY_FOLDER
zip -j -m -q $IN_FOLDER/$DATE.zip $i
#echo 'Перемещено в архив'
unset i
unset j
sleep 1
done
