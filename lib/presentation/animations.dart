import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoist/presentation/theme/app_theme.dart';

class AnimationUtils {
  static Widget slideInAnimation({
    required Widget child,
    required int index,
    Duration? duration,
    bool fromLeft = true,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([]),
      builder: (context, _) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: duration ?? AppTheme.mediumAnimationDuration,
          curve: Curves.easeOutQuint,
          builder: (context, value, child) {
            final delay = Duration(milliseconds: index * 50);
            return FutureBuilder(
              future: Future.delayed(delay),
              builder: (context, snapshot) {
                final show = snapshot.connectionState == ConnectionState.done;
                final offset = show ? 0.0 : (fromLeft ? -100.0 : 100.0);
                return Transform.translate(
                  offset: Offset(offset * (1 - value), 0),
                  child: Opacity(opacity: show ? value : 0, child: child),
                );
              },
            );
          },
          child: child,
        );
      },
    );
  }

  static Widget scaleAnimation({required Widget child, Duration? duration}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration ?? AppTheme.shortAnimationDuration,
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: child,
    );
  }

  static Widget buttonPressAnimation({
    required Widget child,
    required VoidCallback onTap,
    bool hapticFeedback = true,
  }) {
    return GestureDetector(
      onTap: () {
        if (hapticFeedback) {
          HapticFeedback.lightImpact();
        }
        onTap();
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 1.0),
        duration: AppTheme.shortAnimationDuration,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: child,
      ),
    );
  }

  static Widget checkboxAnimation({
    required bool isChecked,
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: AppTheme.mediumAnimationDuration,
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color:
            isChecked
                ? AppTheme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: child,
    );
  }

  static Widget swipeAnimation({
    required Widget child,
    required DismissDirectionCallback onDismissed,
    required Key key,
  }) {
    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: child,
    );
  }

  static Widget fadeThrough({required Widget child, Duration? duration}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration ?? AppTheme.mediumAnimationDuration,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static Widget tapAnimation({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;

        return GestureDetector(
          onTapDown: (_) {
            setState(() => isPressed = true);
            HapticFeedback.lightImpact();
          },
          onTapUp: (_) {
            setState(() => isPressed = false);
            onTap();
          },
          onTapCancel: () {
            setState(() => isPressed = false);
          },
          child: AnimatedScale(
            scale: isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder<T> pageTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.05);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: AppTheme.mediumAnimationDuration,
    );
  }
}
