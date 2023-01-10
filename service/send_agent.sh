#!/bin/bash
# Скрипт скачивает архив агента за определенную дату и отправляет повторно файлы агенту
echo 'Нажмите нужную цифру'
echo '1 - Региональный центр бронирования'
echo '2 - Регион24'
echo '3 - Ираэросервис ООО'
read
echo 'Введите дату архива в формате ГГГГ-мм-дд'
read arch
IN_ARCH="$arch.zip"
OUT_FOLDER="/mnt/c/Users/seligenenko/result"
case "$REPLY" in
1)
  IN_ORG='Региональный_центр_бронирования'
  FTP_COMPANY='ftp://portbiletftp:9384893848@rcr-travel.ru'
  ;;
2)
  IN_ORG='Регион24'
  FTP_COMPANY='ftp://remote:1cNewPassword1!@109.226.192.9:59960'
  FTP_COMPANY='ftp://vipservice:vX8yK=9JgH@109.226.192.9:7006'
  ;;
3)
  IN_ORG='Ираэросервис_ООО'
  FTP_COMPANY='ftp://irairservice:4zUg397gYZTV5WjgszD7q3@62.113.96.14:2100'
  ;;
esac
scp -P2200 root@62.113.96.14:/srv/portbilet-company/$IN_ORG/$IN_ARCH $OUT_FOLDER >/dev/null 2>&1
unzip $OUT_FOLDER/$IN_ARCH -d $OUT_FOLDER >/dev/null 2>&1
for i in $OUT_FOLDER/*.xml
do
    echo "Выгружается: $IN_ORG  --  $i"
    echo "put $i" | lftp $FTP_COMPANY
done
rm $OUT_FOLDER/*