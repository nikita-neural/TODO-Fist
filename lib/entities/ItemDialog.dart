import 'package:flutter/material.dart';
import 'package:list_app/pages/HomePage.dart';

class ItemDialog extends StatefulWidget {
  final Item? item;
  final void Function(Item) onSubmit;
  final String windowTitle;
  final String submitButtonText;

  const ItemDialog({
    Key? key,
    this.item,
    required this.onSubmit,
    required this.windowTitle,
    required this.submitButtonText,
  }) : super(key: key);

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  Color _fieldBorderColor = Colors.grey;
  bool isFieldStatusShowing = false;
  bool isFormValid = false;

  void setColor() {
    if (isFormValid) {
      _setSuccessColor();
    } else {
      _setErrorColor();
    }
  }

  void updateFields() {
    isFormValid = titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
    if (isFieldStatusShowing) {
      setColor();
    } else {
      isFieldStatusShowing = true;
    }
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
    titleController = TextEditingController(text: widget.item?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
  }

  void _setErrorColor() {
    setState(() {
      _fieldBorderColor = Colors.red;
    });
  }

  void _setSuccessColor() {
    setState(() {
      _fieldBorderColor = Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.windowTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Заголовок',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _fieldBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _fieldBorderColor, width: 2.0),
              ),
            ),
            controller: titleController,
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              labelText: 'Описание',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _fieldBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _fieldBorderColor, width: 2.0),
              ),
            ),
            controller: descriptionController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = titleController.text;
            final description = descriptionController.text;
            if (title.isNotEmpty && description.isNotEmpty) {
              widget.onSubmit(
                Item(
                  id: widget.item?.id ?? 0, // id задайте по-своему
                  title: title,
                  description: description,
                ),
              );
              Navigator.of(context).pop();
            } else {
              _setErrorColor();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Пожалуйста, заполните все поля.'),
                ),
              );
            }
          },
          child: Text(widget.submitButtonText),
        ),
      ],
    );
  }
}
