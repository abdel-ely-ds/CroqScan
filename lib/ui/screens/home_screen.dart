import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/scan_history_service.dart';
import '../../core/services/profile_service.dart';
import 'scanner_screen.dart';
import 'search_screen_new.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _recentScans = [];
  AnimalProfile? _animalProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final scans = await ScanHistoryService.getRecentScans(5);
    final profile = await ProfileService.loadProfile();

    if (mounted) {
      setState(() {
        _recentScans = scans;
        _animalProfile = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // Clean header
              SliverToBoxAdapter(child: _buildHeader()),

              // Main feature cards
              SliverToBoxAdapter(child: _buildFeatureCards()),

              // Encouraging message
              SliverToBoxAdapter(child: _buildEncouragingMessage()),

              // Pet illustration
              SliverToBoxAdapter(child: _buildPetIllustration()),

              // Recent scans (if any)
              if (_recentScans.isNotEmpty)
                SliverToBoxAdapter(child: _buildRecentScans()),

              // Pet profile prompt (if no profile)
              if (_animalProfile == null)
                SliverToBoxAdapter(child: _buildPetProfilePrompt()),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  // Clean header with greeting
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    _animalProfile != null
                        ? 'Coucou ${_animalProfile!.name}'
                        : 'Coucou',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_animalProfile != null)
                  Image.asset(
                    _animalProfile!.animalType == 'dog'
                        ? 'assets/icons/dog_illustration.png'
                        : 'assets/images/cat_illustration.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  )
                else
                  const Text('🐾', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
          GestureDetector(
            onTap: _loadData,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.pastelLavender,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Main feature cards
  Widget _buildFeatureCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildFeatureCard(
            title: 'Scanner un produit',
            subtitle: 'Analyse instantanée de la qualité',
            icon: Icons.qr_code_scanner_rounded,
            color: AppColors.pastelPeach,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScannerScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            title: 'Rechercher',
            subtitle: 'Explorer la base de données',
            icon: Icons.search_rounded,
            color: AppColors.pastelMint,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreenNew(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            title: 'Mes Favoris',
            subtitle: 'Produits sauvegardés',
            icon: Icons.favorite_rounded,
            color: AppColors.pastelLavender,
            onTap: () {
              // Navigate to favorites (via navigation bar)
              DefaultTabController.of(context).animateTo(3);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _FeatureCardWithHover(
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      onTap: onTap,
    );
  }

  // Encouraging message from pet
  Widget _buildEncouragingMessage() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 48, 24, 0),
        constraints: const BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                'Merci de prendre soin de moi',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (_animalProfile != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Image.asset(
                  'assets/icons/heart.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Pet illustration with decorative wave background
  Widget _buildPetIllustration() {
    // Determine which image to show based on pet type
    final String imagePath;
    if (_animalProfile != null) {
      imagePath = _animalProfile!.animalType == 'dog'
          ? 'assets/images/dog_illustration.png'
          : 'assets/images/cat_illustration.png';
    } else {
      imagePath = 'assets/images/cat_illustration.png'; // Default to cat
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Wave/arc decorative elements (overlapping circles for wave effect)
          // Left side wave
          Positioned(
            left: -60,
            bottom: 20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.25),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: 50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.20),
              ),
            ),
          ),
          // Right side wave
          Positioned(
            right: -50,
            bottom: 40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.25),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: 70,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.18),
              ),
            ),
          ),
          // Top right accent
          Positioned(
            right: 20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.15),
              ),
            ),
          ),
          // Pet image on top (cat or dog based on profile)
          Center(
            child: Image.asset(
              imagePath,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // Recent scans - horizontal scroll
  Widget _buildRecentScans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Text(
            'Récemment scannés',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: _recentScans.length,
            itemBuilder: (context, index) {
              final scan = _recentScans[index];
              return _buildRecentScanCard(scan);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentScanCard(Map<String, dynamic> scan) {
    final score = scan['score'] as int? ?? 50;
    final scoreColor = AppColors.getScoreColor(score);

    return GestureDetector(
      onTap: () {
        // Navigate to product details
        // Implementation similar to original
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Container(
                height: 80,
                color: AppColors.background,
                child: Center(
                  child:
                      scan['imageUrl'] != null &&
                          (scan['imageUrl'] as String).isNotEmpty
                      ? Image.network(
                          scan['imageUrl'],
                          height: 70,
                          width: 70,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              '🐾',
                              style: TextStyle(fontSize: 32),
                            );
                          },
                        )
                      : const Text('🐾', style: TextStyle(fontSize: 32)),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan['name'] as String? ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    // Score badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        score.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pet profile prompt
  Widget _buildPetProfilePrompt() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to profile
            DefaultTabController.of(context).animateTo(4);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.pastelPink,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pets,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crée le profil de ton animal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Pour des recommandations personnalisées',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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

// Feature card with hover effect
class _FeatureCardWithHover extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCardWithHover({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_FeatureCardWithHover> createState() => _FeatureCardWithHoverState();
}

class _FeatureCardWithHoverState extends State<_FeatureCardWithHover> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _isHovered ? 0.08 : 0.04,
                    ),
                    blurRadius: _isHovered ? 16 : 12,
                    offset: Offset(0, _isHovered ? 6 : 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      widget.icon,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
