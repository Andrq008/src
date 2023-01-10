#!/bin/bash
IN_FOLDER="/srv/portbilet/mount_ticket"
OUT_FOLDER="/srv/portbilet-company"
ERR_FOLDER="/srv/portbilet-company/err-send/"
declare -A FTP_COMPANY=(	[ТИКЕТ СЕРВИС]="ftp://tiketservis:Jfk7c68tMcU8QZS8cx2N3u@127.0.0.1:2100")
IFS=""
while true; do
	for i in $IN_FOLDER/"*.xml"; do
		sleep 2
		if ! (($(find $IN_FOLDER -type f | wc -l) > 1)); then
			break
		fi
		DATE=`date +%Y-%m-%d`
		TIME=`date +%T`
		a=`echo $i | cut -d '/' -f5`
		for j in ${!FTP_COMPANY[@]}; do
			if grep -i -l -q -m 1 $j $i; then
				echo "Выгружается: $j"
				echo put $i | lftp ${FTP_COMPANY[$j]}
				if [ $? != 0 ]; then
					echo 'Повторить выгрузку из err-send'
					if [ ! -d "$ERR_FOLDER/$y" ]; then
						mkdir -p "$ERR_FOLDER/$y"
					fi
					cp $i "$ERR_FOLDER/$y"
				fi
				# echo $TIME  - $j -  $a >> /root/prtb.log
				echo $TIME  - $j -  $a
				y=`echo $j | tr ' ' '_'`
				if [ ! -d "$OUT_FOLDER/$y" ]; then
					mkdir -p "$OUT_FOLDER-sofi/$y"
				fi
                echo 'В архив для субагента'
				zip -j -m -q $OUT_FOLDER/$y/$DATE.zip $i
			fi
		done
    done
	unset i
	unset j
done
