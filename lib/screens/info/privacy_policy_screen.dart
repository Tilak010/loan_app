import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';

/// Privacy Policy informational page
///
/// Explains what the prototype does and does not collect.
/// Clearly states that the demonstration does not submit personal data to a backend
/// and users should not enter real identity documents or financial information.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
              // Critical Caution Card: Do Not Enter Real Data
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: AppTheme.error,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important Privacy Notice',
                            style: TextStyle(
                              color: Color(0xFF991B1B),
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'This application is a demonstration only. It does not submit personal data to a backend server. Users should NOT enter real identity documents (e.g., Aadhaar, PAN) or real financial information (e.g., bank credentials, cards).',
                            style: TextStyle(
                              color: Color(0xFF7F1D1D),
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // What the prototype collects
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
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppTheme.secondary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'What This Prototype Collects',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDataRow(
                      title: 'Simulated In-Memory Session Inputs',
                      description:
                          'Temporary parameters entered during interactive screens (such as mock name, simulated monthly income, loan amount, and tenure preferences).',
                    ),
                    const Divider(height: 18, color: Color(0xFFF1F5F9)),
                    _buildDataRow(
                      title: 'Local Device State Only',
                      description:
                          'All simulated data is retained strictly in local device memory during the active session. Logging out or clearing session state immediately resets all entered values.',
                    ),
                    const Divider(height: 18, color: Color(0xFFF1F5F9)),
                    _buildDataRow(
                      title: 'Mock Document Attachments',
                      description:
                          'Sample document uploads selected during the demo KYC screen remain on your local device and are discarded upon session reset.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // What the prototype DOES NOT collect
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
                    const Row(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: AppTheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'What This Prototype Does Not Collect',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDataRow(
                      title: 'No Backend Submission',
                      description:
                          'The demonstration does not transmit your personal data, identity numbers, or phone inputs to any remote server or cloud database.',
                    ),
                    const Divider(height: 18, color: Color(0xFFF1F5F9)),
                    _buildDataRow(
                      title: 'No Real Identity Verification',
                      description:
                          'No live Aadhaar e-KYC, PAN API validation, CKYC registry lookup, or government database queries are performed.',
                    ),
                    const Divider(height: 18, color: Color(0xFFF1F5F9)),
                    _buildDataRow(
                      title: 'No Financial or Banking Records',
                      description:
                          'No bank statement fetch, account aggregators, net-banking credentials, or credit bureau checks (CIBIL/Experian) are initiated.',
                    ),
                    const Divider(height: 18, color: Color(0xFFF1F5F9)),
                    _buildDataRow(
                      title: 'No Advertising or Data Monetization',
                      description:
                          'No third-party trackers, commercial profiling, or advertising networks are integrated in this demonstration application.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Regulatory & DPDP Readiness Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.gavel_rounded,
                          color: AppTheme.textSecondary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Regulatory Framework & Privacy Roadmap',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Placeholder',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Diksha Finance is currently an illustrative prototype and does not hold an RBI lending license. '
                      'Upon formal commercial partnership with an RBI-regulated lending entity, a comprehensive privacy policy adhering to the Digital Personal Data Protection (DPDP) Act, 2023, RBI Digital Lending Guidelines, and statutory disclosure requirements will be established and published.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Privacy Contact (Placeholder)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.mark_email_read_outlined,
                      color: AppTheme.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy Queries & Prototype Feedback',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'For inquiries regarding this demonstration privacy statement, please refer to the contact details:',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            AppConstants.contactEmail,
                            style: TextStyle(
                              color: AppTheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

  Widget _buildDataRow({
    required String title,
    required String description,
  }) {
    return Column(
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
        const SizedBox(height: 3),
        Text(
          description,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
