import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/welcome/welcome_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/loan_apply/loan_amount_screen.dart';
import '../screens/loan_apply/personal_details_screen.dart';
import '../screens/loan_apply/kyc_upload_screen.dart';
import '../screens/loan_apply/key_fact_statement_screen.dart';
import '../screens/loan_apply/loan_status_screen.dart';
import '../screens/my_loans/my_loans_screen.dart';
import '../screens/my_loans/loan_history_screen.dart';
import '../screens/emi_calculator/emi_calculator_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/info/about_us_screen.dart';
import '../screens/info/privacy_policy_screen.dart';
import '../screens/info/terms_conditions_screen.dart';
import '../screens/info/grievance_officer_screen.dart';
import '../screens/info/contact_us_screen.dart';
import '../widgets/app_scaffold.dart';

/// Centralized route names and route generator for the application.
class AppRoutes {
  AppRoutes._();

  // ─── Route Names ────────────────────────────────────────────────
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String home = '/home';
  static const String loanAmount = '/loan/amount';
  static const String personalDetails = '/loan/personal-details';
  static const String kycUpload = '/loan/kyc-upload';
  static const String keyFactStatement = '/loan/key-fact-statement';
  static const String loanStatus = '/loan/status';
  static const String myLoans = '/my-loans';
  static const String loanHistory = '/my-loans/history';
  static const String emiCalculator = '/emi-calculator';
  static const String profile = '/profile';
  static const String aboutUs = '/about-us';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String grievanceOfficer = '/grievance-officer';
  static const String contactUs = '/contact-us';

  // ─── Route Generator ───────────────────────────────────────────
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashScreen(), settings);
      case welcome:
        return _fadeRoute(const WelcomeScreen(), settings);
      case login:
        return _slideRoute(const LoginScreen(), settings);
      case home:
        return _fadeRoute(const AppScaffold(), settings);
      case loanAmount:
        return _slideRoute(const LoanAmountScreen(), settings);
      case personalDetails:
        return _slideRoute(const PersonalDetailsScreen(), settings);
      case kycUpload:
        return _slideRoute(const KycUploadScreen(), settings);
      case keyFactStatement:
        return _slideRoute(const KeyFactStatementScreen(), settings);
      case loanStatus:
        return _fadeRoute(const LoanStatusScreen(), settings);
      case myLoans:
        return _slideRoute(const MyLoansScreen(), settings);
      case loanHistory:
        return _slideRoute(const LoanHistoryScreen(), settings);
      case emiCalculator:
        return _slideRoute(const EmiCalculatorScreen(), settings);
      case profile:
        return _slideRoute(const ProfileScreen(), settings);
      case aboutUs:
        return _slideRoute(const AboutUsScreen(), settings);
      case privacyPolicy:
        return _slideRoute(const PrivacyPolicyScreen(), settings);
      case termsConditions:
        return _slideRoute(const TermsConditionsScreen(), settings);
      case grievanceOfficer:
        return _slideRoute(const GrievanceOfficerScreen(), settings);
      case contactUs:
        return _slideRoute(const ContactUsScreen(), settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }

  // ─── Transition Helpers ─────────────────────────────────────────

  /// Fade transition for major screen changes (splash, home)
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide transition for sub-screens and forms
  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
