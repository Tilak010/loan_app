import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// My Loans & Repayment tracking screen.
/// Placeholder — full implementation in Phase 5.
class MyLoansScreen extends StatelessWidget {
  const MyLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'My Loans',
      icon: Icons.account_balance_rounded,
      subtitle: 'Active loans & repayment tracking — Phase 5',
    );
  }
}
