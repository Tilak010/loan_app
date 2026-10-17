import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';
import '../../config/app_routes.dart';
import '../../config/app_strings.dart';
import '../../providers/app_provider.dart';

/// Screen 2: Welcome and Language Selection
///
/// Features:
/// - Dark navy blue header area with app logo and name
/// - Light grey background
/// - Heading: "Welcome to Diksha Finance"
/// - Supporting text: "Personal and Business Loan Application Demo"
/// - Interactive language selection (English and हिंदी)
/// - Selected language highlight & state synchronization
/// - Prominent orange "Get Started" button navigating to Mobile Login
/// - Demonstration application disclaimer footer
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final currentLang = appProvider.selectedLanguage;
    final isHindi = appProvider.isHindi;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        top: false, // Allow header to extend behind status bar
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ─── Dark Navy Header Area ─────────────────────────
                      _buildHeaderArea(context),

                      // ─── Main Content ──────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 24),

                            // Heading
                            Text(
                              isHindi
                                  ? AppStrings.tr('welcome_title', 'hi')
                                  : 'Welcome to Diksha Finance',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 8),

                            // Supporting Text
                            Text(
                              isHindi
                                  ? AppStrings.tr('welcome_subtitle', 'hi')
                                  : 'Personal and Business Loan Application Demo',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.textSecondary,
                                    height: 1.4,
                                  ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 32),

                            // Language Section Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.language_rounded,
                                  size: 18,
                                  color: AppTheme.secondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isHindi
                                      ? AppStrings.tr('select_language', 'hi')
                                      : 'Select Preferred Language',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Two Language Selection Options: हिंदी & English
                            Row(
                              children: [
                                // Option 1: Hindi
                                Expanded(
                                  child: _LanguageOptionCard(
                                    title: 'हिंदी',
                                    subtitle: 'Hindi',
                                    isSelected: currentLang == 'hi',
                                    onTap: () {
                                      context
                                          .read<AppProvider>()
                                          .setLanguage('hi');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Option 2: English
                                Expanded(
                                  child: _LanguageOptionCard(
                                    title: 'English',
                                    subtitle: 'अंग्रेजी',
                                    isSelected: currentLang == 'en',
                                    onTap: () {
                                      context
                                          .read<AppProvider>()
                                          .setLanguage('en');
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 36),

                            // Orange "Get Started" Button
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Save onboarding completion and navigate to Login
                                  context
                                      .read<AppProvider>()
                                      .completeOnboarding();
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.login);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accent,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shadowColor:
                                      AppTheme.accent.withValues(alpha: 0.35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isHindi
                                          ? AppStrings.tr('get_started', 'hi')
                                          : 'Get Started',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // ─── Small Demonstration Footer ────────────────────
                      _buildDemoFooter(context, isHindi),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Dark navy blue header area with app logo, name, and regional badge
  Widget _buildHeaderArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x2A0B1F3A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // App Logo Emblem
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF132D52),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.accent.withValues(alpha: 0.7),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  size: 26,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // App Name
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),

          const SizedBox(height: 6),

          // Tagline Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: const Text(
              AppConstants.appTagline,
              style: TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Small demonstration application disclaimer footer
  Widget _buildDemoFooter(BuildContext context, bool isHindi) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isHindi
                  ? AppStrings.tr('demo_footer', 'hi')
                  : 'Demonstration Application: For prospective NBFC lending partner review only. No real loans are disbursed.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.35,
                    fontSize: 11,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive card button for language selection
class _LanguageOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeBorderColor = AppTheme.secondary;
    const activeBgColor = Color(0xFFEFF6FF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeBorderColor : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.secondary.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            // Radio / Checkmark Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppTheme.secondary : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.secondary
                          : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Native Title (हिंदी / English)
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppTheme.secondary : AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
