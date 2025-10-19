import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/product_details_screen.dart';
import 'package:croq_scan/ui/screens/image_fullscreen_screen.dart';
import 'package:croq_scan/core/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    // Mock SharedPreferences for FavoritesService
    SharedPreferences.setMockInitialValues({});
  });

  group('Image Zoom Integration Tests', () {
    final testProduct = Product(
      barcode: '123456789',
      name: 'Test Product',
      brand: 'Test Brand',
      imageUrl: 'https://example.com/test-product.jpg',
      healthScore: 85,
      suitableFor: [PetType.dog],
      ingredients: ['Chicken', 'Rice', 'Vegetables'],
      benefits: ['High protein', 'Natural ingredients'],
      warnings: [],
      description: 'Test product description',
      nutritionalInfo: NutritionalInfo(
        protein: 30.0,
        fat: 15.0,
        fiber: 3.0,
        moisture: 10.0,
        ash: 7.0,
      ),
    );

    testWidgets(
      'tapping product image opens fullscreen zoom view from ProductDetailsScreen',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: ProductDetailsScreen(product: testProduct)),
        );

        // Wait for initial render
        await tester.pumpAndSettle();

        // Find the product image in header
        final productImage = find.byType(Image).first;
        expect(productImage, findsOneWidget);

        // Tap on the image
        await tester.tap(productImage);
        await tester.pumpAndSettle();

        // Verify we navigated to ImageFullscreenScreen
        expect(find.byType(ImageFullscreenScreen), findsOneWidget);
      },
    );

    testWidgets(
      'fullscreen image view has InteractiveViewer for zoom functionality',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: ProductDetailsScreen(product: testProduct)),
        );

        await tester.pumpAndSettle();

        // Tap product image to open fullscreen
        await tester.tap(find.byType(Image).first);
        await tester.pumpAndSettle();

        // Verify InteractiveViewer exists in fullscreen view
        expect(find.byType(InteractiveViewer), findsOneWidget);

        // Verify it has correct zoom limits
        final interactiveViewer = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );
        expect(interactiveViewer.minScale, 0.5);
        expect(interactiveViewer.maxScale, 4.0);
      },
    );

    testWidgets('fullscreen image uses entire screen (no padding constraints)', (
      tester,
    ) async {
      // Set screen size
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(home: ProductDetailsScreen(product: testProduct)),
      );

      await tester.pumpAndSettle();

      // Open fullscreen image
      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();

      // Verify fullscreen has black background
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).last);
      expect(scaffold.backgroundColor, Colors.black);

      // Verify InteractiveViewer can take full screen
      final interactiveViewerSize = tester.getSize(
        find.byType(InteractiveViewer),
      );
      final screenSize =
          tester.view.physicalSize / tester.view.devicePixelRatio;

      // InteractiveViewer should be close to screen size (accounting for SafeArea)
      expect(interactiveViewerSize.width, closeTo(screenSize.width, 50));
      expect(interactiveViewerSize.height, closeTo(screenSize.height, 100));

      // Reset
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('close button returns to ProductDetailsScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductDetailsScreen(product: testProduct)),
      );

      await tester.pumpAndSettle();

      // Open fullscreen image
      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();

      // Verify we're on fullscreen
      expect(find.byType(ImageFullscreenScreen), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify we're back on ProductDetailsScreen
      expect(find.byType(ImageFullscreenScreen), findsNothing);
      expect(find.byType(ProductDetailsScreen), findsOneWidget);
    });

    testWidgets('Hero animation works between screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductDetailsScreen(product: testProduct)),
      );

      await tester.pumpAndSettle();

      // Find Hero widget in ProductDetailsScreen
      final heroInDetails = find.ancestor(
        of: find.byType(Image).first,
        matching: find.byType(Hero),
      );
      expect(heroInDetails, findsOneWidget);

      // Verify hero tag
      final heroWidgetInDetails = tester.widget<Hero>(heroInDetails);
      expect(heroWidgetInDetails.tag, 'product_image_${testProduct.barcode}');

      // Tap to open fullscreen
      await tester.tap(find.byType(Image).first);
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 100)); // Mid animation

      // During animation, Hero should exist
      expect(find.byType(Hero), findsWidgets);

      await tester.pumpAndSettle(); // Complete animation

      // In fullscreen, Hero should still exist with same tag
      final heroInFullscreen = find.byType(Hero);
      expect(heroInFullscreen, findsOneWidget);

      final heroWidgetInFullscreen = tester.widget<Hero>(heroInFullscreen);
      expect(
        heroWidgetInFullscreen.tag,
        'product_image_${testProduct.barcode}',
      );
    });

    testWidgets('image with empty URL does not open fullscreen', (
      tester,
    ) async {
      final productNoImage = Product(
        barcode: '987654321',
        name: 'Test Product No Image',
        brand: 'Test Brand',
        imageUrl: '', // Empty image URL
        healthScore: 85,
        suitableFor: [PetType.dog],
        ingredients: ['Chicken', 'Rice'],
        benefits: ['High protein'],
        warnings: [],
        description: 'Test product without image',
        nutritionalInfo: NutritionalInfo(
          protein: 30.0,
          fat: 15.0,
          fiber: 3.0,
          moisture: 10.0,
          ash: 7.0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(home: ProductDetailsScreen(product: productNoImage)),
      );

      await tester.pumpAndSettle();

      // Find placeholder icon (no image)
      expect(find.byIcon(Icons.pets), findsOneWidget);

      // Tap on placeholder
      await tester.tap(find.byIcon(Icons.pets));
      await tester.pumpAndSettle();

      // Should NOT navigate to fullscreen
      expect(find.byType(ImageFullscreenScreen), findsNothing);
      expect(find.byType(ProductDetailsScreen), findsOneWidget);
    });

    testWidgets('zoom instructions hint is visible in fullscreen', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductDetailsScreen(product: testProduct)),
      );

      await tester.pumpAndSettle();

      // Open fullscreen
      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();

      // Verify zoom hint is visible
      expect(find.text('Pincez pour zoomer'), findsOneWidget);
      expect(find.byIcon(Icons.zoom_in), findsOneWidget);
    });

    testWidgets('fullscreen uses correct image URL', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductDetailsScreen(product: testProduct)),
      );

      await tester.pumpAndSettle();

      // Open fullscreen
      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();

      // Find Image.network in fullscreen
      final images = find.byType(Image);
      final fullscreenImage = tester.widget<Image>(images.last);

      // Verify it uses NetworkImage with correct URL
      expect(fullscreenImage.image, isA<NetworkImage>());
      final networkImage = fullscreenImage.image as NetworkImage;
      expect(networkImage.url, testProduct.imageUrl);
    });
  });
}
