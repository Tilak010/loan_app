import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// EMI Calculator with interactive sliders.
/// Placeholder — full implementation in Phase 5.
class EmiCalculatorScreen extends StatelessWidget {
  const EmiCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'EMI Calculator',
      icon: Icons.calculate_rounded,
      subtitle: 'Interactive EMI calculator — Phase 5',
    );
  }
}
