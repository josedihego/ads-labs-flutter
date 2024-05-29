import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:crud_tasks/consts.dart';

class Task {
  int id;
  final String title;
  final String description;
  final String responsible;
  final String status;
  final String priority;
  final DateTime deadline;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.responsible,
    required this.status,
    required this.priority,
    required this.deadline,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['titulo'],
        description: json['descricao'],
        responsible: json['responsavel'],
        status: json['status'],
        priority: json['prioridade'],
        deadline: DateTime.parse(json['data_limite']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': title,
        'descricao': description,
        'responsavel': responsible,
        'status': status,
        'prioridade': priority,
        'data_limite': deadline.toIso8601String(),
      };
  Map<String, dynamic> toJsonForAdd() => {
        'titulo': title,
        'descricao': description,
        'responsavel': responsible,
        'status': status,
        'prioridade': priority,
        'data_limite': deadline.toIso8601String(),
      };
}

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  Future<void> fetchTasks() async {
    const url = 'http://$localhost:3000/tarefas';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> taskData = data['tarefas'];
      tasks = taskData.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(Task task) async {
    const url = 'http://$localhost:3000/tarefas';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJsonForAdd()),
    );
    if (response.statusCode != 200) {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add task');
    } else {
      tasks.add(task);
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    final url = 'http://$localhost:3000/tarefas/$taskId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    } else {
      tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    }
  }

  Future<void> editTask(int taskId, Task updatedTask) async {
    final url = 'http://$localhost:3000/tarefas/$taskId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedTask.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit task');
    } else {
      final index = tasks.indexWhere((task) => task.id == taskId);
      tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
