from pyrogram import Client
import asyncio
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from pyrogram import enums
import random

import test_5list

api_id = '####'
api_hash = '####'
app_version="####"
device_model="####"
system_version="####"

app = Client('Andrq-2', api_id, api_hash, app_version, device_model, system_version)

async def cp_post():
        async for message_ in app.get_chat_history(-1001217979498, limit=1):
            await app.copy_message(-1001794193522, message_.chat.id, message_.id)

async def moning():
    await app.send_message(-1001794193522, test_5list.goodMoning())

async def bla():
    await app.send_message(-1001794193522, test_5list.balabol())

@app.on_message()
async def echo(client, message):
    if message.chat.id == -1001794193522:
#        print(message)
        print(message.text)
        if message.from_user:
            print(message.from_user.id)
            print(message.from_user.first_name)
            await app.send_chat_action(message.chat.id, enums.ChatAction.TYPING)
            await asyncio.sleep(2)
            await app.send_reaction(message.chat.id, message.id, test_5list.reaction())
            if message.from_user.id == 701462683:       # Валера Сычев
                if 'ага' in message.text:
                    await app.send_dice(-1001794193522)
            elif message.from_user.id == 73482731:      # Максим Литуновский
                await app.send_dice(-1001794193522)
            # elif message.from_user.id == 2023184629:    # Егор Медведев
                # await app.send_dice(-1001794193522, "🎳")
                # await app.send_chat_action(message.chat.id, enums.ChatAction.TYPING)
                # await asyncio.sleep(5)
                # await message.reply_text(test_5list.answer_text())
                # 499129636 -- Даша Бабаева
            # else:
                # await app.send_dice(-1001794193522, "🎳")
                # await app.send_chat_action(message.chat.id, enums.ChatAction.TYPING)
                # await asyncio.sleep(5)
                # await message.reply_text(test_5list.answer_text())
            for i in test_5list.list_fuck:
                if i in message.text:
                    await app.send_chat_action(message.chat.id, enums.ChatAction.TYPING)
                    await asyncio.sleep(1)
                    await message.reply_text(test_5list.fuck())
                    break
            for i in test_5list.list_bot:
                if i in message.text:
                    await app.send_chat_action(message.chat.id, enums.ChatAction.TYPING)
                    await asyncio.sleep(1)
                    await message.reply_text(test_5list.botik())
            for i in test_5list.list_born: 
                if i in message.text:
                    await app.send_chat_action(message.chat.id, enums.ChatAction.TYPING)
                    await asyncio.sleep(1)
                    await message.reply_text(test_5list.help_support())
            for i in test_5list.list_ok:
                if i in message.text:
                    await app.send_chat_action(message.chat.id, enums.ChatAction.TYPING)
                    await asyncio.sleep(1)
                    await app.send_message(message.chat.id, test_5list.motivation())
            for i in test_5list.list_blabla:
                if i in message.text:
                    await app.send_chat_action(message.chat.id, enums.ChatAction.TYPING)
                    await asyncio.sleep(1)
                    await message.reply_text(test_5list.motivation())

scheduler = AsyncIOScheduler()
# scheduler.add_job(cp_post, 'cron', day_of_week='mon-fri', hour=9, minute=10)
scheduler.add_job(cp_post, 'cron', hour=12, minute=43)
scheduler.add_job(moning, 'cron', hour=6, minute=36)
scheduler.add_job(bla, 'cron', hour=12, minute=5)
scheduler.start()

app.run()