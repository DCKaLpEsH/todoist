import 'package:flutter/material.dart';
import 'package:todoist/presentation/animations.dart';
import 'package:todoist/presentation/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.check_circle_outline,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationUtils.fadeThrough(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 2000),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Icon(
                  icon,
                  size: 80,
                  color: AppTheme.primaryColor.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(height: AppTheme.spacingLarge),
                AnimationUtils.tapAnimation(
                  onTap: onAction!,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLarge,
                      vertical: AppTheme.spacingMedium,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusLarge,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      actionLabel!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
