import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/pet_onboarding_screen.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  testWidgets('PetOnboardingScreen golden test - step 1', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const PetOnboardingScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(PetOnboardingScreen),
      matchesGoldenFile('images/pet_onboarding_screen_step1.png'),
    );
  });

  testWidgets('PetOnboardingScreen golden test - dark mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const PetOnboardingScreen(),
        themeMode: ThemeMode.dark,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(PetOnboardingScreen),
      matchesGoldenFile('images/pet_onboarding_screen_dark.png'),
    );
  });
}
