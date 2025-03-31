import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  String category;

  @HiveField(6)
  int priority; // 0: Low, 1: Medium, 2: High

  @HiveField(7)
  DateTime createdAt;

  Task({
    String? id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    this.category = 'Personal',
    this.priority = 1,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? category,
    int? priority,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      createdAt: createdAt,
    );
  }
} 