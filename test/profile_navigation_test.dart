import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diksha_finance/config/app_routes.dart';
import 'package:diksha_finance/config/app_theme.dart';
import 'package:diksha_finance/models/user_model.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/auth_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:diksha_finance/screens/welcome/welcome_screen.dart';
import 'package:diksha_finance/screens/profile/profile_screen.dart';
import 'package:diksha_finance/screens/info/about_us_screen.dart';
import 'package:diksha_finance/screens/info/privacy_policy_screen.dart';
import 'package:diksha_finance/screens/info/terms_conditions_screen.dart';
import 'package:diksha_finance/screens/info/grievance_officer_screen.dart';
import 'package:diksha_finance/screens/info/contact_us_screen.dart';
import 'package:diksha_finance/widgets/app_scaffold.dart';

void main() {
  group('Profile Screen & Bottom Navigation Tests', () {
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

    Widget createScaffoldApp({
      AuthProvider? customAuthProvider,
      AppProvider? customAppProvider,
      LoanProvider? customLoanProvider,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => customAuthProvider ?? AuthProvider()),
          ChangeNotifierProvider(create: (_) => customAppProvider ?? AppProvider()),
          ChangeNotifierProvider(create: (_) => customLoanProvider ?? LoanProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.home: (ctx) => const AppScaffold(),
            AppRoutes.welcome: (ctx) => const WelcomeScreen(),
            AppRoutes.aboutUs: (ctx) => const AboutUsScreen(),
            AppRoutes.privacyPolicy: (ctx) => const PrivacyPolicyScreen(),
            AppRoutes.termsConditions: (ctx) => const TermsConditionsScreen(),
            AppRoutes.grievanceOfficer: (ctx) => const GrievanceOfficerScreen(),
            AppRoutes.contactUs: (ctx) => const ContactUsScreen(),
          },
          home: const AppScaffold(),
        ),
      );
    }

    testWidgets('Bottom navigation switches tabs and highlights selected tab',
        (WidgetTester tester) async {
      final appProvider = AppProvider();

      await tester.pumpWidget(createScaffoldApp(customAppProvider: appProvider));
      await tester.pumpAndSettle();

      // Initially on Home (index 0)
      expect(appProvider.currentNavIndex, 0);

      // Tap Profile tab
      final profileTabFinder = find.text('Profile');
      expect(profileTabFinder, findsWidgets);
      await tester.tap(profileTabFinder.first);
      await tester.pumpAndSettle();

      // Now on Profile tab (index 3)
      expect(appProvider.currentNavIndex, 3);
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('PopScope Android back navigation returns from tabs 1, 2, 3 to Home tab 0',
        (WidgetTester tester) async {
      final appProvider = AppProvider();
      appProvider.setNavIndex(3); // Start on Profile tab

      await tester.pumpWidget(createScaffoldApp(customAppProvider: appProvider));
      await tester.pumpAndSettle();

      expect(appProvider.currentNavIndex, 3);

      // Simulate system back button
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      // Returns to Home (index 0) without popping AppScaffold
      expect(appProvider.currentNavIndex, 0);
      expect(find.byType(AppScaffold), findsOneWidget);
    });

    testWidgets('Profile Screen displays demo user name and masked mobile number',
        (WidgetTester tester) async {
      final authProvider = AuthProvider();
      authProvider.updateUser(
        UserModel.mock().copyWith(name: 'Rahul Sharma', phone: '9876543210'),
      );

      final appProvider = AppProvider();
      appProvider.setNavIndex(3); // Profile tab

      await tester.pumpWidget(createScaffoldApp(
        customAuthProvider: authProvider,
        customAppProvider: appProvider,
      ));
      await tester.pumpAndSettle();

      // Demo User Name
      expect(find.text('Rahul Sharma'), findsOneWidget);

      // Masked Mobile Number
      expect(find.text('******3210'), findsOneWidget);

      // Simulated Demo Account tag
      expect(find.text('Simulated Demo Account'), findsOneWidget);
    });

    testWidgets('Language selection updates app language in local state',
        (WidgetTester tester) async {
      final appProvider = AppProvider();
      appProvider.setNavIndex(3); // Profile tab

      await tester.pumpWidget(createScaffoldApp(customAppProvider: appProvider));
      await tester.pumpAndSettle();

      // Find Language tile and tap
      final languageTile = find.text('Language');
      expect(languageTile, findsOneWidget);
      await tester.tap(languageTile);
      await tester.pumpAndSettle();

      // Language modal sheet opens
      expect(find.text('Select Application Language'), findsOneWidget);

      // Tap Hindi option
      final hindiOption = find.text('हिन्दी (Hindi)');
      expect(hindiOption, findsOneWidget);
      await tester.tap(hindiOption);
      await tester.pumpAndSettle();

      // App language updated to Hindi
      expect(appProvider.selectedLanguage, 'hi');
      expect(appProvider.isHindi, isTrue);
    });

    testWidgets('Profile screen menu tiles navigate to informational pages',
        (WidgetTester tester) async {
      final appProvider = AppProvider();
      appProvider.setNavIndex(3); // Profile tab

      await tester.pumpWidget(createScaffoldApp(customAppProvider: appProvider));
      await tester.pumpAndSettle();

      // 1. About Us
      final aboutUsTile = find.text('About Us');
      await tester.ensureVisible(aboutUsTile);
      await tester.tap(aboutUsTile);
      await tester.pumpAndSettle();
      expect(find.byType(AboutUsScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 2. Privacy Policy
      final privacyTile = find.text('Privacy Policy');
      await tester.ensureVisible(privacyTile);
      await tester.tap(privacyTile);
      await tester.pumpAndSettle();
      expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 3. Terms & Conditions
      final termsTile = find.text('Terms & Conditions');
      await tester.ensureVisible(termsTile);
      await tester.tap(termsTile);
      await tester.pumpAndSettle();
      expect(find.byType(TermsConditionsScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 4. Grievance Officer
      final grievanceTile = find.text('Grievance Officer');
      await tester.ensureVisible(grievanceTile);
      await tester.tap(grievanceTile);
      await tester.pumpAndSettle();
      expect(find.byType(GrievanceOfficerScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 5. Contact Us
      final contactTile = find.text('Contact Us');
      await tester.ensureVisible(contactTile);
      await tester.tap(contactTile);
      await tester.pumpAndSettle();
      expect(find.byType(ContactUsScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
    });

    testWidgets('Logout confirms and clears demo session, returning to WelcomeScreen',
        (WidgetTester tester) async {
      final authProvider = AuthProvider();
      authProvider.updateUser(
        UserModel.mock().copyWith(name: 'Rahul Sharma', phone: '9876543210'),
      );
      expect(authProvider.isLoggedIn, isTrue);

      final loanProvider = LoanProvider();
      loanProvider.setLoanAmount(90000);

      final appProvider = AppProvider();
      appProvider.setNavIndex(3); // Profile tab

      await tester.pumpWidget(createScaffoldApp(
        customAuthProvider: authProvider,
        customAppProvider: appProvider,
        customLoanProvider: loanProvider,
      ));
      await tester.pumpAndSettle();

      // Tap Log Out tile
      final logoutTile = find.text('Log Out');
      await tester.ensureVisible(logoutTile);
      await tester.tap(logoutTile);
      await tester.pumpAndSettle();

      // Confirmation dialog opens
      expect(find.text('Log Out?'), findsOneWidget);

      // Tap confirmation "Log Out" button
      final confirmLogoutBtn = find.widgetWithText(ElevatedButton, 'Log Out');
      await tester.tap(confirmLogoutBtn);
      await tester.pumpAndSettle();

      // Auth state is cleared
      expect(authProvider.isLoggedIn, isFalse);
      expect(authProvider.currentUser, isNull);

      // Temporary loan state is reset to defaults
      expect(loanProvider.loanAmount, 100000);

      // Returned to WelcomeScreen
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });
}
