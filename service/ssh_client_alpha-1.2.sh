API_KEY='5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
CHAT_ID=394151541
CHAT_ID_2=1192697423
COUNT=0
while true; do
  tail -f /var/log/auth.log | while read line; do
    if [[ $(echo $line | grep sshd | egrep -o '[0-9.]{10,15}') == "212.192.40.14" ]]; then
      continue
    elif [[ $(echo $line | grep sshd | egrep -o '[0-9.]{8,15}') == "185.154.75.183" ]]; then
      continue
    elif [[ $(echo $line | grep sshd | egrep -o '[0-9.]{8,15}') == "62.113.96.14" ]]; then
      continue
    elif echo $line | grep -wq sshd; then
      if grep -wq 'Accepted' <<< $line; then
        TG_MESSAGE="<b>SSH_LK: </b> Connect $(echo $line | grep sshd | egrep -o '[0-9.]{8,15}')"
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
      fi
    fi
    let COUNT+=1
    if [ $COUNT == 100 ]; then
      break
    fi
  done
  echo 'New Session'
done