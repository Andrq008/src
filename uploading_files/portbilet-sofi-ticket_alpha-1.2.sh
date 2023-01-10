#!/bin/bash
IN_FOLDER="/srv/portbilet/mount_ticket"
OUT_FOLDER="/srv/portbilet-company/ТИКЕТ_СЕРВИС-sofi"
ERR_FOLDER="/srv/portbilet-company/err-send/ТИКЕТ_СЕРВИС/"
IFS=""
while true; do
	for i in $IN_FOLDER/"*.xml"; do
		sleep 2
		if ! (($(find $IN_FOLDER -type f | wc -l) >= 1)); then
			break
		fi
		DATE=`date +%Y-%m-%d`
		TIME=`date +%T`
		a=`echo $i | cut -d '/' -f5`
		echo "Выгружается: $a"
		echo put $i | lftp ftp://tiketservis:Jfk7c68tMcU8QZS8cx2N3u@127.0.0.1:2100
		if [ $? != 0 ]; then
			echo 'Повторить выгрузку из err-send'
			if [ ! -d "$ERR_FOLDER" ]; then
				mkdir -p "$ERR_FOLDER"
			fi
			cp $i $ERR_FOLDER
		fi
		echo $TIME  - 'Тикет Сервис sofi' -  $a >> /root/prtb.log
		# echo $TIME  - 'Тикет Сервис' -  $a
		if [ ! -d "$OUT_FOLDER" ]; then
			mkdir -p "$OUT_FOLDER"
		fi
        echo 'В архив для субагента'
		zip -j -m -q $OUT_FOLDER/$DATE.zip $i
    done
	unset i
	unset j
done
