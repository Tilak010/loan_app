import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diksha_finance/config/app_routes.dart';
import 'package:diksha_finance/config/app_theme.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:diksha_finance/screens/loan_apply/personal_details_screen.dart';
import 'package:diksha_finance/screens/loan_apply/kyc_upload_screen.dart';

void main() {
  group('Screen 6: PersonalDetailsScreen Tests', () {
    setUp(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.physicalSize = const Size(1080, 2400);
      binding.platformDispatcher.views.first.devicePixelRatio = 2.0;
    });

    tearDown(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.resetPhysicalSize();
      binding.platformDispatcher.views.first.resetDevicePixelRatio();
    });

    Widget createPersonalDetailsApp({String loanType = 'Personal Loan'}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final lp = LoanProvider();
            lp.setLoanType(loanType);
            return lp;
          }),
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.personalDetails: (ctx) => PersonalDetailsScreen(initialLoanType: loanType),
            AppRoutes.kycUpload: (ctx) => const KycUploadScreen(),
          },
          home: PersonalDetailsScreen(initialLoanType: loanType),
        ),
      );
    }

    testWidgets('Renders all personal details headers, sections, and privacy notice',
        (WidgetTester tester) async {
      await tester.pumpWidget(createPersonalDetailsApp());
      await tester.pumpAndSettle();

      // Heading & Subtitle
      expect(find.text('Tell Us About Yourself'), findsOneWidget);
      expect(find.text('Step 2 of 4 • Applicant Details'), findsOneWidget);

      // Privacy banner
      expect(find.text('Demo Notice — Privacy Protection'), findsOneWidget);
      expect(find.text('Fill Demo Data'), findsOneWidget);

      // Section 1: Identity fields
      expect(find.text('Full Name (as per PAN)'), findsOneWidget);
      expect(find.text('Date of Birth (DD/MM/YYYY)'), findsOneWidget);
      expect(find.text('PAN Card Number (Demo Format)'), findsOneWidget);
      expect(find.text('Aadhaar (Last 4 Digits Only)'), findsOneWidget);

      // Section 2: Occupation fields
      expect(find.text('Occupation Type'), findsOneWidget);
      expect(find.text('Salaried'), findsOneWidget);
      expect(find.text('Business Owner'), findsOneWidget);
      expect(find.text('Shopkeeper'), findsOneWidget);

      // Personal loan default has Monthly Net Income
      expect(find.text('Monthly Net Income'), findsOneWidget);

      // Bottom button
      expect(find.text('Review & Continue to KYC'), findsOneWidget);
    });

    testWidgets('Shows validation errors for empty/invalid fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createPersonalDetailsApp());
      await tester.pumpAndSettle();

      // Tap submit with empty form
      final continueButton = find.text('Review & Continue to KYC');
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // Required field validation messages
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter or select your Date of Birth'), findsOneWidget);
      expect(find.text('Please enter your PAN number'), findsOneWidget);
      expect(find.text('Please enter the last 4 digits of Aadhaar'), findsOneWidget);
      expect(find.text('Please enter your monthly income'), findsOneWidget);
    });

    testWidgets('Validates PAN format and Aadhaar 4-digit constraints',
        (WidgetTester tester) async {
      await tester.pumpWidget(createPersonalDetailsApp());
      await tester.pumpAndSettle();

      // Enter invalid PAN
      final panField = find.widgetWithText(TextFormField, 'e.g. ABCDE1234F');
      await tester.enterText(panField, 'INVALID12');

      // Enter invalid Aadhaar
      final aadhaarField = find.widgetWithText(TextFormField, '1234');
      await tester.enterText(aadhaarField, '12');

      // Enter invalid DOB (under 18)
      final dobField = find.widgetWithText(TextFormField, 'DD/MM/YYYY');
      await tester.enterText(dobField, '01/01/2020');

      final continueButton = find.text('Review & Continue to KYC');
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid PAN number (e.g. ABCDE1234F)'), findsOneWidget);
      expect(find.text('Must be exactly 4 digits'), findsOneWidget);
      expect(find.text('Applicant must be at least 18 years old'), findsOneWidget);
    });

    testWidgets('Dynamic fields: Switching to Business Owner shows Sales and Business Name',
        (WidgetTester tester) async {
      await tester.pumpWidget(createPersonalDetailsApp());
      await tester.pumpAndSettle();

      // Tap Business Owner
      await tester.ensureVisible(find.text('Business Owner'));
      await tester.tap(find.text('Business Owner'));
      await tester.pumpAndSettle();

      // Monthly Net Income should be gone; Monthly Sales and Business Name should appear
      expect(find.text('Monthly Net Income'), findsNothing);
      expect(find.text('Monthly Sales / Turnover'), findsOneWidget);
      expect(find.text('Business / Shop Name'), findsOneWidget);
    });

    testWidgets('1-Tap Fill Demo Data populates form and opens Review Sheet on submit',
        (WidgetTester tester) async {
      await tester.pumpWidget(createPersonalDetailsApp());
      await tester.pumpAndSettle();

      // Tap "Fill Demo Data"
      await tester.ensureVisible(find.text('Fill Demo Data'));
      await tester.tap(find.text('Fill Demo Data'));
      await tester.pumpAndSettle();

      // Verify fields are populated
      expect(find.text('Rahul Sharma'), findsOneWidget);
      expect(find.text('15/08/1992'), findsOneWidget);
      expect(find.text('ABCDE1234F'), findsOneWidget);
      expect(find.text('1234'), findsWidgets); // Both hint and value
      expect(find.text('45000'), findsOneWidget);

      // Dismiss SnackBar and tap Review & Continue to KYC
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      final continueButton = find.text('Review & Continue to KYC');
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // Verify Review Bottom Sheet appears
      expect(find.text('Review Demo Details'), findsOneWidget);
      expect(find.text('Confirm & Continue'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);

      // Tap Confirm & Continue
      await tester.tap(find.text('Confirm & Continue'));
      await tester.pumpAndSettle();

      // Verify navigation to KYC screen
      expect(find.byType(KycUploadScreen), findsOneWidget);

      // Verify LoanProvider holds the synced details
      final BuildContext context = tester.element(find.byType(KycUploadScreen));
      final loanProvider = Provider.of<LoanProvider>(context, listen: false);
      expect(loanProvider.fullName, 'Rahul Sharma');
      expect(loanProvider.pan, 'ABCDE1234F');
      expect(loanProvider.aadhaarLastFour, '1234');
      expect(loanProvider.monthlyIncome, 45000);
      expect(loanProvider.currentStep, 2);
    });
  });
}
