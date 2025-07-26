# 📱 TODO App с Push Уведомлениями и Периодическими Напоминаниями

Flutter приложение для управления задачами с поддержкой автоматических push уведомлений и настраиваемых периодических напоминаний.

## 🚀 Новые возможности

- ✅ **MVVM архитектура** с Provider state management
- 💾 **Постоянное хранение данных** с SharedPreferences  
- 🔔 **Push уведомления** через Firebase Cloud Messaging
- ⏰ **Периодические напоминания** - настраиваемый интервал уведомлений
- 📱 **Локальные уведомления** для надежности
- 🎛️ **Гибкие настройки** напоминаний в интерфейсе создания задач
- 🎨 **Современный Material Design** интерфейс

## 🔧 Как работают периодические напоминания

### **В ItemDetailsPage:**
1. **Переключатель "Напоминания"** - включение/выключение уведомлений
2. **Выбор периода** - 5 мин, 15 мин, 30 мин, 1 ч, 2 ч, 4 ч
3. **Автоматическая настройка** при сохранении задачи

### **Логика работы:**
```dart
// При создании/обновлении задачи
if (item.reminderEnabled && !item.isDone) {
  NotificationService.setupPeriodicReminder(item);
}

// При выполнении задачи
if (newItem.isDone) {
  NotificationService.cancelPeriodicReminder(newItem.id);
}
```

### **Типы уведомлений:**
- **Локальные уведомления**: работают без интернета
- **Push уведомления**: через Firebase (требует настройки)
- **Периодические**: автоматически каждые N минут/часов

## 🎯 Использование

### **1. Создание задачи с напоминаниями:**
1. Нажмите "+" для создания новой задачи
2. Заполните название и описание
3. Включите переключатель "Напоминания"
4. Выберите период (например, каждые 30 минут)
5. Сохраните задачу

### **2. Что происходит автоматически:**
- Каждые N минут приходит уведомление
- При выполнении задачи напоминания останавливаются
- При удалении задачи напоминания отменяются
- При загрузке приложения напоминания восстанавливаются

## 🛠️ Настройка Firebase (для Push уведомлений)

### **1. Создайте проект Firebase:**
1. [Firebase Console](https://console.firebase.google.com/)
2. "Create project" → введите название
3. Включите Google Analytics (опционально)

### **2. Добавьте iOS приложение:**
1. В Firebase Console: "Add app" → iOS
2. Bundle ID: `com.example.listApp`
3. Скачайте `GoogleService-Info.plist`
4. Добавьте файл в `ios/Runner/` через Xcode

### **3. Обновите firebase_options.dart:**
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'ваш-реальный-ключ',
  appId: 'ваш-app-id',
  messagingSenderId: 'ваш-sender-id',
  projectId: 'ваш-project-id',
  storageBucket: 'ваш-проект.appspot.com',
);
```
    flutter run
    ```
- Сборка APK для Android:
    ```bash
    flutter build apk
    ```
- Сборка приложения для iOS:
    ```bash
    flutter build ios
    ```
- Запуск тестов:
    ```bash
    flutter test
    ```
- Проверка кода на ошибки:
    ```bash
    flutter analyze
    ```




This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
