#!/bin/bash
API_KEY='5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
CHAT_ID_1=394151541
CHAT_ID_2=1192697423
DATE=$(date +%H:%M)
declare -A addr
declare -A addr_2
addr=(  [100.100.100.17]="Волгоград, ул. Рабоче-Крестьянская, д. 15"
        [100.100.100.14]="Волгоград, ул. Новодвинская"
        [100.100.100.19]="Волгоград, ул. Еременко, д. 80"
        [100.100.100.21]="Волжский, ул. Мира, д. 62"
        [100.100.100.32]="Новошахтинск, пр. Ленина, д.7"
        [100.100.100.34]="Краснодар Ищенко"
        [100.100.100.40]="Сергиев посад"
        [100.100.100.41]="Новороссийск"
        [100.100.100.51]="Краснодар, Привокзальная"
        [100.100.100.53]="Волгоград, шоссе Авиаторов, д. 161"
        [100.100.100.54]="Волгоград, ул. Аллея Героев, д. 5"
        [10.15.0.160]="Крымск, Синева, д.26"
        [10.15.0.224]="Волгоград, б-р имени Энгельса, д. 15"
        [10.15.0.226]="Камышин, улица Некрасова, дом 25"
        [10.15.0.222]="Волжский, Ленина")
addr_2=(    [100.100.100.17]="88.87.79.125"
            [100.100.100.14]="83.239.139.110"
            [100.100.100.19]="85.172.120.22"
            [100.100.100.21]="188.233.185.12"
            [100.100.100.32]="176.59.83.79"
            [100.100.100.34]="185.105.170.215"
            [100.100.100.40]="31.173.80.108"
            [100.100.100.41]="188.170.194.9"
            [100.100.100.51]="188.170.198.102"
            [100.100.100.53]="31.173.194.130"
            [100.100.100.54]="31.173.194.131"
            [10.15.0.160]="83.239.80.166"
            [10.15.0.224]="83.239.163.178"
            [10.15.0.226]="94.233.120.77"
            [10.15.0.222]="83.239.189.242")

for i in ${!addr[*]}; do
    if ! ($(ping -c 1 ${addr_2[$i]} | grep -q 'ttl') || $(ping -c 1 $i | grep -q 'ttl')); then
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
