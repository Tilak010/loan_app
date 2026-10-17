import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Manages demo authentication state.
///
/// Simulates phone-based OTP login. No real OTP is sent.
/// Any 6-digit code is accepted for demonstration purposes.
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool _otpSent = false;
  String _phoneNumber = '';
  UserModel? _currentUser;
  String? _errorMessage;

  // ─── Getters ────────────────────────────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get otpSent => _otpSent;
  String get phoneNumber => _phoneNumber;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  // ─── Actions ────────────────────────────────────────────────────

  static const String demoOtp = '1234';

  /// Simulate sending an OTP to the entered phone number.
  Future<void> sendOtp(String phone) async {
    _phoneNumber = phone;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Brief simulated latency (300ms) for realistic UX
    await Future.delayed(const Duration(milliseconds: 300));

    _otpSent = true;
    _isLoading = false;
    notifyListeners();
  }

  /// Simulate verifying the OTP. Expects demo OTP '1234'.
  Future<bool> verifyOtp(String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    if (otp.trim() == demoOtp) {
      _isLoggedIn = true;
      _currentUser = UserModel.mock().copyWith(phone: _phoneNumber);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid OTP. Please enter demo OTP: $demoOtp';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user profile details.
  void updateUser(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  /// Reset OTP state (go back to phone entry).
  void resetOtp() {
    _otpSent = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Log out and clear all auth state.
  void logout() {
    _isLoggedIn = false;
    _otpSent = false;
    _phoneNumber = '';
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
