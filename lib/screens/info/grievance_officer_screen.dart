import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';

/// Grievance Redressal Officer informational page
///
/// Contains structured placeholder sections for:
/// - Officer Name
/// - Designation
/// - Email
/// - Phone Number
/// - Escalation Process
///
/// Complies with strict demonstration guidelines:
/// - No invented officer names, contact details, or addresses
/// - Clearly marked placeholder badges
/// - No claims of RBI registration
/// - Easy to update via AppConstants
class GrievanceOfficerScreen extends StatelessWidget {
  const GrievanceOfficerScreen({super.key});

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
          'Grievance Officer',
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
              // Notice Banner explaining Placeholder Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Color(0xFF16A34A),
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
                                  'Grievance Redressal Framework',
                                  style: TextStyle(
                                    color: Color(0xFF15803D),
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
                            'Digital lending standards require a designated Grievance Officer and escalation matrix. '
                            'Because Diksha Finance is currently an illustrative prototype with pending partner onboarding, '
                            'all officer and contact fields below are structured placeholders and will be confirmed upon formal entity launch.',
                            style: TextStyle(
                              color: Color(0xFF166534),
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

              // Officer Details Section
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
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.support_agent_rounded,
                            color: AppTheme.secondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nodal Officer Profile',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Structured Placeholder Details',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24, color: Color(0xFFF1F5F9)),

                    // 1. Officer Name
                    _buildField(
                      icon: Icons.person_outline_rounded,
                      label: 'Officer Name',
                      value: AppConstants.grievanceOfficerName,
                      isPlaceholder: true,
                    ),

                    const Divider(height: 18, color: Color(0xFFF1F5F9)),

                    // 2. Designation
                    _buildField(
                      icon: Icons.badge_outlined,
                      label: 'Designation',
                      value: AppConstants.grievanceOfficerDesignation,
                      isPlaceholder: false,
                    ),

                    const Divider(height: 18, color: Color(0xFFF1F5F9)),

                    // 3. Email
                    _buildField(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: AppConstants.grievanceOfficerEmail,
                      isPlaceholder: true,
                    ),

                    const Divider(height: 18, color: Color(0xFFF1F5F9)),

                    // 4. Phone Number
                    _buildField(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: AppConstants.grievanceOfficerPhone,
                      isPlaceholder: true,
                    ),

                    const Divider(height: 18, color: Color(0xFFF1F5F9)),

                    // Office Address
                    _buildField(
                      icon: Icons.location_on_outlined,
                      label: 'Office Address',
                      value: AppConstants.contactOfficeAddress,
                      isPlaceholder: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 5. Escalation Process Section
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
                    const Row(
                      children: [
                        Icon(
                          Icons.account_tree_outlined,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Escalation Process',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Multi-tiered dispute resolution mechanism to be instituted upon commercial launch:',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Level 1
                    _buildEscalationStep(
                      level: '1',
                      title: AppConstants.grievanceEscalationLevel1Title,
                      description: AppConstants.grievanceEscalationLevel1Desc,
                      badgeText: 'First Point of Contact',
                      badgeColor: const Color(0xFF0284C7),
                      isLast: false,
                    ),

                    // Level 2
                    _buildEscalationStep(
                      level: '2',
                      title: AppConstants.grievanceEscalationLevel2Title,
                      description: AppConstants.grievanceEscalationLevel2Desc,
                      badgeText: 'Internal Escalation',
                      badgeColor: const Color(0xFFD97706),
                      isLast: false,
                    ),

                    // Level 3
                    _buildEscalationStep(
                      level: '3',
                      title: AppConstants.grievanceEscalationLevel3Title,
                      description: AppConstants.grievanceEscalationLevel3Desc,
                      badgeText: 'Regulatory Authority',
                      badgeColor: const Color(0xFF16A34A),
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Regulatory Non-claim Reminder
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  'Note: Diksha Finance makes no claim of RBI registration or regulated lender status in this demonstration. '
                  'Ombudsman and regulatory escalation routes will become active upon integration with an authorized NBFC partner.',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required String value,
    required bool isPlaceholder,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 10),
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

  Widget _buildEscalationStep({
    required String level,
    required String title,
    required String description,
    required String badgeText,
    required Color badgeColor,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  level,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
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
