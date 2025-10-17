import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen_new.dart';
import '../screens/scanner_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Clé pour forcer le rebuild de FavoritesScreen
  Key _favoritesKey = UniqueKey();

  // ScrollControllers pour chaque page (pour scroll to top)
  final List<ScrollController> _scrollControllers = [
    ScrollController(), // Home
    ScrollController(), // Search
    ScrollController(), // Scanner (non utilisé)
    ScrollController(), // Favorites
    ScrollController(), // Profile
  ];

  // Construire les écrans à la demande
  List<Widget> get _screens => [
    const HomeScreen(),
    const SearchScreenNew(),
    const ScannerScreen(), // Écran central
    FavoritesScreen(key: _favoritesKey), // Avec clé pour forcer rebuild
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    HapticFeedback.lightImpact();

    if (index == 2) {
      // Scanner - Navigation en plein écran
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScannerScreen(),
          fullscreenDialog: true,
        ),
      );
    } else {
      if (_currentIndex == index) {
        // Déjà sur cet onglet - scroll to top
        if (_scrollControllers[index].hasClients) {
          _scrollControllers[index].animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } else {
        // Changement d'onglet
        setState(() {
          _currentIndex = index;

          // Si on navigue vers les favoris (index 3), forcer un rebuild
          if (index == 3) {
            _favoritesKey = UniqueKey();
            print('🔄 Navigation vers Favoris - Refresh forcé');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Accueil',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.search_rounded,
                label: 'Recherche',
                index: 1,
              ),
              _buildScannerButton(),
              _buildNavItem(
                icon: Icons.favorite_rounded,
                label: 'Favoris',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isActive ? AppColors.navActive : AppColors.navInactive,
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive
                        ? AppColors.navActive
                        : AppColors.navInactive,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerButton() {
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
