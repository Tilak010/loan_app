import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../models/emi_model.dart';
import '../config/app_constants.dart';

/// Manages loan application state for the Diksha Finance demo.
///
/// All loan data is simulated. No real applications are submitted.
class LoanProvider extends ChangeNotifier {
  // ─── Loan Application State ─────────────────────────────────────
  double _loanAmount = AppConstants.defaultLoanAmount;
  int _tenureMonths = AppConstants.defaultTenureMonths;
  String _purpose = AppConstants.loanPurposes.first;
  bool _isApplying = false;
  int _currentStep = 0; // 0=amount, 1=details, 2=kyc, 3=kfs, 4=status
  String? _applicationStatus;

  // ─── Personal Details ───────────────────────────────────────────
  String _fullName = '';
  String _email = '';
  String _dateOfBirth = '';
  String _gender = '';
  String _pan = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _pincode = '';
  String _employmentType = '';
  double _monthlyIncome = 0;

  // ─── KYC State ──────────────────────────────────────────────────
  String? _idDocumentType;
  bool _idDocumentUploaded = false;
  String? _addressProofType;
  bool _addressProofUploaded = false;
  bool _selfieUploaded = false;

  // ─── Loan List ──────────────────────────────────────────────────
  List<LoanModel> _loans = [];
  bool _loansLoaded = false;

  // ─── Getters ────────────────────────────────────────────────────
  double get loanAmount => _loanAmount;
  int get tenureMonths => _tenureMonths;
  String get purpose => _purpose;
  bool get isApplying => _isApplying;
  int get currentStep => _currentStep;
  String? get applicationStatus => _applicationStatus;

  String get fullName => _fullName;
  String get email => _email;
  String get dateOfBirth => _dateOfBirth;
  String get gender => _gender;
  String get pan => _pan;
  String get address => _address;
  String get city => _city;
  String get state => _state;
  String get pincode => _pincode;
  String get employmentType => _employmentType;
  double get monthlyIncome => _monthlyIncome;

  String? get idDocumentType => _idDocumentType;
  bool get idDocumentUploaded => _idDocumentUploaded;
  String? get addressProofType => _addressProofType;
  bool get addressProofUploaded => _addressProofUploaded;
  bool get selfieUploaded => _selfieUploaded;

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
    required String email,
    required String dateOfBirth,
    required String gender,
    required String pan,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String employmentType,
    required double monthlyIncome,
  }) {
    _fullName = fullName;
    _email = email;
    _dateOfBirth = dateOfBirth;
    _gender = gender;
    _pan = pan;
    _address = address;
    _city = city;
    _state = state;
    _pincode = pincode;
    _employmentType = employmentType;
    _monthlyIncome = monthlyIncome;
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
    _address = '';
    _city = '';
    _state = '';
    _pincode = '';
    _employmentType = '';
    _monthlyIncome = 0;
    _idDocumentType = null;
    _idDocumentUploaded = false;
    _addressProofType = null;
    _addressProofUploaded = false;
    _selfieUploaded = false;
    notifyListeners();
  }
}
