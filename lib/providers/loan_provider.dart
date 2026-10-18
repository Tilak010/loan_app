import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../models/emi_model.dart';
import '../config/app_constants.dart';

/// Manages loan application state for the Diksha Finance demo.
///
/// All loan data is simulated. No real applications are submitted.
class LoanProvider extends ChangeNotifier {
  // ─── Loan Application State ─────────────────────────────────────
  String _loanType = 'Personal Loan';
  double _illustrativeRate = 24.0;
  double _loanAmount = AppConstants.defaultLoanAmount;
  int _tenureMonths = AppConstants.defaultTenureMonths;
  String _purpose = AppConstants.loanPurposes.first;
  bool _isApplying = false;
  int _currentStep = 0; // 0=amount, 1=details, 2=kyc, 3=kfs, 4=status
  String? _applicationStatus;
  String? _demoReferenceNumber;
  DateTime? _demoApplicationDate;

  // ─── Personal Details ───────────────────────────────────────────
  String _fullName = '';
  String _email = '';
  String _dateOfBirth = '';
  String _gender = '';
  String _pan = '';
  String _aadhaarLastFour = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _pincode = '';
  String _employmentType = '';
  String _occupation = 'Salaried';
  double _monthlyIncome = 0;
  double _monthlySales = 0;
  String _businessName = '';

  // ─── KYC State ──────────────────────────────────────────────────
  String? _idDocumentType;
  bool _idDocumentUploaded = false;
  String? _addressProofType;
  bool _addressProofUploaded = false;
  bool _selfieUploaded = false;

  bool _aadhaarFrontAdded = false;
  bool _aadhaarBackAdded = false;
  bool _panCardAdded = false;
  bool _bankStatementAdded = false;
  bool _selfieAdded = false;

  // ─── Loan List ──────────────────────────────────────────────────
  List<LoanModel> _loans = [];
  bool _loansLoaded = false;

  // ─── Getters ────────────────────────────────────────────────────
  String get loanType => _loanType;
  double get illustrativeRate => _illustrativeRate;
  double get loanAmount => _loanAmount;
  int get tenureMonths => _tenureMonths;
  String get purpose => _purpose;
  bool get isApplying => _isApplying;
  int get currentStep => _currentStep;
  String? get applicationStatus => _applicationStatus;

  String get demoReferenceNumber {
    if (_demoReferenceNumber == null || _demoReferenceNumber!.isEmpty) {
      final randomSuffix = (10000 + DateTime.now().millisecondsSinceEpoch % 90000).toString();
      _demoReferenceNumber = 'DF-APP-${DateTime.now().year}-$randomSuffix';
    }
    return _demoReferenceNumber!;
  }

  DateTime get demoApplicationDate {
    _demoApplicationDate ??= DateTime.now();
    return _demoApplicationDate!;
  }

  void setDemoReferenceNumber(String ref) {
    _demoReferenceNumber = ref;
    notifyListeners();
  }

  void setDemoApplicationDate(DateTime date) {
    _demoApplicationDate = date;
    notifyListeners();
  }

  void recordDemoCompletedLoan() {
    final ref = demoReferenceNumber;
    if (_loans.any((l) => l.id == ref)) return;
    final emi = emiModel;
    final fee = (_loanAmount == 50000) ? 500.0 : (_loanAmount * 0.01);
    final completedLoan = LoanModel(
      id: ref,
      amount: _loanAmount,
      tenureMonths: _tenureMonths,
      interestRate: _illustrativeRate,
      emiAmount: emi.emi,
      processingFee: fee,
      totalPayable: emi.totalPayable,
      purpose: _loanType,
      status: AppConstants.statusApproved,
      applicationDate: demoApplicationDate,
      approvalDate: demoApplicationDate,
      paidEmis: 0,
      totalEmis: _tenureMonths,
      nextEmiDate: demoApplicationDate.add(const Duration(days: 30)),
      outstandingAmount: emi.totalPayable,
    );
    _loans.insert(0, completedLoan);
    _applicationStatus = AppConstants.statusApproved;
    notifyListeners();
  }

