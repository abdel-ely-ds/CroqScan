import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../services/scan_history_service.dart';
import '../services/profile_service.dart';
import '../services/openpetfoodfacts_service.dart';
import 'scanner_screen.dart';
import 'search_screen_new.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _recentScans = [];
  bool _isLoadingRecommendations = false;
  AnimalProfile? _animalProfile;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadRecentScans();
    _loadProfile();
    _loadRecommendations();
  }

  Future<void> _loadRecentScans() async {
    final scans = await ScanHistoryService.getRecentScans(5);
    if (mounted) {
      setState(() {
        _recentScans = scans;
      });
    }
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.loadProfile();
    final userName = await ProfileService.loadUserName();
    if (mounted) {
      setState(() {
        _animalProfile = profile;
        _userName = userName;
      });
    }
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _isLoadingRecommendations = true;
    });

    // TODO: Implémenter le chargement de recommandations depuis l'API
    // Pour le MVP, on affiche un message statique

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoadingRecommendations = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadRecentScans();
            await _loadProfile();
            await _loadRecommendations();
          },
          child: CustomScrollView(
            slivers: [
              // 1️⃣ Header personnalisé
              SliverToBoxAdapter(child: _buildHeader()),

              // 2️⃣ Bouton Scanner principal
              SliverToBoxAdapter(child: _buildScannerButton()),

              // 🧪 TEST: Score Colors
              SliverToBoxAdapter(child: _buildTestScores()),

              // 📊 Quick Stats
              SliverToBoxAdapter(child: _buildQuickStats()),

              // 💡 Daily Tip
              SliverToBoxAdapter(child: _buildDailyTip()),

              // 🐾 Pet Profile Prompt (if no profile)
              if (_animalProfile == null)
                SliverToBoxAdapter(child: _buildPetProfilePrompt()),

              // 3️⃣ Mes derniers produits
              if (_recentScans.isNotEmpty)
                SliverToBoxAdapter(child: _buildRecentScans()),

              // 4️⃣ Recommandés pour toi
              SliverToBoxAdapter(child: _buildRecommendations()),

              // 5️⃣ Explorer par catégorie
              SliverToBoxAdapter(child: _buildCategories()),

              // 6️⃣ Info OpenPetFoodFacts
              SliverToBoxAdapter(child: _buildInfoSection()),

              // Espace pour la navbar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  // 1️⃣ Header personnalisé
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 2),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 0.1,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.accent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName != null
                          ? 'Bonjour $_userName 👋'
                          : 'Bonjour 👋',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _animalProfile != null
                          ? 'Des produits sains pour ${_animalProfile!.name} 🐾'
                          : 'Des produits sains pour vos animaux 🐾',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2️⃣ Bouton Scanner principal avec hover
  Widget _buildScannerButton() {
    return _ScannerButtonWithHover();
  }

  // 3️⃣ Mes derniers produits
  Widget _buildRecentScans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes derniers produits',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Naviguer vers l'historique complet
                },
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
      onTap: () async {
        // Charger le produit complet depuis l'API
        final barcode = scan['barcode'] as String;
        final product = await OpenPetFoodFactsService.fetchProductByBarcode(
          barcode,
        );
        if (product != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          );
        }
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                top: Radius.circular(16),
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
                            return const Icon(
                              Icons.pets,
                              size: 40,
                              color: AppColors.textSecondary,
                            );
                          },
                        )
                      : const Icon(
                          Icons.pets,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
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
                    // Score
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        score.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
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

  // 4️⃣ Découverte des produits
  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            _animalProfile != null
                ? 'Trouvez le meilleur pour ${_animalProfile!.name} 🔍'
                : 'Découvrez nos produits 🔍',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (_isLoadingRecommendations)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.accent.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Explorez notre base de données',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Utilisez la recherche pour découvrir des produits adaptés à vos animaux',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreenNew(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Rechercher'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // 5️⃣ Explorer par catégorie
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Explorer par catégorie',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildCategoryCard(
                emoji: '🐕',
                title: 'Croquettes chien',
                color: AppColors.dogColor,
                onTap: () => _openSearch('dog-food'),
              ),
              _buildCategoryCard(
                emoji: '🐈',
                title: 'Alimentation chat',
                color: AppColors.catColor,
                onTap: () => _openSearch('cat-food'),
              ),
              _buildCategoryCard(
                emoji: '🍪',
                title: 'Friandises',
                color: Colors.orange,
                onTap: () => _openSearch('treats'),
              ),
              _buildCategoryCard(
                emoji: '🍼',
                title: 'Jeunes animaux',
                color: Colors.purple.shade300,
                onTap: () => _openSearch('puppy'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String emoji,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (value * 0.1),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.2),
                      color.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: color.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 1.0 + (value * 0.1),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 44),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
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

  void _openSearch(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreenNew()),
    );
  }

  // 6️⃣ Info OpenPetFoodFacts
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.accent.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: const Column(
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Propulsé par OpenPetFoodFacts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Base de données collaborative et libre de produits pour animaux du monde entier.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧪 TEST: Products with different scores to test color gradient
  Widget _buildTestScores() {
    final testScores = [20, 30, 40, 50, 60, 70, 80, 90, 95];
    
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.science, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Test: Score Colors 🎨',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: testScores.length,
              itemBuilder: (context, index) {
                final score = testScores[index];
                final color = AppColors.getScoreColor(score);
                final label = _getScoreLabel(score);
                
                return GestureDetector(
                  onTap: () => _navigateToTestProduct(score),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$score',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to test product details
  void _navigateToTestProduct(int score) {
    final testProduct = _createTestProduct(score);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: testProduct),
      ),
    );
  }

  // Create a test product with a specific score
  Product _createTestProduct(int score) {
    // Generate nutritional values based on score
    double protein = 10 + (score * 0.3); // 10-38%
    double fat = score >= 50 ? 15.0 : 8.0;
    double fiber = score >= 60 ? 3.5 : 1.0;
    
    // Generate ingredients based on score
    List<String> ingredients;
    String ingredientsText;
    List<String> warnings = [];
    List<String> benefits = [];
    
    if (score >= 80) {
      ingredients = [
        'Poulet frais (35%)',
        'Saumon (20%)',
        'Patate douce bio',
        'Légumes déshydratés',
        'Huile de saumon',
        'Vitamines et minéraux',
      ];
      ingredientsText = ingredients.join(', ');
      benefits = [
        'Haute teneur en protéines',
        'Ingrédients naturels',
        'Sans céréales',
        'Riche en oméga-3',
      ];
    } else if (score >= 60) {
      ingredients = [
        'Viande de poulet (25%)',
        'Riz complet',
        'Légumes',
        'Huiles végétales',
        'Vitamines',
      ];
      ingredientsText = ingredients.join(', ');
      benefits = ['Bonne teneur en protéines', 'Équilibré'];
      warnings = ['Contient des céréales'];
    } else if (score >= 40) {
      ingredients = [
        'Céréales',
        'Sous-produits animaux (15%)',
        'Maïs',
        'Colorants',
        'Conservateurs',
      ];
      ingredientsText = ingredients.join(', ');
      warnings = [
        'Céréales en premier ingrédient',
        'Sous-produits animaux',
        'Colorants artificiels',
      ];
    } else {
      ingredients = [
        'Céréales (maïs, blé)',
        'Sous-produits animaux',
        'Sucre',
        'Colorants E127',
        'Conservateurs',
        'Arômes artificiels',
      ];
      ingredientsText = ingredients.join(', ');
      warnings = [
        'Très faible en protéines',
        'Colorants artificiels',
        'Sous-produits de faible qualité',
        'Contient du sucre',
      ];
    }
    
    return Product(
      barcode: 'TEST-$score',
      name: 'Produit Test - Score $score',
      brand: 'Test Brand',
      imageUrl: '',
      healthScore: score,
      suitableFor: [PetType.dog, PetType.cat],
      description: 'Produit de test pour vérifier l\'affichage du score $score',
      ingredients: ingredients,
      warnings: warnings,
      benefits: benefits,
      nutritionalInfo: NutritionalInfo(
        protein: protein,
        fat: fat,
        fiber: fiber,
        moisture: 10.0,
        ash: 5.0,
      ),
    );
  }

  // 📊 Quick Stats Card
  Widget _buildQuickStats() {
    final scanCount = _recentScans.length;
    final avgScore = scanCount > 0
        ? (_recentScans.fold<int>(0, (sum, scan) => sum + (scan['score'] as int? ?? 50)) / scanCount).round()
        : 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.qr_code_scanner,
              label: 'Scans',
              value: '$scanCount',
              color: AppColors.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.bar_chart,
              label: 'Score moyen',
              value: scanCount > 0 ? '$avgScore/100' : '--',
              color: AppColors.secondary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.pets,
              label: 'Profil',
              value: _animalProfile != null ? '✓' : '?',
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // 💡 Daily Tip Card
  Widget _buildDailyTip() {
    final tips = [
      {
        'title': 'Protéines 🥩',
        'tip': 'Les animaux ont besoin de 25-35% de protéines dans leur alimentation pour rester en bonne santé.',
        'icon': '🥩',
        'color': AppColors.primary,
      },
      {
        'title': 'Hydratation 💧',
        'tip': 'Assurez-vous que votre animal ait toujours accès à de l\'eau fraîche et propre.',
        'icon': '💧',
        'color': AppColors.secondary,
      },
      {
        'title': 'Céréales 🌾',
        'tip': 'Les céréales en premier ingrédient peuvent indiquer une alimentation de moindre qualité.',
        'icon': '🌾',
        'color': AppColors.accent,
      },
      {
        'title': 'Colorants ⚠️',
        'tip': 'Évitez les produits avec des colorants artificiels (E100-E199).',
        'icon': '⚠️',
        'color': AppColors.scorePoor,
      },
      {
        'title': 'Oméga-3 🐟',
        'tip': 'Les acides gras oméga-3 favorisent un pelage brillant et une peau saine.',
        'icon': '🐟',
        'color': AppColors.scoreExcellent,
      },
    ];
    
    // Use day of year to rotate tips
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final tip = tips[dayOfYear % tips.length];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (tip['color'] as Color).withValues(alpha: 0.15),
            (tip['color'] as Color).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (tip['color'] as Color).withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Could show more tips or info
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (tip['color'] as Color).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      tip['icon'] as String,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Astuce du jour',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tip['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tip['tip'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
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

  // 🐾 Pet Profile Prompt
  Widget _buildPetProfilePrompt() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to profile creation
            Navigator.pushNamed(context, '/profile');
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Créez le profil de votre compagnon 🐾',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Recevez des recommandations personnalisées adaptées à votre animal',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Très bon';
    if (score >= 60) return 'Bon';
    if (score >= 50) return 'Moyen';
    if (score >= 40) return 'Passable';
    if (score >= 30) return 'Médiocre';
    return 'À éviter';
  }
}

// Scanner button with hover effect
class _ScannerButtonWithHover extends StatefulWidget {
  const _ScannerButtonWithHover();

  @override
  State<_ScannerButtonWithHover> createState() =>
      _ScannerButtonWithHoverState();
}

class _ScannerButtonWithHoverState extends State<_ScannerButtonWithHover> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScannerScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.accent,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: _isHovered ? 0.7 : 0.5,
                      ),
                      blurRadius: _isHovered ? 30 : 25,
                      offset: Offset(0, _isHovered ? 15 : 12),
                    ),
                    BoxShadow(
                      color: AppColors.accent.withValues(
                        alpha: _isHovered ? 0.5 : 0.3,
                      ),
                      blurRadius: _isHovered ? 20 : 15,
                      offset: Offset(0, _isHovered ? 8 : 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: _isHovered ? 0.3 : 0.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Scanner un produit',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '🐶 Ton compagnon compte sur toi !',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 24,
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
