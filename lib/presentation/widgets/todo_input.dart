import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoist/presentation/animations.dart';
import 'package:todoist/presentation/theme/app_theme.dart';

class TodoInput extends StatefulWidget {
  final Function(String) onAddTodo;

  const TodoInput({super.key, required this.onAddTodo});

  @override
  State<TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppTheme.mediumAnimationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleInput() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    HapticFeedback.mediumImpact();
  }

  void _submitTodo() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onAddTodo(_controller.text);
      _controller.clear();
      HapticFeedback.lightImpact();
      _toggleInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded)
          AnimatedContainer(
            duration: AppTheme.mediumAnimationDuration,
            curve: Curves.easeOutCubic,
            height: _isExpanded ? 80 : 0,
            margin: const EdgeInsets.only(
              left: AppTheme.spacingMedium,
              right: AppTheme.spacingMedium,
              bottom: AppTheme.spacingMedium,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMedium,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'What needs to be done?',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onSubmitted: (_) => _submitTodo(),
                    ),
                  ),
                  AnimationUtils.tapAnimation(
                    onTap: _submitTodo,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusMedium,
                        ),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(
              right: AppTheme.spacingMedium,
              bottom: AppTheme.spacingMedium,
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotateAnimation.value * 2 * 3.14159,
                    child: FloatingActionButton(
                      onPressed: _toggleInput,
                      elevation: 4,
                      child: Icon(
                        _isExpanded ? Icons.close : Icons.add,
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
