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

  // ─── Lending Partner & Regulatory Notices ─────────────────────
  static const String proposedLendingPartner =
      'Proposed Lending Partner: To Be Confirmed';
  static const String proposedLendingPartnerNote =
      'Diksha Finance is currently a technology demonstration prototype. '
      'Neither Diksha Finance nor any proposed lending partner is claimed '
      'to be an RBI-registered NBFC or bank for active lending operations within this demo. '
      'All formal regulatory and partner credentials will be disclosed upon commercial authorization.';

  // ─── Contact Us Fields (Structured Placeholders — No Invented Details) ───
  static const String contactBusinessName = 'Diksha Finance';
  static const String contactBusinessStatus = 'Demonstration Prototype';
  static const String contactOfficeAddress =
      '[Registered / Corporate Office Address to be updated upon operational setup]';
  static const String contactEmail =
      '[Official contact email to be updated upon partner launch]';
  static const String contactPhone =
      '[Support phone line to be configured upon commercial deployment]';
  static const String contactWebsite =
      '[Official website URL to be announced]';

  // Backwards-compatible aliases
  static const String companyAddress = contactOfficeAddress;
  static const String companyEmail = contactEmail;
  static const String companyPhone = contactPhone;
  static const String companyWebsite = contactWebsite;

  // ─── Grievance Redressal (Structured Placeholders — No Invented Details) ─
  static const String grievanceOfficerName =
      '[Grievance Officer Name - To be appointed upon formal launch]';
  static const String grievanceOfficerDesignation =
      'Grievance Redressal / Nodal Officer';
  static const String grievanceOfficerEmail =
      '[Grievance Email - To be designated]';
  static const String grievanceOfficerPhone =
      '[Grievance Helpline - To be configured]';

  // Escalation Process steps
  static const String grievanceEscalationLevel1Title = 'Level 1: Customer Support Helpdesk';
  static const String grievanceEscalationLevel1Desc =
      'Borrowers submit inquiries or operational issues via designated support channels. Initial response target is within 48 to 72 business hours upon commercial rollout.';

  static const String grievanceEscalationLevel2Title = 'Level 2: Grievance Redressal Officer';
  static const String grievanceEscalationLevel2Desc =
      'If the complaint is not redressed within 7 business days or the resolution is unsatisfactory, the matter escalates directly to the designated Grievance Officer for formal review.';

  static const String grievanceEscalationLevel3Title = 'Level 3: Regulatory Escalation / Ombudsman';
  static const String grievanceEscalationLevel3Desc =
      'If unresolved after 30 business days, borrowers may approach the statutory Reserve Bank of India (RBI) Ombudsman mechanism or regulatory redressal portal of the partner regulated entity once authorized.';

  // ─── About Us Content ──────────────────────────────────────────
  static const String aboutUsText =
      'Diksha Finance is currently a demonstration application designed to '
      'showcase a proposed digital loan application journey.\n\n'
      'This technology prototype provides a comprehensive walkthrough of a '
      'modern digital lending flow — including interactive loan amount selection, '
      'real-time EMI simulation, simulated applicant profiling, mock KYC verification, '
      'illustrative Key Fact Statement (KFS) generation, simulated loan sanction, and '
      'repayment tracking.\n\n'
      'Important Notice: Diksha Finance is strictly a demonstration prototype. '
      'The application does not disburse real credit, does not collect or process live banking '
      'transactions, and makes no claim of RBI registration or regulated financial lending status.';
}

