#!/usr/local/bin/python3.9
from netmiko import ConnectHandler
from time import sleep
import socket

mikrotik_router_1 = {
'device_type': 'mikrotik_routeros',
'host': '192.168.0.20',
# 'host': '100.100.100.5',
'port': '22',
'username': 'admin+ct',
'password': 'MavVip2020$#21'
}

def Access(host):
    conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    conn.settimeout(5)
    result = conn.connect_ex((host, 80))
    conn.close
    return result

tocken = True

while True:
    sleep (1)
    # if Access('212.192.40.14') == 0:
    if Access('185.154.75.183') == 0:
        if not tocken:
            sleep(2)
            print('connect')
            try:
                sshCli = ConnectHandler(**mikrotik_router_1)
                sshCli.send_command('/ip firewall nat disable [find where comment="This reserv chanel"]')
                sshCli.disconnect()
            except:
                continue
            tocken = True
        continue
    # elif Access('212.192.40.14') != 0:
    elif Access('185.154.75.183') != 0:
        if tocken:
            sleep(2)
            print('disconnect')
            try:
                sshCli = ConnectHandler(**mikrotik_router_1)
                sshCli.send_command('ip firewall nat enable [find where comment="This reserv chanel"]')
                sshCli.disconnect()
            except:
                continue
            tocken = False
        continue