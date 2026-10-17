import 'package:intl/intl.dart';

/// Formatting helpers for currency, dates, and numbers.
class Formatters {
  Formatters._();

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final _currencyFormatWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final _numberFormat = NumberFormat('#,##,###', 'en_IN');

  static final _dateFormat = DateFormat('dd MMM yyyy');

  static final _shortDateFormat = DateFormat('dd/MM/yyyy');

  /// Format a number as Indian Rupees (no decimals).
  /// Example: 150000 → ₹1,50,000
  static String currency(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Format a number as Indian Rupees (with 2 decimals).
  /// Example: 13542.67 → ₹13,542.67
  static String currencyWithDecimals(double amount) {
    return _currencyFormatWithDecimals.format(amount);
  }

  /// Format a number with Indian commas.
  /// Example: 150000 → 1,50,000
  static String number(num value) {
    return _numberFormat.format(value);
  }

  /// Format a date as "dd MMM yyyy".
  /// Example: 2024-03-15 → 15 Mar 2024
  static String date(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format a date as "dd/MM/yyyy".
  static String shortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Format a percentage.
  /// Example: 14.5 → 14.5%
  static String percent(double value) {
    return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}%';
  }

  /// Format tenure in months to a readable string.
  /// Example: 12 → "12 Months"
  static String tenure(int months) {
    if (months == 1) return '1 Month';
    return '$months Months';
  }

  /// Format a phone number for display.
  /// Example: 9876543210 → +91 98765 43210
  static String phone(String number) {
    if (number.length == 10) {
      return '+91 ${number.substring(0, 5)} ${number.substring(5)}';
    }
    return number;
  }

  /// Mask a phone number for privacy.
  /// Example: 9876543210 → ******3210
  static String maskedPhone(String number) {
    if (number.length >= 4) {
      return '******${number.substring(number.length - 4)}';
    }
    return number;
  }

  /// Mask a PAN number for privacy.
  /// Example: ABCDE1234F → ABCDE****F
  static String maskedPan(String pan) {
    if (pan.length == 10) {
      return '${pan.substring(0, 5)}****${pan.substring(9)}';
    }
    return pan;
  }
}
