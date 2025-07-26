import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list_app/views/ItemDetailsPage.dart';
import 'package:list_app/viewmodels/ItemListViewModel.dart';
import 'package:list_app/services/NotificationService.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  void handleUpdateButton(
    BuildContext context,
    ItemListViewModel viewModel,
    int index,
  ) {
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
            title: Padding(padding: EdgeInsets.only(left: 14),child: Text(title)),
            actions: [
              // Добавим кнопку для очистки всех данных
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'clear') {
                    _showClearConfirmDialog(context, viewModel);
                  } else if (value == 'reload') {
                    viewModel.reloadItems();
                  } else if (value == 'test_notification') {
                    NotificationService.showTestNotification();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'reload',
                    child: Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text('Обновить'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'test_notification',
                    child: Row(
                      children: [
                        Icon(Icons.notifications),
                        SizedBox(width: 8),
                        Text('Тест уведомления'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all),
                        SizedBox(width: 8),
                        Text('Очистить все'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.items.isEmpty
              ? const Center(
                  child: Text(
                    'Список пуст.\nДобавьте первый элемент!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Center(
                  child: ListView.builder(
                    itemCount: viewModel.items.length,
                    itemBuilder: (context, index) {
                      final item = viewModel.items[index];
                      final hasDescription = item.description.isNotEmpty;
                      
                      return ListTile(
                        leading: Checkbox(
                          value: item.isDone,
                          onChanged: (bool? value) {
                            viewModel.toggleItemDone(item);
                          },
                        ),
                        title: Text(item.title),
                        subtitle: hasDescription ? Text(item.description) : null,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: hasDescription ? 0.0 : 8.0,
                        ),
                        minVerticalPadding: hasDescription ? 8.0 : 16.0,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  handleUpdateButton(context, viewModel, index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  handleRemoveButton(viewModel, index),
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

  // Диалог подтверждения очистки данных
  void _showClearConfirmDialog(
    BuildContext context,
    ItemListViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: const Text('Вы уверены, что хотите удалить все элементы?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              viewModel.clearAllItems();
              Navigator.of(context).pop();
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
