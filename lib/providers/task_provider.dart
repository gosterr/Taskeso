import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  static const String _boxName = 'tasks';
  List<Task> _tasks = [];
  String _filter = 'All'; // All, Completed, Pending
  String _categoryFilter = 'All';

  // Getters
  List<Task> get tasks {
    if (_filter == 'All' && _categoryFilter == 'All') {
      return _tasks;
    } else if (_filter != 'All' && _categoryFilter == 'All') {
      return _tasks.where((task) {
        if (_filter == 'Completed') return task.isCompleted;
        return !task.isCompleted;
      }).toList();
    } else if (_filter == 'All' && _categoryFilter != 'All') {
      return _tasks.where((task) => task.category == _categoryFilter).toList();
    } else {
      return _tasks.where((task) {
        final filterMatch = _filter == 'Completed' 
            ? task.isCompleted 
            : !task.isCompleted;
        final categoryMatch = task.category == _categoryFilter;
        return filterMatch && categoryMatch;
      }).toList();
    }
  }

  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  
  String get filter => _filter;
  String get categoryFilter => _categoryFilter;

  // Set filters
  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _categoryFilter = category;
    notifyListeners();
  }

  // Initialize provider and load tasks
  Future<void> initialize() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Task>(_boxName);
    }
    _loadTasks();
  }

  // Load tasks from Hive
  void _loadTasks() {
    final box = Hive.box<Task>(_boxName);
    _tasks = box.values.toList();
    _sortTasks();
    notifyListeners();
  }

  // Sort tasks by completion status and due date
  void _sortTasks() {
    _tasks.sort((a, b) {
      // First sort by completion status
      if (a.isCompleted && !b.isCompleted) return 1;
      if (!a.isCompleted && b.isCompleted) return -1;

      // Then sort by priority for uncompleted tasks
      if (!a.isCompleted && !b.isCompleted) {
        if (a.priority != b.priority) return b.priority.compareTo(a.priority);
      }

      // Then sort by due date (if available)
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      } else if (a.dueDate != null) {
        return -1;
      } else if (b.dueDate != null) {
        return 1;
      }

      // Finally sort by creation date
      return a.createdAt.compareTo(b.createdAt);
    });
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    final box = Hive.box<Task>(_boxName);
    await box.put(task.id, task);
    _loadTasks();
  }

  // Update an existing task
  Future<void> updateTask(Task updatedTask) async {
    final box = Hive.box<Task>(_boxName);
    await box.put(updatedTask.id, updatedTask);
    _loadTasks();
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    final box = Hive.box<Task>(_boxName);
    await box.delete(id);
    _loadTasks();
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    final task = _tasks.firstWhere((task) => task.id == id);
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  // Get a list of all categories
  List<String> getAllCategories() {
    final categories = _tasks.map((task) => task.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  // Get tasks statistics
  Map<String, int> getTaskStatistics() {
    final total = _tasks.length;
    final completed = completedTasks.length;
    final pending = pendingTasks.length;
    
    // Calculate tasks by priority
    final lowPriority = _tasks.where((task) => task.priority == 0).length;
    final mediumPriority = _tasks.where((task) => task.priority == 1).length;
    final highPriority = _tasks.where((task) => task.priority == 2).length;
    
    // Calculate overdue tasks
    final overdue = _tasks.where((task) {
      if (task.isCompleted) return false;
      if (task.dueDate == null) return false;
      return task.dueDate!.isBefore(DateTime.now());
    }).length;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'lowPriority': lowPriority,
      'mediumPriority': mediumPriority,
      'highPriority': highPriority,
      'overdue': overdue,
    };
  }
} 