  String get fullName => _fullName;
  String get email => _email;
  String get dateOfBirth => _dateOfBirth;
  String get gender => _gender;
  String get pan => _pan;
  String get aadhaarLastFour => _aadhaarLastFour;
  String get address => _address;
  String get city => _city;
  String get state => _state;
  String get pincode => _pincode;
  String get employmentType => _employmentType;
  String get occupation => _occupation;
  double get monthlyIncome => _monthlyIncome;
  double get monthlySales => _monthlySales;
  String get businessName => _businessName;

  String? get idDocumentType => _idDocumentType;
  bool get idDocumentUploaded => _idDocumentUploaded;
  String? get addressProofType => _addressProofType;
  bool get addressProofUploaded => _addressProofUploaded;
  bool get selfieUploaded => _selfieUploaded;

  bool get aadhaarFrontAdded => _aadhaarFrontAdded;
  bool get aadhaarBackAdded => _aadhaarBackAdded;
  bool get panCardAdded => _panCardAdded;
  bool get bankStatementAdded => _bankStatementAdded;
  bool get selfieAdded => _selfieAdded;

  bool get allDemoKycAdded =>
      _aadhaarFrontAdded &&
      _aadhaarBackAdded &&
      _panCardAdded &&
      _bankStatementAdded &&
      _selfieAdded;

  List<LoanModel> get loans => _loans;
  bool get loansLoaded => _loansLoaded;

  /// Computed EMI model based on current selections.
  EmiModel get emiModel => EmiModel(
        principal: _loanAmount,
        annualRate: AppConstants.sampleInterestRate,
        tenureMonths: _tenureMonths,
      );

  bool get isKycComplete =>
      _idDocumentUploaded && _addressProofUploaded && _selfieUploaded;

  // ─── Loan Amount / Tenure ───────────────────────────────────────
  void setLoanType(String type) {
    _loanType = type;
    notifyListeners();
  }

  void setIllustrativeRate(double rate) {
    _illustrativeRate = rate;
    notifyListeners();
  }

  void setLoanAmount(double amount) {
    _loanAmount = amount;
    notifyListeners();
  }

  void setTenureMonths(int months) {
    _tenureMonths = months;
    notifyListeners();
  }

  void setPurpose(String purpose) {
    _purpose = purpose;
    notifyListeners();
  }

  // ─── Personal Details ───────────────────────────────────────────

  void setPersonalDetails({
    required String fullName,
    String email = '',
    required String dateOfBirth,
    String gender = '',
    required String pan,
    String aadhaarLastFour = '',
    String address = '',
    String city = '',
    String state = '',
    String pincode = '',
    String employmentType = '',
    String occupation = 'Salaried',
    double monthlyIncome = 0,
    double monthlySales = 0,
    String businessName = '',
  }) {
    _fullName = fullName;
    _email = email;
    _dateOfBirth = dateOfBirth;
    _gender = gender;
    _pan = pan;
    _aadhaarLastFour = aadhaarLastFour;
    _address = address;
    _city = city;
    _state = state;
    _pincode = pincode;
    _employmentType = employmentType;
    _occupation = occupation;
    _monthlyIncome = monthlyIncome;
    _monthlySales = monthlySales;
    _businessName = businessName;
    notifyListeners();
  }

  // ─── KYC ────────────────────────────────────────────────────────

  void setIdDocument(String type) {
    _idDocumentType = type;
    notifyListeners();
  }

  void simulateIdUpload() {
    _idDocumentUploaded = true;
    notifyListeners();
  }

  void setAddressProof(String type) {
    _addressProofType = type;
    notifyListeners();
  }

  void simulateAddressProofUpload() {
    _addressProofUploaded = true;
    notifyListeners();
  }

  void simulateSelfieUpload() {
    _selfieUploaded = true;
    _selfieAdded = true;
    notifyListeners();
  }

