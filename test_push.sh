#!/bin/bash

# Скрипт для тестирования push уведомлений
# Требует установки curl

# FCM Server Key (замените на ваш Server Key из Firebase Console)
SERVER_KEY="AAAA7x5qPCI:APA91bFzbQCFOWCNGcvH8E-wJ2g1C7oRPo9MfWJp3rvs_r3DUvl7bqROFdkPK2eGWH6E8Lzo_tpvnD8LsOJ9FiNb4YcFrOWXz4q8B9zL5rS_z1vQ7RfT6Q8w5D3K"

# FCM Token устройства (получается из приложения)
# Замените на токен, который выводится в консоли при запуске приложения
FCM_TOKEN="YOUR_DEVICE_TOKEN"

echo "Отправка тестового push уведомления..."

curl -X POST \
     -H "Authorization: key=$SERVER_KEY" \
     -H "Content-Type: application/json" \
     -d '{
       "to": "'$FCM_TOKEN'",
       "notification": {
         "title": "Тестовое уведомление",
         "body": "Push уведомления работают!"
       },
       "data": {
         "test": "true"
       }
     }' \
     https://fcm.googleapis.com/fcm/send

echo ""
echo "Уведомление отправлено!"
