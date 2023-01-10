#!/bin/bash
# DATE=`date +%Y-%m-%d`
# TIME=`date +%T`
IN_FOLDER='/srv/portbilet/mount'
OUT_FOLDER='/srv/portbilet-company'
COPY_FOLDER='/srv/ftp/copy1c/'
ARCH_FOLDER="/srv/portbilet/archive"
ERR_FOLDER='/srv/portbilet-company/err-send/'
NAME_COMPANY=(	"Региональный центр бронирования"
				"Регион24 ООО"
				"Регион24"
				"Ираэросервис ООО"
				"Авиабизнес ООО"
				"Кий Авиа Крым")
IFS=""
FTP_COMPANY='{	"Региональный центр бронирования":["ftp://portbiletftp:9384893848@rcr-travel.ru"],
				"Регион24 ООО":["ftp://remote:1cNewPassword1!@109.226.192.9:59960"],
				"Регион24":["ftp://vipservice:vX8yK=9JgH@109.226.192.9:7006"],
				"Ираэросервис ООО":["ftp://irairservice:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"],
				"Авиабизнес ООО":["ftp://aviabusiness:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"],
				"Кий Авиа Крым":["ftp://maverik:6eMxwj%i@195.49.206.90/portbilet"]}'
while true; do
	for i in $IN_FOLDER/*.xml; do
        if [ ! -f $i ]; then
            break
        fi
		DATE=`date +%Y-%m-%d`
		TIME=`date +%T`
		sleep 1
		a=`echo $i | cut -d '/' -f5`
		for j in ${NAME_COMPANY[*]}; do
			if grep -i -l -q -m 1 $j $i; then
				ff=$(jq -r ".\"${j}\"[]" <<< ${FTP_COMPANY})
				echo "Выгружается: $ff"
				echo "put $i" | lftp $ff
				if [ $? != 0 ]; then
					echo 'Повторить выгрузку из err-send'
					if [ ! -d "$ERR_FOLDER/$y" ]; then
						mkdir -p "$ERR_FOLDER/$y"
					fi
					cp $i "$ERR_FOLDER/$y"
				fi
				echo $TIME  - $j -  $a >> /root/prtb.log
				y=`echo $j | tr ' ' '_'`
				if [ ! -d "$OUT_FOLDER/$y" ]; then
					mkdir -p "$OUT_FOLDER/$y"
				fi
                echo 'В архив для субагента'
				zip -j -q $OUT_FOLDER/$y/$DATE.zip $i
			fi
		done
        echo 'Копирование в 1С'
	    cp $i $COPY_FOLDER
	    echo 'Перемещено в архив'
	    zip -j -m -q $ARCH_FOLDER/$DATE.zip $i
    done
	sleep 2
	unset i
	unset j
done
