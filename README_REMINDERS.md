# 📱 TODO App с Напоминаниями и Push Уведомлениями

Flutter приложение для управления задачами с поддержкой периодических напоминаний и push уведомлений.

## 🎯 **Что было реализовано:**

### ✅ **Сохранение данных с SharedPreferences**
- Автоматическое сохранение всех задач в локальное хранилище
- Загрузка задач при запуске приложения
- Поддержка новых полей: напоминания, периоды, время

### 🔔 **Система напоминаний**
- Настройка периодических напоминаний для каждой задачи
- Автоматическая отмена напоминаний при выполнении задачи
- Локальные уведомления каждый указанный период
- Push уведомления (требует настройки Firebase)

### 📋 **Расширенная модель Item**
- `reminderEnabled`: включены ли напоминания
- `reminderPeriodMinutes`: период в минутах (5, 15, 30, 60, 120, 240)
- `reminderTime`: время напоминания
- `copyWith()`: метод для создания копий с изменениями

## 🚀 **Как это работает:**

### **1. Сохранение данных**

```dart
// StorageService автоматически сохраняет данные
await StorageService.saveItems(_items);

// При запуске загружает сохраненные задачи
final loadedItems = await StorageService.loadItems();
```

### **2. Настройка напоминаний в ItemDetailsPage**

- Переключатель "Напоминания" включает/выключает функцию
- Выбор периода из готовых вариантов: 5 мин, 15 мин, 30 мин, 1 ч, 2 ч, 4 ч
- Информационная подсказка о работе напоминаний

### **3. Автоматическая обработка в ItemListViewModel**

```dart
// При добавлении задачи
void addItem(Item item) {
  _items.add(item);
  _saveItems(); // Сохранение
  
  // Настройка напоминаний
  if (item.reminderEnabled && !item.isDone) {
    NotificationService.setupPeriodicReminder(item);
  }
  
  notifyListeners();
}

// При выполнении задачи
void toggleItemDone(Item item) {
  Item newItem = item.copyWith(isDone: !item.isDone);
  
  // Отмена напоминаний если задача выполнена
  if (newItem.isDone) {
    NotificationService.cancelPeriodicReminder(newItem.id);
  }
  
  updateItem(newItem);
}
```

### **4. NotificationService - Периодические напоминания**

```dart
// Настройка периодического таймера
static Future<void> setupPeriodicReminder(Item item) async {
  if (!item.reminderEnabled || item.isDone) return;

  // Создаем периодический таймер
  _periodicTimers[item.id] = Timer.periodic(
    Duration(minutes: item.reminderPeriodMinutes!),
    (timer) async {
      // Показываем локальное уведомление
      await _showLocalNotification(
        title: 'Напоминание: ${item.title}',
        body: 'Не забудьте выполнить задачу: ${item.description}',
      );
      
      // Отправляем push уведомление
      await _sendReminderPushNotification(item);
    },
  );
}
```

## 🛠️ **Пошаговая инструкция реализации:**

### **Шаг 1: Добавление зависимостей в pubspec.yaml**

```yaml
dependencies:
  shared_preferences: ^2.2.2      # Локальное хранилище
  firebase_core: ^3.6.0           # Firebase SDK
  firebase_messaging: ^15.1.3     # Push уведомления
  flutter_local_notifications: ^18.0.1  # Локальные уведомления
  timezone: ^0.9.2                 # Работа с временными зонами
```

### **Шаг 2: Расширение модели данных**

```dart
class Item {
  final DateTime? reminderTime;
  final int? reminderPeriodMinutes;
  final bool reminderEnabled;
  
  // Метод copyWith для удобного обновления
  Item copyWith({
    bool? reminderEnabled,
    int? reminderPeriodMinutes,
    // ... другие поля
  }) {
    return Item(
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      // ... копирование остальных полей
    );
  }
}
```

### **Шаг 3: Создание StorageService**

```dart
class StorageService {
  static const String _itemsKey = 'todo_items';
  
  static Future<void> saveItems(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_itemsKey, jsonString);
  }
  
  static Future<List<Item>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_itemsKey);
    // ... парсинг и возврат данных
  }
}
```

### **Шаг 4: Создание NotificationService**

```dart
class NotificationService {
  static final Map<int, Timer?> _periodicTimers = {};
  
  static Future<void> setupPeriodicReminder(Item item) async {
    // Отменяем существующий таймер
    _periodicTimers[item.id]?.cancel();
    
    // Создаем новый периодический таймер
    _periodicTimers[item.id] = Timer.periodic(
      Duration(minutes: item.reminderPeriodMinutes!),
      (timer) async {
        await _showLocalNotification(/*...*/);
      },
    );
  }
}
```

### **Шаг 5: Обновление ViewModel**

```dart
class ItemListViewModel extends ChangeNotifier {
  // Загрузка при инициализации
  ItemListViewModel() {
    _loadItems();
  }
  
  // Автоматическое сохранение при изменениях
  void addItem(Item item) {
    _items.add(item);
    _saveItems(); // Сохранение
    
    // Настройка напоминаний
    if (item.reminderEnabled && !item.isDone) {
      NotificationService.setupPeriodicReminder(item);
    }
    
    notifyListeners();
  }
}
```

### **Шаг 6: UI для настройки напоминаний**

```dart
// В ItemDetailsPage добавить
Card(
  child: Column(
    children: [
      // Переключатель напоминаний
      Switch(
        value: reminderEnabled,
        onChanged: (value) => setState(() => reminderEnabled = value),
      ),
      
      // Выбор периода
      if (reminderEnabled)
        Wrap(
          children: reminderPeriods.map((period) => 
            FilterChip(
              label: Text(getReminderPeriodText(period)),
              selected: reminderPeriodMinutes == period,
              onSelected: (selected) {
                if (selected) {
                  setState(() => reminderPeriodMinutes = period);
                }
              },
            ),
          ).toList(),
        ),
    ],
  ),
)
```

## 🔥 **Ключевые особенности реализации:**

1. **Автоматическое управление**: Напоминания автоматически настраиваются/отменяются при изменении статуса задач

2. **Периодичность**: Уведомления приходят каждый указанный период времени пока задача не выполнена

3. **Персистентность**: Все данные сохраняются локально и восстанавливаются при перезапуске

4. **Гибкость**: Можно легко добавить новые периоды напоминаний или изменить логику

5. **Интеграция с Firebase**: Готовность к отправке push уведомлений через сервер

## 🧪 **Тестирование:**

1. Создайте новую задачу
2. Включите напоминания и выберите период (например, 5 минут)
3. Сохраните задачу
4. Через 5 минут придет локальное уведомление
5. Уведомления будут повторяться каждые 5 минут
6. Отметьте задачу как выполненную - уведомления прекратятся

## 📚 **Для изучения:**

- **SharedPreferences**: Локальное хранилище ключ-значение
- **Timer.periodic**: Периодическое выполнение кода
- **Flutter Local Notifications**: Локальные уведомления
- **Firebase Cloud Messaging**: Push уведомления
- **State Management**: Управление состоянием с Provider
