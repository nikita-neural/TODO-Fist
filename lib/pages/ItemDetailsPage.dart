import 'package:flutter/material.dart';
import 'package:list_app/models/Item.dart';
import 'package:list_app/shared/TextInput.dart';

class ItemDetailsPage extends StatefulWidget {
  final Item item;
  final void Function(Item) onSubmit;
  final String pageTitle;
  final String submitButtonText;

  const ItemDetailsPage({
    required this.item,
    required this.onSubmit,
    required this.pageTitle,
    required this.submitButtonText,
    super.key,
  });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool isFieldStatusShowing = false;
  bool isTitleValid = false;
  bool isTitleInputError = false;
  bool isTitleInputSuccess = false;
  bool validateTitleField() => titleController.text.isNotEmpty;

  void updateTitleFieldStatus() {
    if (isFieldStatusShowing) {
      setState(() {
        isTitleInputError = !isTitleValid;
        isTitleInputSuccess = isTitleValid;
      });
    }
  }

  void updateFields() {
    isTitleValid = validateTitleField();
    updateTitleFieldStatus();
  }

  void submitButtonHandler() {
    isFieldStatusShowing = true;
    updateTitleFieldStatus();
    if (isTitleValid) {
      widget.onSubmit(
        Item(
          id: widget.item.id,
          title: titleController.text,
          description: descriptionController.text,
          isDone: widget.item.isDone,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void canselButtonHandler() {
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    titleController.addListener(updateFields);
    descriptionController.addListener(updateFields);
  }

  @override
  void dispose() {
    titleController.removeListener(updateFields);
    descriptionController.removeListener(updateFields);
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    descriptionController = TextEditingController(
      text: widget.item.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.pageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            TextInput(
              controller: titleController,
              label: "Заголовок",
              isError: isTitleInputError,
              isSuccess: isTitleInputSuccess,
              errorText: "Поле обязательно",
            ),

            TextInput(
              controller: descriptionController,
              label: "Описание",
              isMultiline: true,
              minLines: 1,
              maxLines: 10,
            ),
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: canselButtonHandler,
            label: const Text('Отмена'),
            icon: const Icon(Icons.close),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            onPressed: submitButtonHandler,
            label: Text(widget.submitButtonText),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
