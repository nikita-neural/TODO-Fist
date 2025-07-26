class Item {
  final String title;
  final String description;
  final int id;
  final bool isDone;
  final DateTime? reminderTime;
  final double? reminderPeriodMinutes; // Период напоминаний в минутах (может быть дробным для тестирования)
  final bool reminderEnabled;

  Item({
    required this.title,
    required this.description,
    required this.id,
    required this.isDone,
    this.reminderTime,
    this.reminderPeriodMinutes,
    this.reminderEnabled = false,
  });

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'id': id,
      'isDone': isDone,
      'reminderTime': reminderTime?.millisecondsSinceEpoch,
      'reminderPeriodMinutes': reminderPeriodMinutes,
      'reminderEnabled': reminderEnabled,
    };
  }

  // Фабричный метод для создания объекта из JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'] as String,
      description: json['description'] as String,
      id: json['id'] as int,
      isDone: json['isDone'] as bool,
      reminderTime: json['reminderTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['reminderTime'] as int)
          : null,
      reminderPeriodMinutes: json['reminderPeriodMinutes'] != null 
          ? (json['reminderPeriodMinutes'] as num).toDouble()
          : null,
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
    );
  }

  // Метод для создания копии с изменениями
  Item copyWith({
    String? title,
    String? description,
    int? id,
    bool? isDone,
    DateTime? reminderTime,
    double? reminderPeriodMinutes,
    bool? reminderEnabled,
  }) {
    return Item(
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id,
      isDone: isDone ?? this.isDone,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderPeriodMinutes: reminderPeriodMinutes ?? this.reminderPeriodMinutes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    );
  }
}
