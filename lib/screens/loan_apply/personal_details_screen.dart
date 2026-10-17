import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Personal details form for loan application.
/// Placeholder — full implementation in Phase 4.
class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Personal Details',
      icon: Icons.person_outline_rounded,
      subtitle: 'Applicant information form — Phase 4',
    );
  }
}
