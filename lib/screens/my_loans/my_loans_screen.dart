import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../models/loan_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/primary_button.dart';

/// Screen 10: My Loans and Repayment
///
/// PURPOSE:
/// Demonstrates what an active loans and repayment tracking screen looks like.
/// Supports both empty and populated states based on local application state.
///
/// DESIGN:
/// - Accessible via My Loans bottom-navigation tab
/// - Heading: "My Loans"
/// - Loan summary card with "Demo Only" status badge
/// - Selected loan amount, illustrative monthly EMI, tenure
/// - Next instalment date explicitly labelled "Sample Date"
/// - Loan history section
///
/// ACTIONS:
/// - "View Details": opens detailed demo loan summary bottom sheet
/// - "View History": navigates to Loan History (/my-loans/history)
/// - "Pay Now": MUST BE DISABLED
///
/// PAYMENT SAFETY:
/// - Prominently displays:
///   "Payments are disabled in this demonstration. No money can be collected."
/// - Zero payment gateway, UPI, or banking integrations
///
/// EMPTY STATE:
/// - If no demo application exists, shows: "You have no demo loans yet."
/// - Button: "Explore Loan Options" to begin loan flow
class MyLoansScreen extends StatelessWidget {
  const MyLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loanProvider = context.watch<LoanProvider>();
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;

    final activeLoans = loanProvider.activeLoans;
    final closedLoans = loanProvider.closedLoans;
    final bool isEmpty = activeLoans.isEmpty && closedLoans.isEmpty;

