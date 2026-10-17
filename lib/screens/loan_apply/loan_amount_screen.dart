import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Loan amount and tenure selection with slider UI.
/// Placeholder — full implementation in Phase 4.
class LoanAmountScreen extends StatelessWidget {
  const LoanAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Loan Amount',
      icon: Icons.currency_rupee_rounded,
      subtitle: 'Amount & tenure selection with slider — Phase 4',
    );
  }
}
