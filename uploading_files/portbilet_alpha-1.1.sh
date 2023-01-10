#!/bin/bash
DATE=`date +%Y-%m-%d`
IN_FOLDER="/srv/ftp/upload/"
OUT_FOLDER='/srv/portbilet-company'
COPY_FOLDER='/srv/ftp/copy1c/'
ARCH_FOLDER="/srv/ftp/upload/"
ERR_FOLDER='/srv/portbilet-company/err-send'
declare -A FTPCOMPANY
FTPCOMPANY=(	[Региональный_центр_бронирования]="ftp://portbiletftp:9384893848@rcr-travel.ru"
		[Регион24_ООО]="ftp://remote:1cNewPassword1!@109.226.192.9:59960"
		[Регион24]="ftp://vipservice:vX8yK=9JgH@109.226.192.9:7006"
		[Ираэросервис_ООО]="ftp://irairservice:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"
		[Кий_Авиа_Крым]="ftp://maverik:maverik!@#$%%@195.49.206.90")
for i in `find /srv/ftp/upload/ -cmin +1 -type f`
do
	cp $i $COPY_FOLDER
	for j in ${!FTPCOMPANY[@]}
	do
		u=`echo $j | tr '_' ' '`
		if grep "$u" $i > /dev/null
		then
			echo "Выгружается: $u"
			curl -T $i ${FTPCOMPANY[$j]}
			if [ $? != 0 ]
			then
				echo 'Повторить выгрузку из err-send'
				if [ -d "$ERR_FOLDER/$j" ]
				then
					cp $i "$ERR_FOLDER/$j"
				else
					mkdir -p "$ERR_FOLDER/$j"
					cp $i "$ERR_FOLDER/$j"
				fi
			fi
			if [ -d $OUT_FOLDER/$j ]
			then
				zip -j -q $OUT_FOLDER/$j/$DATE.zip $i
			else
				mkdir -p $OUT_FOLDER/$j
				zip -j -q $OUT_FOLDER/$j/$DATE.zip $i
			fi
		fi
	done
	zip -j -m -q $ARCH_FOLDER/$DATE.zip $i
done
