#!/bin/bash
DATE=`date +%F`
IN_FOLDER="/srv/gabriel_new/upload/$1"
OUT_FOLDER="/srv/ftp/copy1c/amadeus/"
COPY_FOLDER="/srv/ftp/copy1c/amadeus/"
ARCH_FOLDER="/srv/gabriel_new/archive"
declare -A FTP_COMPANY
FTP_COMPANY[99563177]="ftp://specit:13508@192.168.0.54:21"
cp $IN_FOLDER $COPY_FOLDER
for i in ${!FTP_COMPANY[@]}; do
	if grep -q $i $IN_FOLDER; then
		echo "put $IN_FOLDER" | lftp ${FTP_COMPANY[$i]}
		break
	fi
done
if [[ $(echo $IN_FOLDER | grep zip) ]]; then
	unzip -o $IN_FOLDER -d $COPY_FOLDER
fi
zip -j -m -q $ARCH_FOLDER/$DATE.zip $IN_FOLDER
