import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Sample Key Fact Statement display.
/// Placeholder — full implementation in Phase 4.
class KeyFactStatementScreen extends StatelessWidget {
  const KeyFactStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Key Fact Statement',
      icon: Icons.description_rounded,
      subtitle: 'Sample KFS with illustrative data — Phase 4',
    );
  }
}
