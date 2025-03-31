import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task_model.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(TaskAdapter());
  
  runApp(const MyApp());
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final hasDueDate = reader.readBool();
    final dueDate = hasDueDate ? DateTime.fromMillisecondsSinceEpoch(reader.readInt()) : null;
    final isCompleted = reader.readBool();
    final category = reader.readString();
    final priority = reader.readInt();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    
    return Task(
      id: id,
      title: title,
      description: description.isEmpty ? null : description,
      dueDate: dueDate,
      isCompleted: isCompleted,
      category: category,
      priority: priority,
      createdAt: createdAt,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description ?? '');
    writer.writeBool(obj.dueDate != null);
    if (obj.dueDate != null) {
      writer.writeInt(obj.dueDate!.millisecondsSinceEpoch);
    }
    writer.writeBool(obj.isCompleted);
    writer.writeString(obj.category);
    writer.writeInt(obj.priority);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Taskeso',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getLightTheme(),
        home: const HomeScreen(),
      ),
    );
  }
} 