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
/// Houses the four primary tabs: Home, My Loans,
/// EMI Calculator, and Profile.
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
        return Scaffold(
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
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_balance_outlined),
                      activeIcon: Icon(Icons.account_balance_rounded),
                      label: 'My Loans',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calculate_outlined),
                      activeIcon: Icon(Icons.calculate_rounded),
                      label: 'EMI Calc',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person_rounded),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
