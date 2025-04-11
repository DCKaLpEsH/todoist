import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoist/presentation/widgets/empty_state.dart';
import 'package:todoist/presentation/theme/app_theme.dart';
import 'package:todoist/presentation/widgets/filter_bar.dart';
import 'package:todoist/presentation/widgets/todo_input.dart';
import 'package:todoist/presentation/widgets/todo_list_item.dart';
import '../../providers/todo_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context),
                  Consumer<TodoProvider>(
                    builder: (context, todoProvider, _) {
                      return FilterBar(
                        currentFilter: todoProvider.filter,
                        onFilterChanged: todoProvider.setFilter,
                        totalCount: todoProvider.totalTodos,
                        activeCount: todoProvider.activeTodos,
                        completedCount: todoProvider.completedTodos,
                      );
                    },
                  ),
                  Expanded(child: _buildTodoList()),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Consumer<TodoProvider>(
                  builder: (context, todoProvider, _) {
                    return TodoInput(onAddTodo: todoProvider.addTodo);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMedium,
        AppTheme.spacingLarge,
        AppTheme.spacingMedium,
        AppTheme.spacingMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Todo List',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Consumer<TodoProvider>(
                  builder: (context, todoProvider, _) {
                    final pendingTasks = todoProvider.activeTodos;
                    return Text(
                      pendingTasks == 0
                          ? 'All caught up! ✨'
                          : 'You have $pendingTasks pending ${pendingTasks == 1 ? 'task' : 'tasks'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer<TodoProvider>(
            builder: (context, todoProvider, _) {
              return todoProvider.completedTodos > 0
                  ? _buildClearCompletedButton(todoProvider)
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClearCompletedButton(TodoProvider todoProvider) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        todoProvider.clearCompleted();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMedium,
          vertical: AppTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline, size: 16, color: Colors.red.shade700),
            const SizedBox(width: 4),
            Text(
              'Clear done',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoList() {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, _) {
        if (todoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final todos = todoProvider.todos;
        if (todos.isEmpty) {
          switch (todoProvider.filter) {
            case TodoFilter.all:
              return EmptyState(
                message: 'No todos yet. Create one!',
                icon: Icons.task_alt,
                actionLabel: 'Add Todo',
                onAction: () {},
              );
            case TodoFilter.active:
              return const EmptyState(
                message: 'No active todos',
                icon: Icons.check_circle_outline,
              );
            case TodoFilter.completed:
              return const EmptyState(
                message: 'No completed todos',
                icon: Icons.check_circle,
              );
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoListItem(
              todo: todo,
              index: index,
              onToggle: todoProvider.toggleTodo,
              onDelete: todoProvider.deleteTodo,
              onUpdate: todoProvider.updateTodo,
            );
          },
        );
      },
    );
  }
}
