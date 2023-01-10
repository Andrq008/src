#!/bin/bash
IN_FOLDER='/mnt/c/Users/seligenenko/port'
OUT_FOLDER='/mnt/c/Users/seligenenko/test2'
COPY_FOLDER='/mnt/c/Users/seligenenko/test/'
ARCH_FOLDER="/mnt/c/Users/seligenenko/test2"
ERR_FOLDER='/mnt/c/Users/seligenenko/test/'
declare -A FTP_COMPANY=(    [Тикет сервис]="ftp://tiketservis:Jfk7c68tMcU8QZS8cx2N3u@127.0.0.1:2100"
                            [Региональный центр бронирования]="ftp://portbiletftp:9384893848@rcr-travel.ru"
                            [Регион24 ООО]="ftp://remote:1cNewPassword1!@109.226.192.9:59960"
                            [Регион24]="ftp://vipservice:vX8yK=9JgH@109.226.192.9:7006"
                            [Ираэросервис ООО]="ftp://irairservice:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"
                            [Авиабизнес ООО]="ftp://aviabusiness:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"
                            [Кий Авиа Крым]="ftp://maverik:6eMxwj%i@195.49.206.90/portbilet"
                            )
IFS=""
while true; do
	for i in "$IN_FOLDER/*.xml"; do
		sleep 1
        if [ ! -f $i ]; then
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
	unset i
	unset j
done
