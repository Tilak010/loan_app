import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_provider.dart';

/// Screen 3: Mobile Login and Demo OTP
///
/// Features:
/// - Dark navy blue title area
/// - Heading: "Login to Diksha Finance"
/// - Mobile number input with India country code (+91)
/// - Orange "Continue" button
/// - Terms and Privacy Policy links
/// - Demo OTP screen with "Demo OTP — no SMS will be sent" label
/// - Demo OTP value: 1234
/// - Verification error feedback on incorrect OTP
/// - Navigates to Home Dashboard on success
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isOtpScreen = false;
  String? _phoneError;
  String? _otpError;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _validateAndSubmitPhone() {
    final phone = _phoneController.text.trim();
    setState(() {
      _phoneError = null;
    });

    if (phone.isEmpty) {
      setState(() {
        _phoneError = 'Please enter your mobile number';
      });
      return;
    }

    // Must be a valid 10-digit number
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!phoneRegex.hasMatch(phone)) {
      setState(() {
        _phoneError = 'Please enter a valid 10-digit Indian mobile number';
      });
      return;
    }

    final auth = context.read<AuthProvider>();
    auth.sendOtp(phone).then((_) {
      if (mounted) {
        setState(() {
          _isOtpScreen = true;
          _otpController.clear();
          _otpError = null;
        });
      }
    });
  }

  void _validateAndVerifyOtp() {
    final otp = _otpController.text.trim();
    setState(() {
      _otpError = null;
    });

    if (otp.isEmpty) {
      setState(() {
        _otpError = 'Please enter the 4-digit demo OTP';
      });
      return;
    }

    final auth = context.read<AuthProvider>();
    auth.verifyOtp(otp).then((success) {
      if (!mounted) return;
      if (success) {
        // Navigate to Home Dashboard
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.home,
          (route) => false,
        );
      } else {
        setState(() {
          _otpError = auth.errorMessage ?? 'Invalid OTP. Please enter demo OTP: 1234';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = context.watch<AppProvider>().isHindi;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        top: false,
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
                      _buildHeader(context, isHindi),

                      // ─── Form Body ─────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _isOtpScreen
                              ? _buildOtpSection(context, auth, isHindi)
                              : _buildPhoneSection(context, auth, isHindi),
                        ),
                      ),

                      const Spacer(),

                      // ─── Terms & Privacy Policy / Demo Footnote ────────
                      if (!_isOtpScreen)
                        _buildTermsAndPrivacy(context, isHindi),

                      const SizedBox(height: 20),
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

  /// Dark navy blue title area
  Widget _buildHeader(BuildContext context, bool isHindi) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_isOtpScreen)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isOtpScreen = false;
                      _otpError = null;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  tooltip: 'Back',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              else
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  tooltip: 'Back',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              const Spacer(),
              // Mini Emblem
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            _isOtpScreen
                ? (isHindi ? 'ओटीपी सत्यापन' : 'Verify Mobile OTP')
                : (isHindi ? 'दीक्षा फाइनेंस में लॉगिन करें' : 'Login to Diksha Finance'),
            key: const ValueKey('login_heading'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            _isOtpScreen
                ? (isHindi
                    ? '+91 ${_phoneController.text} पर भेजा गया डेमो ओटीपी दर्ज करें'
                    : 'Enter the 4-digit demo OTP sent to +91 ${_phoneController.text}')
                : (isHindi
                    ? 'जारी रखने के लिए अपना 10 अंकों का मोबाइल नंबर दर्ज करें'
                    : 'Enter your 10-digit mobile number to continue'),
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// Step 1: Mobile Phone Number Input Section
  Widget _buildPhoneSection(
    BuildContext context,
    AuthProvider auth,
    bool isHindi,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // White Card for Form Input
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'मोबाइल नंबर' : 'Mobile Number',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 10),

                // Mobile Number Input with +91 Prefix
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _phoneError != null
                          ? AppTheme.error
                          : const Color(0xFFCBD5E1),
                      width: _phoneError != null ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Country Code Prefix (+91)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEF2F6),
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(11),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '🇮🇳',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '+91',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        height: 28,
                        width: 1,
                        color: const Color(0xFFCBD5E1),
                      ),

                      // Phone Input Field
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (_) {
                            if (_phoneError != null) {
                              setState(() {
                                _phoneError = null;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: '98765 43210',
                            hintStyle: TextStyle(
                              color: AppTheme.textHint,
                              letterSpacing: 0.5,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Error Text
                if (_phoneError != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppTheme.error,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _phoneError!,
                          style: const TextStyle(
                            color: AppTheme.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Orange Continue Button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: auth.isLoading ? null : _validateAndSubmitPhone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppTheme.accent.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: auth.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isHindi ? 'आगे बढ़ें (Continue)' : 'Continue',
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
        ],
      ),
    );
  }

  /// Step 2: Demo OTP Verification Section
  Widget _buildOtpSection(
    BuildContext context,
    AuthProvider auth,
    bool isHindi,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Demo OTP Notice Banner: "Demo OTP — no SMS will be sent"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED), // Warm Amber Light
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.accent.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppTheme.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo OTP — no SMS will be sent',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF9A3412),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Use Demo Code: 1234',
                    style: TextStyle(
                      color: Color(0xFFC2410C),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _otpController.text = '1234';
                      setState(() {
                        _otpError = null;
                      });
                    },
                    icon: const Icon(Icons.bolt_rounded, size: 16),
                    label: const Text('Auto-Fill'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.accent,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // OTP Card with Input Box
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                isHindi ? '4-अंकीय डेमो ओटीपी दर्ज करें' : 'Enter 4-Digit Demo OTP',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),

              // OTP Input Field
              Container(
                width: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _otpError != null
                        ? AppTheme.error
                        : AppTheme.secondary,
                    width: 2.0,
                  ),
                ),
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (_) {
                    if (_otpError != null) {
                      setState(() {
                        _otpError = null;
                      });
                    }
                  },
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 20,
                    color: AppTheme.primary,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: '••••',
                    hintStyle: TextStyle(
                      color: AppTheme.textHint,
                      letterSpacing: 18,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              // Error Text
              if (_otpError != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppTheme.error,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _otpError!,
                        style: const TextStyle(
                          color: AppTheme.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // Edit Mobile Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Wrong number?',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isOtpScreen = false;
                        _otpError = null;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text(
                      'Change',
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Orange Verify & Continue Button
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : _validateAndVerifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: AppTheme.accent.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: auth.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    isHindi ? 'सत्यापित करें और आगे बढ़ें' : 'Verify & Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// Terms of Service and Privacy Policy clickable links below form
  Widget _buildTermsAndPrivacy(BuildContext context, bool isHindi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
              children: [
                TextSpan(
                  text: isHindi
                      ? 'जारी रखकर, आप हमारे '
                      : 'By continuing, you agree to our ',
                ),
                TextSpan(
                  text: isHindi ? 'नियम व शर्तें' : 'Terms & Conditions',
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushNamed(AppRoutes.termsConditions);
                    },
                ),
                TextSpan(
                  text: isHindi ? ' और ' : ' and ',
                ),
                TextSpan(
                  text: isHindi ? 'गोपनीयता नीति' : 'Privacy Policy',
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushNamed(AppRoutes.privacyPolicy);
                    },
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Demo Mode • 100% Mocked Authentication',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
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
