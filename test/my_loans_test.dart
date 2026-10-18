import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diksha_finance/config/app_routes.dart';
import 'package:diksha_finance/config/app_theme.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:diksha_finance/screens/my_loans/my_loans_screen.dart';
import 'package:diksha_finance/screens/my_loans/loan_history_screen.dart';
import 'package:diksha_finance/screens/loan_apply/loan_amount_screen.dart';
import 'package:diksha_finance/widgets/app_scaffold.dart';

void main() {
  group('Screen 10: My Loans and Repayment Tests', () {
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

    Widget createScaffoldApp({LoanProvider? customLoanProvider, AppProvider? customAppProvider}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => customLoanProvider ?? LoanProvider()),
          ChangeNotifierProvider(create: (_) => customAppProvider ?? AppProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.home: (ctx) => const AppScaffold(),
            AppRoutes.myLoans: (ctx) => const MyLoansScreen(),
            AppRoutes.loanHistory: (ctx) => const LoanHistoryScreen(),
            AppRoutes.loanAmount: (ctx) => const LoanAmountScreen(),
          },
          home: const AppScaffold(),
        ),
      );
    }

    testWidgets('Accessible through My Loans bottom-navigation tab (Tab index 1)',
        (WidgetTester tester) async {
      await tester.pumpWidget(createScaffoldApp());
      await tester.pumpAndSettle();

      // Tap "My Loans" in bottom navigation
      final myLoansTab = find.text('My Loans');
      expect(myLoansTab, findsWidgets);
      await tester.tap(myLoansTab.first);
      await tester.pumpAndSettle();

      // Screen 10 is visible
      expect(find.byType(MyLoansScreen), findsOneWidget);
    });

    testWidgets('Empty State: Renders "You have no demo loans yet." and Explore button',
        (WidgetTester tester) async {
      final appProvider = AppProvider();
      appProvider.setNavIndex(1); // Start on My Loans tab

      final loanProvider = LoanProvider(); // No loans added

      await tester.pumpWidget(createScaffoldApp(
        customLoanProvider: loanProvider,
        customAppProvider: appProvider,
      ));
      await tester.pumpAndSettle();

      // Verify Empty State Heading
      expect(find.text('You have no demo loans yet.'), findsOneWidget);

      // Verify Payment safety message even in empty state
      expect(
        find.text('Payments are disabled in this demonstration. No money can be collected.'),
        findsOneWidget,
      );

      // Verify button to explore loan options
      final exploreButton = find.text('Explore Loan Options');
      expect(exploreButton, findsOneWidget);

      // Tap Explore Loan Options button
      await tester.tap(exploreButton);
      await tester.pumpAndSettle();

      // Navigates to Loan Amount screen
      expect(find.byType(LoanAmountScreen), findsOneWidget);
    });

    testWidgets(
        'Populated State: Renders loan summary card, Demo Only badge, Sample Date, and disabled Pay Now',
        (WidgetTester tester) async {
      final appProvider = AppProvider();
      appProvider.setNavIndex(1); // My Loans tab

      final loanProvider = LoanProvider();
      // Add a demo active loan
      loanProvider.setLoanType('Personal Loan');
      loanProvider.setLoanAmount(75000);
      loanProvider.setTenureMonths(12);
      loanProvider.setIllustrativeRate(24.0);
      loanProvider.recordDemoCompletedLoan();

      await tester.pumpWidget(createScaffoldApp(
        customLoanProvider: loanProvider,
        customAppProvider: appProvider,
      ));
      await tester.pumpAndSettle();

      // 1. Heading "My Loans"
      expect(find.text('My Loans'), findsWidgets);

      // 2. Status badge clearly labelled "Demo Only"
      expect(find.text('Demo Only'), findsWidgets);

      // 3. Selected loan amount: ₹75,000
      expect(find.text('₹75,000'), findsOneWidget);

      // 4. Selected tenure: 12 Months
      expect(find.text('12 Months'), findsOneWidget);

      // 5. Next instalment date labelled "Sample Date"
      expect(find.text('Sample Date'), findsOneWidget);

      // 6. Mandatory Payment Safety message
      expect(
        find.text('Payments are disabled in this demonstration. No money can be collected.'),
        findsOneWidget,
      );

      // 7. "Pay Now" button must be disabled
      final payNowFinder = find.widgetWithText(ElevatedButton, 'Pay Now');
      expect(payNowFinder, findsOneWidget);
      final ElevatedButton payNowBtn = tester.widget(payNowFinder);
      expect(payNowBtn.onPressed, isNull); // Disabled

      // 8. "View Details" button opens modal summary
      final viewDetailsFinder = find.text('View Details');
      expect(viewDetailsFinder, findsOneWidget);
      await tester.tap(viewDetailsFinder);
      await tester.pumpAndSettle();

      // Modal summary opens
      expect(find.text('Demo Loan Summary'), findsOneWidget);
      expect(find.text('Close Summary'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Close Summary'));
      await tester.pumpAndSettle();
      expect(find.text('Close Summary'), findsNothing);

      // 9. "View History" opens Loan History screen
      final viewHistoryFinder = find.text('View History');
      expect(viewHistoryFinder, findsOneWidget);
      await tester.tap(viewHistoryFinder);
      await tester.pumpAndSettle();

      // Loan History screen is displayed
      expect(find.byType(LoanHistoryScreen), findsOneWidget);
    });
  });
}
