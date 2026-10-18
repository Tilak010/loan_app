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

/// Screen: Interactive EMI Calculator
///
/// Features:
/// - Accessible from Bottom Navigation (Tab 2) and Direct Route
/// - Inputs:
///     1. Loan Amount (₹10,000 to ₹10,00,000) with Slider & Input Field
///     2. Annual Interest Rate (0% to 36%) with Slider & Input Field
///     3. Loan Tenure in Months (3 to 60 Months) with Slider & Input Field
/// - Display:
///     1. Estimated Monthly EMI (prominent Orange highlight)
///     2. Principal Amount
///     3. Total Interest Payable
///     4. Total Repayment Amount
///     5. Visual Breakdown Bar (Principal vs Interest %)
/// - Standard Reducing-Balance EMI formula using reusable [EmiModel]
/// - Safe handling of 0% interest and invalid inputs
/// - Indian currency formatting (e.g., ₹50,000)
/// - Prominent illustrative disclaimer
/// - Dark navy blue headings, white cards, responsive layout
class EmiCalculatorScreen extends StatefulWidget {
  final double? initialAmount;
  final double? initialRate;
  final int? initialTenure;

  const EmiCalculatorScreen({
    super.key,
    this.initialAmount,
    this.initialRate,
    this.initialTenure,
  });

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  // Constraints
  static const double _minAmount = 10000.0;
  static const double _maxAmount = 1000000.0;
  static const double _minRate = 0.0;
  static const double _maxRate = 36.0;
  static const int _minTenure = 3;
  static const int _maxTenure = 60;

  // Presets
  static const List<double> _amountPresets = [50000, 100000, 200000, 500000];
  static const List<double> _ratePresets = [10.5, 12.0, 14.5, 18.0, 24.0];
  static const List<int> _tenurePresets = [6, 12, 24, 36, 60];

  // State
  late double _amount;
  late double _annualRate;
  late int _tenureMonths;

  late TextEditingController _amountController;
  late TextEditingController _rateController;
  late TextEditingController _tenureController;

  bool _isUpdatingFromSlider = false;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount ?? 100000.0;
    _annualRate = widget.initialRate ?? 14.5;
    _tenureMonths = widget.initialTenure ?? 12;

