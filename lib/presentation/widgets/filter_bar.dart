import 'package:flutter/material.dart';
import 'package:todoist/presentation/theme/app_theme.dart';
import 'package:todoist/presentation/widgets/filter_button.dart';
import 'package:todoist/providers/todo_provider.dart';

class FilterBar extends StatelessWidget {
  final TodoFilter currentFilter;
  final Function(TodoFilter) onFilterChanged;
  final int totalCount;
  final int activeCount;
  final int completedCount;

  const FilterBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.totalCount,
    required this.activeCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMedium),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
        child: Row(
          children: [
            FilterButton(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              count: totalCount,
              label: 'All',
              filter: TodoFilter.all,
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            FilterButton(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              count: activeCount,
              label: 'Active',
              filter: TodoFilter.active,
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            FilterButton(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              count: completedCount,
              label: 'Completed',
              filter: TodoFilter.completed,
            ),
          ],
        ),
      ),
    );
  }
}
