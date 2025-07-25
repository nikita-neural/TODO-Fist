import 'package:flutter/material.dart';
import 'package:list_app/pages/ItemDetailsPage.dart';
import 'package:list_app/models/Item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Item> _items = [
    Item(
      title: "Item 1",
      description: "Description of Item 1",
      id: 1,
      isDone: false,
    ),
    Item(
      title: "Item 2",
      description: "Description of Item 2",
      id: 2,
      isDone: true,
    ),
    Item(
      title: "Item 3",
      description: "Description of Item 3",
      id: 3,
      isDone: false,
    ),
  ];

  int getUniqueId() {
    return _items.isNotEmpty
        ? _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1
        : 1;
  }

  void handleUpdateButton(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(
          pageTitle: 'Обновление элемента',
          submitButtonText: 'Сохранить',
          item: _items[index],
          onSubmit: _updateItem,
        ),
      ),
    );
  }

  void handleRemoveButton(int index) {
    _removeItem(_items[index].id);
  }

  void handleAddButton() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(
          pageTitle: 'Добавление элемента',
          submitButtonText: 'Добавить',
          item: Item(
            title: '',
            description: '',
            id: getUniqueId(),
            isDone: false,
          ),
          onSubmit: _addItem,
        ),
      ),
    );
  }

  void _addItem(Item item) {
    setState(() {
      _items.add(item);
    });
  }

  void _removeItem(int id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  void _updateItem(Item item) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
      }
    });
  }

  void _updateIsDoneProperty(Item item) {
   Item newItem = Item(
      description: item.description,
      title: item.title,
      id: item.id,
      isDone: !item.isDone,
    );
   
    _updateItem(newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Checkbox(
                value: _items[index].isDone,
                onChanged: (bool? value) {
                 _updateIsDoneProperty(_items[index]);
                },
              ),
              title: Text(_items[index].title),
              subtitle: Text(_items[index].description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => handleUpdateButton(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => handleRemoveButton(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleAddButton,
        tooltip: 'Добавить',
        child: const Icon(Icons.add),
      ),
    );
  }
}
