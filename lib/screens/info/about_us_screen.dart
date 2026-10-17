import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// About Us informational page.
/// Placeholder — full implementation in Phase 6.
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'About Us',
      icon: Icons.info_outline_rounded,
      subtitle: 'Company information — Phase 6',
    );
  }
}
