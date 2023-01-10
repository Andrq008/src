#!/bin/bash
DATE=`date +%F`
IN_FOLDER="/mnt/c/Users/seligenenko/tele/"
OUT_FOLDER="/mnt/c/Users/seligenenko/tele/"
SUB_FOLDER="/mnt/c/Users/seligenenko/test"
COPY_FOLDER="/srv/teletrain/"
ARCH_FOLDER="/mnt/c/Users/seligenenko/tele"

declare -A FTP_COMPANY=(    [ИРАЭРОСЕРВИС]="ftp://specit:13508@192.168.0.54:21"
                            [Омега авиа]="ftp://specit:13508@192.168.0.54:21")
# FTP_COMPANY[ИРАЭРОСЕРВИС]="ftp://irairservice:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"
# FTP_COMPANY[Омега авиа]="ftp://omega_avia:4zUg397gYZTV5WjgszD7q3@127.0.0.1:2100"
IFS=""
for f in $IN_FOLDER*.xml; do
	for i in ${!FTP_COMPANY[@]}; do
		y=$(echo $i | tr ' ' '_')
		if [[ $(xmllint --xpath "string(//NameOrg)" $f | grep $i) ]]; then
            echo $y
			if [[ ! -d $OUT_FOLDER$y ]]; then
                mkdir -p $OUT_FOLDER$y
            fi
            echo ${FTP_COMPANY[$i]}
            echo "put $f" | lftp ${FTP_COMPANY[$i]}
			cp $f $SUB_FOLDER
			zip -j -q $OUT_FOLDER$y/$DATE.zip $f
            break
		fi
	done
	zip -j -m -q $ARCH_FOLDER/$DATE.zip $f
done