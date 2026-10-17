import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';

/// A persistent banner indicating that the application is in demo mode.
///
/// Displayed at the top of key screens to clearly communicate
/// that no real financial transactions are being performed.
class DemoBanner extends StatelessWidget {
  final String? customMessage;
  final bool compact;

  const DemoBanner({
    super.key,
    this.customMessage,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.warning.withValues(alpha: 0.15),
          border: Border(
            bottom: BorderSide(
              color: AppTheme.warning.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 14,
              color: AppTheme.warning.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 6),
            Text(
              AppConstants.demoBannerText,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.warning.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: AppTheme.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppTheme.warning,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              customMessage ?? AppConstants.demoDisclaimer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textPrimary.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