    final bool canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: canPop,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: isHindi ? 'वापस' : 'Back',
              )
            : null,
        title: Text(
          isHindi ? 'मेरे ऋण (My Loans)' : 'My Loans',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
        ),
        centerTitle: false,
        actions: [
          if (!isEmpty)
            IconButton(
              icon: const Icon(Icons.history_rounded, color: AppTheme.primary),
              tooltip: isHindi ? 'ऋण इतिहास' : 'Loan History',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.loanHistory),
            ),
        ],
      ),
      body: SafeArea(
        child: isEmpty
            ? _buildEmptyState(context, isHindi, loanProvider)
            : _buildPopulatedState(
                context,
                isHindi,
                loanProvider,
                activeLoans,
                closedLoans,
              ),
      ),
    );
  }

  // ─── 1. EMPTY STATE ─────────────────────────────────────────────────
  Widget _buildEmptyState(
    BuildContext context,
    bool isHindi,
    LoanProvider loanProvider,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Illustration container
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 42,
                      color: AppTheme.secondary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Required Empty State text
            Text(
              isHindi ? 'आपके पास अभी कोई डेमो ऋण नहीं है।' : 'You have no demo loans yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
            ),

            const SizedBox(height: 10),

            Text(
              isHindi
                  ? 'ऋण आवेदन और ईएमआई भुगतान ट्रैकिंग के अनुभव के लिए डेमो ऋण विकल्प देखें।'
                  : 'Explore simulated loan options to test the repayment tracking and EMI workflow.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 20),

            // Payment Safety Banner (Even in empty state)
            _buildPaymentSafetyBanner(isHindi),

            const SizedBox(height: 32),

            // Button to explore loan options
            PrimaryButton(
              text: isHindi ? 'ऋण विकल्प देखें' : 'Explore Loan Options',
              backgroundColor: AppTheme.accent,
              icon: Icons.search_rounded,
              onPressed: () {
                // Navigate to loan amount selection
                Navigator.of(context).pushNamed(AppRoutes.loanAmount);
              },
            ),

            const SizedBox(height: 14),

            // Helper button for testing populated state directly
            OutlinedButton.icon(
              onPressed: () {
                loanProvider.loadMockLoans();
              },
              icon: const Icon(Icons.playlist_add_rounded, size: 18),
              label: Text(
                isHindi ? 'डेमो नमूना ऋण लोड करें' : 'Load Sample Demo Loan',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.secondary,
                side: BorderSide(color: AppTheme.secondary.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 2. POPULATED STATE ─────────────────────────────────────────────
  Widget _buildPopulatedState(
    BuildContext context,
    bool isHindi,
    LoanProvider loanProvider,
    List<LoanModel> activeLoans,
    List<LoanModel> closedLoans,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Mandatory Payment Safety Banner ─────────────────────────
          _buildPaymentSafetyBanner(isHindi),

          const SizedBox(height: 18),

          // ─── Active Loan Section Header ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'सक्रिय डेमो ऋण' : 'Active Demo Loans',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${activeLoans.length} ${activeLoans.length == 1 ? "Active" : "Active"}',
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ─── Active Loan Cards ───────────────────────────────────────
          if (activeLoans.isNotEmpty)
            ...activeLoans.map(
              (loan) => _buildLoanSummaryCard(context, loan, isHindi),
            )
          else
            _buildNoActiveLoansCard(isHindi),

          const SizedBox(height: 24),

          // ─── Loan History Section ────────────────────────────────────
          _buildLoanHistorySection(context, isHindi, closedLoans),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─── Component: Mandatory Payment Safety Banner ─────────────────────
  Widget _buildPaymentSafetyBanner(bool isHindi) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // Soft red/rose
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFCA5A5), // Rose border
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFFDC2626),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'भुगतान सुरक्षा सूचना' : 'Payment Safety Notice',
                  style: const TextStyle(
                    color: Color(0xFF991B1B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isHindi
                      ? 'Payments are disabled in this demonstration. No money can be collected.'
                      : 'Payments are disabled in this demonstration. No money can be collected.',
                  style: const TextStyle(
                    color: Color(0xFF7F1D1D),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isHindi
                      ? 'इस ऐप में कोई भुगतान गेटवे, यूपीआई या वास्तविक बैंक लेनदेन सक्षम नहीं है।'
                      : 'No payment gateway, UPI, or financial collection is integrated into this simulated app.',
                  style: const TextStyle(
                    color: Color(0xFF991B1B),
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Component: Loan Summary Card ───────────────────────────────────
  Widget _buildLoanSummaryCard(
    BuildContext context,
    LoanModel loan,
    bool isHindi,
  ) {
    final nextEmiDate = loan.nextEmiDate ?? DateTime.now().add(const Duration(days: 30));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header band with Reference and "Demo Only" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reference ID with "Demo" prefix
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_outlined,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      loan.id,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                // Mandatory Status badge: "Demo Only"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFDBA74)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: Color(0xFFEA580C),
                        size: 13,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Demo Only',
                        style: TextStyle(
                          color: Color(0xFFC2410C),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main parameters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Amount and Tenure Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHindi ? 'ऋण राशि' : 'Selected Loan Amount',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.currency(loan.amount),
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isHindi ? 'अवधि' : 'Tenure',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.tenure(loan.tenureMonths),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(height: 20, color: Color(0xFFF1F5F9)),

                // EMI & Next Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Illustrative Monthly EMI
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHindi ? 'मासिक ईएमआई' : 'Illustrative Monthly EMI',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            Formatters.currencyWithDecimals(loan.emiAmount),
                            style: const TextStyle(
                              color: AppTheme.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Next instalment date labelled "Sample Date"
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Sample Date',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isHindi ? 'अगली किस्त' : 'Next EMI',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            Formatters.date(nextEmiDate),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Action Buttons: View Details & Disabled Pay Now
                Row(
                  children: [
                    // Button 1: "View Details"
                    Expanded(
                      flex: 5,
                      child: OutlinedButton.icon(
                        onPressed: () => _showLoanDetailsModal(context, loan, isHindi),
                        icon: const Icon(Icons.info_outline_rounded, size: 16),
                        label: Text(
                          isHindi ? 'विवरण देखें' : 'View Details',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: AppTheme.primary, width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Button 2: "Pay Now" — MUST BE DISABLED
                    Expanded(
                      flex: 5,
                      child: Tooltip(
                        message: isHindi
                            ? 'डेमो मोड में भुगतान अक्षम है'
                            : 'Payments are disabled in this demonstration',
                        child: ElevatedButton.icon(
                          onPressed: null, // REQUIRED: MUST BE DISABLED
                          icon: const Icon(Icons.lock_rounded, size: 15),
                          label: Text(
                            isHindi ? 'भुगतान (Pay Now)' : 'Pay Now',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: const Color(0xFFE2E8F0),
                            disabledForegroundColor: const Color(0xFF94A3B8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Component: Loan History Section ────────────────────────────────
  Widget _buildLoanHistorySection(
    BuildContext context,
    bool isHindi,
    List<LoanModel> closedLoans,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.history_toggle_off_rounded,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isHindi ? 'ऋण इतिहास (Loan History)' : 'Loan History',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              // Action: "View History"
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.loanHistory);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isHindi ? 'सभी देखें (View History)' : 'View History',
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (closedLoans.isNotEmpty)
            ...closedLoans.map((closed) => _buildClosedLoanRow(closed, isHindi))
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 20,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHindi ? 'कोई बंद ऋण नहीं' : 'No closed demo loans',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          isHindi
                              ? 'पूर्ण किए गए ऋण रिकॉर्ड यहाँ प्रदर्शित होंगे'
                              : 'Closed and settled demo loan records will appear here',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClosedLoanRow(LoanModel closed, bool isHindi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    closed.id,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    closed.purpose,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(closed.amount),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Closed (Demo)',
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoActiveLoansCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        isHindi ? 'कोई सक्रिय ऋण नहीं है।' : 'No active loans at this time.',
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
      ),
    );
  }

  // ─── Modal: Detailed Demo Loan Summary ──────────────────────────────
  void _showLoanDetailsModal(
    BuildContext context,
    LoanModel loan,
    bool isHindi,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHindi ? 'डेमो ऋण विवरण' : 'Demo Loan Summary',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isHindi
                                ? 'केवल प्रदर्शन हेतु सिम्युलेटेड रिकॉर्ड'
                                : 'Simulated demonstration record only',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildModalDetailRow('Demo Loan ID', loan.id),
                _buildModalDetailRow('Purpose / Category', loan.purpose),
                _buildModalDetailRow('Principal Loan Amount', Formatters.currency(loan.amount)),
                _buildModalDetailRow('Illustrative Interest Rate', '${loan.interestRate.toStringAsFixed(1)}% p.a.'),
                _buildModalDetailRow('Tenure', Formatters.tenure(loan.tenureMonths)),
                _buildModalDetailRow('Illustrative Monthly EMI', Formatters.currencyWithDecimals(loan.emiAmount)),
                _buildModalDetailRow('Total Estimated Repayment', Formatters.currencyWithDecimals(loan.totalPayable)),
                _buildModalDetailRow('Status', 'Demo Only (${loan.status})'),
                _buildModalDetailRow(
                  'Next Instalment (Sample Date)',
                  Formatters.date(loan.nextEmiDate ?? DateTime.now().add(const Duration(days: 30))),
                ),

                const SizedBox(height: 16),

                // Payment safety callout
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: const Text(
                    'Payments are disabled in this demonstration. No money can be collected.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF991B1B),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                PrimaryButton(
                  text: isHindi ? 'बंद करें' : 'Close Summary',
                  backgroundColor: AppTheme.primary,
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
