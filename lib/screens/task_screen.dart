import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/voice_service.dart';
import '../repositories/task_repository.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final VoiceService _voiceService = VoiceService();
  final TaskRepository _taskRepository = TaskRepository();
  List<Task> _tasks = [];
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _voiceService.initialize();
    await _taskRepository.init();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskRepository.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
    } else {
      await _voiceService.startListening();
    }
    setState(() {
      _isListening = !_isListening;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow Solutions'),
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _toggleListening,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                _taskRepository.markTaskAsCompleted(task.id);
                _loadTasks();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleListening,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
} 