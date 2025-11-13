#!/bin/bash
# Скрипт для получения Chat ID из Telegram бота

echo "Введите токен вашего бота (который вы скопировали от BotFather):"
read BOT_TOKEN

echo ""
echo "Получаю Chat ID..."
echo ""

# Получаем обновления от бота
curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates" | python3 -m json.tool

echo ""
echo ""
echo "Найдите в ответе строку с 'chat':{'id':123456789}"
echo "Это число и есть ваш Chat ID"

