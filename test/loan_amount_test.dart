import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diksha_finance/config/app_routes.dart';
import 'package:diksha_finance/config/app_theme.dart';
import 'package:diksha_finance/models/emi_model.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:diksha_finance/screens/loan_apply/loan_amount_screen.dart';
import 'package:diksha_finance/screens/loan_apply/personal_details_screen.dart';

void main() {
  group('EmiModel Reducing-Balance Formula Tests', () {
    const double annualRate = 24.0; // 24% per year -> r = 2% per month (0.02)

    test('Formula accuracy for P=10,000 across tenures (3, 6, 9, 12)', () {
      // n = 3: (1+0.02)^3 = 1.061208 -> EMI = 10000*0.02*1.061208 / 0.061208 = 3467.55
      const emi3 = EmiModel(principal: 10000, annualRate: annualRate, tenureMonths: 3);
      expect((emi3.emi - 3467.55).abs() < 0.1, isTrue);

      // n = 6: (1+0.02)^6 = 1.1261624 -> EMI = 10000*0.02*1.1261624 / 0.1261624 = 1785.26
      const emi6 = EmiModel(principal: 10000, annualRate: annualRate, tenureMonths: 6);
      expect((emi6.emi - 1785.26).abs() < 0.1, isTrue);

      // n = 9: (1+0.02)^9 = 1.1950926 -> EMI = 10000*0.02*1.1950926 / 0.1950926 = 1225.15
      const emi9 = EmiModel(principal: 10000, annualRate: annualRate, tenureMonths: 9);
      expect((emi9.emi - 1225.15).abs() < 0.1, isTrue);

      // n = 12: (1+0.02)^12 = 1.2682418 -> EMI = 10000*0.02*1.2682418 / 0.2682418 = 945.60
      const emi12 = EmiModel(principal: 10000, annualRate: annualRate, tenureMonths: 12);
      expect((emi12.emi - 945.60).abs() < 0.1, isTrue);
    });

    test('Formula accuracy for P=50,000, 100,000, 200,000 at 12 months', () {
      const emi50k = EmiModel(principal: 50000, annualRate: annualRate, tenureMonths: 12);
      expect((emi50k.emi - 4727.98).abs() < 0.1, isTrue);
      expect((emi50k.totalPayable - (4727.98 * 12)).abs() < 1.0, isTrue);

      const emi100k = EmiModel(principal: 100000, annualRate: annualRate, tenureMonths: 12);
      expect((emi100k.emi - 9455.96).abs() < 0.1, isTrue);

      const emi200k = EmiModel(principal: 200000, annualRate: annualRate, tenureMonths: 12);
      expect((emi200k.emi - 18911.92).abs() < 0.1, isTrue);
    });

    test('Safe handling of zero-interest rate (annualRate = 0)', () {
      // When r = 0, EMI should be exactly principal / tenureMonths
      const emiZeroRate = EmiModel(principal: 12000, annualRate: 0, tenureMonths: 12);
      expect(emiZeroRate.monthlyRate, 0);
      expect(emiZeroRate.emi, 1000.0);
      expect(emiZeroRate.totalPayable, 12000.0);
      expect(emiZeroRate.totalInterest, 0.0);

      const emiZero6m = EmiModel(principal: 60000, annualRate: 0, tenureMonths: 6);
      expect(emiZero6m.emi, 10000.0);
    });

    test('Safe handling of negative/zero tenure', () {
      const emiZeroTenure = EmiModel(principal: 50000, annualRate: 24, tenureMonths: 0);
      expect(emiZeroTenure.emi, 0.0);
    });
  });

  group('Screen 5 Widget Tests: LoanAmountScreen', () {
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

    Widget buildTestWidget({
      String? initialLoanType,
      double? initialAmount,
      int? initialTenure,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LoanProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.loanAmount: (ctx) => LoanAmountScreen(
                  initialLoanType: initialLoanType,
                  initialAmount: initialAmount,
                  initialTenure: initialTenure,
                ),
            AppRoutes.personalDetails: (ctx) => const PersonalDetailsScreen(),
          },
          home: LoanAmountScreen(
            initialLoanType: initialLoanType,
            initialAmount: initialAmount,
            initialTenure: initialTenure,
          ),
        ),
      );
    }

    testWidgets('Renders all Screen 5 design components and default values',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 1. Heading
      expect(find.text('How much financing do you need?'), findsOneWidget);

      // 2. Both Loan types shown
      expect(find.text('Personal Loan'), findsWidgets);
      expect(find.text('Business Loan'), findsWidgets);

      // 3. Amount Slider & Min/Max labels
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('Min: ₹10,000'), findsOneWidget);
      expect(find.text('Max: ₹2,00,000'), findsOneWidget);

      // 4. Tenure options (3, 6, 9, 12 M)
      expect(find.text('3 M'), findsOneWidget);
      expect(find.text('6 M'), findsOneWidget);
      expect(find.text('9 M'), findsOneWidget);
      expect(find.text('12 M'), findsOneWidget);

      // 5. EMI Summary Card with 24% illustrative rate
      expect(find.text('EMI SUMMARY'), findsOneWidget);
      expect(find.text('24.0% p.a. (Illustrative)'), findsOneWidget);
      expect(find.text('Estimated Monthly EMI'), findsWidgets);
      expect(
        find.textContaining('This calculation is for demonstration purposes only'),
        findsOneWidget,
      );

      // 6. Orange Continue button
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('Toggling loan type switches between Personal and Business Loan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(initialLoanType: 'Personal Loan'));
      await tester.pumpAndSettle();

      // Tap on Business Loan
      await tester.tap(find.text('Business Loan').first);
      await tester.pumpAndSettle();

      // Verify Business Loan is selected
      final loanContext = tester.element(find.byType(LoanAmountScreen));
      final loanProvider = Provider.of<LoanProvider>(loanContext, listen: false);

      // Tap Continue to verify state sync
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(loanProvider.loanType, 'Business Loan');
      expect(loanProvider.purpose, 'Business');
      expect(find.byType(PersonalDetailsScreen), findsOneWidget);
    });

    testWidgets('Tenure selection updates EMI immediately',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(initialAmount: 50000, initialTenure: 12));
      await tester.pumpAndSettle();

      // Initial EMI at 12M should be ₹4,728 (present in summary and 12M card)
      expect(find.text('₹4,728'), findsWidgets);

      // Tap 6 M tenure
      await tester.ensureVisible(find.text('6 M'));
      await tester.tap(find.text('6 M'));
      await tester.pumpAndSettle();

      // EMI at 6M for 50,000 at 24% should immediately update to ₹8,926
      expect(find.text('₹8,926'), findsWidgets);
      expect(find.text('6 Months'), findsOneWidget);
    });

    testWidgets('Quick amount preset updates amount and EMI immediately',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(initialAmount: 50000, initialTenure: 12));
      await tester.pumpAndSettle();

      // Tap ₹1,00,000 preset chip
      await tester.ensureVisible(find.text('₹1,00,000').first);
      await tester.tap(find.text('₹1,00,000').first);
      await tester.pumpAndSettle();

      // At ₹1,00,000, 12M, 24% -> EMI is ₹9,456
      expect(find.text('₹9,456'), findsWidgets);
      expect(find.text('₹1,00,000'), findsWidgets);
    });

    testWidgets('Continue navigates to PersonalDetailsScreen and passes arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        initialLoanType: 'Personal Loan',
        initialAmount: 100000,
        initialTenure: 12,
      ));
      await tester.pumpAndSettle();

      final continueButton = find.text('Continue');
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.byType(PersonalDetailsScreen), findsOneWidget);

      final BuildContext context = tester.element(find.byType(PersonalDetailsScreen));
      final loanProvider = Provider.of<LoanProvider>(context, listen: false);

      expect(loanProvider.loanAmount, 100000);
      expect(loanProvider.tenureMonths, 12);
      expect(loanProvider.illustrativeRate, 24.0);
      expect(loanProvider.loanType, 'Personal Loan');
    });
  });
}
