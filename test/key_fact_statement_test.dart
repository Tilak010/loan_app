import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diksha_finance/config/app_routes.dart';
import 'package:diksha_finance/config/app_theme.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:diksha_finance/screens/loan_apply/key_fact_statement_screen.dart';
import 'package:diksha_finance/screens/loan_apply/loan_status_screen.dart';

void main() {
  group('Screen 8: KeyFactStatementScreen Tests', () {
    setUp(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.physicalSize =
          const Size(1080, 2400);
      binding.platformDispatcher.views.first.devicePixelRatio = 2.0;
    });

    tearDown(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.resetPhysicalSize();
      binding.platformDispatcher.views.first.resetDevicePixelRatio();
    });

    Widget createKfsApp({LoanProvider? customLoanProvider}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => customLoanProvider ?? LoanProvider()),
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.keyFactStatement: (ctx) => const KeyFactStatementScreen(),
            AppRoutes.loanStatus: (ctx) => const LoanStatusScreen(),
          },
          home: const KeyFactStatementScreen(),
        ),
      );
    }

    testWidgets(
        'Renders mandatory Header and exact Disclaimer without prior selection (Default Example)',
        (WidgetTester tester) async {
      await tester.pumpWidget(createKfsApp());
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.text('Key Fact Statement — Sample'), findsOneWidget);
      expect(find.text('Step 4 of 4 • Sample KFS'), findsOneWidget);

      // 2. Exact Mandatory Disclaimer
      expect(
        find.text(
          'Illustrative demonstration only. This is not an actual credit offer, approved loan, or legally operative KFS.',
        ),
        findsOneWidget,
      );

      // 3. Default demo example values:
      // Loan Amount: ₹50,000
      expect(find.text('Default Demo Example (₹50,000)'), findsOneWidget);
      expect(find.text('₹50,000'), findsOneWidget);
      // Tenure: 12 Months
      expect(find.text('12 Months'), findsOneWidget);
      // Illustrative rate: 24.0% p.a.
      expect(find.text('24.0% p.a.'), findsOneWidget);
      // Processing fee: ₹500.00
      expect(find.text('₹500.00'), findsOneWidget);
      // GST on fee: 18% of ₹500 = ₹90.00
      expect(find.text('₹90.00'), findsOneWidget);
      // Total fees and charges: ₹590.00
      expect(find.text('₹590.00'), findsOneWidget);
      // Net disbursement: ₹49,410.00
      expect(find.text('₹49,410.00'), findsOneWidget);

      // 4. Checkbox text
      expect(
        find.text('I have reviewed this illustrative example'),
        findsOneWidget,
      );

      // 5. Button text
      expect(find.text('Continue Demo'), findsOneWidget);
    });

    testWidgets(
        'Renders user-selected loan terms when prior selection is available in LoanProvider',
        (WidgetTester tester) async {
      final loanProvider = LoanProvider();
      loanProvider.setLoanType('Business Loan');
      loanProvider.setLoanAmount(100000);
      loanProvider.setTenureMonths(6);
      loanProvider.setIllustrativeRate(24.0);
      loanProvider.setCurrentStep(3); // Previous step completed

      await tester.pumpWidget(createKfsApp(customLoanProvider: loanProvider));
      await tester.pumpAndSettle();

      // Should detect user selection mode
      expect(find.text('Your Selected Application Terms'), findsOneWidget);
      expect(find.text('Business Loan'), findsWidgets);
      expect(find.text('₹1,00,000'), findsOneWidget);
      expect(find.text('6 Months'), findsOneWidget);

      // Processing fee for 1,00,000 is ₹1,000.00
      expect(find.text('₹1,000.00'), findsOneWidget);
      // GST for 1,000 is ₹180.00
      expect(find.text('₹180.00'), findsOneWidget);
      // Total fee: ₹1,180.00
      expect(find.text('₹1,180.00'), findsOneWidget);
    });

    testWidgets(
        'Continue Demo is disabled until checkbox is checked, and navigates to loanStatus',
        (WidgetTester tester) async {
      await tester.pumpWidget(createKfsApp());
      await tester.pumpAndSettle();

      // Checkbox is initially unchecked
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);
      final Checkbox initialCheckbox = tester.widget(checkboxFinder);
      expect(initialCheckbox.value, isFalse);

      // Try tapping Continue Demo while disabled
      final continueBtnFinder = find.widgetWithText(ElevatedButton, 'Continue Demo');
      expect(continueBtnFinder, findsOneWidget);
      final ElevatedButton initialBtn = tester.widget(continueBtnFinder);
      expect(initialBtn.onPressed, isNull); // Disabled

      // Tap the checkbox tile to accept
      final checkboxTileText = find.text('I have reviewed this illustrative example');
      await tester.ensureVisible(checkboxTileText);
      await tester.tap(checkboxTileText);
      await tester.pumpAndSettle();

      // Checkbox is now checked
      final Checkbox updatedCheckbox = tester.widget(checkboxFinder);
      expect(updatedCheckbox.value, isTrue);

      // Button is now enabled
      final ElevatedButton enabledBtn = tester.widget(continueBtnFinder);
      expect(enabledBtn.onPressed, isNotNull);

      // Tap Continue Demo
      await tester.tap(continueBtnFinder);
      await tester.pumpAndSettle();

      // Verify navigation to Demo Application Status screen
      expect(find.byType(LoanStatusScreen), findsOneWidget);
    });

    testWidgets('Toggles amortization schedule expansion',
        (WidgetTester tester) async {
      await tester.pumpWidget(createKfsApp());
      await tester.pumpAndSettle();

      // Initially collapsed, shows View All 12 Instalments
      final expandBtn = find.text('View All 12 Instalments');
      await tester.ensureVisible(expandBtn);
      expect(expandBtn, findsOneWidget);

      // Tap expand
      await tester.tap(expandBtn);
      await tester.pumpAndSettle();

      // Now should show Collapse Schedule
      expect(find.text('Collapse Schedule'), findsOneWidget);
    });
  });
}
