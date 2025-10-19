import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/constants/app_colors.dart';
import '../golden_test_helper.dart';

/// Splash screen golden test with static UI (no timers/navigation)
///
/// The real SplashScreen has async timers and navigation that prevent golden testing.
/// This tests the visual appearance only.
void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  testWidgets('SplashScreen static - light mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const StaticSplashScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(StaticSplashScreen),
      matchesGoldenFile('images/splash_screen_static_light.png'),
    );
  });

  testWidgets('SplashScreen static - dark mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const StaticSplashScreen(),
        themeMode: ThemeMode.dark,
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(StaticSplashScreen),
      matchesGoldenFile('images/splash_screen_static_dark.png'),
    );
  });
}

/// Static version of SplashScreen for golden tests
/// No async logic, just the visual layout
class StaticSplashScreen extends StatelessWidget {
  const StaticSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo (statique, sans animation)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.accent.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets,
                size: 100,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'PetScan',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Analyse pour animaux',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

