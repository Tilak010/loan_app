import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../models/emi_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/primary_button.dart';

/// Screen 9: Demo Application Status
///
/// PURPOSE:
/// Demonstrates what an application-status screen might look like in a digital
/// lending flow. No actual loan approval, credit check, or disbursement is performed.
///
/// DESIGN:
/// - White background
/// - Navy blue header (AppTheme.primary)
/// - Orange accent (AppTheme.accent)
/// - Professional status card with clear hierarchy
/// - Simple success-style illustration / icon
///
/// CONTENT:
/// - Heading: "Demo Application Completed"
/// - Status badge: "SIMULATED APPROVAL — NOT A REAL LOAN APPROVAL"
/// - Demo application reference number
/// - Selected loan type, amount, tenure, illustrative EMI
/// - Device-generated date
/// - Explicit non-disbursement disclaimer (no guaranteed disbursement date)
///
/// BUTTONS:
/// 1. "View Loan Details" — opens My Loan Details modal/route
/// 2. "Back to Home" — returns to the dashboard
///
/// FUNCTIONALITY:
/// - Generates and preserves local demo reference number
/// - Reads previously selected loan details from local application state
/// - Preserves details across navigation
/// - Zero API, SMS, email, or payment calls
class LoanStatusScreen extends StatefulWidget {
  const LoanStatusScreen({super.key});

