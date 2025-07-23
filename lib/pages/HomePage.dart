
import 'package:flutter/material.dart';
import 'package:list_app/entities/ItemDialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class Item {
  final String title;
  final String description;
  final int id;

  Item({required this.title, required this.description, required this.id});
}

class _HomePageState extends State<HomePage> {

  final List<Item> _items = [
    Item(title: "Item 1", description: "Description of Item 1", id: 1),
    Item(title: "Item 2", description: "Description of Item 2", id: 2),
    Item(title: "Item 3", description: "Description of Item 3", id: 3),
  ];


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
    setState(()  {   
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
          _items[index] = item;
        }
    });
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
          itemBuilder: (context,index) {
            return ListTile(
              title: Text(_items[index].title),
              subtitle: Text(_items[index].description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ItemDialog(
                        windowTitle: 'Редактировать элемент',
                        submitButtonText: 'Сохранить',
                        item: _items[index],
                        onSubmit: _updateItem,
                      );
                    },
                  );
                },
              ),IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeItem(_items[index].id),
              ),],)
            );
          },
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return ItemDialog(
                  windowTitle: 'Добавить элемент',
                  submitButtonText: 'Добавить',
                  onSubmit: _addItem,
                );
              },
            );
      },
      tooltip: 'Добавить',
        child: const Icon(Icons.add),
      ),
    );
  }
}
