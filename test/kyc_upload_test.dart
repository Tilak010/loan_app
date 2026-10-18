import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diksha_finance/config/app_routes.dart';
import 'package:diksha_finance/config/app_theme.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:diksha_finance/screens/loan_apply/kyc_upload_screen.dart';
import 'package:diksha_finance/screens/loan_apply/key_fact_statement_screen.dart';

void main() {
  group('Screen 7: KycUploadScreen Tests', () {
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

    Widget createKycUploadApp() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoanProvider()),
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.kycUpload: (ctx) => const KycUploadScreen(),
            AppRoutes.keyFactStatement: (ctx) => const KeyFactStatementScreen(),
          },
          home: const KycUploadScreen(),
        ),
      );
    }

    testWidgets('Renders all Screen 7 headings, notices, and unverified labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(createKycUploadApp());
      await tester.pumpAndSettle();

      // 1. Heading and Subtitle
      expect(find.text('Document Verification'), findsWidgets);
      expect(
        find.text('Demonstration Only — Do Not Upload Real Documents'),
        findsOneWidget,
      );

      // 2. Step 3 of 4 Progress
      expect(find.text('Step 3 of 4 • Demo KYC'), findsOneWidget);

      // 3. Privacy notice
      expect(
        find.text(
          'This is a demonstration. Please do not upload real identity documents or bank statements.',
        ),
        findsOneWidget,
      );

      // 4. Label: "Demo KYC — Not Verified"
      expect(find.text('Demo KYC — Not Verified'), findsWidgets);

      // 5. Four document cards
      expect(find.text('Aadhaar Card (Front)'), findsOneWidget);
      expect(find.text('Aadhaar Card (Back)'), findsOneWidget);
      expect(find.text('PAN Card'), findsOneWidget);
      expect(find.text('Bank Statement PDF'), findsOneWidget);

      // 6. Selfie demonstration card
      expect(find.text('Selfie Verification (Mock)'), findsOneWidget);
      expect(find.text('Simulate Demo Selfie Capture'), findsOneWidget);

      // Initial status: "Not Added"
      expect(find.text('Not Added'), findsNWidgets(5));
    });

    testWidgets('Tapping Add Demo Sample transitions document to Demo Sample Added',
        (WidgetTester tester) async {
      await tester.pumpWidget(createKycUploadApp());
      await tester.pumpAndSettle();

      // Find first "Add Demo Sample" button (for Aadhaar Front)
      final addSampleButtons = find.text('Add Demo Sample');
      expect(addSampleButtons, findsWidgets);

      await tester.tap(addSampleButtons.first);
      await tester.pumpAndSettle();

      // Aadhaar Front should now display "Demo Sample Added" and preview action
      expect(find.text('Demo Sample Added'), findsOneWidget);
      expect(find.text('demo_aadhaar_front.jpg (240 KB)'), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);

      // Remaining 4 cards should still be "Not Added"
      expect(find.text('Not Added'), findsNWidgets(4));
    });

    testWidgets('Simulating selfie updates selfie card to Demo Sample Added',
        (WidgetTester tester) async {
      await tester.pumpWidget(createKycUploadApp());
      await tester.pumpAndSettle();

      final selfieButton = find.text('Simulate Demo Selfie Capture');
      await tester.ensureVisible(selfieButton);
      await tester.tap(selfieButton);
      await tester.pumpAndSettle();

      expect(find.text('Synthetic Selfie Captured (Demo)'), findsOneWidget);
      expect(find.text('Re-simulate Selfie'), findsOneWidget);
    });

    testWidgets('Add All Demo Samples marks all 5 items as Demo Sample Added',
        (WidgetTester tester) async {
      await tester.pumpWidget(createKycUploadApp());
      await tester.pumpAndSettle();

      // Tap "Add All Demo" button
      final addAllButton = find.text('Add All Demo');
      await tester.tap(addAllButton);
      await tester.pumpAndSettle();

      // All 5 items should now display "Demo Sample Added"
      expect(find.text('Demo Sample Added'), findsNWidgets(5));
      expect(find.text('Not Added'), findsNothing);
      expect(find.text('Demo Samples Added: 5 of 5'), findsOneWidget);
    });

    testWidgets('Continue navigates to Key Fact Statement screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createKycUploadApp());
      await tester.pumpAndSettle();

      final continueButton = find.text('Continue to Key Fact Statement');
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.byType(KeyFactStatementScreen), findsOneWidget);

      final BuildContext context = tester.element(find.byType(KeyFactStatementScreen));
      final loanProvider = Provider.of<LoanProvider>(context, listen: false);
      expect(loanProvider.currentStep, 3);
    });
  });
}
