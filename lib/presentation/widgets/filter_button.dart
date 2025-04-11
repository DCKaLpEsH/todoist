import 'package:flutter/material.dart';
import 'package:todoist/presentation/animations.dart';
import 'package:todoist/presentation/theme/app_theme.dart';
import '../../../providers/todo_provider.dart';

class FilterButton extends StatelessWidget {
  final TodoFilter currentFilter;
  final Function(TodoFilter) onFilterChanged;
  final int count;
  final String label;
  final TodoFilter filter;

  const FilterButton({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.count,
    required this.label,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentFilter == filter;

    return AnimationUtils.tapAnimation(
      onTap: () => onFilterChanged(filter),
      child: AnimatedContainer(
        duration: AppTheme.shortAnimationDuration,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMedium,
          vertical: AppTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          border: Border.all(
            color:
                isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.primaryColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSmall),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSmall,
                vertical: AppTheme.spacingXSmall,
              ),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Colors.white.withOpacity(0.3)
                        : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
