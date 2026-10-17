import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Demo KYC document upload screen.
/// Placeholder — full implementation in Phase 4.
class KycUploadScreen extends StatelessWidget {
  const KycUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'KYC Upload',
      icon: Icons.upload_file_rounded,
      subtitle: 'Simulated KYC document upload — Phase 4',
    );
  }
}
