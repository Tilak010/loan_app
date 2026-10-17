import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';
import '../../config/app_routes.dart';
import '../../models/emi_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/loan_provider.dart';

/// Screen 4: Home Dashboard for Diksha Finance
///
/// Features:
/// - Header with "Namaste, Diksha" greeting, subtitle, profile avatar, and notification bell
/// - Promotional Banner: "Find the Right Loan for Your Needs" with dark navy & orange accents
/// - Loan Cards:
///     1. Personal Loan (₹10,000–₹1,00,000)
///     2. Business Loan (₹10,000–₹2,00,000)
/// - Interactive Compact EMI Calculator card with slider & tenure selection
/// - Dedicated Lending Partner section: "Proposed Lending Partner: To Be Confirmed"
/// - Complete navigation hooks into loan flow, tabs, and notifications
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Compact EMI calculator local state
  double _calcAmount = 50000;
  int _calcTenure = 12;

  final List<int> _tenureOptions = [3, 6, 12, 24];

  double _calculateEmi() {
    final emiModel = EmiModel(
      principal: _calcAmount,
      annualRate: AppConstants.sampleInterestRate,
      tenureMonths: _calcTenure,
    );
    return emiModel.emi;
  }

  String _formatCurrency(double amount) {
    final int val = amount.round();
    final String s = val.toString();
    if (s.length <= 3) return '₹$s';
    final String lastThree = s.substring(s.length - 3);
    final String rest = s.substring(0, s.length - 3);
    final StringBuffer result = StringBuffer();
    for (int i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) {
        result.write(',');
      }
      result.write(rest[i]);
    }
    result.write(',');
    result.write(lastThree);
    return '₹${result.toString()}';
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.accent.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.celebration_rounded,
                      color: AppTheme.accent,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Welcome to Diksha Finance!',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Explore our personal and business loan options with instant demo calculations.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.secondary.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: AppTheme.secondary,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Digital KYC Demonstration Ready',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Try the simulated KYC workflow with automated OCR and Key Fact Statement.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── 1. Header Area ────────────────────────────────────────
              _buildHeader(context, isHindi),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),

                    // ─── 2. Promotional Banner ───────────────────────────
                    _buildPromoBanner(context, isHindi),

                    const SizedBox(height: 24),

                    // ─── 3. Section Title: Loan Products ────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isHindi ? 'लोन विकल्प' : 'Loan Products',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AppProvider>().setNavIndex(1); // My Loans
                          },
                          child: Text(
                            isHindi ? 'सभी लोन' : 'View All',
                            style: const TextStyle(
                              color: AppTheme.secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ─── 4. Loan Cards: Personal & Business Loans ────────
                    _buildLoanCards(context, isHindi),

                    const SizedBox(height: 24),

                    // ─── 5. Compact EMI Calculator Card ─────────────────
                    _buildCompactEmiCalculator(context, isHindi),

                    const SizedBox(height: 24),

                    // ─── 6. Dedicated Lending Partner Section ───────────
                    _buildLendingPartnerSection(context, isHindi),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Top Header with Greeting, Subtitle, Avatar, and Notification Bell
  Widget _buildHeader(BuildContext context, bool isHindi) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Greeting & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isHindi ? 'नमस्ते, दीक्षा' : 'Namaste, Diksha',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const SizedBox(width: 6),
                    const Text('🙏', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isHindi ? 'दीक्षा फाइनेंस में आपका स्वागत है' : 'Welcome to Diksha Finance',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),

          // Notification Bell Icon with Badge
          InkWell(
            onTap: () => _showNotificationsSheet(context),
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.primary,
                    size: 22,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Profile Avatar on the Right
          GestureDetector(
            onTap: () {
              // Navigate to Profile tab
              context.read<AppProvider>().setNavIndex(3);
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'D',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Promotional Banner with Dark Navy Blue background and Orange Accents
  Widget _buildPromoBanner(BuildContext context, bool isHindi) {
    return Container(
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
          // Background decorative glow shapes
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 40,
            top: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Banner Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Orange Accent Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'FAST APPROVAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Heading
                      Text(
                        isHindi
                            ? 'अपनी ज़रूरतों के लिए सही लोन खोजें'
                            : 'Find the Right Loan for Your Needs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Supporting Text
                      Text(
                        isHindi
                            ? 'पर्सनल और बिजनेस लोन विकल्प देखें'
                            : 'Explore personal and business loan options',
                        style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Financial Vector Illustration Composition
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFF132D52),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.accent.withValues(alpha: 0.6),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 28,
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

  /// 3. Loan Cards: Card 1 Personal Loan & Card 2 Business Loan
  Widget _buildLoanCards(BuildContext context, bool isHindi) {
    return Column(
      children: [
        // ─── Card 1: Personal Loan ───────────────────────────────────────
        _LoanCardItem(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: AppTheme.secondary,
          iconBgColor: const Color(0xFFEFF6FF),
          heading: isHindi ? 'पर्सनल लोन' : 'Personal Loan',
          description: isHindi
              ? 'व्यक्तिगत ज़रूरतों के लिए आसान वित्तपोषण'
              : 'Explore financing options for personal needs',
          amountRange: '₹10,000–₹1,00,000',
          buttonLabel: isHindi ? 'लोन देखें (Explore)' : 'Explore Loan',
          onExplore: () {
            final loanProvider = context.read<LoanProvider>();
            loanProvider.setPurpose('Personal Expense');
            loanProvider.setLoanAmount(50000);
            Navigator.of(context).pushNamed(AppRoutes.loanAmount);
          },
        ),

        const SizedBox(height: 16),

        // ─── Card 2: Business Loan ───────────────────────────────────────
        _LoanCardItem(
          icon: Icons.storefront_rounded,
          iconColor: const Color(0xFFD97706),
          iconBgColor: const Color(0xFFFFFBEB),
          heading: isHindi ? 'बिजनेस लोन' : 'Business Loan',
          description: isHindi
              ? 'छोटे व्यवसायों के विकास के लिए लोन'
              : 'Explore financing options for small businesses',
          amountRange: '₹10,000–₹2,00,000',
          buttonLabel: isHindi ? 'लोन देखें (Explore)' : 'Explore Loan',
          onExplore: () {
            final loanProvider = context.read<LoanProvider>();
            loanProvider.setPurpose('Business');
            loanProvider.setLoanAmount(100000);
            Navigator.of(context).pushNamed(AppRoutes.loanAmount);
          },
        ),
      ],
    );
  }

  /// 4. Compact EMI Calculator Card with Slider, Tenure, and Monthly EMI
  Widget _buildCompactEmiCalculator(BuildContext context, bool isHindi) {
    final emi = _calculateEmi();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calculate_rounded,
                  color: AppTheme.secondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'त्वरित ईएमआई कैलकुलेटर' : 'Quick EMI Calculator',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      isHindi
                          ? 'तुरंत अपनी मासिक किस्त का अनुमान लगाएं'
                          : 'Estimate your monthly installment instantly',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Amount Row & Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'लोन राशि' : 'Loan Amount',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                _formatCurrency(_calcAmount),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.secondary,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: AppTheme.accent,
              overlayColor: AppTheme.accent.withValues(alpha: 0.2),
              trackHeight: 5,
            ),
            child: Slider(
              value: _calcAmount,
              min: 10000,
              max: 200000,
              divisions: 38,
              onChanged: (val) {
                setState(() {
                  _calcAmount = val;
                });
              },
            ),
          ),

          // Tenure Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'अवधि (महीने)' : 'Tenure (Months)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '$_calcTenure Months',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _tenureOptions.map((tenure) {
              final isSelected = _calcTenure == tenure;
              return InkWell(
                onTap: () {
                  setState(() {
                    _calcTenure = tenure;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    '$tenure M',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // Calculated Monthly EMI Highlight Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'अनुमानित मासिक ईएमआई' : 'Estimated Monthly EMI',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatCurrency(emi)} / mo',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '@ 14.5% p.a.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Button to Open Full EMI Calculator Screen
          OutlinedButton(
            onPressed: () {
              // Set loan amount and tenure into loan provider then switch to EMI Calc tab
              final loanProvider = context.read<LoanProvider>();
              loanProvider.setLoanAmount(_calcAmount);
              loanProvider.setTenureMonths(_calcTenure);
              context.read<AppProvider>().setNavIndex(2); // EMI Calculator tab
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.secondary,
              side: const BorderSide(color: AppTheme.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tune_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  isHindi ? 'विस्तृत ईएमआई कैलकुलेटर खोलें' : 'Open Complete EMI Calculator',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Dedicated Lending Partner Section
  Widget _buildLendingPartnerSection(BuildContext context, bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.handshake_outlined,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'लेंडिंग पार्टनर' : 'Lending Partner',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      AppConstants.proposedLendingPartner,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isHindi
                ? 'यह एप्लिकेशन एनबीएफसी लेंडिंग पार्टनर्स के लिए प्रस्तावित वर्कफ़्लो का प्रदर्शन करता है। साझेदारी की पुष्टि होने पर नाम अपडेट किया जाएगा।'
                : AppConstants.proposedLendingPartnerNote,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: AppTheme.secondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isHindi
                        ? 'आरबीआई डिजिटल लेंडिंग दिशा-निर्देशों का अनुपालन प्रदर्शित करने वाला डेमो'
                        : 'Simulated digital lending origination compliant with RBI flow standards',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
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
}

/// Reusable Card component for Personal Loan & Business Loan
class _LoanCardItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String heading;
  final String description;
  final String amountRange;
  final String buttonLabel;
  final VoidCallback onExplore;

  const _LoanCardItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.heading,
    required this.description,
    required this.amountRange,
    required this.buttonLabel,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        heading,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        amountRange,
                        style: const TextStyle(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.35,
                  ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onExplore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
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
}
