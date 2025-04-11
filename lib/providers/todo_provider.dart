import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/models/todo.dart';
import 'package:uuid/uuid.dart';

enum TodoFilter { all, active, completed }

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;
  final String _storageKey = 'todos';
  bool _isLoading = true;

  TodoProvider() {
    _loadTodos();
  }

  List<Todo> get todos {
    switch (_filter) {
      case TodoFilter.all:
        return _todos;
      case TodoFilter.active:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
    }
  }

  bool get isLoading => _isLoading;
  TodoFilter get filter => _filter;
  int get totalTodos => _todos.length;
  int get activeTodos => _todos.where((todo) => !todo.isCompleted).length;
  int get completedTodos => _todos.where((todo) => todo.isCompleted).length;

  void setFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> _loadTodos() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(_storageKey);

    if (todosJson != null) {
      final List<dynamic> decodedList = json.decode(todosJson);
      _todos = decodedList.map((item) => Todo.fromJson(item)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(
      _todos.map((todo) => todo.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedList);
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(
      id: const Uuid().v4(),
      title: title.trim(),
      createdAt: DateTime.now(),
    );

    _todos.add(newTodo);
    notifyListeners();
    await _saveTodos();
  }

  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      notifyListeners();
      await _saveTodos();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
    await _saveTodos();
  }

  Future<void> updateTodo(String id, String title) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(title: title.trim());
      notifyListeners();
      await _saveTodos();
    }
  }

  Future<void> clearCompleted() async {
    _todos.removeWhere((todo) => todo.isCompleted);
    notifyListeners();
    await _saveTodos();
  }
}
