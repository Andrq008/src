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
    # conn.settimeout(2)
    result = conn.connect_ex((host, 443))
    conn.close()
    return result

tocken = True

while True:
    sleep (1)
    if Access('185.154.75.183') == 0:
        print('test_connetc')
    # if Access('192.168.0.54') == 0:
        if not tocken:
            print('connect')
            '''
            try:
                sleep (5)
                sshCli = ConnectHandler(**mikrotik_router_1)
                sshCli.send_command('/ip firewall nat disable [find where comment="This reserv chanel"]')
                sshCli.disconnect()
            except:
                print('error_connected')
                continue
            '''
            sleep (5)
            sshCli = ConnectHandler(**mikrotik_router_1)
            sshCli.send_command('/ip firewall nat disable [find where comment="This reserv chanel"]')
            sshCli.disconnect()
            tocken = True
            continue
    elif Access('185.154.75.183') != 0:
        print('test_disconnect')
    # elif Access('192.168.0.54') != 0:
        if tocken:
            print('disconnect')
            # try:
            sshCli = ConnectHandler(**mikrotik_router_1)
            sshCli.send_command('ip firewall nat enable [find where comment="This reserv chanel"]')
            sshCli.disconnect()
            tocken = False
            # continue
            # except:
            #     print('error_disconnected')
            #     continue
            # tocken = False
            continue


        # sshCli = ConnectHandler(**mikrotik_router_1)
        # sshCli.send_command('ip firewall nat enable [find where comment="This reserv chanel"]')
    # sshCli.send_command('/ip firewall nat disable [find where comment="This reserv chanel"]')