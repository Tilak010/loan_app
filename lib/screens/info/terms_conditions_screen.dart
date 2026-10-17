import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Terms & Conditions page.
/// Placeholder — full implementation in Phase 6.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Terms & Conditions',
      icon: Icons.gavel_rounded,
      subtitle: 'Terms of use — Phase 6',
    );
  }
}
