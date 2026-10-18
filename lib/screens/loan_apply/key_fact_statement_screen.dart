import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../models/emi_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/primary_button.dart';

/// Screen 8: Sample Key Fact Statement (KFS)
///
/// PURPOSE:
/// Demonstrates how loan terms and charges could be presented to a customer
/// before accepting an actual loan offer in a digital lending journey.
///
/// HEADER:
/// "Key Fact Statement — Sample"
///
/// MANDATORY DISCLAIMER:
/// "Illustrative demonstration only. This is not an actual credit offer,
/// approved loan, or legally operative KFS."
///
/// FEATURES:
/// - Selected loan type, amount, tenure, illustrative rate
/// - Standard reducing-balance EMI calculation
/// - Separate processing fee and GST calculations
/// - Other charges disclosure (Prepayment, Late payment, Stamp duty)
/// - Total estimated cost of borrowing & net disbursement
/// - Explicit assumptions breakdown
/// - Collapsible monthly amortization schedule preview
/// - Default demo example (₹50,000, 24%, 12 mo, ₹500 fee, 18% GST)
///   when no previous selection is available, with interactive switcher
/// - Checkbox: "I have reviewed this illustrative example"
/// - "Continue Demo" button (requires checkbox)
/// - Navigates to Demo Application Status screen (/loan/status)
/// - Strictly local acceptance state
/// - Non-regulatory, unbranded demonstration
class KeyFactStatementScreen extends StatefulWidget {
  final double? initialAmount;
  final int? initialTenure;
  final String? initialLoanType;
  final double? initialRate;

  const KeyFactStatementScreen({
    super.key,
    this.initialAmount,
    this.initialTenure,
    this.initialLoanType,
    this.initialRate,
  });

  @override
  State<KeyFactStatementScreen> createState() => _KeyFactStatementScreenState();
}

class _KeyFactStatementScreenState extends State<KeyFactStatementScreen> {
  // ─── Default Demo Benchmark Constants ──────────────────────────────
  static const double _defaultAmount = 50000.0;
  static const int _defaultTenure = 12;
  static const double _defaultRate = 24.0;
  static const double _defaultProcessingFee = 500.0;
  static const double _defaultGstRate = 18.0;

  // ─── Local State ───────────────────────────────────────────────────
  bool _initialized = false;
  bool _hasUserSelection = false;
  bool _useDefaultExample = false;

  // Active parameter values
  late String _loanType;
  late double _loanAmount;
  late int _tenureMonths;
  late double _annualRate;

  // Acceptance state (strictly local demo state)
  bool _hasReviewed = false;

