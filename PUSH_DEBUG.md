# Диагностика Push Уведомлений

## Основные проблемы и решения

### 1. Push уведомления не работают в iOS Simulator
**Проблема**: iOS Simulator не поддерживает FCM push уведомления.
**Решение**: Используйте реальное iOS устройство для тестирования.

### 2. Права доступа для iOS
**Проверьте файлы:**
- `ios/Runner/Info.plist` должен содержать:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

- `ios/Runner/Runner.entitlements` должен содержать:
```xml
<key>aps-environment</key>
<string>development</string>
```

### 3. Firebase конфигурация
**Проверьте файлы:**
- `GoogleService-Info.plist` должен быть добавлен в iOS проект
- `android/app/google-services.json` должен быть добавлен в Android проект
- Bundle ID должен совпадать в Firebase Console и приложении

### 4. Разрешения Android
**Проверьте в `android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

### 5. Проверка FCM токена
При запуске приложения в консоли должен появиться FCM токен:
```
Flutter: FCM Token: [длинная строка токена]
```

### 6. Тестирование уведомлений
1. **Локальные уведомления**: Используйте кнопку "Тест уведомления" в меню приложения
2. **Push уведомления**: Используйте скрипт `test_push.sh` (замените токен)

### 7. Отладка
**Добавьте логи в код:**
```dart
// В main.dart
debugPrint('Firebase initialized successfully');

// В NotificationService.dart
debugPrint('FCM Token: $token');
debugPrint('Notification permission: ${settings.authorizationStatus}');
```

### 8. Типичные ошибки
- **"MissingPluginException"**: Перезапустите приложение после добавления плагинов
- **"FirebaseApp not initialized"**: Проверьте вызов `Firebase.initializeApp()` в main.dart
- **"Invalid bundle ID"**: Bundle ID в Firebase должен совпадать с приложением

### 9. Проверка состояния
```bash
# Проверить установленные пакеты
flutter pub deps

# Очистить и пересобрать
flutter clean
flutter pub get
flutter run
```

### 10. Продакшн настройки
Для продакшн версии измените в `Runner.entitlements`:
```xml
<key>aps-environment</key>
<string>production</string>
```
