import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Demo loan application status tracking.
/// Placeholder — full implementation in Phase 4.
class LoanStatusScreen extends StatelessWidget {
  const LoanStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Loan Status',
      icon: Icons.track_changes_rounded,
      subtitle: 'Simulated application status tracker — Phase 4',
    );
  }
}
