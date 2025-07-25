import 'package:flutter/material.dart';
import 'package:list_app/models/Item.dart';

class ItemListViewModel extends ChangeNotifier {
  final List<Item> _items = [];
  List<Item> get items => _items;

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  Item createEmptyItem() {
    return Item(title: '', description: '', id: _getUniqueId(), isDone: false);
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateItem(Item item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
    notifyListeners();
  }

  void toggleItemDone(Item item) {
    Item newItem = Item(
      description: item.description,
      title: item.title,
      id: item.id,
      isDone: !item.isDone,
    );
    updateItem(newItem);
    notifyListeners();
  }

  int _getUniqueId() {
    return _items.isNotEmpty
        ? _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1
        : 1;
  }
}
