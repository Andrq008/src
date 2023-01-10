API_KEY='5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
CHAT_ID=394151541
CHAT_ID_2=1192697423
tail -f /var/log/auth.log | while IFS='' read -r line; do
  if [[ $(echo $line | grep sshd | egrep -o '[0-9.]{10,15}') == "212.192.40.14" ]]; then
    continue
  elif [[ $(echo $line | grep sshd | egrep -o '[0-9.]{8,15}') == "82.150.225.129" ]]; then
    continue
  elif echo $line | grep -wq sshd; then
    if grep -wq 'Accepted' <<< $line; then
      TG_MESSAGE="<b>SSH_VPN: </b> Connect $(echo $line | grep sshd | egrep -o '[0-9.]{8,15}')"
      curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
      # curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
    fi
  fi
done