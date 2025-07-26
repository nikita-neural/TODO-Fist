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

  // Новые поля для напоминаний
  bool reminderEnabled = false;
  double reminderPeriodMinutes = 30; // По умолчанию 30 минут
  DateTime? reminderTime;

  // Предустановленные периоды напоминаний
  // 0.17 минуты = 10 секунд (для тестирования)
  final List<double> reminderPeriods = [
    5,
    15,
    30,
    60,
    120,
    240,
    60 * 24,
    60 * 24 * 2,
    60 * 24 * 7,
  ]; // в минутах

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
    updateFields();
    if (isTitleValid) {
      widget.onSubmit(
        Item(
          id: widget.item.id,
          title: titleController.text,
          description: descriptionController.text,
          isDone: widget.item.isDone,
          reminderEnabled: reminderEnabled,
          reminderPeriodMinutes: reminderEnabled ? reminderPeriodMinutes : null,
          reminderTime: reminderEnabled ? reminderTime : null,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void canselButtonHandler() {
    Navigator.of(context).pop();
  }

  String getReminderPeriodText(double minutes) {
    if (minutes < 1.0) {
      // Для периодов меньше минуты показываем секунды
      final seconds = (minutes * 60).round();
      return '$seconds сек';
    } else if (minutes < 60) {
      if (minutes == minutes.toInt()) {
        return '${minutes.toInt()} мин';
      } else {
        return '${minutes.toStringAsFixed(1)} мин';
      }
    } else if (minutes >= 60 && minutes < 60 * 24) {
      final hours = minutes / 60;
      if (hours == hours.toInt()) {
        return '${hours.toInt()} ч';
      } else {
        return '${hours.toStringAsFixed(1)} ч';
      }
    } else  {
      final days = minutes / 60 / 24;
      if (days == days.toInt()) {
        return '${days.toInt()} д';
      } else {
        return '${days.toStringAsFixed(1)} д';
      }
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
    titleController = TextEditingController(text: widget.item.title);
    descriptionController = TextEditingController(
      text: widget.item.description,
    );

    // Инициализация настроек напоминаний из существующего элемента
    reminderEnabled = widget.item.reminderEnabled;
    reminderPeriodMinutes = widget.item.reminderPeriodMinutes ?? 30.0;
    reminderTime = widget.item.reminderTime;
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
        child: SingleChildScrollView(
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

              const SizedBox(height: 20),

              // Секция настройки напоминаний
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications_outlined),
                          const SizedBox(width: 8),
                          const Text(
                            'Напоминания',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: reminderEnabled,
                            onChanged: (value) {
                              setState(() {
                                reminderEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),

                      if (reminderEnabled) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Период напоминаний:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: reminderPeriods
                              .map(
                                (period) => FilterChip(
                                  label: Text(getReminderPeriodText(period)),
                                  selected: reminderPeriodMinutes == period,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        reminderPeriodMinutes = period;
                                      });
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Уведомления будут приходить каждые ${getReminderPeriodText(reminderPeriodMinutes)} пока задача не выполнена',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "cancel_button",
            onPressed: canselButtonHandler,
            label: const Text('Отмена'),
            icon: const Icon(Icons.close),
            backgroundColor: Colors.white70,
          ),
          const SizedBox(height: 16),

          FloatingActionButton.extended(
            heroTag: "submit_button",
            onPressed: submitButtonHandler,
            label: Text(widget.submitButtonText),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
