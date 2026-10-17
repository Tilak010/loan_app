import 'package:flutter/material.dart';

/// Manages global application state: language selection,
/// bottom navigation index, and app-wide preferences.
class AppProvider extends ChangeNotifier {
  String _selectedLanguage = 'en';
  int _currentNavIndex = 0;
  bool _onboardingComplete = false;

  // ─── Getters ────────────────────────────────────────────────────
  String get selectedLanguage => _selectedLanguage;
  bool get isHindi => _selectedLanguage == 'hi';
  int get currentNavIndex => _currentNavIndex;
  bool get onboardingComplete => _onboardingComplete;

  // ─── Language ───────────────────────────────────────────────────

  void setLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }

  // ─── Navigation ─────────────────────────────────────────────────

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // ─── Onboarding ─────────────────────────────────────────────────

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  // ─── Reset ──────────────────────────────────────────────────────

  void reset() {
    _selectedLanguage = 'en';
    _currentNavIndex = 0;
    _onboardingComplete = false;
    notifyListeners();
  }
}
