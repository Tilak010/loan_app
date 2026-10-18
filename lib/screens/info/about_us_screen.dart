import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';

/// About Us informational page
///
/// Explains that Diksha Finance is currently a demonstration application
/// designed to showcase a proposed digital loan application journey.
/// Contains no claims of RBI registration, and clearly marks unconfirmed
/// details as placeholders that can be easily updated.
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero branding card with Demo badge
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'DEMO PROTOTYPE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.appTagline,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Overview section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: AppTheme.softShadow,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppTheme.secondary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'About Diksha Finance',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      AppConstants.aboutUsText,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Key Showcase Pillars
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Demonstrated Application Journey',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPillarItem(
                      icon: Icons.calculate_outlined,
                      title: 'Interactive EMI Calculator',
                      description:
                          'Real-time principal, interest rate, and tenure sliders calculating monthly commitments.',
                    ),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildPillarItem(
                      icon: Icons.assignment_outlined,
                      title: 'Digital Loan Application Workflow',
                      description:
                          'Structured steps for entering income details, employment classification, and loan purpose.',
                    ),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildPillarItem(
                      icon: Icons.document_scanner_outlined,
                      title: 'Simulated KYC & Document Flow',
                      description:
                          'Mock Aadhaar/PAN identity upload and instant simulated verification demonstration.',
                    ),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildPillarItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Illustrative Key Fact Statement (KFS)',
                      description:
                          'Transparent disclosure breakdown modeling regulatory requirements for lending transparency.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Lending Partner & Regulatory Notice (Placeholder)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.handshake_outlined,
                          color: Color(0xFFD97706),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            AppConstants.proposedLendingPartner,
                            style: TextStyle(
                              color: Color(0xFF92400E),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFF59E0B)),
                          ),
                          child: const Text(
                            'Placeholder',
                            style: TextStyle(
                              color: Color(0xFFB45309),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      AppConstants.proposedLendingPartnerNote,
                      style: TextStyle(
                        color: Color(0xFFB45309),
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• No claim is made of RBI registration for this application or its proposed lenders.\n'
                      '• Entity credentials and NBFC partner disclosures will be updated upon final commercial onboarding.',
                      style: TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillarItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppTheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.secondary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
