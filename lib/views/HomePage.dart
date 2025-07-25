import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list_app/pages/ItemDetailsPage.dart';
import 'package:list_app/viewmodels/ItemListViewModel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  void handleUpdateButton(BuildContext context, ItemListViewModel viewModel, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(
          pageTitle: 'Обновление элемента',
          submitButtonText: 'Сохранить',
          item: viewModel.items[index],
          onSubmit: viewModel.updateItem,
        ),
      ),
    );
  }

  void handleRemoveButton(ItemListViewModel viewModel, int index) {
    viewModel.removeItem(viewModel.items[index].id);
  }

  void handleAddButton(BuildContext context, ItemListViewModel viewModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(
          pageTitle: 'Добавление элемента',
          submitButtonText: 'Добавить',
          item: viewModel.createEmptyItem(),
          onSubmit: viewModel.addItem,
        ),
      ),
    );
  }


  
@override
  Widget build(BuildContext context) {
    return Consumer<ItemListViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title),
          ),
          body: Center(
            child: ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: viewModel.items[index].isDone,
                    onChanged: (bool? value) {
                      viewModel.toggleItemDone(viewModel.items[index]);
                    },
                  ),
                  title: Text(viewModel.items[index].title),
                  subtitle: Text(viewModel.items[index].description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => handleUpdateButton(context, viewModel, index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => handleRemoveButton(viewModel, index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => handleAddButton(context, viewModel),
            tooltip: 'Добавить',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

}

