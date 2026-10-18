import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../models/emi_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/primary_button.dart';

/// Screen 5: Loan Amount and Tenure Selection
///
/// Supports both Personal Loan and Business Loan demo flows.
/// Features:
/// - Heading: "How much financing do you need?"
/// - Interactive Loan Type Selector (Personal vs Business Loan)
/// - Prominent Selected Loan Type and Current Amount Display
/// - Amount Slider from ₹10,000 to ₹2,00,000 with quick preset buttons
/// - Tenure Selector with 3, 6, 9, and 12 month options
/// - Dynamic EMI Summary Card with reducing-balance formula at 24% illustrative rate
/// - Safe zero-interest rate handling
/// - Orange Continue button navigating to Personal Details
/// - Back navigation with Step indicator
class LoanAmountScreen extends StatefulWidget {
  final String? initialLoanType;
  final double? initialAmount;
  final int? initialTenure;

  const LoanAmountScreen({
    super.key,
    this.initialLoanType,
    this.initialAmount,
    this.initialTenure,
  });

  @override
  State<LoanAmountScreen> createState() => _LoanAmountScreenState();
}

class _LoanAmountScreenState extends State<LoanAmountScreen> {
  // Constants for Screen 5
  static const double _minAmount = 10000.0;
  static const double _maxAmount = 200000.0;
  static const double _amountStep = 5000.0;
  static const double _illustrativeRate = 24.0; // 24% annual illustrative rate
  static const List<int> _tenureOptions = [3, 6, 9, 12];
  static const List<double> _presetAmounts = [25000, 50000, 100000, 200000];

  // Local state for immediate, responsive feedback
  late String _selectedLoanType;
  late double _selectedAmount;
  late int _selectedTenure;
  bool _initializedFromRoute = false;

  @override
  void initState() {
    super.initState();
    _selectedLoanType = widget.initialLoanType ?? 'Personal Loan';
    _selectedAmount = widget.initialAmount ?? 50000.0;
    _selectedTenure = widget.initialTenure ?? 12;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedFromRoute) {
      _initializedFromRoute = true;
      final loanProvider = context.read<LoanProvider>();

      // Check route arguments if passed
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is Map<String, dynamic>) {
        if (routeArgs['loanType'] is String) {
          _selectedLoanType = routeArgs['loanType'] as String;
        }
        if (routeArgs['loanAmount'] is num) {
          _selectedAmount = (routeArgs['loanAmount'] as num).toDouble();
        }
        if (routeArgs['tenureMonths'] is int) {
          _selectedTenure = routeArgs['tenureMonths'] as int;
        }
      } else {
        // Fallback to loan provider only if not provided in widget constructor
        if (widget.initialLoanType == null) {
          if (loanProvider.purpose.toLowerCase().contains('business')) {
            _selectedLoanType = 'Business Loan';
          } else if (loanProvider.loanType.isNotEmpty) {
            _selectedLoanType = loanProvider.loanType;
          }
        }

        if (widget.initialAmount == null) {
          if (loanProvider.loanAmount >= _minAmount &&
              loanProvider.loanAmount <= _maxAmount) {
            _selectedAmount = loanProvider.loanAmount;
          }
        }

        if (widget.initialTenure == null) {
          if (_tenureOptions.contains(loanProvider.tenureMonths)) {
            _selectedTenure = loanProvider.tenureMonths;
          }
        }
      }