  // Schedule expansion state
  bool _isScheduleExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _resolveInitialValues();
    }
  }

  void _resolveInitialValues() {
    final loanProvider = context.read<LoanProvider>();
    final routeArgs = ModalRoute.of(context)?.settings.arguments;

    double? resolvedAmount = widget.initialAmount;
    int? resolvedTenure = widget.initialTenure;
    String? resolvedType = widget.initialLoanType;
    double? resolvedRate = widget.initialRate;

    if (routeArgs is Map<String, dynamic>) {
      if (routeArgs['loanAmount'] is num) {
        resolvedAmount = (routeArgs['loanAmount'] as num).toDouble();
      }
      if (routeArgs['tenureMonths'] is int) {
        resolvedTenure = routeArgs['tenureMonths'] as int;
      }
      if (routeArgs['loanType'] is String) {
        resolvedType = routeArgs['loanType'] as String;
      }
      if (routeArgs['interestRate'] is num) {
        resolvedRate = (routeArgs['interestRate'] as num).toDouble();
      }
    }

    // Determine if previous user selection is available
    // Previous selection exists if user passed arguments or completed step >= 1
    final bool hasSelectionInProvider = loanProvider.currentStep >= 1 &&
        loanProvider.loanAmount > 0 &&
        loanProvider.tenureMonths > 0;

    if (resolvedAmount != null && resolvedTenure != null) {
      _hasUserSelection = true;
      _loanAmount = resolvedAmount;
      _tenureMonths = resolvedTenure;
      _loanType = resolvedType ?? 'Personal Loan';
      _annualRate = resolvedRate ?? _defaultRate;
      _useDefaultExample = false;
    } else if (hasSelectionInProvider) {
      _hasUserSelection = true;
      _loanAmount = loanProvider.loanAmount;
      _tenureMonths = loanProvider.tenureMonths;
      _loanType = loanProvider.loanType.isNotEmpty
          ? loanProvider.loanType
          : 'Personal Loan';
      _annualRate = loanProvider.illustrativeRate > 0
          ? loanProvider.illustrativeRate
          : _defaultRate;
      _useDefaultExample = false;
    } else {
      // Use default example when no previous selection is available
      _hasUserSelection = false;
      _useDefaultExample = true;
      _loanAmount = _defaultAmount;
      _tenureMonths = _defaultTenure;
      _loanType = 'Personal Loan';
      _annualRate = _defaultRate;
    }
  }

  void _toggleSourceExample() {
    setState(() {
      _useDefaultExample = !_useDefaultExample;
      if (_useDefaultExample) {
        _loanAmount = _defaultAmount;
        _tenureMonths = _defaultTenure;
        _annualRate = _defaultRate;
        _loanType = 'Personal Loan';
      } else {
        final loanProvider = context.read<LoanProvider>();
        _loanAmount = loanProvider.loanAmount;
        _tenureMonths = loanProvider.tenureMonths;
        _annualRate = loanProvider.illustrativeRate > 0
            ? loanProvider.illustrativeRate
            : _defaultRate;
        _loanType = loanProvider.loanType.isNotEmpty
            ? loanProvider.loanType
            : 'Personal Loan';
      }
    });
  }

  // ─── Mathematical Financial Calculations ───────────────────────────

  /// Computes monthly EMI using the standard reducing-balance formula:
  /// EMI = P × r × (1 + r)^n / ((1 + r)^n - 1)
  EmiModel _calculateEmiModel() {
    return EmiModel(
      principal: _loanAmount,
      annualRate: _annualRate,
      tenureMonths: _tenureMonths,
    );
  }

  /// Processing fee:
  /// For default example or ₹50,000, processing fee is ₹500.
  /// For user-selected amounts, calculated proportionately at 1% of principal.
  double get _processingFee {
    if (_useDefaultExample || _loanAmount == _defaultAmount) {
      return _defaultProcessingFee;
    }
    return (_loanAmount * 0.01).roundToDouble();
  }

  /// Applicable GST on processing fee (18%)
  double get _gstOnFee {
    return (_processingFee * (_defaultGstRate / 100)).roundToDouble();
  }

  /// Total upfront fees and charges
  double get _totalFeesAndCharges => _processingFee + _gstOnFee;

  /// Net disbursement amount
  double get _netDisbursement => _loanAmount - _totalFeesAndCharges;

  /// Estimated total cost of borrowing:
  /// Total Interest over tenure + Total Fees and Taxes
  double _calculateTotalCostOfBorrowing(EmiModel emiModel) {
    return emiModel.totalInterest + _totalFeesAndCharges;
  }

  /// Approximate Annual Percentage Rate (APR) for illustration
  /// APR reflects nominal interest + upfront fees annualized
  double _calculateIllustrativeApr() {
    if (_loanAmount <= 0 || _tenureMonths <= 0) return _annualRate;
    final feePercentage = (_totalFeesAndCharges / _loanAmount) * 100;
    final annualizedFee = (feePercentage / _tenureMonths) * 12;
    return _annualRate + annualizedFee;
  }

  // ─── Navigation ────────────────────────────────────────────────────
  void _onContinueDemo() {
    if (!_hasReviewed) return;

    final loanProvider = context.read<LoanProvider>();
    loanProvider.setCurrentStep(4); // Advance to status step

    // Navigate to Demo Application Status screen
    Navigator.of(context).pushNamed(AppRoutes.loanStatus);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;
    final emiModel = _calculateEmiModel();
    final totalCostOfBorrowing = _calculateTotalCostOfBorrowing(emiModel);
    final apr = _calculateIllustrativeApr();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: isHindi ? 'वापस' : 'Back',
        ),
        title: Column(
          children: [
            Text(
              isHindi ? 'मुख्य तथ्य विवरण — नमूना' : 'Key Fact Statement — Sample',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              isHindi
                  ? 'चरण 4 / 4 • नमूना केएफएस'
                  : 'Step 4 of 4 • Sample KFS',
              style: const TextStyle(
                color: AppTheme.secondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 1.0, // Step 4 of 4 = 100%
            backgroundColor: Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
            minHeight: 3,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ─── 1. Mandatory Disclaimer Banner ───────────────────
                    _buildMandatoryDisclaimer(isHindi),

                    const SizedBox(height: 16),

                    // ─── 2. Data Mode Indicator & Switcher ────────────────
                    _buildDataModeBadge(isHindi),

                    const SizedBox(height: 16),

                    // ─── 3. Header & Purpose Intro ───────────────────────
                    _buildHeaderSection(isHindi),

                    const SizedBox(height: 16),

                    // ─── 4. Selected Loan Terms & EMI Hero Card ──────────
                    _buildLoanTermsCard(isHindi, emiModel),

                    const SizedBox(height: 16),

                    // ─── 5. Fees & Charges Breakdown Card ────────────────
                    _buildFeesAndChargesCard(isHindi),

                    const SizedBox(height: 16),

                    // ─── 6. Total Cost of Borrowing Summary Card ─────────
                    _buildTotalCostCard(isHindi, emiModel, totalCostOfBorrowing, apr),

                    const SizedBox(height: 16),

                    // ─── 7. Amortization Schedule Preview ────────────────
                    _buildAmortizationPreview(isHindi, emiModel),

                    const SizedBox(height: 16),

                    // ─── 8. Explicit Assumptions Section ─────────────────
                    _buildAssumptionsCard(isHindi),

                    const SizedBox(height: 20),

                    // ─── 9. Acceptance Checkbox ──────────────────────────
                    _buildAcceptanceCheckbox(isHindi),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── 10. Sticky Bottom Action Bar ────────────────────────────
            _buildBottomBar(isHindi),
          ],
        ),
      ),
    );
  }

  // ─── Section 1: Mandatory Disclaimer Banner ────────────────────────
  Widget _buildMandatoryDisclaimer(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED), // Soft amber
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFDBA74), // Amber border
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEA580C).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFC2410C),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi
                      ? 'स्पष्टीकरण / अस्वीकरण (Disclaimer)'
                      : 'Regulatory & Demonstration Disclaimer',
                  style: const TextStyle(
                    color: Color(0xFF9A3412),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isHindi
                      ? 'Illustrative demonstration only. This is not an actual credit offer, approved loan, or legally operative KFS.'
                      : 'Illustrative demonstration only. This is not an actual credit offer, approved loan, or legally operative KFS.',
                  style: const TextStyle(
                    color: Color(0xFF7C2D12),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isHindi
                      ? 'यह नमूना विवरण केवल ग्राहक जागरूकता और डिजिटल प्रक्रिया के प्रदर्शन हेतु तैयार किया गया है। यह वास्तविक एनबीएफसी या ऋणदाता की औपचारिक स्वीकृति नहीं है।'
                      : 'This sample statement illustrates how digital lending terms and cost disclosures are presented. It does not constitute a sanctioned credit facility or legally operative agreement, and does not claim to fulfill every regulatory mandate.',
                  style: const TextStyle(
                    color: Color(0xFF9A3412),
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section 2: Data Mode Indicator & Switcher ─────────────────────
  Widget _buildDataModeBadge(bool isHindi) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Icon(
            _useDefaultExample
                ? Icons.tune_rounded
                : Icons.check_circle_outline_rounded,
            size: 18,
            color: _useDefaultExample ? AppTheme.secondary : AppTheme.success,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _useDefaultExample
                      ? (isHindi
                          ? 'डिफ़ॉल्ट डेमो उदाहरण (₹50,000)'
                          : 'Default Demo Example (₹50,000)')
                      : (isHindi
                          ? 'आपके द्वारा चयनित विवरण'
                          : 'Your Selected Application Terms'),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _useDefaultExample
                      ? (isHindi
                          ? 'मानक तुलनात्मक बेंचमार्क प्रदर्शित है'
                          : 'Standard reference benchmark displayed')
                      : (isHindi
                          ? 'चरण 1 में चुनी गई राशि व अवधि'
                          : 'Based on your selections in Step 1'),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (_hasUserSelection)
            TextButton(
              onPressed: _toggleSourceExample,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _useDefaultExample
                    ? (isHindi ? 'मेरा चयन देखें' : 'View My Selection')
                    : (isHindi ? 'डिफ़ॉल्ट देखें' : 'View Default'),
                style: const TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Section 3: Header Section ─────────────────────────────────────
  Widget _buildHeaderSection(bool isHindi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: AppTheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'मुख्य तथ्य विवरण (KFS)'
                        : 'Key Fact Statement (KFS)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isHindi
                        ? 'ऋण स्वीकृति से पूर्व लागत व शर्तों का पारदर्शी विवरण'
                        : 'Transparent summary of key loan terms, charges, and repayments',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Section 4: Selected Loan Terms Card ───────────────────────────
  Widget _buildLoanTermsCard(bool isHindi, EmiModel emiModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header band
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
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isHindi ? '1. मुख्य ऋण शर्तें' : '1. Key Loan Terms',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _loanType,
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Highlighting EMI Hero Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary,
                    AppTheme.secondary.withValues(alpha: 0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHindi ? 'अनुमानित मासिक ईएमआई' : 'Estimated Monthly EMI',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.currencyWithDecimals(emiModel.emi),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isHindi
                            ? '$_tenureMonths समान मासिक किस्तों में'
                            : 'In $_tenureMonths equated monthly instalments',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Parameter rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildFactRow(
                  label: isHindi ? 'चयनित ऋण प्रकार' : 'Selected Loan Type',
                  value: _loanType,
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi ? 'स्वीकृत/चयनित ऋण राशि (Principal)' : 'Selected Loan Amount (Principal)',
                  value: Formatters.currency(_loanAmount),
                  valueStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi
                      ? 'वार्षिक ब्याज दर (Illustrative)'
                      : 'Illustrative Annual Interest Rate',
                  value: '${_annualRate.toStringAsFixed(1)}% p.a.',
                  subtitle: isHindi
                      ? 'घटते मूलधन आधार पर (Reducing Balance)'
                      : 'Calculated on Reducing Balance method',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi ? 'चयनित ऋण अवधि' : 'Selected Tenure',
                  value: Formatters.tenure(_tenureMonths),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi
                      ? 'कुल अनुमानित पुनर्भुगतान'
                      : 'Total Estimated Repayment',
                  value: Formatters.currencyWithDecimals(emiModel.totalPayable),
                  valueStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    fontSize: 14,
                  ),
                  subtitle: isHindi
                      ? 'मूलधन + कुल देय ब्याज'
                      : 'Principal + Total interest payable',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ─── Section 5: Fees & Charges Breakdown Card ──────────────────────
  Widget _buildFeesAndChargesCard(bool isHindi) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header band
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
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isHindi ? '2. शुल्क एवं अन्य प्रभार' : '2. Fees & Other Charges',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                _buildFactRow(
                  label: isHindi ? 'प्रोसेसिंग शुल्क (Processing Fee)' : 'Processing Fee',
                  value: Formatters.currencyWithDecimals(_processingFee),
                  subtitle: isHindi
                      ? 'ऋण राशि का 1% (जीएसटी पूर्व)'
                      : 'Illustrative 1% of loan amount (excl. GST)',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi
                      ? 'लागू जीएसटी (18% शुल्क पर)'
                      : 'Applicable GST on Fee (18%)',
                  value: Formatters.currencyWithDecimals(_gstOnFee),
                  subtitle: isHindi
                      ? 'केवल प्रोसेसिंग शुल्क पर 18% कर'
                      : '18% GST levied on processing fee',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi ? 'कुल शुल्क व प्रभार' : 'Total Fees & Charges',
                  value: Formatters.currencyWithDecimals(_totalFeesAndCharges),
                  valueStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary,
                    fontSize: 14,
                  ),
                  subtitle: isHindi
                      ? 'प्रोसेसिंग शुल्क + जीएसटी'
                      : 'Processing Fee + GST combined',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi
                      ? 'शुद्ध संवितरण राशि (Net Disbursal)'
                      : 'Net Disbursable Amount',
                  value: Formatters.currencyWithDecimals(_netDisbursement),
                  valueStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.success,
                    fontSize: 14,
                  ),
                  subtitle: isHindi
                      ? 'मूलधन में से शुल्क घटाने के उपरांत'
                      : 'Principal minus upfront fees deducted',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi ? 'स्टाम्प ड्यूटी व प्रलेखन' : 'Stamp Duty & Documentation',
                  value: '₹0 (Nil)',
                  subtitle: isHindi ? 'नमूना प्रदर्शन में शून्य' : 'Waived in demonstration mode',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi ? 'समय पूर्व भुगतान प्रभार' : 'Prepayment / Foreclosure Charges',
                  value: 'Nil',
                  subtitle: isHindi
                      ? 'डेमो दिशानिर्देश अनुसार शून्य'
                      : 'Zero foreclosure charges for floating retail demo',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildFactRow(
                  label: isHindi ? 'विलंब शुल्क (Penal Charges)' : 'Late Payment / Penal Charges',
                  value: 'Nil',
                  subtitle: isHindi
                      ? 'डेमो के लिए लागू नहीं'
                      : 'Not applicable in demo simulation',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── Section 6: Total Cost of Borrowing Summary Card ───────────────
  Widget _buildTotalCostCard(
    bool isHindi,
    EmiModel emiModel,
    double totalCostOfBorrowing,
    double apr,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header band
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
              children: [
                const Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isHindi
                        ? '3. ऋण की कुल लागत'
                        : '3. Total Cost of Borrowing',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Highlight callout for total cost of borrowing
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF), // soft blue
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              isHindi
                                  ? 'अनुमानित कुल ऋण लागत'
                                  : 'Estimated Total Cost of Borrowing',
                              style: const TextStyle(
                                color: AppTheme.secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'APR ~${apr.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: AppTheme.secondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Formatters.currencyWithDecimals(totalCostOfBorrowing),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isHindi
                            ? 'कुल देय ब्याज (${Formatters.currencyWithDecimals(emiModel.totalInterest)}) + कुल शुल्क (${Formatters.currencyWithDecimals(_totalFeesAndCharges)})'
                            : 'Interest (${Formatters.currencyWithDecimals(emiModel.totalInterest)}) + Fees & GST (${Formatters.currencyWithDecimals(_totalFeesAndCharges)})',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Equation breakdown items
                _buildEquationItem(
                  label: isHindi ? 'मूलधन (Principal)' : 'Principal Amount',
                  amount: Formatters.currencyWithDecimals(_loanAmount),
                  prefix: '',
                  color: AppTheme.textPrimary,
                ),
                _buildEquationItem(
                  label: isHindi ? 'कुल अनुमानित ब्याज' : 'Total Estimated Interest',
                  amount: Formatters.currencyWithDecimals(emiModel.totalInterest),
                  prefix: '+ ',
                  color: const Color(0xFFD97706),
                ),
                _buildEquationItem(
                  label: isHindi ? 'कुल अग्रिम शुल्क व कर' : 'Total Upfront Fees & GST',
                  amount: Formatters.currencyWithDecimals(_totalFeesAndCharges),
                  prefix: '+ ',
                  color: AppTheme.secondary,
                ),
                const Divider(height: 16, color: Color(0xFFE2E8F0)),
                _buildEquationItem(
                  label: isHindi
                      ? 'कुल लागत (ब्याज + शुल्क)'
                      : 'Total Borrowing Cost (Interest + Fees)',
                  amount: Formatters.currencyWithDecimals(totalCostOfBorrowing),
                  prefix: '= ',
                  color: AppTheme.primary,
                  isBold: true,
                ),
                _buildEquationItem(
                  label: isHindi
                      ? 'ग्राहक द्वारा कुल पुनर्भुगतान'
                      : 'Total Repayment by Customer',
                  amount: Formatters.currencyWithDecimals(emiModel.totalPayable),
                  prefix: '= ',
                  color: AppTheme.primary,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section 7: Amortization Schedule Preview ──────────────────────
  Widget _buildAmortizationPreview(bool isHindi, EmiModel emiModel) {
    final schedule = emiModel.amortizationSchedule;
    // Show first 4 instalments by default, full on expand
    final displayList = _isScheduleExpanded ? schedule : schedule.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header band
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
              children: [
                const Icon(
                  Icons.table_chart_outlined,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isHindi
                        ? '4. किस्तों का विभाजन'
                        : '4. Illustrative Schedule',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_tenureMonths EMIs',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          isHindi ? 'माह' : 'Month',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          isHindi ? 'ईएमआई' : 'EMI',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          isHindi ? 'मूलधन' : 'Principal',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          isHindi ? 'ब्याज' : 'Interest',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // Table rows
                ...displayList.map((row) {
                  final monthNum = row['month']?.toInt() ?? 1;
                  final emiVal = row['emi'] ?? 0.0;
                  final principalVal = row['principal'] ?? 0.0;
                  final interestVal = row['interest'] ?? 0.0;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF1F5F9),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'M$monthNum',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '₹${emiVal.toStringAsFixed(0)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '₹${principalVal.toStringAsFixed(0)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '₹${interestVal.toStringAsFixed(0)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                if (schedule.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isScheduleExpanded = !_isScheduleExpanded;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isScheduleExpanded
                                  ? (isHindi ? 'कम दिखाएं' : 'Collapse Schedule')
                                  : (isHindi
                                      ? 'सभी $_tenureMonths किस्तें देखें'
                                      : 'View All $_tenureMonths Instalments'),
                              style: const TextStyle(
                                color: AppTheme.secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isScheduleExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: AppTheme.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section 8: Explicit Assumptions Card ──────────────────────────
  Widget _buildAssumptionsCard(bool isHindi) {
    final assumptions = isHindi
        ? [
            'मासिक घटते मूलधन (Reducing Balance) आधार पर वार्षिक 24% सांकेतिक ब्याज दर मानी गई है।',
            'ऋण अवधि के दौरान सभी किस्तें समय पर चुकाए जाने की परिकल्पना की गई है।',
            '1% प्रोसेसिंग शुल्क पर वर्तमान 18% जीएसटी दर लागू की गई है।',
            'यह विवरण केवल डिजिटल प्रारूप को प्रदर्शित करने हेतु एक नमूना है और कोई विधिक ऋण अनुबंध नहीं है।',
            'वास्तविक ऋण की शर्तें अंतिम अंडरराइटिंग एवं सत्यापन के पश्चात ही मान्य होंगी।',
          ]
        : [
            'Interest is calculated on a monthly reducing balance method at an illustrative rate of 24.0% p.a.',
            'Assumes regular and punctual repayments across all monthly instalments with no prepayment or defaults.',
            'Processing fee is illustrative at 1% of the loan amount with 18% GST applicable exclusively on the fee.',
            'This statement is purely illustrative for customer demonstration and does not constitute an actual credit sanction.',
            'Final commercial and credit terms are subject to formal underwriting and lending partner authorization.',
          ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                size: 18,
                color: Color(0xFFD97706),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isHindi
                      ? '5. गणना संबंधी स्पष्ट मान्यताएं (Assumptions)'
                      : '5. Explicit Financial Assumptions',
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...assumptions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Icon(
                      Icons.fiber_manual_record,
                      size: 6,
                      color: AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section 9: Acceptance Checkbox ────────────────────────────────
  Widget _buildAcceptanceCheckbox(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: _hasReviewed
            ? AppTheme.secondary.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hasReviewed
              ? AppTheme.secondary.withValues(alpha: 0.5)
              : const Color(0xFFCBD5E1),
          width: _hasReviewed ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _hasReviewed = !_hasReviewed;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _hasReviewed,
              activeColor: AppTheme.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (val) {
                setState(() {
                  _hasReviewed = val ?? false;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi
                          ? 'मैंने इस सांकेतिक उदाहरण की समीक्षा कर ली है'
                          : 'I have reviewed this illustrative example',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isHindi
                          ? 'मैं समझता/समझती हूँ कि यह केवल प्रदर्शन हेतु नमूना केएफएस है और यह वास्तविक ऋण स्वीकृति नहीं है।'
                          : 'I understand this is a sample Key Fact Statement for demonstration purposes only and not a legally binding credit contract.',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section 10: Fixed Bottom Bar ──────────────────────────────────
  Widget _buildBottomBar(bool isHindi) {
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
            PrimaryButton(
              text: isHindi ? 'डेमो जारी रखें (Continue Demo)' : 'Continue Demo',
              backgroundColor: AppTheme.accent,
              icon: Icons.arrow_forward_rounded,
              onPressed: _hasReviewed ? _onContinueDemo : null,
            ),
            if (!_hasReviewed)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  isHindi
                      ? 'आगे बढ़ने के लिए कृपया ऊपर दिए गए बॉक्स पर टिक करें'
                      : 'Please check the box above to continue the demo',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Helper Row Widgets ────────────────────────────────────────────
  Widget _buildFactRow({
    required String label,
    required String value,
    TextStyle? valueStyle,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle ??
                  const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquationItem({
    required String label,
    required String amount,
    required String prefix,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isBold ? AppTheme.primary : AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$prefix$amount',
            style: TextStyle(
              color: color,
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
