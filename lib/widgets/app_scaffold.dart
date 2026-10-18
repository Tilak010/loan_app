import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/app_provider.dart';
import '../screens/home/home_screen.dart';
import '../screens/my_loans/my_loans_screen.dart';
import '../screens/emi_calculator/emi_calculator_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'demo_banner.dart';

/// The main scaffold with bottom navigation bar.
///
/// Houses the four primary tabs:
/// 1. Home
/// 2. My Loans
/// 3. EMI Calculator
/// 4. Profile
///
/// FEATURES:
/// - Highlights the currently selected tab with distinct color and filled icon
/// - Preserves relevant local demo state using IndexedStack
/// - Prevents duplicate navigation routes by updating currentNavIndex
/// - Supports Android back navigation: if on non-Home tab, back returns to Home tab
/// - Avoids resetting application state unexpectedly
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    MyLoansScreen(),
    EmiCalculatorScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        final isHindi = appProvider.isHindi;

        return PopScope(
          // Support Android back navigation: if on tabs 1, 2, or 3, return to Home (index 0)
          canPop: appProvider.currentNavIndex == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            if (appProvider.currentNavIndex != 0) {
              appProvider.setNavIndex(0);
            }
          },
          child: Scaffold(
            body: Column(
              children: [
                const DemoBanner(compact: true),
                Expanded(
                  child: IndexedStack(
                    index: appProvider.currentNavIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                border: const Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: BottomNavigationBar(
                    currentIndex: appProvider.currentNavIndex,
                    onTap: (index) => appProvider.setNavIndex(index),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    selectedItemColor: AppTheme.secondary,
                    unselectedItemColor: AppTheme.textHint,
                    selectedFontSize: 12,
                    unselectedFontSize: 11,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.home_outlined),
                        activeIcon: const Icon(Icons.home_rounded),
                        label: isHindi ? 'होम' : 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.account_balance_wallet_outlined),
                        activeIcon: const Icon(Icons.account_balance_wallet_rounded),
                        label: isHindi ? 'मेरे ऋण' : 'My Loans',
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.calculate_outlined),
                        activeIcon: const Icon(Icons.calculate_rounded),
                        label: isHindi ? 'ईएमआई' : 'EMI Calc',
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.person_outline_rounded),
                        activeIcon: const Icon(Icons.person_rounded),
                        label: isHindi ? 'प्रोफ़ाइल' : 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
