#!/bin/bash
API_KEY='5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
CHAT_ID_1=394151541
CHAT_ID_2=1192697423
#DATE=$(date +%H:%M)
declare -A addr
addr=(  [88.87.79.125]="Волгоград, ул. Рабоче-Крестьянская, д. 15"
        [83.239.139.110]="Волгоград, ул. Новодвинская"
        [85.172.120.22]="Волгоград, ул. Еременко, д. 80"
        [83.239.163.206]="Волжский, ул. Мира, д. 62"
        [100.100.100.32]="Новошахтинск, пр. Ленина, д.7"
        [185.105.170.215]="Краснодар Ищенко"
        [100.100.100.40]="Сергиев посад"
        [100.100.100.41]="Новороссийск"
        [100.100.100.51]="Краснодар, Привокзальная"
        [31.173.194.130]="Волгоград, шоссе Авиаторов, д. 161"
        [100.100.100.54]="Волгоград, ул. Аллея Героев, д. 5"
        [83.239.80.166]="Крымск, Синева, д.26"
        [83.239.163.178]="Волгоград, б-р имени Энгельса, д. 15"
        [94.233.120.77]="Камышин, улица Некрасова, дом 25"
        [83.239.189.242]="Волжский, Ленина")

for i in ${!addr[*]}; do
    if ! ($(ping -c 1 $i | grep -q 'ttl') || $(ping -c 1 $i | grep -q 'ttl')); then
        if [ -f /mnt/sip/$i ]; then
            echo ${addr[$i]}
            continue
        fi
        # echo $DATE -- ${addr[$i]} -- Отключен
        echo -e "Subject:KASSA\n\nКасса отключена: ${addr[$i]}\nВозможно выключили свет" | msmtp -a kassa 135@maverik.ru
        TG_MESSAGE="<b>KASSA: </b> ${addr[$i]} -- Отключен."
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_1 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
        touch /mnt/sip/$i
        continue
    fi
    if [ -f /mnt/sip/$i ];then
        rm /mnt/sip/$i
        # echo $DATE -- ${addr[$i]} -- Доступен
        echo -e "Subject:KASSA\n\nКасса доступна: ${addr[$i]}" | msmtp -a kassa 135@maverik.ru
        TG_MESSAGE="<b>KASSA: </b> ${addr[$i]} -- Доступен"
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_1 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
    fi
done
