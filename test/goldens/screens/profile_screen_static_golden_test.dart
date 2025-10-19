import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/constants/app_colors.dart';
import '../golden_test_helper.dart';

/// ProfileScreen golden test with static UI (no providers/data loading)
void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
    await GoldenTestHelper.initMocks();
  });

  testWidgets('ProfileScreen static - light mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const StaticProfileScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(StaticProfileScreen),
      matchesGoldenFile('images/profile_screen_static_light.png'),
    );
  });

  testWidgets('ProfileScreen static - dark mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const StaticProfileScreen(),
        themeMode: ThemeMode.dark,
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(StaticProfileScreen),
      matchesGoldenFile('images/profile_screen_static_dark.png'),
    );
  });

  testWidgets('ProfileScreen static - tablet', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.tabletSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const StaticProfileScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(StaticProfileScreen),
      matchesGoldenFile('images/profile_screen_static_tablet.png'),
    );
  });
}

/// Static version of ProfileScreen for golden tests
class StaticProfileScreen extends StatelessWidget {
  const StaticProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Utilisateur',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'utilisateur@example.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pet info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pets, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Mon Animal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Nom', 'Rex'),
                  _buildInfoRow('Type', 'Chien'),
                  _buildInfoRow('Race', 'Labrador'),
                  _buildInfoRow('Âge', '5 ans'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bar_chart, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Statistiques',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Scans', '0'),
                      _buildStatItem('Favoris', '0'),
                      _buildStatItem('Alertes', '0'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
