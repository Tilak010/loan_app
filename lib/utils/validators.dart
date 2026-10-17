/// Form validation helpers for the Diksha Finance demo.
///
/// These validators are for demonstrating UI validation behavior.
/// No real data validation against external services is performed.
class Validators {
  Validators._();

  /// Validates a 10-digit Indian mobile number.
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Please enter a valid Indian mobile number';
    }
    return null;
  }

  /// Validates a 6-digit OTP code.
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP must be 6 digits';
    }
    return null;
  }

  /// Validates that a field is not empty.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates an email address.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a PAN number format (ABCDE1234F).
  static String? pan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your PAN number';
    }
    if (!RegExp(r'^[A-Z]{5}\d{4}[A-Z]$').hasMatch(value.toUpperCase())) {
      return 'Please enter a valid PAN number (e.g. ABCDE1234F)';
    }
    return null;
  }

  /// Validates a 6-digit PIN code.
  static String? pincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your PIN code';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'PIN code must be 6 digits';
    }
    return null;
  }

  /// Validates a name (alphabets and spaces only, min 2 chars).
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates monthly income (must be a positive number).
  static String? income(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your monthly income';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return 'Please enter a valid income amount';
    }
    return null;
  }
}
