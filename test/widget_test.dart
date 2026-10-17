import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:diksha_finance/main.dart';
import 'package:diksha_finance/screens/splash/splash_screen.dart';
import 'package:diksha_finance/screens/welcome/welcome_screen.dart';
import 'package:diksha_finance/screens/login/login_screen.dart';
import 'package:diksha_finance/screens/home/home_screen.dart';
import 'package:diksha_finance/screens/loan_apply/loan_amount_screen.dart';
import 'package:diksha_finance/widgets/app_scaffold.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Screens 1 & 2: Splash and WelcomeScreen with Language Selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DikshaFinanceApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Diksha Finance'), findsOneWidget);
    expect(find.text('Indore & Dewas Ka Apna Loan App'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Welcome to Diksha Finance'), findsOneWidget);
    expect(find.text('Personal and Business Loan Application Demo'), findsOneWidget);

    final hindiButton = find.text('हिंदी');
    final englishButton = find.text('English');
    expect(hindiButton, findsOneWidget);
    expect(englishButton, findsOneWidget);

    final BuildContext welcomeContext = tester.element(find.byType(WelcomeScreen));
    final appProvider = Provider.of<AppProvider>(welcomeContext, listen: false);
    expect(appProvider.selectedLanguage, 'en');
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(hindiButton);
    await tester.pumpAndSettle();

    expect(appProvider.selectedLanguage, 'hi');
    expect(find.text('दीक्षा फाइनेंस में आपका स्वागत है'), findsOneWidget);
    expect(find.text('पर्सनल और बिजनेस लोन आवेदन डेमो'), findsOneWidget);
    expect(find.text('शुरू करें (Get Started)'), findsOneWidget);

    await tester.tap(englishButton);
    await tester.pumpAndSettle();

    expect(appProvider.selectedLanguage, 'en');
    expect(find.text('Welcome to Diksha Finance'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Screen 3: Mobile Login validation, demo OTP 1234, and Home Dashboard navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DikshaFinanceApp());

    // Advance splash
    await tester.pump(const Duration(milliseconds: 2100));
    await tester.pumpAndSettle();

    // From Welcome, tap Get Started
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Login to Diksha Finance'), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);

    // 1. Validation test: Empty phone number
    final continueButton = find.text('Continue');
    await tester.tap(continueButton);
    await tester.pumpAndSettle();
    expect(find.text('Please enter your mobile number'), findsOneWidget);

    // 2. Validation test: Invalid / short phone number
    final phoneField = find.byType(TextFormField);
    await tester.enterText(phoneField, '12345');
    await tester.tap(continueButton);
    await tester.pumpAndSettle();
    expect(find.text('Please enter a valid 10-digit Indian mobile number'), findsOneWidget);

    // 3. Valid 10-digit Indian mobile number
    await tester.enterText(phoneField, '9876543210');
    await tester.tap(continueButton);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // 4. Verify Demo OTP screen is displayed
    expect(find.text('Demo OTP — no SMS will be sent'), findsOneWidget);
    expect(find.text('Use Demo Code: 1234'), findsOneWidget);

    // 5. Rejection of incorrect OTP
    final otpField = find.byType(TextField);
    await tester.enterText(otpField, '0000');
    final verifyButton = find.text('Verify & Continue');
    await tester.tap(verifyButton);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('Invalid OTP. Please enter demo OTP: 1234'), findsOneWidget);

    // 6. Enter correct Demo OTP '1234'
    await tester.enterText(otpField, '1234');
    await tester.tap(verifyButton);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // 7. Verify navigation to Home Dashboard (AppScaffold)
    expect(find.byType(AppScaffold), findsOneWidget);
  });

  testWidgets('Screen 4: Home Dashboard elements, EMI calculation, and navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DikshaFinanceApp());

    // Advance splash & login to dashboard
    await tester.pump(const Duration(milliseconds: 2100));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    final phoneField = find.byType(TextFormField);
    await tester.enterText(phoneField, '9876543210');
    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    final otpField = find.byType(TextField);
    await tester.enterText(otpField, '1234');
    await tester.tap(find.text('Verify & Continue'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // 1. Verify Header Elements
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Namaste, Diksha'), findsOneWidget);
    expect(find.text('Welcome to Diksha Finance'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    expect(find.text('D'), findsOneWidget);

    // 2. Verify Promotional Banner
    expect(find.text('Find the Right Loan for Your Needs'), findsOneWidget);
    expect(find.text('Explore personal and business loan options'), findsOneWidget);

    // 3. Verify Loan Cards
    expect(find.text('Personal Loan'), findsOneWidget);
    expect(find.text('₹10,000–₹1,00,000'), findsOneWidget);
    expect(find.text('Business Loan'), findsOneWidget);
    expect(find.text('₹10,000–₹2,00,000'), findsOneWidget);

    // 4. Verify Compact EMI Calculator
    expect(find.text('Quick EMI Calculator'), findsOneWidget);
    expect(find.text('Estimated Monthly EMI'), findsOneWidget);
    expect(find.text('Open Complete EMI Calculator'), findsOneWidget);

    // 5. Verify Proposed Lending Partner Section
    expect(find.text('Proposed Lending Partner: To Be Confirmed'), findsOneWidget);

    // 6. Test interaction: Explore Personal Loan
    final exploreButtons = find.text('Explore Loan');
    expect(exploreButtons, findsNWidgets(2));
    await tester.tap(exploreButtons.first);
    await tester.pumpAndSettle();

    // Verify navigates to LoanAmountScreen and sets purpose
    expect(find.byType(LoanAmountScreen), findsOneWidget);
    final BuildContext loanContext = tester.element(find.byType(LoanAmountScreen));
    final loanProvider = Provider.of<LoanProvider>(loanContext, listen: false);
    expect(loanProvider.purpose, 'Personal Expense');
  });
}
