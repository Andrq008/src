#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import requests
import telebot

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

NO_TEST = '6505, 130, 6533, 6208, 2003, 6163, 180'

for i in url:
    conn.post(url=i, headers=headers, data=auth)
    pbx = conn.post(url[i])
    sip = pbx.json()
    for i in sip['data']:
        if 'UNKNOWN' in i['state']:
            print(i['id'])
            if i['id'] in NO_TEST:
                print(i['id'])
                continue
            bot.send_message(CHAT_ID_1, f"*SIP: *  Номер *{i['id']}* не доступен")
            bot.send_message(CHAT_ID_2, f"*SIP: *  Номер *{i['id']}* не доступен")