  void setDocumentAdded(String docKey, bool value) {
    switch (docKey) {
      case 'aadhaar_front':
        _aadhaarFrontAdded = value;
        _idDocumentUploaded = _aadhaarFrontAdded && _aadhaarBackAdded;
        break;
      case 'aadhaar_back':
        _aadhaarBackAdded = value;
        _idDocumentUploaded = _aadhaarFrontAdded && _aadhaarBackAdded;
        break;
      case 'pan_card':
        _panCardAdded = value;
        break;
      case 'bank_statement':
        _bankStatementAdded = value;
        _addressProofUploaded = value;
        break;
      case 'selfie':
        _selfieAdded = value;
        _selfieUploaded = value;
        break;
    }
    notifyListeners();
  }

  void addAllKycDemoSamples() {
    _aadhaarFrontAdded = true;
    _aadhaarBackAdded = true;
    _panCardAdded = true;
    _bankStatementAdded = true;
    _selfieAdded = true;
    _idDocumentUploaded = true;
    _addressProofUploaded = true;
    _selfieUploaded = true;
    notifyListeners();
  }

  // ─── Application Flow ──────────────────────────────────────────

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  /// Simulate submitting the loan application.
  Future<void> submitApplication() async {
    _isApplying = true;
    _applicationStatus = AppConstants.statusSubmitted;
    notifyListeners();

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));
    _applicationStatus = AppConstants.statusUnderReview;
    notifyListeners();

    // Simulate approval
    await Future.delayed(const Duration(seconds: 3));

    final emi = emiModel;
    final processingFee = emi.processingFee(AppConstants.sampleProcessingFee);

    final newLoan = LoanModel(
      id: 'DF-${DateTime.now().year}-${(_loans.length + 1).toString().padLeft(3, '0')}',
      amount: _loanAmount,
      tenureMonths: _tenureMonths,
      interestRate: AppConstants.sampleInterestRate,
      emiAmount: emi.emi,
      processingFee: processingFee,
      totalPayable: emi.totalPayable,
      purpose: _purpose,
      status: AppConstants.statusApproved,
      applicationDate: DateTime.now(),
      approvalDate: DateTime.now(),
      paidEmis: 0,
      totalEmis: _tenureMonths,
      nextEmiDate: DateTime.now().add(const Duration(days: 30)),
      outstandingAmount: emi.totalPayable,
    );

    _loans.insert(0, newLoan);
    _applicationStatus = AppConstants.statusApproved;
    _isApplying = false;
    notifyListeners();
  }

  // ─── Loans List ─────────────────────────────────────────────────

  /// Load mock loans for demonstration.
  void loadMockLoans() {
    if (!_loansLoaded) {
      _loans = LoanModel.mockLoans();
      _loansLoaded = true;
      notifyListeners();
    }
  }

  /// Get active (non-closed) loans.
  List<LoanModel> get activeLoans =>
      _loans.where((l) => l.status != AppConstants.statusClosed).toList();

  /// Get closed loans.
  List<LoanModel> get closedLoans =>
      _loans.where((l) => l.status == AppConstants.statusClosed).toList();

  // ─── Reset ──────────────────────────────────────────────────────

  /// Reset the loan application form state.
  void resetApplication() {
    _loanType = 'Personal Loan';
    _illustrativeRate = 24.0;
    _loanAmount = AppConstants.defaultLoanAmount;
    _tenureMonths = AppConstants.defaultTenureMonths;
    _purpose = AppConstants.loanPurposes.first;
    _currentStep = 0;
    _applicationStatus = null;
    _isApplying = false;
    _fullName = '';
    _email = '';
    _dateOfBirth = '';
    _gender = '';
    _pan = '';
    _aadhaarLastFour = '';
    _address = '';
    _city = '';
    _state = '';
    _pincode = '';
    _employmentType = '';
    _occupation = 'Salaried';
    _monthlyIncome = 0;
    _monthlySales = 0;
    _businessName = '';
    _idDocumentType = null;
    _idDocumentUploaded = false;
    _addressProofType = null;
    _addressProofUploaded = false;
    _selfieUploaded = false;
    _aadhaarFrontAdded = false;
    _aadhaarBackAdded = false;
    _panCardAdded = false;
    _bankStatementAdded = false;
    _selfieAdded = false;
    _demoReferenceNumber = null;
    _demoApplicationDate = null;
    notifyListeners();
  }
}
