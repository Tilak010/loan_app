import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/loan_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/formatters.dart';

/// Loan History Screen
///
/// Displays closed and settled demo loans as well as past simulated repayment
/// records with explicit "Demo Only" labelling.
class LoanHistoryScreen extends StatelessWidget {
  const LoanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loanProvider = context.watch<LoanProvider>();
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;

    final allLoans = loanProvider.loans;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: isHindi ? 'वापस' : 'Back',
        ),
        title: Text(
          isHindi ? 'ऋण इतिहास (Loan History)' : 'Loan History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: allLoans.isEmpty
            ? _buildEmptyHistory(context, isHindi)
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Demo indicator banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFD97706)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isHindi
                                  ? 'यह केवल अनुकरणीय इतिहास है — कोई वास्तविक वित्तीय लेनदेन नहीं हुआ है।'
                                  : 'Demonstration records only. No actual financial payments were transacted.',
                              style: const TextStyle(
                                color: Color(0xFF92400E),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      isHindi ? 'सभी सिमुलेटेड ऋण रिकॉर्ड' : 'All Simulated Loan Records',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...allLoans.map((loan) => _buildHistoryCard(loan, isHindi)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyHistory(BuildContext context, bool isHindi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_toggle_off_rounded,
                size: 48,
                color: AppTheme.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isHindi ? 'कोई ऋण इतिहास नहीं मिला' : 'No demo loan history found',
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isHindi
                  ? 'जब आप डेमो ऋण पूर्ण करेंगे, तब रिकॉर्ड यहाँ दिखाई देंगे।'
                  : 'Completed or closed simulated loans will be tracked here.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(LoanModel loan, bool isHindi) {
    final bool isClosed = loan.status == 'Closed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isClosed
                            ? const Color(0xFFDCFCE7)
                            : AppTheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        isClosed ? Icons.check_circle_outline_rounded : Icons.pending_actions_rounded,
                        size: 16,
                        color: isClosed ? const Color(0xFF16A34A) : AppTheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loan.id,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isClosed ? const Color(0xFFDCFCE7) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isClosed ? 'Closed (Demo)' : '${loan.status} (Demo)',
                    style: TextStyle(
                      color: isClosed ? const Color(0xFF16A34A) : AppTheme.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 16, color: Color(0xFFF1F5F9)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.purpose,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      Formatters.currency(loan.amount),
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Tenure',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      Formatters.tenure(loan.tenureMonths),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
