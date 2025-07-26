import 'package:flutter/material.dart';
import 'package:list_app/models/Item.dart';
import 'package:list_app/services/StorageService.dart';
import 'package:list_app/services/NotificationService.dart';

class ItemListViewModel extends ChangeNotifier {
  final List<Item> _items = [];
  List<Item> get items => _items;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Конструктор - загружаем данные при создании
  ItemListViewModel() {
    _loadItems();
  }

  // Загрузка данных из хранилища
  Future<void> _loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loadedItems = await StorageService.loadItems();
      _items.clear();
      _items.addAll(loadedItems);
      
      // Настроить напоминания для загруженных задач
      for (var item in _items) {
        if (item.reminderEnabled && !item.isDone) {
          await NotificationService.setupPeriodicReminder(item);
        }
      }
    } catch (e) {
      debugPrint('Ошибка загрузки данных: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Сохранение данных в хранилище
  Future<void> _saveItems() async {
    try {
      await StorageService.saveItems(_items);
    } catch (e) {
      debugPrint('Ошибка сохранения данных: $e');
    }
  }

  void addItem(Item item) {
    _items.add(item);
    _saveItems();
    
    // Настроить напоминания для новой задачи
    if (item.reminderEnabled && !item.isDone) {
      NotificationService.setupPeriodicReminder(item);
    }
    
    notifyListeners();
  }

  Item createEmptyItem() {
    return Item(
      title: '', 
      description: '', 
      id: _getUniqueId(), 
      isDone: false,
      reminderEnabled: false,
    );
  }

  void removeItem(int id) {
    // Отменить напоминания для удаляемой задачи
    NotificationService.cancelPeriodicReminder(id);
    
    _items.removeWhere((item) => item.id == id);
    _saveItems();
    notifyListeners();
  }

  void updateItem(Item item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      _saveItems();
      
      // Обновить напоминания
      if (item.isDone || !item.reminderEnabled) {
        // Отменить напоминания если задача выполнена или отключены
        NotificationService.cancelPeriodicReminder(item.id);
      } else if (item.reminderEnabled && !item.isDone) {
        // Настроить новые напоминания
        NotificationService.setupPeriodicReminder(item);
      }
    }
    notifyListeners();
  }

  void toggleItemDone(Item item) {
    Item newItem = item.copyWith(isDone: !item.isDone);
    
    // Если задача выполнена, отменить напоминания
    if (newItem.isDone) {
      NotificationService.cancelPeriodicReminder(newItem.id);
    } else if (newItem.reminderEnabled) {
      // Если задача снова не выполнена и включены напоминания
      NotificationService.setupPeriodicReminder(newItem);
    }
    
    updateItem(newItem);
  }

  // Метод для очистки всех данных
  Future<void> clearAllItems() async {
    // Отменить все напоминания
    NotificationService.clearAllReminders();
    
    _items.clear();
    await StorageService.clearItems();
    notifyListeners();
  }

  // Принудительная перезагрузка данных
  Future<void> reloadItems() async {
    await _loadItems();
  }

  int _getUniqueId() {
    return _items.isNotEmpty
        ? _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1
        : 1;
  }
}
