from netmiko import ConnectHandler
import datetime
from paramiko import SSHClient
import paramiko
from scp import SCPClient

DATE = datetime.datetime.today().strftime("%d-%m-%Y")

mikrotik_router_1 = {
'device_type': 'mikrotik_routeros',
'host': '192.168.0.###',
'port': '22',
'username': 'admin+ct',
'password': '########'
}

sshCli = ConnectHandler(**mikrotik_router_1)
sshCli.send_command("export file=%s.rsc hide-sensitive" % DATE)
sshCli.send_command("/system backup save name=%s" % DATE)

client = SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
client.connect(hostname='192.168.0.###', username='admin', password='######', allow_agent=False, look_for_keys=False)

scp = SCPClient(client.get_transport())
scp.get('%s.rsc' % DATE, 'C:\\Users\\seligenenko\\')
scp.get('%s.backup' % DATE, 'C:\\Users\\seligenenko\\')
scp.close()

sshCli.disconnect()