import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TaskRepository {
  static const String _boxName = 'tasks';
  late Box<Task> _taskBox;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    _taskBox = await Hive.openBox<Task>(_boxName);
  }

  Future<List<Task>> getAllTasks() async {
    return _taskBox.values.toList();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String taskId) async {
    await _taskBox.delete(taskId);
  }

  Future<void> markTaskAsCompleted(String taskId) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      final updatedTask = task.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      await _taskBox.put(taskId, updatedTask);
    }
  }

  Future<void> clearAllTasks() async {
    await _taskBox.clear();
  }
} 