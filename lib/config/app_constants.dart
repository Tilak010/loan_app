/// Diksha Finance — Application Constants
///
/// Centralizes all static strings, mock data, and configuration
/// values used across the application. No hardcoded strings in widgets.
class AppConstants {
  AppConstants._();

  // ─── App Info ───────────────────────────────────────────────────
  static const String appName = 'Diksha Finance';
  static const String appTagline = 'Indore & Dewas Ka Apna Loan App';
  static const String appVersion = '1.0.0 (Demo)';
  static const String companyName = 'Diksha Finance Pvt. Ltd.';

  // ─── Demo Disclaimer ───────────────────────────────────────────
  static const String demoDisclaimer =
      'This is a demonstration application. No real loans are disbursed, '
      'no real KYC is performed, and no real financial information is '
      'collected or stored.';

  static const String demoBannerText = 'DEMO MODE';

  static const String demoOtp = '1234';
  static const String demoOtpNotice =
      'Demo OTP — no SMS will be sent. Enter 1234 to proceed.';

  static const String demoKycNotice =
      'This is a simulated KYC upload. No real identity documents are '
      'collected, stored, or verified.';

  static const String demoApprovalNotice =
      'This is a simulated loan approval for demonstration purposes. '
      'No real loan application has been submitted or approved.';

  static const String demoKfsNotice =
      'This is a sample Key Fact Statement generated with illustrative '
      'data for demonstration purposes only.';

  // ─── Supported Languages ───────────────────────────────────────
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'kn', 'name': 'Kannada', 'native': 'ಕನ್ನಡ'},
  ];

  // ─── Loan Configuration ────────────────────────────────────────
  static const double minLoanAmount = 10000;
  static const double maxLoanAmount = 500000;
  static const double loanAmountStep = 5000;
  static const double defaultLoanAmount = 100000;

  static const int minTenureMonths = 3;
  static const int maxTenureMonths = 36;
  static const int defaultTenureMonths = 12;

  static const List<int> tenureOptions = [3, 6, 9, 12, 18, 24, 36];

  static const double sampleInterestRate = 14.5; // Annual %
  static const double sampleProcessingFee = 2.0; // Percentage
  static const double sampleGst = 18.0; // GST on processing fee

  // ─── Mock User ─────────────────────────────────────────────────
  static const String mockUserName = 'Rahul Sharma';
  static const String mockUserPhone = '9876543210';
  static const String mockUserEmail = 'rahul.sharma@example.com';

  // ─── Loan Purposes ─────────────────────────────────────────────
  static const List<String> loanPurposes = [
    'Personal Expense',
    'Medical Emergency',
    'Education',
    'Home Renovation',
    'Travel',
    'Wedding',
    'Debt Consolidation',
    'Business',
    'Other',
  ];

  // ─── Employment Types ──────────────────────────────────────────
  static const List<String> employmentTypes = [
    'Salaried',
    'Self-Employed',
    'Business Owner',
    'Professional',
    'Freelancer',
  ];

  // ─── ID Document Types (Demo) ──────────────────────────────────
  static const List<String> idDocumentTypes = [
    'Aadhaar Card',
    'PAN Card',
    'Voter ID',
    'Driving License',
    'Passport',
  ];

  // ─── Address Proof Types (Demo) ────────────────────────────────
  static const List<String> addressProofTypes = [
    'Aadhaar Card',
    'Utility Bill',
    'Bank Statement',
    'Rent Agreement',
    'Passport',
  ];

  // ─── Loan Status Labels ────────────────────────────────────────
  static const String statusDraft = 'Draft';
  static const String statusSubmitted = 'Submitted';
  static const String statusUnderReview = 'Under Review';
  static const String statusApproved = 'Approved';
  static const String statusDisbursed = 'Disbursed';
  static const String statusRejected = 'Rejected';
  static const String statusClosed = 'Closed';

  // ─── Lending Partner ──────────────────────────────────────────
  static const String proposedLendingPartner =
      'Proposed Lending Partner: To Be Confirmed';
  static const String proposedLendingPartnerNote =
      'Lending partner branding will be updated upon NBFC partnership authorization.';

  // ─── Company Info (Fictional) ──────────────────────────────────
  static const String companyAddress =
      'Demo Office, 123 Finance Street,\nBKC, Mumbai - 400051\nMaharashtra, India';
  static const String companyEmail = 'info@dikshafinance.demo';
  static const String companyPhone = '+91 22 1234 5678';
  static const String companyWebsite = 'www.dikshafinance.demo';

  static const String grievanceOfficerName = 'Mr. Demo Officer';
  static const String grievanceOfficerEmail = 'grievance@dikshafinance.demo';
  static const String grievanceOfficerPhone = '+91 22 8765 4321';

  // ─── About Us Text ─────────────────────────────────────────────
  static const String aboutUsText =
      'Diksha Finance is a demonstration lending application designed to '
      'showcase a proposed digital loan origination workflow for NBFC '
      'lending partners.\n\n'
      'This application illustrates the end-to-end borrower journey — '
      'from loan application and KYC verification to loan approval and '
      'repayment tracking — using modern mobile UI/UX patterns.\n\n'
      'All data shown is illustrative. No real financial transactions '
      'are processed through this application.';
}
