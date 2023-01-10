#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import requests
import telebot
import pathlib
import arrow

TOKEN = '5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
CHAT_ID_1 = 394151541
CHAT_ID_2 = 1192697423

bot = telebot.TeleBot(TOKEN, parse_mode='MarkdownV2')

conn = requests.Session()

url = {
    'https://sip.maverik.ru/admin-cabinet/session/start': 'https://sip.maverik.ru/pbxcore/api/sip/getPeersStatuses',
    'https://sip2.maverik.ru/admin-cabinet/session/start': 'https://sip2.maverik.ru/pbxcore/api/sip/getPeersStatuses',
    'https://sip3.maverik.ru/admin-cabinet/session/start': 'https://sip3.maverik.ru/pbxcore/api/sip/getPeersStatuses'
}

auth = {
    'login': 'admin',
    'password': 'Merse!23des'
}

headers = {
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'X-Requested-With': 'XMLHttpRequest'
}

for i in url:
    conn.post(url=i, headers=headers, data=auth)
    pbx = conn.post(url[i])
    sip = pbx.json()
    for i in sip['data']:
        if 'UNKNOWN' in i['state']:
            path = pathlib.Path(fr"/mnt/sip/{i['id']}.sip")
            if path.exists():
                print('Отключен')
                continue
            with open(fr"/mnt/sip/{i['id']}.sip", "w") as file:
                file.write(i['id'])
            print(i['id'])
        if  'OK' in i['state']:
            path = pathlib.Path(fr"/mnt/sip/{i['id']}.sip")
            if path.exists():
                pathlib.Path(path.absolute()).unlink()

from pathlib import Path
criticalTime = arrow.utcnow().shift(minutes=-20)
for sip_file in Path(r"/mnt/sip").glob('*.sip'):
    if sip_file.is_file():
        print (str(sip_file.absolute()))
        itemTime = arrow.get(sip_file.stat().st_mtime)
        if itemTime < criticalTime:
            print('delete')
            with open(sip_file) as f:
                sn = f.read()
                bot.send_message(CHAT_ID_1, text=f"*SIP: *  Номер *{sn}* Отключен")
                bot.send_message(CHAT_ID_2, text=f"*SIP: *  Номер *{sn}* Отключен")
            Path(sip_file.absolute()).unlink()