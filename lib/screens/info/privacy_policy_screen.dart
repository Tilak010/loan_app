import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Privacy Policy page.
/// Placeholder — full implementation in Phase 6.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Privacy Policy',
      icon: Icons.privacy_tip_outlined,
      subtitle: 'Privacy policy details — Phase 6',
    );
  }
}
