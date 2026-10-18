import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// A styled primary action button used across the app.
///
/// Supports full-width mode, loading state, outlined variant,
/// icon prefix, and disabled state.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool fullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.fullWidth = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppTheme.primary : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          );

    final Widget button;

    if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(fullWidth ? double.infinity : 0, height ?? 52),
          padding: padding,
        ),
        child: buttonChild,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.accent,
          foregroundColor: textColor ?? Colors.white,
          minimumSize: Size(fullWidth ? double.infinity : 0, height ?? 52),
          padding: padding,
        ),
        child: buttonChild,
      );
    }

    return button;
  }
}
