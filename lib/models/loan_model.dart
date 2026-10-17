/// Represents a loan application in the Diksha Finance demo.
///
/// All data is simulated. No real loan applications are
/// submitted, approved, or disbursed.
class LoanModel {
  final String id;
  final double amount;
  final int tenureMonths;
  final double interestRate;
  final double emiAmount;
  final double processingFee;
  final double totalPayable;
  final String purpose;
  final String status;
  final DateTime applicationDate;
  final DateTime? approvalDate;
  final DateTime? disbursementDate;
  final int paidEmis;
  final int totalEmis;
  final DateTime? nextEmiDate;
  final double? outstandingAmount;

  const LoanModel({
    required this.id,
    required this.amount,
    required this.tenureMonths,
    required this.interestRate,
    required this.emiAmount,
    required this.processingFee,
    required this.totalPayable,
    required this.purpose,
    required this.status,
    required this.applicationDate,
    this.approvalDate,
    this.disbursementDate,
    this.paidEmis = 0,
    this.totalEmis = 0,
    this.nextEmiDate,
    this.outstandingAmount,
  });

  LoanModel copyWith({
    String? id,
    double? amount,
    int? tenureMonths,
    double? interestRate,
    double? emiAmount,
    double? processingFee,
    double? totalPayable,
    String? purpose,
    String? status,
    DateTime? applicationDate,
    DateTime? approvalDate,
    DateTime? disbursementDate,
    int? paidEmis,
    int? totalEmis,
    DateTime? nextEmiDate,
    double? outstandingAmount,
  }) {
    return LoanModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      interestRate: interestRate ?? this.interestRate,
      emiAmount: emiAmount ?? this.emiAmount,
      processingFee: processingFee ?? this.processingFee,
      totalPayable: totalPayable ?? this.totalPayable,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      applicationDate: applicationDate ?? this.applicationDate,
      approvalDate: approvalDate ?? this.approvalDate,
      disbursementDate: disbursementDate ?? this.disbursementDate,
      paidEmis: paidEmis ?? this.paidEmis,
      totalEmis: totalEmis ?? this.totalEmis,
      nextEmiDate: nextEmiDate ?? this.nextEmiDate,
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
    );
  }

  /// Progress as a fraction (0.0 to 1.0) for repayment tracking.
  double get repaymentProgress {
    if (totalEmis == 0) return 0;
    return paidEmis / totalEmis;
  }

  /// Mock loan list for demo purposes.
  static List<LoanModel> mockLoans() {
    final now = DateTime.now();
    return [
      LoanModel(
        id: 'DF-2024-001',
        amount: 150000,
        tenureMonths: 12,
        interestRate: 14.5,
        emiAmount: 13542,
        processingFee: 3540,
        totalPayable: 162504,
        purpose: 'Personal Expense',
        status: 'Disbursed',
        applicationDate: now.subtract(const Duration(days: 90)),
        approvalDate: now.subtract(const Duration(days: 88)),
        disbursementDate: now.subtract(const Duration(days: 85)),
        paidEmis: 3,
        totalEmis: 12,
        nextEmiDate: now.add(const Duration(days: 5)),
        outstandingAmount: 121878,
      ),
      LoanModel(
        id: 'DF-2024-002',
        amount: 50000,
        tenureMonths: 6,
        interestRate: 14.5,
        emiAmount: 8757,
        processingFee: 1180,
        totalPayable: 52542,
        purpose: 'Medical Emergency',
        status: 'Closed',
        applicationDate: now.subtract(const Duration(days: 250)),
        approvalDate: now.subtract(const Duration(days: 248)),
        disbursementDate: now.subtract(const Duration(days: 245)),
        paidEmis: 6,
        totalEmis: 6,
      ),
    ];
  }
}
