PID=$(ps aux | grep -m1 test_ping.sh | grep -v 'grep' | awk '{print $2}')
API_KEY='5374522720:AAGoNUYCEyJ-7-bSAQPT7aV_W2GWcinnkQU'
CHAT_ID=394151541
CHAT_ID_2=1192697423

if [[ -n $PID ]]; then
  if (($(ps -p $PID -o etimes | egrep -o '[0-9:]*') > 120)); then
    TG_MESSAGE="<b>SCRIPTS: </b> Скрипт Портбилета завис!  Происходит попытка завершить процесс!"
    curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
    curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d chat_id=$CHAT_ID_2 -d text="$TG_MESSAGE" -d parse_mode=HTML > /dev/null
    pkill -f test_ping.sh
  elif (($(ps -p $PID -o etimes | egrep -o '[0-9:]*') > 1)); then
    exit
  fi
fi
