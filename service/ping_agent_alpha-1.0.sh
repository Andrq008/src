#!/bin/bash

API_KEY='########:########-#-########_#########'
CHAT_ID_1='########'
CHAT_ID_2='########'

declare -A agent
agent=( [88.87.88.126]="Волгоград, Жукова, 106а" 
        [31.173.194.130]="Аэропорт"
#        [31.173.194.243]="Волжский, Ленина 97"
#        [88.87.76.221]="Волгоград, б.Энгельса, 15"
#        [31.173.194.131]="Волгоград, ул. Аллея Героев, 5"
        [94.233.120.77]="Камышин, ул. Некрасова, 25"
#        [88.87.76.224]="Волгоград,  ул. Менжинского, 11"
        [88.87.79.125]="Волгоград Рабочекрест"
        [188.233.186.209]="Волгоград Еременко"
        [188.233.185.12]="Волгоград Мира"
        [185.105.170.215]="Краснодар Ищенко"
#        [188.170.194.9]="Новороссийск"
#        [178.176.216.39]="Краснодар вокзал"
#        [176.59.83.79]="Новошахтинск"
        [83.239.80.166]="Крымск")
while true; do
    for i in ${!agent[*]}; do
        # ping -c 1 $i
        if ! $(ping -c 1 $i | grep -q 'ttl'); then
            echo ${agent[$i]}
            TG_MESSAGE="<b>KASSA: </b> ${agent[$i]} | НЕТ Пинга."
            curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_1 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
            curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
        fi
    done
    echo '####################'
    sleep 120
done