  @override
  State<LoanStatusScreen> createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends State<LoanStatusScreen> {
  bool _recorded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_recorded) {
      _recorded = true;
      // Record completed demo loan in local state after frame renders
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<LoanProvider>().recordDemoCompletedLoan();
        }
      });
    }
  }

  void _onBackToHome() {
    // Reset bottom nav to Home tab and return to dashboard
    context.read<AppProvider>().setNavIndex(0);
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  void _onViewLoanDetails(
    BuildContext context,
    LoanProvider loanProvider,
    bool isHindi,
    EmiModel emiModel,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildLoanDetailsSheet(ctx, loanProvider, isHindi, emiModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = context.watch<LoanProvider>();
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;

    final amount = loanProvider.loanAmount > 0
        ? loanProvider.loanAmount
        : 50000.0;
    final tenure = loanProvider.tenureMonths > 0
        ? loanProvider.tenureMonths
        : 12;
    final rate = loanProvider.illustrativeRate > 0
        ? loanProvider.illustrativeRate
        : 24.0;
    final loanType = loanProvider.loanType.isNotEmpty
        ? loanProvider.loanType
        : 'Personal Loan';
    final refNumber = loanProvider.demoReferenceNumber;
    final generatedDate = loanProvider.demoApplicationDate;

    final emiModel = EmiModel(
      principal: amount,
      annualRate: rate,
      tenureMonths: tenure,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          isHindi ? 'आवेदन स्थिति (Demo)' : 'Application Status (Demo)',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ─── 1. Success Illustration / Icon ─────────────────────
                    _buildSuccessIllustration(),

                    const SizedBox(height: 20),

                    // ─── 2. Main Heading ────────────────────────────────────
                    Text(
                      isHindi ? 'डेमो आवेदन पूर्ण हुआ' : 'Demo Application Completed',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isHindi
                          ? 'आपका अनुकरणीय ऋण आवेदन स्थानीय रूप से सफलतापूर्वक दर्ज कर लिया गया है।'
                          : 'Your digital demonstration application has been recorded locally.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ─── 3. Required Status Badge ───────────────────────────
                    _buildStatusBadge(isHindi),

                    const SizedBox(height: 24),

                    // ─── 4. Professional Status Card ────────────────────────
                    _buildStatusCard(
                      context: context,
                      isHindi: isHindi,
                      refNumber: refNumber,
                      loanType: loanType,
                      amount: amount,
                      tenure: tenure,
                      rate: rate,
                      emiModel: emiModel,
                      generatedDate: generatedDate,
                    ),

                    const SizedBox(height: 20),

                    // ─── 5. Non-Disbursement & Presentation Notice ──────────
                    _buildPresentationNotice(isHindi),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── 6. Action Buttons Bar ──────────────────────────────────────
            _buildActionButtons(context, loanProvider, isHindi, emiModel),
          ],
        ),
      ),
    );
  }

  // ─── Component: Success Illustration / Icon ────────────────────────
  Widget _buildSuccessIllustration() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7), // Soft green ring
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 74,
          height: 74,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Component: Required Status Badge ──────────────────────────────
  Widget _buildStatusBadge(bool isHindi) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Soft amber/yellow
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF59E0B), // Amber border
          width: 1.2,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            color: Color(0xFFD97706),
            size: 16,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'SIMULATED APPROVAL — NOT A REAL LOAN APPROVAL',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFB45309),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Component: Professional Status Card ───────────────────────────
  Widget _buildStatusCard({
    required BuildContext context,
    required bool isHindi,
    required String refNumber,
    required String loanType,
    required double amount,
    required int tenure,
    required double rate,
    required EmiModel emiModel,
    required DateTime generatedDate,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Reference Band
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'डेमो संदर्भ संख्या (Reference No.)' : 'Demo Application Ref. No.',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      refNumber,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: refNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isHindi
                              ? 'संदर्भ संख्या कॉपी कर ली गई'
                              : 'Demo reference number copied to clipboard',
                        ),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: AppTheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isHindi ? 'कॉपी' : 'Copy',
                          style: const TextStyle(
                            color: AppTheme.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detail rows
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildCardRow(
                  label: isHindi ? 'चयनित ऋण प्रकार' : 'Selected Loan Type',
                  value: loanType,
                  icon: Icons.category_outlined,
                  valueColor: AppTheme.secondary,
                ),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _buildCardRow(
                  label: isHindi ? 'स्वीकृत/चयनित राशि' : 'Selected Loan Amount',
                  value: Formatters.currency(amount),
                  icon: Icons.currency_rupee_rounded,
                  valueColor: AppTheme.textPrimary,
                  isBold: true,
                ),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _buildCardRow(
                  label: isHindi ? 'चयनित अवधि' : 'Selected Tenure',
                  value: Formatters.tenure(tenure),
                  icon: Icons.timelapse_rounded,
                  valueColor: AppTheme.textPrimary,
                ),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _buildCardRow(
                  label: isHindi ? 'अनुमानित मासिक ईएमआई' : 'Illustrative Monthly EMI',
                  value: '${Formatters.currencyWithDecimals(emiModel.emi)} / mo',
                  icon: Icons.calendar_month_outlined,
                  valueColor: AppTheme.accent,
                  isBold: true,
                ),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _buildCardRow(
                  label: isHindi ? 'उत्पत्ति तिथि (Device Date)' : 'Date Generated by Device',
                  value: Formatters.date(generatedDate),
                  icon: Icons.today_outlined,
                  valueColor: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Component: Presentation Notice ────────────────────────────────
  Widget _buildPresentationNotice(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppTheme.secondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'एनबीएफसी प्रदर्शन सूचना' : 'NBFC Demonstration Notice',
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isHindi
                      ? 'संवितरण निर्धारित नहीं है। यह अनुकरणीय स्थिति केवल डिजिटल प्रक्रिया पूर्णता दर्शाती है। वास्तविक ऋण स्वीकृति या संवितरण किसी भी ऋणदाता द्वारा नहीं किया गया है।'
                      : 'Disbursement is not scheduled. This simulated status demonstrates mobile application completion and does not constitute a formal lending agreement or sanction from any NBFC.',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Component: Action Buttons ─────────────────────────────────────
  Widget _buildActionButtons(
    BuildContext context,
    LoanProvider loanProvider,
    bool isHindi,
    EmiModel emiModel,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Button 1: "View Loan Details"
            OutlinedButton.icon(
              onPressed: () => _onViewLoanDetails(context, loanProvider, isHindi, emiModel),
              icon: const Icon(Icons.description_outlined, size: 20),
              label: Text(
                isHindi ? 'ऋण विवरण देखें (View Loan Details)' : 'View Loan Details',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary, width: 1.5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Button 2: "Back to Home"
            PrimaryButton(
              text: isHindi ? 'होम पेज पर वापस जाएं' : 'Back to Home',
              backgroundColor: AppTheme.accent,
              icon: Icons.home_rounded,
              onPressed: _onBackToHome,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Component: Loan Details Bottom Sheet ──────────────────────────
  Widget _buildLoanDetailsSheet(
    BuildContext context,
    LoanProvider loanProvider,
    bool isHindi,
    EmiModel emiModel,
  ) {
    return Container(
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
              // Top drag handle
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
                    child: Text(
                      isHindi ? 'सिम्युलेटेड ऋण विवरण' : 'My Loan Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isHindi
                    ? 'स्थानीय डेमो स्थिति विवरण'
                    : 'Locally preserved demonstration summary',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),

              // Detail List
              _buildModalRow(
                isHindi ? 'संदर्भ क्रमांक' : 'Reference Number',
                loanProvider.demoReferenceNumber,
              ),
              _buildModalRow(
                isHindi ? 'ऋण प्रकार' : 'Loan Category',
                loanProvider.loanType,
              ),
              _buildModalRow(
                isHindi ? 'मूलधन राशि' : 'Principal Amount',
                Formatters.currency(loanProvider.loanAmount),
              ),
              _buildModalRow(
                isHindi ? 'वार्षिक ब्याज दर' : 'Illustrative Rate',
                '${loanProvider.illustrativeRate.toStringAsFixed(1)}% p.a.',
              ),
              _buildModalRow(
                isHindi ? 'ऋण अवधि' : 'Tenure Duration',
                Formatters.tenure(loanProvider.tenureMonths),
              ),
              _buildModalRow(
                isHindi ? 'मासिक ईएमआई' : 'Monthly EMI',
                Formatters.currencyWithDecimals(emiModel.emi),
              ),
              _buildModalRow(
                isHindi ? 'कुल पुनर्भुगतान' : 'Total Repayment',
                Formatters.currencyWithDecimals(emiModel.totalPayable),
              ),
              _buildModalRow(
                isHindi ? 'आवेदन स्थिति' : 'Application Status',
                'Simulated Approval (Demo)',
              ),
              _buildModalRow(
                isHindi ? 'उत्पत्ति तिथि' : 'Application Date',
                Formatters.date(loanProvider.demoApplicationDate),
              ),

              const SizedBox(height: 20),

              // Close / Navigate button
              PrimaryButton(
                text: isHindi ? 'विवरण बंद करें' : 'Close Details',
                backgroundColor: AppTheme.primary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helper Row Widgets ────────────────────────────────────────────
  Widget _buildCardRow({
    required String label,
    required String value,
    required IconData icon,
    required Color valueColor,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModalRow(String label, String value) {
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
