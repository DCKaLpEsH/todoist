import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/presentation/animations.dart';
import 'package:todoist/presentation/theme/app_theme.dart';

class TodoListItem extends StatefulWidget {
  final Todo todo;
  final Function(String) onToggle;
  final Function(String) onDelete;
  final Function(String, String) onUpdate;
  final int index;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onUpdate,
    required this.index,
  });

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _checkAnimation;
  bool _isEditing = false;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.todo.title);

    _controller = AnimationController(
      vsync: this,
      duration: AppTheme.mediumAnimationDuration,
    );

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    if (widget.todo.isCompleted) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TodoListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todo.isCompleted != oldWidget.todo.isCompleted) {
      if (widget.todo.isCompleted) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    if (widget.todo.title != oldWidget.todo.title) {
      _textController.text = widget.todo.title;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toggleComplete() {
    HapticFeedback.mediumImpact();
    widget.onToggle(widget.todo.id);
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveEdit() {
    if (_textController.text.trim().isNotEmpty) {
      widget.onUpdate(widget.todo.id, _textController.text);
    }
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimationUtils.slideInAnimation(
      index: widget.index,
      child: AnimationUtils.swipeAnimation(
        key: Key(widget.todo.id),
        onDismissed: (_) {
          HapticFeedback.mediumImpact();
          widget.onDelete(widget.todo.id);
        },
        child: AnimationUtils.checkboxAnimation(
          isChecked: widget.todo.isCompleted,
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMedium,
              vertical: AppTheme.spacingSmall,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              child: Row(
                children: [
                  AnimationUtils.tapAnimation(
                    onTap: _toggleComplete,
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMedium,
                      ),
                      decoration: BoxDecoration(
                        color:
                            widget.todo.isCompleted
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusSmall,
                        ),
                        border: Border.all(
                          color:
                              widget.todo.isCompleted
                                  ? AppTheme.primaryColor
                                  : AppTheme.primaryColor.withOpacity(0.6),
                          width: 1.5,
                        ),
                      ),
                      child: AnimatedBuilder(
                        animation: _checkAnimation,
                        builder: (context, child) {
                          return Icon(
                            Icons.check,
                            size: 18,
                            color: Theme.of(context).colorScheme.surface,
                          );
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                        _isEditing
                            ? TextField(
                              controller: _textController,
                              autofocus: true,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration:
                                    widget.todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                color:
                                    widget.todo.isCompleted
                                        ? AppTheme.textColorSecondary
                                        : AppTheme.textColorPrimary,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSmall,
                                ),
                              ),
                              onEditingComplete: _saveEdit,
                            )
                            : GestureDetector(
                              onDoubleTap: _startEditing,
                              child: AnimatedDefaultTextStyle(
                                duration: AppTheme.shortAnimationDuration,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration:
                                      widget.todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                  color:
                                      widget.todo.isCompleted
                                          ? AppTheme.textColorSecondary
                                          : AppTheme.textColorPrimary,
                                ),
                                child: Text(widget.todo.title),
                              ),
                            ),
                  ),

                  AnimationUtils.tapAnimation(
                    onTap: _isEditing ? _saveEdit : _startEditing,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Icon(
                        _isEditing ? Icons.check : Icons.edit_outlined,
                        size: 20,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
