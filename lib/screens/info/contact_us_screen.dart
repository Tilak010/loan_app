import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';

/// Contact Us informational page
///
/// Contains structured fields for:
/// - Business Name
/// - Office Address
/// - Contact Email
/// - Phone Number
///
/// Complies with strict demonstration guidelines:
/// - No invented registered office address
/// - No invented contact details
/// - Clearly marked placeholder badges
/// - No claims of RBI registration
/// - Easy to update via AppConstants
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
          'Contact Us',
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
              // Notice Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.contact_support_outlined,
                        color: AppTheme.secondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Demonstration Channels',
                                  style: TextStyle(
                                    color: Color(0xFF1E40AF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              _buildPlaceholderTag(),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Diksha Finance is currently a digital loan application demonstration prototype. '
                            'Official business channels, office location, and customer helplines will be activated upon formal entity registration and NBFC partner onboarding. '
                            'All unconfirmed fields below are structured placeholders.',
                            style: TextStyle(
                              color: Color(0xFF1E3A8A),
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

              // Structured Contact Fields Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Official Business Information',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Structured fields for commercial and legal disclosures:',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),

                    const Divider(height: 24, color: Color(0xFFF1F5F9)),

                    // 1. Business Name
                    _buildContactItem(
                      icon: Icons.business_rounded,
                      label: 'Business Name',
                      value: AppConstants.contactBusinessName,
                      subtitleTag: 'Demonstration Prototype',
                      isPlaceholder: false,
                    ),

                    const Divider(height: 20, color: Color(0xFFF1F5F9)),

                    // 2. Office Address
                    _buildContactItem(
                      icon: Icons.location_on_outlined,
                      label: 'Office Address',
                      value: AppConstants.contactOfficeAddress,
                      isPlaceholder: true,
                    ),

                    const Divider(height: 20, color: Color(0xFFF1F5F9)),

                    // 3. Contact Email
                    _buildContactItem(
                      icon: Icons.email_outlined,
                      label: 'Contact Email',
                      value: AppConstants.contactEmail,
                      isPlaceholder: true,
                    ),

                    const Divider(height: 20, color: Color(0xFFF1F5F9)),

                    // 4. Phone Number
                    _buildContactItem(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: AppConstants.contactPhone,
                      isPlaceholder: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Easy update and regulatory notice card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: AppTheme.textSecondary,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Regulatory Disclosure Notice',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Diksha Finance does not claim to be an RBI-registered NBFC or bank.\n'
                      '• No real financial transactions, lending operations, or debt collections occur through this application.\n'
                      '• Official corporate identification numbers (CIN), registered address, and regulated partner disclosures will be updated upon commercial launch.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.5,
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

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    String? subtitleTag,
    required bool isPlaceholder,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.secondary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppTheme.secondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (subtitleTag != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        subtitleTag,
                        style: const TextStyle(
                          color: AppTheme.secondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  if (isPlaceholder) ...[
                    const SizedBox(width: 6),
                    _buildPlaceholderTag(),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: isPlaceholder
                      ? const Color(0xFF475569)
                      : AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: isPlaceholder ? FontWeight.w500 : FontWeight.w700,
                  height: 1.35,
                  fontStyle: isPlaceholder ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: const Text(
        'Placeholder',
        style: TextStyle(
          color: Color(0xFFB45309),
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
