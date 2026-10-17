import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Contact Us page.
/// Placeholder — full implementation in Phase 6.
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Contact Us',
      icon: Icons.contact_support_outlined,
      subtitle: 'Contact information — Phase 6',
    );
  }
}
