import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:list_app/models/Item.dart';

class StorageService {
  static const String _itemsKey = 'todo_items';

  // Сохранение списка элементов
  static Future<void> saveItems(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_itemsKey, jsonString);
  }

  // Загрузка списка элементов
  static Future<List<Item>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_itemsKey);
    
    if (jsonString == null) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((json) => Item.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Если произошла ошибка при парсинге, возвращаем пустой список
      return [];
    }
  }

  // Очистка сохраненных данных
  static Future<void> clearItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_itemsKey);
  }
}
