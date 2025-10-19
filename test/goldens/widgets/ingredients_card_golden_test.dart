import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_details/ingredients_card.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  group('IngredientsCard golden tests', () {
    testWidgets('IngredientsCard - good ingredients', (tester) async {
      const ingredientsText = 'Chicken, Salmon, Turkey, Rice, Vegetables';

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(
            child: SizedBox(
              width: 350,
              child: IngredientsCard(ingredientsText: ingredientsText),
            ),
          ),
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(IngredientsCard),
        matchesGoldenFile('images/ingredients_card_good.png'),
      );
    });

    testWidgets('IngredientsCard - mixed quality ingredients', (tester) async {
      const ingredientsText =
          'Chicken, Corn, By-products, Rice, Salmon, E127 colorant, Sugar';

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(
            child: SizedBox(
              width: 350,
              child: IngredientsCard(ingredientsText: ingredientsText),
            ),
          ),
        ),
        surfaceSize: const Size(400, 500),
      );

      await expectLater(
        find.byType(IngredientsCard),
        matchesGoldenFile('images/ingredients_card_mixed.png'),
      );
    });

    testWidgets('IngredientsCard - problematic ingredients', (tester) async {
      const ingredientsText =
          'Corn, By-products, E123 colorant, E456 additif, Sugar, Corn syrup';

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(
            child: SizedBox(
              width: 350,
              child: IngredientsCard(ingredientsText: ingredientsText),
            ),
          ),
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(IngredientsCard),
        matchesGoldenFile('images/ingredients_card_problematic.png'),
      );
    });

    testWidgets('IngredientsCard - organic ingredients', (tester) async {
      const ingredientsText =
          'Organic chicken, Bio salmon, Organic vegetables, Turkey meat';

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(
            child: SizedBox(
              width: 350,
              child: IngredientsCard(ingredientsText: ingredientsText),
            ),
          ),
        ),
        surfaceSize: const Size(400, 350),
      );

      await expectLater(
        find.byType(IngredientsCard),
        matchesGoldenFile('images/ingredients_card_organic.png'),
      );
    });

    testWidgets('IngredientsCard - dark mode', (tester) async {
      const ingredientsText = 'Chicken, Salmon, Rice, By-products, Sugar';

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(
            child: SizedBox(
              width: 350,
              child: IngredientsCard(ingredientsText: ingredientsText),
            ),
          ),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(IngredientsCard),
        matchesGoldenFile('images/ingredients_card_dark.png'),
      );
    });
  });
}
