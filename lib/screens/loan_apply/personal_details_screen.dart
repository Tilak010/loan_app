import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/app_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/validators.dart';
import '../../utils/formatters.dart';
import '../../widgets/input_field.dart';
import '../../widgets/primary_button.dart';

/// Screen 6: Personal Details Form
///
/// Features:
/// - Heading: "Tell Us About Yourself"
/// - Clean, section-based form layout
/// - Progress indicator: Step 2 of 4 (50%)
/// - Dynamic fields:
///     - Personal Loan: Salaried / Monthly Income fields
///     - Business Loan: Business Owner / Shopkeeper / Monthly Sales fields
/// - Fields: Full Name, Date of Birth (DatePicker + validation), PAN (ABCDE1234F),
///   Aadhaar (last 4 digits only), Occupation, Monthly Income / Sales
/// - Strict field-level validation with clear error messages
/// - Privacy banner reminding users this is a synthetic demo
/// - 1-Tap "Fill Demo Details" helper button for quick demonstration
/// - Review Modal Sheet before proceeding to KYC
/// - Back navigation and Continue to Demo KYC screen
class PersonalDetailsScreen extends StatefulWidget {
  final String? initialLoanType;

  const PersonalDetailsScreen({
    super.key,
    this.initialLoanType,
  });

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _panController;
  late TextEditingController _aadhaarController;
  late TextEditingController _incomeController;
  late TextEditingController _salesController;
  late TextEditingController _businessNameController;

  late String _loanType;
  late String _selectedOccupation; // Salaried, Business Owner, Shopkeeper
  bool _initialized = false;

  final List<String> _occupationOptions = [
    'Salaried',
    'Business Owner',
    'Shopkeeper',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dobController = TextEditingController();
    _panController = TextEditingController();
    _aadhaarController = TextEditingController();
    _incomeController = TextEditingController();
    _salesController = TextEditingController();
    _businessNameController = TextEditingController();

    _loanType = widget.initialLoanType ?? 'Personal Loan';
    _selectedOccupation =
        _loanType == 'Business Loan' ? 'Business Owner' : 'Salaried';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final loanProvider = context.read<LoanProvider>();

      // Read arguments from route if available
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is Map<String, dynamic> &&
          routeArgs['loanType'] is String) {
        _loanType = routeArgs['loanType'] as String;
      } else if (loanProvider.loanType.isNotEmpty) {
        _loanType = loanProvider.loanType;
      }

      // Default occupation based on loan type
      if (_loanType == 'Business Loan') {
        _selectedOccupation = 'Business Owner';
      } else {
        _selectedOccupation = 'Salaried';
      }

