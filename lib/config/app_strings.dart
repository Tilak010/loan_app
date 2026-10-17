/// Localization strings dictionary for Diksha Finance (English and Hindi).
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome_title': 'Welcome to Diksha Finance',
      'welcome_subtitle': 'Personal and Business Loan Application Demo',
      'select_language': 'Select Preferred Language',
      'select_language_sub': 'Choose your language to proceed',
      'hindi': 'हिंदी',
      'english': 'English',
      'get_started': 'Get Started',
      'demo_footer':
          'Demonstration application for prospective NBFC lending partners. No real loans are disbursed.',
      'login_title': 'Sign In / Register',
      'login_subtitle': 'Enter your mobile number to get demo OTP',
      'mobile_number': 'Mobile Number',
      'enter_mobile': 'Enter 10-digit mobile number',
      'get_otp': 'Get Demo OTP',
      'verify_otp': 'Verify OTP',
      'home': 'Home',
      'my_loans': 'My Loans',
      'calculator': 'Calculator',
      'profile': 'Profile',
      'apply_now': 'Apply Now',
    },
    'hi': {
      'welcome_title': 'दीक्षा फाइनेंस में आपका स्वागत है',
      'welcome_subtitle': 'पर्सनल और बिजनेस लोन आवेदन डेमो',
      'select_language': 'पसंदीदा भाषा चुनें',
      'select_language_sub': 'आगे बढ़ने के लिए भाषा का चयन करें',
      'hindi': 'हिंदी',
      'english': 'English',
      'get_started': 'शुरू करें (Get Started)',
      'demo_footer':
          'एनबीएफसी लेंडिंग पार्टनर्स के लिए प्रदर्शन एप्लिकेशन। कोई वास्तविक ऋण वितरित नहीं किया जाता है।',
      'login_title': 'साइन इन / रजिस्टर',
      'login_subtitle': 'डेमो ओटीपी प्राप्त करने के लिए मोबाइल नंबर दर्ज करें',
      'mobile_number': 'मोबाइल नंबर',
      'enter_mobile': '10 अंकों का मोबाइल नंबर दर्ज करें',
      'get_otp': 'डेमो ओटीपी प्राप्त करें',
      'verify_otp': 'ओटीपी सत्यापित करें',
      'home': 'होम',
      'my_loans': 'मेरे लोन',
      'calculator': 'कैलकुलेटर',
      'profile': 'प्रोफाइल',
      'apply_now': 'अभी आवेदन करें',
    },
  };

  /// Fetch translated string by key and language code.
  static String tr(String key, String langCode) {
    return _localizedValues[langCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}