    _amountController = TextEditingController(text: _amount.round().toString());
    _rateController = TextEditingController(text: _annualRate.toString());
    _tenureController = TextEditingController(text: _tenureMonths.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  /// Reusable calculation logic via EmiModel
  EmiModel get _emiModel {
    return EmiModel(
      principal: _amount,
      annualRate: _annualRate,
      tenureMonths: _tenureMonths,
    );
  }

  void _onAmountSliderChanged(double val) {
    setState(() {
      _amount = val;
      _isUpdatingFromSlider = true;
      _amountController.text = val.round().toString();
      _isUpdatingFromSlider = false;
    });
  }

  void _onAmountTextChanged(String text) {
    if (_isUpdatingFromSlider) return;
    final parsed = double.tryParse(text.replaceAll(',', '').trim());
    if (parsed != null && parsed >= 0) {
      setState(() {
        _amount = parsed.clamp(_minAmount, _maxAmount);
      });
    }
  }

  void _onRateSliderChanged(double val) {
    setState(() {
      _annualRate = double.parse(val.toStringAsFixed(1));
      _isUpdatingFromSlider = true;
      _rateController.text = _annualRate.toString();
      _isUpdatingFromSlider = false;
    });
  }

  void _onRateTextChanged(String text) {
    if (_isUpdatingFromSlider) return;
    final parsed = double.tryParse(text.trim());
    if (parsed != null && parsed >= 0) {
      setState(() {
        _annualRate = parsed.clamp(_minRate, _maxRate);
      });
    }
  }

  void _onTenureSliderChanged(double val) {
    setState(() {
      _tenureMonths = val.round();
      _isUpdatingFromSlider = true;
      _tenureController.text = _tenureMonths.toString();
      _isUpdatingFromSlider = false;
    });
  }

  void _onTenureTextChanged(String text) {
    if (_isUpdatingFromSlider) return;
    final parsed = int.tryParse(text.trim());
    if (parsed != null && parsed > 0) {
      setState(() {
        _tenureMonths = parsed.clamp(_minTenure, _maxTenure);
      });
    }
  }

  /// Action to apply with currently computed amount and tenure
  void _applyWithTheseTerms() {
    final loanProvider = context.read<LoanProvider>();
    loanProvider.setLoanAmount(_amount.clamp(10000, 200000));
    loanProvider.setTenureMonths(_tenureMonths);
    Navigator.of(context).pushNamed(
      AppRoutes.loanAmount,
      arguments: {
        'loanAmount': _amount.clamp(10000, 200000),
        'tenureMonths': _tenureMonths,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;
    final emiModel = _emiModel;
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: canPop
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppTheme.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calculate_rounded,
                  color: AppTheme.secondary,
                  size: 20,
                ),
              ),
        title: Text(
          isHindi ? 'ईएमआई कैलकुलेटर' : 'EMI Calculator',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── 1. Subtitle / Intro ─────────────────────────────────
              Text(
                isHindi
                    ? 'अपनी मासिक किस्त और ब्याज का त्वरित अनुमान लगाएं'
                    : 'Calculate your monthly installments & interest easily',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              // ─── 2. Prominent EMI Result Card ────────────────────────
              _buildEmiResultCard(isHindi, emiModel),

              const SizedBox(height: 20),

              // ─── 3. Loan Amount Input & Slider Card ──────────────────
              _buildAmountInputCard(isHindi),

              const SizedBox(height: 16),

              // ─── 4. Interest Rate Input & Slider Card ────────────────
              _buildRateInputCard(isHindi),

              const SizedBox(height: 16),

              // ─── 5. Tenure Input & Slider Card ───────────────────────
              _buildTenureInputCard(isHindi),

              const SizedBox(height: 20),

              // ─── 6. Cost Distribution Chart & Breakdown ───────────────
              _buildBreakdownCard(isHindi, emiModel),

              const SizedBox(height: 20),

              // ─── 7. Illustrative Disclaimer Notice ───────────────────
              _buildDisclaimerNotice(isHindi),

              const SizedBox(height: 24),

              // ─── 8. Action Button: Apply With This Loan ──────────────
              PrimaryButton(
                text: isHindi
                    ? 'लोन के लिए आवेदन करें'
                    : 'Apply for this Loan',
                icon: Icons.check_circle_outline_rounded,
                backgroundColor: AppTheme.accent,
                onPressed: _applyWithTheseTerms,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Prominent EMI Result Highlight Card with Dark Navy Background
  Widget _buildEmiResultCard(bool isHindi, EmiModel emiModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient decoration
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isHindi ? 'अनुमानित मासिक ईएमआई' : 'ESTIMATED MONTHLY EMI',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.accent.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      '$_annualRate% p.a.',
                      style: const TextStyle(
                        color: Color(0xFFFED7AA),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Orange Highlighted Monthly EMI
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    Formatters.currency(emiModel.emi),
                    style: const TextStyle(
                      color: AppTheme.accent, // Orange highlight
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '/ month',
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFF1E3A5F)),
              const SizedBox(height: 14),

              // Three-Column Quick Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildResultMiniItem(
                    label: isHindi ? 'मूलधन' : 'Principal',
                    value: Formatters.currency(emiModel.principal),
                  ),
                  _buildResultMiniItem(
                    label: isHindi ? 'कुल ब्याज' : 'Total Interest',
                    value: Formatters.currency(emiModel.totalInterest),
                    highlightColor: const Color(0xFFFDBA74),
                  ),
                  _buildResultMiniItem(
                    label: isHindi ? 'कुल देय राशि' : 'Total Payable',
                    value: Formatters.currency(emiModel.totalPayable),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultMiniItem({
    required String label,
    required String value,
    Color? highlightColor,
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
          style: TextStyle(
            color: highlightColor ?? Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// 2. Loan Amount Input & Slider Card
  Widget _buildAmountInputCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                isHindi ? 'ऋण राशि (Loan Amount)' : 'Loan Amount',
                style: const TextStyle(
                  color: AppTheme.primary, // Dark navy blue heading
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Interactive Input Box with ₹ Prefix
              SizedBox(
                width: 140,
                height: 42,
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    prefixStyle: const TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.secondary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: _onAmountTextChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.secondary,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: AppTheme.accent,
              overlayColor: AppTheme.accent.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              trackHeight: 5,
            ),
            child: Slider(
              value: _amount.clamp(_minAmount, _maxAmount),
              min: _minAmount,
              max: _maxAmount,
              divisions: 198,
              onChanged: _onAmountSliderChanged,
            ),
          ),

          // Min & Max Range Labels
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
                  ),
                ),
                Text(
                  'Max: ${Formatters.currency(_maxAmount)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Amount Preset Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amountPresets.map((preset) {
              final isSelected = (_amount - preset).abs() < 1;
              return InkWell(
                onTap: () {
                  _onAmountSliderChanged(preset);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    Formatters.currency(preset),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
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

  /// 3. Annual Interest Rate Input & Slider Card
  Widget _buildRateInputCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                isHindi ? 'वार्षिक ब्याज दर (Interest Rate)' : 'Interest Rate (p.a.)',
                style: const TextStyle(
                  color: AppTheme.primary, // Dark navy blue heading
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Interactive Input Box with % Suffix
              SizedBox(
                width: 100,
                height: 42,
                child: TextField(
                  controller: _rateController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    suffixText: ' %',
                    suffixStyle: const TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.secondary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: _onRateTextChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.secondary,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: AppTheme.accent,
              overlayColor: AppTheme.accent.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              trackHeight: 5,
            ),
            child: Slider(
              value: _annualRate.clamp(_minRate, _maxRate),
              min: _minRate,
              max: _maxRate,
              divisions: 72,
              onChanged: _onRateSliderChanged,
            ),
          ),

          // Min & Max Range Labels
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: 0%',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  'Max: 36%',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Rate Preset Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ratePresets.map((preset) {
              final isSelected = (_annualRate - preset).abs() < 0.05;
              return InkWell(
                onTap: () {
                  _onRateSliderChanged(preset);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$preset%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
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

  /// 4. Tenure Input & Slider Card
  Widget _buildTenureInputCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                isHindi ? 'अवधि (Tenure in Months)' : 'Tenure in Months',
                style: const TextStyle(
                  color: AppTheme.primary, // Dark navy blue heading
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Interactive Input Box with "Mo" Suffix
              SizedBox(
                width: 100,
                height: 42,
                child: TextField(
                  controller: _tenureController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    suffixText: ' Mo',
                    suffixStyle: const TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.secondary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: _onTenureTextChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.secondary,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: AppTheme.accent,
              overlayColor: AppTheme.accent.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              trackHeight: 5,
            ),
            child: Slider(
              value: _tenureMonths.toDouble().clamp(
                    _minTenure.toDouble(),
                    _maxTenure.toDouble(),
                  ),
              min: _minTenure.toDouble(),
              max: _maxTenure.toDouble(),
              divisions: _maxTenure - _minTenure,
              onChanged: _onTenureSliderChanged,
            ),
          ),

          // Min & Max Range Labels
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: 3 Months',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  'Max: 60 Months',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tenure Preset Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tenurePresets.map((preset) {
              final isSelected = _tenureMonths == preset;
              return InkWell(
                onTap: () {
                  _onTenureSliderChanged(preset.toDouble());
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$preset M',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
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

  /// 5. Breakdown Card with Visual Ratio Bar
  Widget _buildBreakdownCard(bool isHindi, EmiModel emiModel) {
    final double total = emiModel.totalPayable;
    final double principalRatio =
        total > 0 ? (emiModel.principal / total).clamp(0.0, 1.0) : 1.0;
    final double interestRatio =
        total > 0 ? (emiModel.totalInterest / total).clamp(0.0, 1.0) : 0.0;

    final principalPercent = (principalRatio * 100).toStringAsFixed(1);
    final interestPercent = (interestRatio * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            isHindi ? 'भुगतान विवरण (Payment Breakdown)' : 'Payment Breakdown',
            style: const TextStyle(
              color: AppTheme.primary, // Dark navy blue heading
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          // Visual Ratio Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: (principalRatio * 1000).round(),
                    child: Container(color: AppTheme.secondary),
                  ),
                  if (interestRatio > 0)
                    Expanded(
                      flex: (interestRatio * 1000).round(),
                      child: Container(color: AppTheme.accent),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Legend & Amounts
          _buildBreakdownRow(
            color: AppTheme.secondary,
            title: isHindi ? 'मूलधन (Principal Amount)' : 'Principal Amount',
            percent: '$principalPercent%',
            amount: Formatters.currency(emiModel.principal),
          ),

          const Divider(height: 16, color: Color(0xFFF1F5F9)),

          _buildBreakdownRow(
            color: AppTheme.accent,
            title: isHindi ? 'कुल ब्याज (Total Interest Payable)' : 'Total Interest Payable',
            percent: '$interestPercent%',
            amount: Formatters.currency(emiModel.totalInterest),
            isOrange: true,
          ),

          const Divider(height: 16, color: Color(0xFFF1F5F9)),

          _buildBreakdownRow(
            color: AppTheme.primary,
            title: isHindi ? 'कुल देय राशि (Total Repayment Amount)' : 'Total Repayment Amount',
            percent: '100%',
            amount: Formatters.currency(emiModel.totalPayable),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow({
    required Color color,
    required String title,
    required String percent,
    required String amount,
    bool isOrange = false,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  percent,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: isOrange ? AppTheme.accent : AppTheme.primary,
          ),
        ),
      ],
    );
  }

  /// 6. Illustrative Disclaimer Notice
  Widget _buildDisclaimerNotice(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFD97706),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isHindi
                  ? 'यह गणना केवल उदाहरण के उद्देश्य से है। वास्तविक ऋण राशि, ब्याज दर और ईएमआई एनबीएफसी पार्टनर के स्वीकृति नियमों पर निर्भर करेगी।'
                  : 'This calculation is for illustrative and estimation purposes only. It does not constitute a loan offer or sanction. Actual terms, interest rate, and fees depend on lender underwriting criteria.',
              style: const TextStyle(
                color: Color(0xFF92400E),
                fontSize: 11,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