      // Pre-fill existing data from provider if user is returning
      if (loanProvider.fullName.isNotEmpty) {
        _nameController.text = loanProvider.fullName;
      }
      if (loanProvider.dateOfBirth.isNotEmpty) {
        _dobController.text = loanProvider.dateOfBirth;
      }
      if (loanProvider.pan.isNotEmpty) {
        _panController.text = loanProvider.pan;
      }
      if (loanProvider.aadhaarLastFour.isNotEmpty) {
        _aadhaarController.text = loanProvider.aadhaarLastFour;
      }
      if (loanProvider.monthlyIncome > 0) {
        _incomeController.text = loanProvider.monthlyIncome.round().toString();
      }
      if (loanProvider.monthlySales > 0) {
        _salesController.text = loanProvider.monthlySales.round().toString();
      }
      if (loanProvider.businessName.isNotEmpty) {
        _businessNameController.text = loanProvider.businessName;
      }
      if (loanProvider.occupation.isNotEmpty) {
        _selectedOccupation = loanProvider.occupation;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _panController.dispose();
    _aadhaarController.dispose();
    _incomeController.dispose();
    _salesController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  /// Helper: Fill synthetic demo information with 1 tap
  void _fillSyntheticDemoData() {
    setState(() {
      _nameController.text = 'Rahul Sharma';
      _dobController.text = '15/08/1992';
      _panController.text = 'ABCDE1234F';
      _aadhaarController.text = '1234';

      if (_isBusinessFlow) {
        _selectedOccupation = 'Business Owner';
        _salesController.text = '150000';
        _businessNameController.text = 'Sharma Enterprises';
      } else {
        _selectedOccupation = 'Salaried';
        _incomeController.text = '45000';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Synthetic demo details filled safely.'),
        backgroundColor: AppTheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  bool get _isBusinessFlow =>
      _loanType == 'Business Loan' || _selectedOccupation != 'Salaried';

  /// Select date of birth using native DatePicker
  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
    final initialDate = DateTime(now.year - 28, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1930),
      lastDate: eighteenYearsAgo,
      helpText: 'SELECT DATE OF BIRTH (MIN 18 YRS)',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {
        _dobController.text = formatted;
      });
    }
  }

  /// Form submission handler: Validates and shows review modal
  void _onContinuePressed() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    _showReviewBottomSheet();
  }

  /// Displays review modal bottom sheet before proceeding to KYC
  void _showReviewBottomSheet() {
    final double income = double.tryParse(
          _incomeController.text.replaceAll(',', '').trim(),
        ) ??
        0;
    final double sales = double.tryParse(
          _salesController.text.replaceAll(',', '').trim(),
        ) ??
        0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Modal Handle
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

                // Modal Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.fact_check_outlined,
                        color: AppTheme.secondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Review Demo Details',
                            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                          ),
                          const Text(
                            'Verify applicant information before simulated KYC',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Details Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _buildReviewRow('Loan Type', _loanType, isTag: true),
                      const SizedBox(height: 10),
                      _buildReviewRow('Full Name', _nameController.text.trim()),
                      const SizedBox(height: 10),
                      _buildReviewRow('Date of Birth', _dobController.text.trim()),
                      const SizedBox(height: 10),
                      _buildReviewRow('PAN (Demo)', _panController.text.trim().toUpperCase()),
                      const SizedBox(height: 10),
                      _buildReviewRow(
                        'Aadhaar (Last 4)',
                        '•••• •••• ${_aadhaarController.text.trim()}',
                      ),
                      const SizedBox(height: 10),
                      _buildReviewRow('Occupation', _selectedOccupation),
                      const SizedBox(height: 10),
                      if (_selectedOccupation == 'Salaried')
                        _buildReviewRow(
                          'Monthly Income',
                          Formatters.currency(income),
                          highlight: true,
                        )
                      else ...[
                        _buildReviewRow(
                          'Monthly Sales',
                          Formatters.currency(sales),
                          highlight: true,
                        ),
                        if (_businessNameController.text.trim().isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _buildReviewRow(
                            'Business Name',
                            _businessNameController.text.trim(),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Simulated Privacy Disclaimer
                const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppTheme.success, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Simulated demonstration environment. No real data transmitted.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Action Buttons: Edit or Proceed
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: PrimaryButton(
                        text: 'Confirm & Continue',
                        backgroundColor: AppTheme.accent,
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _saveAndNavigateToKyc();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewRow(String label, String value,
      {bool isTag = false, bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isTag)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondary,
              ),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              color: highlight ? AppTheme.accent : AppTheme.primary,
            ),
          ),
      ],
    );
  }

  /// Persists demo details to LoanProvider and proceeds to KycUploadScreen
  void _saveAndNavigateToKyc() {
    final loanProvider = context.read<LoanProvider>();
    final double income = double.tryParse(
          _incomeController.text.replaceAll(',', '').trim(),
        ) ??
        0;
    final double sales = double.tryParse(
          _salesController.text.replaceAll(',', '').trim(),
        ) ??
        0;

    loanProvider.setPersonalDetails(
      fullName: _nameController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      pan: _panController.text.trim().toUpperCase(),
      aadhaarLastFour: _aadhaarController.text.trim(),
      occupation: _selectedOccupation,
      employmentType: _selectedOccupation,
      monthlyIncome: income,
      monthlySales: sales,
      businessName: _businessNameController.text.trim(),
    );
    loanProvider.setCurrentStep(2);

    Navigator.of(context).pushNamed(AppRoutes.kycUpload);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;

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
        title: Column(
          children: [
            Text(
              isHindi ? 'व्यक्तिगत विवरण' : 'Personal Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              isHindi ? 'चरण 2 / 4 • आवेदक जानकारी' : 'Step 2 of 4 • Applicant Details',
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
            value: 0.50, // Step 2 of 4 = 50%
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ─── Top Privacy Notice (Synthetic Demo Data) ───────────
                      _buildPrivacyNotice(isHindi),

                      const SizedBox(height: 18),

                      // ─── Main Heading ───────────────────────────────────────
                      Text(
                        isHindi ? 'अपने बारे में बताएं' : 'Tell Us About Yourself',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isHindi
                            ? 'क्रेडिट मूल्यांकन और त्वरित सत्यापन के लिए विवरण दर्ज करें।'
                            : 'Enter basic applicant information for demonstration review.',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ─── SECTION 1: Basic & Identity Details ─────────────────
                      _buildSectionHeader(
                        title: isHindi ? '1. पहचान व व्यक्तिगत जानकारी' : '1. Identity & Personal Details',
                        icon: Icons.person_pin_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildIdentitySection(isHindi),

                      const SizedBox(height: 24),

                      // ─── SECTION 2: Employment & Income Details ──────────────
                      _buildSectionHeader(
                        title: isHindi ? '2. व्यवसाय व आय विवरण' : '2. Occupation & Income Details',
                        icon: Icons.work_outline_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildOccupationSection(isHindi),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Fixed Bottom Bar with Continue Button ─────────────────
            _buildBottomBar(isHindi),
          ],
        ),
      ),
    );
  }

  /// Privacy and synthetic data reminder banner
  Widget _buildPrivacyNotice(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.security_rounded,
                color: Color(0xFFD97706),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isHindi ? 'डेमो सूचना — निजता सुरक्षा' : 'Demo Notice — Privacy Protection',
                  style: const TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _fillSyntheticDemoData,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Fill Demo Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isHindi
                ? 'यह एक परीक्षण डेमो है। कृपया कोई भी वास्तविक आधार या पैन नंबर दर्ज न करें।'
                : 'This is a simulation for NBFC partnership review. Do NOT enter real Aadhaar or PAN details. Use synthetic demo details.',
            style: const TextStyle(
              color: Color(0xFFB45309),
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.secondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// Section 1: Identity & Personal Details Card
  Widget _buildIdentitySection(bool isHindi) {
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
          // 1. Full Name Field
          InputField(
            label: isHindi ? 'पूरा नाम (पैन कार्ड के अनुसार)' : 'Full Name (as per PAN)',
            hint: 'e.g. Rahul Sharma',
            controller: _nameController,
            prefixIcon: Icons.badge_outlined,
            keyboardType: TextInputType.name,
            validator: Validators.name,
          ),

          const SizedBox(height: 16),

          // 2. Date of Birth Field
          InputField(
            label: isHindi ? 'जन्म तिथि (कम से कम 18 वर्ष)' : 'Date of Birth (DD/MM/YYYY)',
            hint: 'DD/MM/YYYY',
            controller: _dobController,
            prefixIcon: Icons.cake_outlined,
            keyboardType: TextInputType.datetime,
            validator: Validators.dob,
            suffix: IconButton(
              icon: const Icon(Icons.calendar_today_rounded, size: 20, color: AppTheme.secondary),
              onPressed: _selectDateOfBirth,
              tooltip: 'Open Calendar',
            ),
          ),

          const SizedBox(height: 16),

          // 3. PAN Card Field (Auto Uppercase)
          InputField(
            label: isHindi ? 'पैन कार्ड नंबर (डेमो प्रारूप)' : 'PAN Card Number (Demo Format)',
            hint: 'e.g. ABCDE1234F',
            controller: _panController,
            prefixIcon: Icons.credit_card_rounded,
            keyboardType: TextInputType.text,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              TextInputFormatter.withFunction(
                (oldValue, newValue) => newValue.copyWith(
                  text: newValue.text.toUpperCase(),
                ),
              ),
            ],
            validator: Validators.pan,
          ),

          const SizedBox(height: 16),

          // 4. Aadhaar Last 4 Digits Field
          InputField(
            label: isHindi ? 'आधार संख्या (केवल अंतिम 4 अंक)' : 'Aadhaar (Last 4 Digits Only)',
            hint: '1234',
            controller: _aadhaarController,
            prefixIcon: Icons.fingerprint_rounded,
            keyboardType: TextInputType.number,
            maxLength: 4,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.aadhaarLastFour,
            suffix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Text(
                '•••• ••••',
                style: TextStyle(
                  color: AppTheme.textHint,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section 2: Occupation & Income / Sales Card
  Widget _buildOccupationSection(bool isHindi) {
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
          // 7. Occupation Selection
          Text(
            isHindi ? 'व्यवसाय का प्रकार (Occupation)' : 'Occupation Type',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),

          // Occupation Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _occupationOptions.map((occ) {
              final isSelected = _selectedOccupation == occ;
              IconData occIcon;
              if (occ == 'Salaried') {
                occIcon = Icons.badge_outlined;
              } else if (occ == 'Business Owner') {
                occIcon = Icons.business_center_outlined;
              } else {
                occIcon = Icons.storefront_outlined;
              }

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedOccupation = occ;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        occIcon,
                        size: 16,
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        occ,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // Conditional Income vs Sales Fields
          if (_selectedOccupation == 'Salaried') ...[
            // 5. Monthly Income for Salaried Users
            InputField(
              label: isHindi ? 'मासिक शुद्ध आय (Monthly Net Income)' : 'Monthly Net Income',
              hint: 'e.g. 45000',
              controller: _incomeController,
              prefixIcon: Icons.currency_rupee_rounded,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.income,
            ),
          ] else ...[
            // 6. Monthly Sales for Business Users / Shopkeepers
            InputField(
              label: isHindi
                  ? 'मासिक बिक्री / टर्नओवर (Monthly Sales / Turnover)'
                  : 'Monthly Sales / Turnover',
              hint: 'e.g. 150000',
              controller: _salesController,
              prefixIcon: Icons.currency_rupee_rounded,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.sales,
            ),

            const SizedBox(height: 16),

            // Business / Enterprise Name
            InputField(
              label: isHindi ? 'व्यवसाय / दुकान का नाम' : 'Business / Shop Name',
              hint: 'e.g. Sharma Enterprises',
              controller: _businessNameController,
              prefixIcon: Icons.store_rounded,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter your business or shop name';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  /// Fixed Bottom Bar with Continue button
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
        child: PrimaryButton(
          text: isHindi ? 'समीक्षा करें व आगे बढ़ें' : 'Review & Continue to KYC',
          backgroundColor: AppTheme.accent,
          icon: Icons.arrow_forward_rounded,
          onPressed: _onContinuePressed,
        ),
      ),
    );
  }
}
