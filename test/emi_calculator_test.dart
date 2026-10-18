import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diksha_finance/config/app_theme.dart';
import 'package:diksha_finance/models/emi_model.dart';
import 'package:diksha_finance/utils/formatters.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:diksha_finance/screens/emi_calculator/emi_calculator_screen.dart';
import 'package:diksha_finance/widgets/app_scaffold.dart';

void main() {
  group('EMI Calculator Widget & Logic Tests', () {
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

    Widget createEmiCalcApp({
      double? initialAmount,
      double? initialRate,
      int? initialTenure,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LoanProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: EmiCalculatorScreen(
            initialAmount: initialAmount,
            initialRate: initialRate,
            initialTenure: initialTenure,
          ),
        ),
      );
    }

    Widget createAppWithBottomNav() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LoanProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const AppScaffold(),
        ),
      );
    }

    testWidgets('Accessible from bottom navigation (Tab index 2)',
        (WidgetTester tester) async {
      await tester.pumpWidget(createAppWithBottomNav());
      await tester.pumpAndSettle();

      // Tap on EMI Calc tab in bottom navigation
      final emiNavTab = find.text('EMI Calc');
      expect(emiNavTab, findsOneWidget);
      await tester.tap(emiNavTab);
      await tester.pumpAndSettle();

      // Verify EmiCalculatorScreen is active
      expect(find.byType(EmiCalculatorScreen), findsOneWidget);
      expect(find.text('EMI Calculator'), findsOneWidget);
    });

    testWidgets('Renders all inputs, headings, and outputs correctly with defaults',
        (WidgetTester tester) async {
      await tester.pumpWidget(createEmiCalcApp(
        initialAmount: 100000,
        initialRate: 14.5,
        initialTenure: 12,
      ));
      await tester.pumpAndSettle();

      // 1. Inputs: Sliders and text fields
      expect(find.text('Loan Amount'), findsOneWidget);
      expect(find.text('Interest Rate (p.a.)'), findsOneWidget);
      expect(find.text('Tenure in Months'), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(3));

      // 2. Output Display elements
      expect(find.text('ESTIMATED MONTHLY EMI'), findsOneWidget);
      expect(find.text('Principal Amount'), findsOneWidget);
      expect(find.text('Total Interest Payable'), findsOneWidget);
      expect(find.text('Total Repayment Amount'), findsOneWidget);

      // Verify calculation consistency: P=100000, r=14.5%, n=12 -> EMI = ₹9,003
      const model = EmiModel(principal: 100000, annualRate: 14.5, tenureMonths: 12);
      expect((model.emi - 9002.73).abs() < 1.0, isTrue);

      expect(find.text(Formatters.currency(model.emi)), findsOneWidget);
      expect(find.text('₹1,00,000'), findsWidgets);

      // 3. Illustrative disclaimer
      expect(
        find.textContaining('This calculation is for illustrative and estimation purposes only'),
        findsOneWidget,
      );
    });

    testWidgets('Updates calculations immediately when preset chips are tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createEmiCalcApp(
        initialAmount: 100000,
        initialRate: 14.5,
        initialTenure: 12,
      ));
      await tester.pumpAndSettle();

      // Tap 24% interest rate preset chip
      await tester.ensureVisible(find.text('24.0%'));
      await tester.tap(find.text('24.0%'));
      await tester.pumpAndSettle();

      // At P=100000, r=24%, n=12 -> EMI should immediately update to ₹9,456
      expect(find.text('₹9,456'), findsOneWidget);
      expect(find.text('24.0% p.a.'), findsOneWidget);

      // Tap 6 M tenure preset chip
      await tester.ensureVisible(find.text('6 M'));
      await tester.tap(find.text('6 M'));
      await tester.pumpAndSettle();

      // At P=100000, r=24%, n=6 -> EMI should immediately update to ₹17,853
      expect(find.text('₹17,853'), findsOneWidget);
    });

    testWidgets('Safely handles 0% interest rate without dividing by zero',
        (WidgetTester tester) async {
      await tester.pumpWidget(createEmiCalcApp(
        initialAmount: 60000,
        initialRate: 0.0,
        initialTenure: 6,
      ));
      await tester.pumpAndSettle();

      // At 0% interest, EMI should be exactly 60000 / 6 = ₹10,000
      expect(find.text('₹10,000'), findsWidgets);
      expect(find.text('₹0'), findsNWidgets(2)); // Total interest in summary and breakdown
      expect(find.text('₹60,000'), findsWidgets); // Total payable is 60,000
    });

    testWidgets('Safely handles text field input editing',
        (WidgetTester tester) async {
      await tester.pumpWidget(createEmiCalcApp(
        initialAmount: 50000,
        initialRate: 12.0,
        initialTenure: 12,
      ));
      await tester.pumpAndSettle();

      // Find amount text field and enter 200000
      final amountField = find.byType(TextField).first;
      await tester.enterText(amountField, '200000');
      await tester.pumpAndSettle();

      // At P=200000, r=12%, n=12 -> EMI is ₹17,770
      const expectedModel = EmiModel(principal: 200000, annualRate: 12.0, tenureMonths: 12);
      expect((expectedModel.emi - 17769.77).abs() < 1.0, isTrue);

      expect(find.text('₹17,770'), findsOneWidget);
      expect(find.text('₹2,00,000'), findsWidgets);
    });
  });
}
