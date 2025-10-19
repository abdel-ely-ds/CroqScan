import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
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
    ScrollController(), // Favorites
    ScrollController(), // Profile
  ];

  // Construire les écrans à la demande
  // Le scanner n'est PAS dans l'IndexedStack pour éviter qu'il reste actif
  List<Widget> get _screens => [
    const HomeScreen(),
    const SearchScreenNew(),
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
      // Scanner - Navigation en plein écran (pas dans l'IndexedStack)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScannerScreen(),
          fullscreenDialog: true,
        ),
      );
    } else {
      // Mapper l'index du bouton à l'index réel de l'écran
      // Bouton 0 → Écran 0 (Home)
      // Bouton 1 → Écran 1 (Search)
      // Bouton 2 → Scanner (route séparée, pas dans IndexedStack)
      // Bouton 3 (Favoris) → Écran 2
      // Bouton 4 (Profil) → Écran 3
      final screenIndex = index > 2 ? index - 1 : index;

      if (_currentIndex == screenIndex) {
        // Déjà sur cet onglet - scroll to top
        if (screenIndex < _scrollControllers.length &&
            _scrollControllers[screenIndex].hasClients) {
          _scrollControllers[screenIndex].animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } else {
        // Changement d'onglet
        setState(() {
          _currentIndex = screenIndex;

          // Si on navigue vers les favoris (écran index 2), forcer un rebuild
          if (screenIndex == 2) {
            _favoritesKey = UniqueKey();
            debugPrint('🔄 Navigation vers Favoris - Refresh forcé');
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
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItemWithImage(
                imagePath: 'assets/icons/pet_house.png',
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
    return _NavItemWithHover(
      icon: icon,
      label: label,
      index: index,
      currentIndex: _currentIndex,
      onTap: () => _onTabTapped(index),
    );
  }

  Widget _buildNavItemWithImage({
    required String imagePath,
    required String label,
    required int index,
  }) {
    return _NavItemWithImage(
      imagePath: imagePath,
      label: label,
      index: index,
      currentIndex: _currentIndex,
      onTap: () => _onTabTapped(index),
    );
  }

  Widget _buildScannerButton() {
    return _ScannerButtonWithHover(onTap: () => _onTabTapped(2));
  }
}

// Nav item with hover effect
class _NavItemWithHover extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItemWithHover({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<_NavItemWithHover> createState() => _NavItemWithHoverState();
}

class _NavItemWithHoverState extends State<_NavItemWithHover>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  // ignore: unused_field
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenIndex = widget.index > 2 ? widget.index - 1 : widget.index;
    final bool isActive = widget.currentIndex == screenIndex;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: _isHovered && !isActive
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: isActive
                          ? AppColors.primary
                          : (_isHovered
                                ? AppColors.primary
                                : AppColors.navInactive),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? AppColors.primary
                            : (_isHovered
                                  ? AppColors.primary
                                  : AppColors.navInactive),
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Nav item with image instead of icon
class _NavItemWithImage extends StatefulWidget {
  final String imagePath;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItemWithImage({
    required this.imagePath,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<_NavItemWithImage> createState() => _NavItemWithImageState();
}

class _NavItemWithImageState extends State<_NavItemWithImage>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  // ignore: unused_field
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenIndex = widget.index > 2 ? widget.index - 1 : widget.index;
    final bool isActive = widget.currentIndex == screenIndex;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: _isHovered && !isActive
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      widget.imagePath,
                      width: 20,
                      height: 20,
                      color: isActive
                          ? AppColors.primary
                          : (_isHovered
                                ? AppColors.primary
                                : AppColors.navInactive),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? AppColors.primary
                            : (_isHovered
                                  ? AppColors.primary
                                  : AppColors.navInactive),
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Scanner button with hover effect
class _ScannerButtonWithHover extends StatefulWidget {
  final VoidCallback onTap;

  const _ScannerButtonWithHover({required this.onTap});

  @override
  State<_ScannerButtonWithHover> createState() =>
      _ScannerButtonWithHoverState();
}

class _ScannerButtonWithHoverState extends State<_ScannerButtonWithHover>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 56,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: _isHovered ? 0.4 : 0.25,
                  ),
                  blurRadius: _isHovered ? 20 : 12,
                  offset: Offset(0, _isHovered ? 6 : 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
