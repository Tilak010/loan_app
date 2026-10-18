import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';
import '../../config/app_routes.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/formatters.dart';

/// Screen 11: Profile Screen
///
/// FEATURES:
/// - Displays demo user name and masked mobile number
/// - Language Selection bottom sheet (English, Hindi, Marathi, etc.)
/// - Informational & Regulatory links:
///     - About Us
///     - Privacy Policy
///     - Terms & Conditions
///     - Grievance Officer
///     - Contact Us
/// - Logout confirmation:
///     - Clears simulated auth session
///     - Clears temporary loan form state
///     - Returns to Welcome screen
/// - Responsive, polished presentation design
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLanguageSelector(BuildContext context, AppProvider? appProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SafeArea(
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
                Text(
                  'Select Application Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Choose your preferred language for the demo experience',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ...AppConstants.supportedLanguages.map((lang) {
                  final code = lang['code'] ?? 'en';
                  final name = lang['name'] ?? '';
                  final native = lang['native'] ?? '';
                  final isSelected = (appProvider?.selectedLanguage ?? 'en') == code;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: isSelected
                          ? AppTheme.secondary.withValues(alpha: 0.08)
                          : const Color(0xFFF8FAFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.secondary
                              : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 2,
                      ),
                      leading: Icon(
                        Icons.translate_rounded,
                        size: 20,
                        color: isSelected ? AppTheme.secondary : AppTheme.textHint,
                      ),
                      title: Text(
                        '$native ($name)',
                        style: TextStyle(
                          color: isSelected ? AppTheme.secondary : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppTheme.secondary,
                              size: 20,
                            )
                          : null,
                      onTap: () {
                        appProvider?.setLanguage(code);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                );
                }),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(
    BuildContext context,
    bool isHindi,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppTheme.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isHindi ? 'लॉग आउट करें?' : 'Log Out?',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          isHindi
              ? 'क्या आप डेमो सत्र से लॉग आउट करना चाहते हैं? इससे आपकी अस्थाई डेमो सत्र स्थिति रीसेट हो जाएगी।'
              : 'Are you sure you want to log out of the demo session? This will clear your simulated login state and temporary form data.',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              isHindi ? 'रद्द करें' : 'Cancel',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                final authProvider = context.read<AuthProvider>();
                authProvider.logout();
              } catch (_) {}

              try {
                final loanProvider = context.read<LoanProvider>();
                loanProvider.resetApplication();
              } catch (_) {}

              try {
                final appProvider = context.read<AppProvider>();
                appProvider.setNavIndex(0);
              } catch (_) {}

              // Return to Welcome screen (clears dialog and all previous routes)
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.welcome,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isHindi ? 'लॉग आउट' : 'Log Out',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider? authProvider;
    try {
      authProvider = Provider.of<AuthProvider>(context, listen: true);
    } catch (_) {}

    AppProvider? appProvider;
    try {
      appProvider = Provider.of<AppProvider>(context, listen: true);
    } catch (_) {}

    final isHindi = appProvider?.isHindi ?? false;

    final user = authProvider?.currentUser;
    final userName = (user?.name != null && user!.name.isNotEmpty)
        ? user.name
        : AppConstants.mockUserName;
    final userPhone = (user?.phone != null && user!.phone.isNotEmpty)
        ? user.phone
        : ((authProvider != null && authProvider.phoneNumber.isNotEmpty)
            ? authProvider.phoneNumber
            : AppConstants.mockUserPhone);
    final maskedPhone = Formatters.maskedPhone(userPhone);

    final currentLangCode = appProvider?.selectedLanguage ?? 'en';
    final currentLangMap = AppConstants.supportedLanguages.firstWhere(
      (l) => l['code'] == currentLangCode,
      orElse: () => {'name': 'English', 'native': 'English'},
    );
    final currentLanguageLabel =
        '${currentLangMap['native']} (${currentLangMap['name']})';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          isHindi ? 'प्रोफ़ाइल एवं सेटिंग्स' : 'Profile & Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
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
              // ─── 1. User Profile Hero Card ──────────────────────────
              _buildUserProfileCard(
                userName: userName,
                maskedPhone: maskedPhone,
                isHindi: isHindi,
              ),

              const SizedBox(height: 20),

              // ─── 2. Preferences & Language Section ───────────────────
              _buildSectionHeader(isHindi ? 'प्राथमिकताएं' : 'Preferences'),
              const SizedBox(height: 8),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.translate_rounded,
                  iconColor: AppTheme.secondary,
                  title: isHindi ? 'ऐप भाषा' : 'Language',
                  subtitle: currentLanguageLabel,
                  onTap: () => _showLanguageSelector(context, appProvider),
                  showChevron: true,
                ),
              ]),

              const SizedBox(height: 20),

              // ─── 3. Legal & Compliance Section ───────────────────────
              _buildSectionHeader(
                isHindi ? 'कंपनी एवं कानूनी जानकारी' : 'About & Legal Information',
              ),
              const SizedBox(height: 8),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.corporate_fare_rounded,
                  iconColor: AppTheme.primary,
                  title: isHindi ? 'हमारे बारे में' : 'About Us',
                  subtitle: isHindi
                      ? 'दीक्षा फाइनेंस एवं डिजिटल ऋण मॉडल'
                      : 'Company overview & digital lending model',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.aboutUs),
                ),
                const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: isHindi ? 'गोपनीयता नीति' : 'Privacy Policy',
                  subtitle: isHindi
                      ? 'डेमो डेटा सुरक्षा एवं गोपनीयता'
                      : 'Simulated data privacy disclosures',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.privacyPolicy),
                ),
                const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
                _buildMenuItem(
                  icon: Icons.description_outlined,
                  iconColor: const Color(0xFFD97706),
                  title: isHindi ? 'नियम एवं शर्तें' : 'Terms & Conditions',
                  subtitle: isHindi
                      ? 'डेमो उपयोग दिशानिर्देश'
                      : 'Application usage terms and policies',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.termsConditions),
                ),
                const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
                _buildMenuItem(
                  icon: Icons.support_agent_rounded,
                  iconColor: const Color(0xFF16A34A),
                  title: isHindi ? 'शिकायत निवारण अधिकारी' : 'Grievance Officer',
                  subtitle: isHindi
                      ? 'नोडल अधिकारी संपर्क विवरण'
                      : 'Statutory grievance redressal details',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.grievanceOfficer),
                ),
                const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
                _buildMenuItem(
                  icon: Icons.contact_mail_outlined,
                  iconColor: AppTheme.accent,
                  title: isHindi ? 'हमसे संपर्क करें' : 'Contact Us',
                  subtitle: isHindi
                      ? 'कार्यालय का पता एवं समर्थन'
                      : 'Support email, phone & demo office',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.contactUs),
                ),
              ]),

              const SizedBox(height: 20),

              // ─── 4. Logout Action ────────────────────────────────────
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  iconColor: AppTheme.error,
                  title: isHindi ? 'लॉग आउट' : 'Log Out',
                  subtitle: isHindi
                      ? 'डेमो सत्र समाप्त करें'
                      : 'End simulated demo session',
                  titleColor: AppTheme.error,
                  onTap: () => _showLogoutConfirmation(context, isHindi),
                ),
              ]),

              const SizedBox(height: 24),

              const Center(
                child: Column(
                  children: [
                    Text(
                      '${AppConstants.appName} • ${AppConstants.appVersion}',
                      style: TextStyle(
                        color: AppTheme.textHint,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Demonstration Application • No real financial data collected',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Component: User Profile Card ──────────────────────────────────
  Widget _buildUserProfileCard({
    required String userName,
    required String maskedPhone,
    required bool isHindi,
  }) {
    // Generate initials from user name
    final initials = userName
        .trim()
        .split(' ')
        .take(2)
        .map((p) => p.isNotEmpty ? p[0].toUpperCase() : '')
        .join();

    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                initials.isNotEmpty ? initials : 'RS',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // User info details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userName,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_iphone_rounded,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      maskedPhone,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    isHindi ? 'डेमो उपयोगकर्ता खाता' : 'Simulated Demo Account',
                    style: const TextStyle(
                      color: Color(0xFFB45309),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
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

  // ─── Component: Menu Card Wrapper ──────────────────────────────────
  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.softShadow,
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }

  // ─── Component: Menu Item ──────────────────────────────────────────
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? titleColor,
    VoidCallback? onTap,
    bool showChevron = true,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? AppTheme.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            )
          : null,
      trailing: showChevron
          ? const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            )
          : null,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}
