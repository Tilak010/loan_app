import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diksha_finance/config/app_routes.dart';
import 'package:diksha_finance/config/app_theme.dart';
import 'package:diksha_finance/config/app_constants.dart';
import 'package:diksha_finance/providers/app_provider.dart';
import 'package:diksha_finance/providers/auth_provider.dart';
import 'package:diksha_finance/providers/loan_provider.dart';
import 'package:diksha_finance/screens/profile/profile_screen.dart';
import 'package:diksha_finance/screens/info/about_us_screen.dart';
import 'package:diksha_finance/screens/info/privacy_policy_screen.dart';
import 'package:diksha_finance/screens/info/terms_conditions_screen.dart';
import 'package:diksha_finance/screens/info/grievance_officer_screen.dart';
import 'package:diksha_finance/screens/info/contact_us_screen.dart';

void main() {
  group('Informational Pages Tests', () {
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

    Widget wrapWithProviders(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LoanProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.aboutUs: (ctx) => const AboutUsScreen(),
            AppRoutes.privacyPolicy: (ctx) => const PrivacyPolicyScreen(),
            AppRoutes.termsConditions: (ctx) => const TermsConditionsScreen(),
            AppRoutes.grievanceOfficer: (ctx) => const GrievanceOfficerScreen(),
            AppRoutes.contactUs: (ctx) => const ContactUsScreen(),
          },
          home: child,
        ),
      );
    }

    testWidgets('1. About Us screen explains demonstration journey and marks unconfirmed details',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const AboutUsScreen()));
      await tester.pumpAndSettle();

      // Title & Demo Badge
      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('DEMO PROTOTYPE'), findsOneWidget);
      expect(find.text(AppConstants.appName), findsOneWidget);

      // Core explanation
      expect(find.text('About Diksha Finance'), findsOneWidget);
      expect(
        find.textContaining(
          'Diksha Finance is currently a demonstration application designed to showcase a proposed digital loan application journey.',
        ),
        findsOneWidget,
      );

      // Core features showcased
      expect(find.text('Demonstrated Application Journey'), findsOneWidget);
      expect(find.text('Interactive EMI Calculator'), findsOneWidget);
      expect(find.text('Digital Loan Application Workflow'), findsOneWidget);
      expect(find.text('Simulated KYC & Document Flow'), findsOneWidget);

      // Proposed Lending Partner placeholder & RBI disclaimer
      expect(find.text(AppConstants.proposedLendingPartner), findsOneWidget);
      expect(
        find.textContaining('No claim is made of RBI registration'),
        findsOneWidget,
      );
    });

    testWidgets('2. Privacy Policy explains what is/is not collected and warns against real data',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const PrivacyPolicyScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);

      // Warning notice against real identity or financial data
      expect(find.text('Important Privacy Notice'), findsOneWidget);
      expect(
        find.textContaining(
          'This application is a demonstration only. It does not submit personal data to a backend server. Users should NOT enter real identity documents (e.g., Aadhaar, PAN) or real financial information',
        ),
        findsOneWidget,
      );

      // What it collects
      expect(find.text('What This Prototype Collects'), findsOneWidget);
      expect(find.text('Simulated In-Memory Session Inputs'), findsOneWidget);
      expect(find.text('Local Device State Only'), findsOneWidget);

      // What it does NOT collect
      expect(find.text('What This Prototype Does Not Collect'), findsOneWidget);
      expect(find.text('No Backend Submission'), findsOneWidget);
      expect(find.text('No Real Identity Verification'), findsOneWidget);
      expect(find.text('No Financial or Banking Records'), findsOneWidget);

      // Regulatory roadmap placeholder
      expect(
        find.text('Regulatory Framework & Privacy Roadmap'),
        findsOneWidget,
      );
      expect(find.text(AppConstants.contactEmail), findsOneWidget);
    });

    testWidgets('3. Terms & Conditions explicitly states application is demonstration only',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const TermsConditionsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Terms & Conditions'), findsOneWidget);

      // Demonstration only notice
      expect(find.text('Demonstration Use Only'), findsOneWidget);
      expect(
        find.textContaining(
          'Diksha Finance is currently a demonstration application only. No real loan offer, approval, disbursement, or repayment is available through this application.',
        ),
        findsOneWidget,
      );

      // Structured clauses
      expect(find.text('Application Nature & Purpose'), findsOneWidget);
      expect(find.text('No Real Loan Offers or Credit Sanctions'), findsOneWidget);
      expect(find.text('No Loan Disbursements or Repayments'), findsOneWidget);
      expect(find.text('No Real Credit Underwriting or Bureau Checks'), findsOneWidget);
      expect(find.text('Regulatory & Lending Partner Disclosures'), findsOneWidget);
    });

    testWidgets('4. Grievance Officer displays structured placeholder section and escalation process',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const GrievanceOfficerScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Grievance Officer'), findsOneWidget);
      expect(find.text('Grievance Redressal Framework'), findsOneWidget);

      // Required fields
      expect(find.text('Officer Name'), findsOneWidget);
      expect(find.text(AppConstants.grievanceOfficerName), findsOneWidget);

      expect(find.text('Designation'), findsOneWidget);
      expect(find.text(AppConstants.grievanceOfficerDesignation), findsOneWidget);

      expect(find.text('Email'), findsOneWidget);
      expect(find.text(AppConstants.grievanceOfficerEmail), findsOneWidget);

      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text(AppConstants.grievanceOfficerPhone), findsOneWidget);

      expect(find.text('Office Address'), findsOneWidget);
      expect(find.text(AppConstants.contactOfficeAddress), findsOneWidget);

      // Escalation Process
      expect(find.text('Escalation Process'), findsOneWidget);
      expect(find.text(AppConstants.grievanceEscalationLevel1Title), findsOneWidget);
      expect(find.text(AppConstants.grievanceEscalationLevel2Title), findsOneWidget);
      expect(find.text(AppConstants.grievanceEscalationLevel3Title), findsOneWidget);

      // RBI non-claim
      expect(
        find.textContaining('Diksha Finance makes no claim of RBI registration'),
        findsOneWidget,
      );
    });

    testWidgets('5. Contact Us displays structured fields with placeholders',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const ContactUsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Contact Us'), findsOneWidget);
      expect(find.text('Official Business Information'), findsOneWidget);

      // 1. Business Name
      expect(find.text('Business Name'), findsOneWidget);
      expect(find.text(AppConstants.contactBusinessName), findsOneWidget);

      // 2. Office Address
      expect(find.text('Office Address'), findsOneWidget);
      expect(find.text(AppConstants.contactOfficeAddress), findsOneWidget);

      // 3. Contact Email
      expect(find.text('Contact Email'), findsOneWidget);
      expect(find.text(AppConstants.contactEmail), findsOneWidget);

      // 4. Phone Number
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text(AppConstants.contactPhone), findsOneWidget);

      // No RBI claim
      expect(
        find.textContaining('Diksha Finance does not claim to be an RBI-registered NBFC or bank.'),
        findsOneWidget,
      );
    });

    testWidgets('6. All five informational pages are accessible from Profile screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const ProfileScreen()));
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
  });
}
