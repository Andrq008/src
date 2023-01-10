#!/bin/bash
IN_FOLDER='/srv/portbilet/mount_KAvia'
OUT_FOLDER='/srv/portbilet-company/Кий_Авиа_Крым-sofi'
ERR_FOLDER='/srv/portbilet-company/err-send/Кий_Авиа_Крым-sofi/'
while true; do
	for i in "$IN_FOLDER/*.xml"; do
		sleep 2
        if ! (($(find $IN_FOLDER -type f | wc -l) >= 1)); then
            break
        fi
		DATE=`date +%Y-%m-%d`
		TIME=`date +%T`
		a=`echo $i | cut -d '/' -f5`
				echo "Выгружается: $a"
				echo put $i | lftp ftp://maverik:6eMxwj%i@195.49.206.90/prt_sofi
				if [ $? != 0 ]; then
					echo 'Повторить выгрузку из err-send'
					if [ ! -d "$ERR_FOLDER" ]; then
						mkdir -p $ERR_FOLDER
					fi
					cp $i $ERR_FOLDER
				fi
			    echo $TIME  - 'Кий_Авиа_Крым sofi' -  $a >> /root/prtb.log
				if [ ! -d "$OUT_FOLDER" ]; then
					mkdir -p "$OUT_FOLDER"
				fi
                echo 'В архив для субагента'
				zip -j -m -q $OUT_FOLDER/$DATE.zip $i
    done
	unset i
	unset j
done