      // Clamp amount within boundaries
      if (_selectedAmount < _minAmount) _selectedAmount = _minAmount;
      if (_selectedAmount > _maxAmount) _selectedAmount = _maxAmount;
    }
  }

  /// Calculates reducing-balance EMI locally using EmiModel
  EmiModel _calculateEmiModel() {
    return EmiModel(
      principal: _selectedAmount,
      annualRate: _illustrativeRate,
      tenureMonths: _selectedTenure,
    );
  }

  /// Validates amount and tenure inputs
  bool _validateInputs() {
    if (_selectedAmount < _minAmount || _selectedAmount > _maxAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Loan amount must be between ${Formatters.currency(_minAmount)} and ${Formatters.currency(_maxAmount)}.',
          ),
          backgroundColor: AppTheme.error,
        ),
      );
      return false;
    }

    if (!_tenureOptions.contains(_selectedTenure)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid tenure (3, 6, 9, or 12 months).'),
          backgroundColor: AppTheme.error,
        ),
      );
      return false;
    }

    return true;
  }

  /// Proceed to Personal Details screen
  void _onContinue() {
    if (!_validateInputs()) return;

    final emiModel = _calculateEmiModel();
    final loanProvider = context.read<LoanProvider>();

    // Update global provider state
    loanProvider.setLoanType(_selectedLoanType);
    loanProvider.setLoanAmount(_selectedAmount);
    loanProvider.setTenureMonths(_selectedTenure);
    loanProvider.setIllustrativeRate(_illustrativeRate);
    loanProvider.setPurpose(
      _selectedLoanType == 'Business Loan' ? 'Business' : 'Personal Expense',
    );
    loanProvider.setCurrentStep(1);

    // Pass parameters explicitly to Personal Details screen
    Navigator.of(context).pushNamed(
      AppRoutes.personalDetails,
      arguments: {
        'loanType': _selectedLoanType,
        'loanAmount': _selectedAmount,
        'tenureMonths': _selectedTenure,
        'interestRate': _illustrativeRate,
        'emi': emiModel.emi,
        'totalPayable': emiModel.totalPayable,
        'totalInterest': emiModel.totalInterest,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;
    final emiModel = _calculateEmiModel();

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
          tooltip: 'Back',
        ),
        title: Column(
          children: [
            Text(
              isHindi ? 'ऋण राशि व अवधि' : 'Loan Amount & Tenure',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              isHindi ? 'चरण 1 / 4 • ऋण विकल्प' : 'Step 1 of 4 • Loan Details',
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
            value: 0.25,
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
                    // ─── 1. Loan Type Selector (Personal vs Business) ─────────
                    _buildLoanTypeSelector(isHindi),

                    const SizedBox(height: 20),

                    // ─── 2. Main Heading ──────────────────────────────────────
                    Text(
                      isHindi
                          ? 'आपको कितने ऋण की आवश्यकता है?'
                          : 'How much financing do you need?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isHindi
                          ? 'अपनी आवश्यकता के अनुसार राशि और आसान अवधि चुनें।'
                          : 'Customize your loan amount and flexible tenure below.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.35,
                          ),
                    ),

                    const SizedBox(height: 20),

                    // ─── 3. Amount Selection Card ─────────────────────────────
                    _buildAmountCard(isHindi),

                    const SizedBox(height: 20),

                    // ─── 4. Tenure Selection Card ─────────────────────────────
                    _buildTenureCard(isHindi, emiModel),

                    const SizedBox(height: 20),

                    // ─── 5. EMI Summary Card ──────────────────────────────────
                    _buildEmiSummaryCard(isHindi, emiModel),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── Bottom Action Bar with Orange Continue Button ─────────
            _buildBottomActionBar(isHindi, emiModel),
          ],
        ),
      ),
    );
  }

  /// 1. Segmented Loan Type Selector: Personal Loan vs Business Loan
  Widget _buildLoanTypeSelector(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLoanTypeTab(
              type: 'Personal Loan',
              label: isHindi ? 'पर्सनल लोन' : 'Personal Loan',
              icon: Icons.account_balance_wallet_outlined,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildLoanTypeTab(
              type: 'Business Loan',
              label: isHindi ? 'बिजनेस लोन' : 'Business Loan',
              icon: Icons.storefront_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanTypeTab({
    required String type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedLoanType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedLoanType = type;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 2. Amount Selection Card with Slider and Quick Presets
  Widget _buildAmountCard(bool isHindi) {
    final int divisions = ((_maxAmount - _minAmount) / _amountStep).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row with loan type badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'चयनित राशि' : 'Selected Amount',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _selectedLoanType == 'Business Loan'
                      ? const Color(0xFFFFFBEB)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedLoanType == 'Business Loan'
                        ? const Color(0xFFFDE68A)
                        : const Color(0xFFBFDBFE),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _selectedLoanType == 'Business Loan'
                          ? Icons.business_center_rounded
                          : Icons.person_rounded,
                      size: 12,
                      color: _selectedLoanType == 'Business Loan'
                          ? const Color(0xFFB45309)
                          : AppTheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _selectedLoanType,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _selectedLoanType == 'Business Loan'
                            ? const Color(0xFFB45309)
                            : AppTheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Prominently Displayed Amount
          Center(
            child: Text(
              Formatters.currency(_selectedAmount),
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Amount Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.secondary,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: AppTheme.accent,
              overlayColor: AppTheme.accent.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 11,
                elevation: 3,
              ),
              trackHeight: 6,
            ),
            child: Slider(
              value: _selectedAmount,
              min: _minAmount,
              max: _maxAmount,
              divisions: divisions,
              onChanged: (val) {
                setState(() {
                  _selectedAmount = val;
                });
              },
            ),
          ),

          // Min & Max range indicators
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: ${Formatters.currency(_minAmount)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Max: ${Formatters.currency(_maxAmount)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // Quick Presets
          Text(
            isHindi ? 'त्वरित चयन' : 'Quick Amount Presets',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetAmounts.map((preset) {
              final isPresetActive = (_selectedAmount - preset).abs() < 1;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedAmount = preset;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isPresetActive
                        ? AppTheme.primary
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isPresetActive
                          ? AppTheme.primary
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    Formatters.currency(preset),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isPresetActive ? FontWeight.w700 : FontWeight.w600,
                      color: isPresetActive ? Colors.white : AppTheme.primary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 3. Tenure Selection Card (3, 6, 9, 12 Months)
  Widget _buildTenureCard(bool isHindi, EmiModel currentModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'चुनें पुनर्भुगतान अवधि' : 'Select Repayment Tenure',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_selectedTenure Months',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Grid / Row of Tenure Options (3, 6, 9, 12 Months)
          Row(
            children: _tenureOptions.map((tenure) {
              final isSelected = _selectedTenure == tenure;
              // Calculate specific EMI for this tenure to help user compare
              final tempEmiModel = EmiModel(
                principal: _selectedAmount,
                annualRate: _illustrativeRate,
                tenureMonths: tenure,
              );

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTenure = tenure;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.8 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primary.withValues(alpha: 0.18),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$tenure M',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Formatters.currency(tempEmiModel.emi),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFFFDBA74)
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '/mo',
                            style: TextStyle(
                              fontSize: 9,
                              color: isSelected
                                  ? Colors.white70
                                  : AppTheme.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 4. Dynamic EMI Summary Card with Breakdown & Illustrative Disclaimer
  Widget _buildEmiSummaryCard(bool isHindi, EmiModel emiModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient shapes
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calculate_rounded,
                            color: AppTheme.accent,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isHindi ? 'ईएमआई सारांश' : 'EMI SUMMARY',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.accent.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Text(
                        '$_illustrativeRate% p.a. (Illustrative)',
                        style: TextStyle(
                          color: Color(0xFFFED7AA),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Large EMI Callout
                Text(
                  isHindi ? 'अनुमानित मासिक किस्त' : 'Estimated Monthly EMI',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      Formatters.currency(emiModel.emi),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '/ month',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFF1E3A5F)),
                const SizedBox(height: 14),

                // Cost Breakdown Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBreakdownColumn(
                      label: isHindi ? 'मूलधन' : 'Principal',
                      value: Formatters.currency(emiModel.principal),
                    ),
                    _buildBreakdownColumn(
                      label: isHindi ? 'कुल ब्याज' : 'Total Interest',
                      value: Formatters.currency(emiModel.totalInterest),
                    ),
                    _buildBreakdownColumn(
                      label: isHindi ? 'कुल देय राशि' : 'Total Payable',
                      value: Formatters.currency(emiModel.totalPayable),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Illustrative Notice Box
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFFDBA74),
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isHindi
                              ? 'अनुकरणीय दर: 24% प्रति वर्ष • यह केवल डेमो गणना है, कोई वास्तविक ऋण प्रस्ताव नहीं।'
                              : 'Illustrative rate: 24.0% p.a. • This calculation is for demonstration purposes only and does not constitute an actual loan offer or sanction.',
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 10,
                            height: 1.35,
                          ),
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

  Widget _buildBreakdownColumn({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// 5. Fixed Bottom Action Bar with Orange Continue Button
  Widget _buildBottomActionBar(bool isHindi, EmiModel emiModel) {
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
        child: Row(
          children: [
            // Quick Recap of Selected EMI
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${Formatters.currency(_selectedAmount)} • $_selectedTenure M',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${Formatters.currency(emiModel.emi)}/mo',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Orange Continue Button
            Expanded(
              flex: 6,
              child: PrimaryButton(
                text: isHindi ? 'आगे बढ़ें (Continue)' : 'Continue',
                backgroundColor: AppTheme.accent,
                textColor: Colors.white,
                icon: Icons.arrow_forward_rounded,
                onPressed: _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
