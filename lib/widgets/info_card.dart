import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// A styled card widget with consistent shadow, padding,
/// and rounded corners used throughout the app.
class InfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? shadow;

  const InfoCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
    this.borderRadius,
    this.border,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.cardColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppTheme.radiusMd,
        ),
        border: border,
        boxShadow: shadow ?? AppTheme.cardShadow,
      ),
      child: Padding(
        padding: padding ??
            const EdgeInsets.all(AppTheme.spacingMd),
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
