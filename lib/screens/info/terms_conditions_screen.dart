import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Terms & Conditions informational page
///
/// Explicitly states that the application is a demonstration only.
/// No real loan offer, approval, disbursement, or repayment is available.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          'Terms & Conditions',
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
              // Mandatory Demonstration Notice Banner
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
                        Icons.verified_outlined,
                        color: AppTheme.secondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demonstration Use Only',
                            style: TextStyle(
                              color: Color(0xFF1E40AF),
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Diksha Finance is currently a demonstration application only. No real loan offer, approval, disbursement, or repayment is available through this application.',
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

              _buildTermCard(
                sectionNumber: '1',
                title: 'Application Nature & Purpose',
                body:
                    'Diksha Finance is presented strictly as a digital lending technology prototype. '
                    'Its primary purpose is to illustrate a proposed end-to-end digital loan origination and servicing journey. '
                    'Nothing within this software constitutes an invitation, solicitation, offer, or binding commitment to lend money or extend commercial credit.',
              ),

              _buildTermCard(
                sectionNumber: '2',
                title: 'No Real Loan Offers or Credit Sanctions',
                body:
                    'All credit amounts, interest calculations, tenure selectors, fee structures, and Key Fact Statements (KFS) generated in this application are illustrative simulations. '
                    'Simulated approval screens and sanction letters do not represent actual underwriting decisions, credit sanctions, or legal entitlements to loan proceeds.',
              ),

              _buildTermCard(
                sectionNumber: '3',
                title: 'No Loan Disbursements or Repayments',
                body:
                    'Under no circumstances will funds be disbursed, deposited, or remitted to any bank account. '
                    'Similarly, all repayment interfaces, EMI payment schedules, and "Pay Now" actions are simulated demonstrations. '
                    'The application does not collect real repayments, process financial transactions, or connect to banking payment gateways.',
              ),

              _buildTermCard(
                sectionNumber: '4',
                title: 'No Real Credit Underwriting or Bureau Checks',
                body:
                    'No hard or soft credit inquiries are submitted to credit bureaus (e.g., CIBIL, Experian, CRIF High Mark, or Equifax). '
                    'Mock approvals and eligibility indicators are generated locally for presentation and testing purposes only.',
              ),

              _buildTermCard(
                sectionNumber: '5',
                title: 'Regulatory & Lending Partner Disclosures',
                body:
                    'Diksha Finance makes no claim of registration as a Non-Banking Financial Company (NBFC) or banking entity with the Reserve Bank of India (RBI). '
                    'Regulated digital lending services will be facilitated solely in formal partnership with RBI-authorized NBFCs or banks upon commercial launch and regulatory approvals.',
              ),

              _buildTermCard(
                sectionNumber: '6',
                title: 'User Obligations & Prototype Data',
                body:
                    'Users interact with this prototype at their own discretion and agree not to submit real government identity credentials, biometric information, or active financial data. '
                    'All state is ephemeral and retained locally in device memory only.',
              ),

              _buildTermCard(
                sectionNumber: '7',
                title: 'Updates & Future Commercial Terms',
                body:
                    'These terms reflect the prototype demonstration phase. A comprehensive, legally binding customer agreement and loan sanction contract will be formulated and published prior to any commercial lending rollout in accordance with applicable Indian laws.',
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermCard({
    required String sectionNumber,
    required String title,
    required String body,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    sectionNumber,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
