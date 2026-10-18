import 'dart:math';

/// EMI calculation model for the Diksha Finance demo.
///
/// Uses the standard reducing-balance EMI formula:
/// EMI = P × r × (1 + r)^n / ((1 + r)^n − 1)
/// where P = principal, r = monthly rate, n = tenure in months.
class EmiModel {
  final double principal;
  final double annualRate;
  final int tenureMonths;

  const EmiModel({
    required this.principal,
    required this.annualRate,
    required this.tenureMonths,
  });

  /// Monthly interest rate as a decimal.
  double get monthlyRate => annualRate / 12 / 100;

  /// Monthly EMI amount.
  /// Safely handles zero interest rate: EMI = principal / tenureMonths
  double get emi {
    if (tenureMonths <= 0) return 0;
    if (monthlyRate <= 0) return principal / tenureMonths;
    final r = monthlyRate;
    final n = tenureMonths;
    final factor = pow(1 + r, n);
    final denominator = factor - 1;
    if (denominator <= 0) return principal / tenureMonths;
    return principal * r * factor / denominator;
  }

  /// Total amount payable over the entire tenure.
  double get totalPayable => emi * tenureMonths;

  /// Total interest payable.
  double get totalInterest => totalPayable - principal;

  /// Processing fee amount (using a percentage).
  double processingFee(double feePercent) => principal * feePercent / 100;

  /// GST on processing fee.
  double gstOnProcessingFee(double feePercent, double gstPercent) =>
      processingFee(feePercent) * gstPercent / 100;

  /// Net disbursement amount (principal minus fees).
  double netDisbursement(double feePercent, double gstPercent) =>
      principal -
      processingFee(feePercent) -
      gstOnProcessingFee(feePercent, gstPercent);

  /// Generate the full amortization schedule.
  List<Map<String, double>> get amortizationSchedule {
    final schedule = <Map<String, double>>[];
    double balance = principal;
    final monthlyEmi = emi;

    for (int i = 1; i <= tenureMonths; i++) {
      final interestComponent = balance * monthlyRate;
      final principalComponent = monthlyEmi - interestComponent;
      balance -= principalComponent;

      schedule.add({
        'month': i.toDouble(),
        'emi': monthlyEmi,
        'principal': principalComponent,
        'interest': interestComponent,
        'balance': balance < 0 ? 0 : balance,
      });
    }

    return schedule;
  }
}
