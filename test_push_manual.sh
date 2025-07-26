#!/bin/bash

# FCM Token из логов приложения
FCM_TOKEN="crf3N5OtR4SwpP-pUP8e9m:APA91bE7RoU7E7S-lbmDwMS4EQ4LNQgQeshuEB7B-qqZXPW52Zq2K8Zuejh1hbW25HppLS8WTTkootlgCBpoHb1lNO747h6_8yg5kKVx_ulLaZq1wpfetIQ"

echo "Для отправки push уведомления нужен Server Key из Firebase Console."
echo "1. Перейдите в Firebase Console: https://console.firebase.google.com/"
echo "2. Выберите проект: todo-list-bc1c5"
echo "3. Перейдите в Project Settings > Cloud Messaging"
echo "4. Скопируйте Server Key"
echo ""
echo "FCM Token для тестирования:"
echo "$FCM_TOKEN"
echo ""
echo "Вы можете использовать Firebase Console для отправки тестового уведомления:"
echo "1. В Firebase Console перейдите в Cloud Messaging"
echo "2. Нажмите 'Send your first message'"
echo "3. Введите заголовок и текст"
echo "4. В Target выберите 'Send test message'"
echo "5. Вставьте FCM Token: $FCM_TOKEN"

# Альтернативно, можно использовать Firebase CLI
echo ""
echo "Или установите Firebase CLI и используйте команду:"
echo "npm install -g firebase-tools"
echo "firebase login"
echo "firebase use todo-list-bc1c5"
