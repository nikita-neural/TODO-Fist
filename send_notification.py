#!/usr/bin/env python3
import requests
import json

# Замените на ваш Server Key из Firebase Console
SERVER_KEY = "AAAA-2Q5L3k:APA91bElqcIQJ3RHXcuHp1FgEVd8PKU8GsZRaBpD7YTcMn3mQTW4EZYkQGEQ7wC5EYQcnQjS7Xs6iM9zO5eEZK13m0a5rEKzjYrCxX6uUZFjYQ3EoOKhcxQ"

# FCM Token из приложения (возьмите из логов)
FCM_TOKEN = "crf3N5OtR4SwpP-pUP8e9m:APA91bE7RoU7E7S-lbmDwMS4EQ4LNQgQeshuEB7B-qqZXPW52Zq2K8Zuejh1hbW25HppLS8WTTkootlgCBpoHb1lNO747h6_8yg5kKVx_ulLaZq1wpfetIQ"

def send_push_notification():
    url = "https://fcm.googleapis.com/fcm/send"
    
    headers = {
        "Authorization": f"key={SERVER_KEY}",
        "Content-Type": "application/json"
    }
    
    payload = {
        "to": FCM_TOKEN,
        "notification": {
            "title": "Тестовое уведомление! 🎉",
            "body": "Проверяем новую иконку в статус баре",
            "icon": "ic_notification"
        },
        "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "test": "true"
        },
        "android": {
            "notification": {
                "icon": "ic_notification",
                "color": "#667eea",
                "sound": "notification_sound",
                "channel_id": "high_importance_channel"
            }
        }
    }
    
    response = requests.post(url, headers=headers, data=json.dumps(payload))
    
    if response.status_code == 200:
        print("✅ Уведомление успешно отправлено!")
        print(f"Response: {response.json()}")
    else:
        print(f"❌ Ошибка отправки: {response.status_code}")
        print(f"Response: {response.text}")

if __name__ == "__main__":
    send_push_notification()
