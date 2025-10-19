import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/image_fullscreen_screen.dart';

void main() {
  group('ImageFullscreenScreen Widget Tests', () {
    const testImageUrl = 'https://example.com/test-image.jpg';
    const testHeroTag = 'test_hero_tag';

    testWidgets('displays InteractiveViewer for zoom functionality', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Verify InteractiveViewer exists
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('InteractiveViewer has correct scale limits and boundaryMargin',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Find the InteractiveViewer
      final interactiveViewer = tester.widget<InteractiveViewer>(
        find.byType(InteractiveViewer),
      );

      // Verify scale limits
      expect(interactiveViewer.minScale, 0.5);
      expect(interactiveViewer.maxScale, 4.0);

      // CRITICAL: Verify boundaryMargin allows iOS-like panning beyond screen
      expect(interactiveViewer.boundaryMargin, const EdgeInsets.all(double.infinity),
          reason: 'boundaryMargin must be infinite to allow iOS-like panning beyond screen boundaries when zoomed');
    });

    testWidgets('has dark background for fullscreen experience', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Find Container with dark background
      final container = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.color != null &&
            widget.color!.alpha > 0.9,
      );
      expect(container, findsOneWidget,
          reason: 'Must have a dark semi-transparent background for immersive experience');
    });

    testWidgets('displays close button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Verify close button icon exists
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('close button pops navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageFullscreenScreen(
                        imageUrl: testImageUrl,
                        heroTag: testHeroTag,
                      ),
                    ),
                  );
                },
                child: const Text('Open Image'),
              ),
            ),
          ),
        ),
      );

      // Tap button to open fullscreen image
      await tester.tap(find.text('Open Image'));
      await tester.pumpAndSettle();

      // Verify we're on the fullscreen screen
      expect(find.byType(ImageFullscreenScreen), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify we're back to the original screen
      expect(find.byType(ImageFullscreenScreen), findsNothing);
      expect(find.text('Open Image'), findsOneWidget);
    });

    testWidgets('displays zoom instructions hint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Verify zoom hint text exists
      expect(find.text('Pincez pour zoomer'), findsOneWidget);

      // Verify zoom icon exists
      expect(find.byIcon(Icons.zoom_in), findsOneWidget);
    });

    testWidgets('uses Hero animation when heroTag provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Verify Hero widget exists
      expect(find.byType(Hero), findsOneWidget);

      // Get the Hero widget
      final hero = tester.widget<Hero>(find.byType(Hero));

      // Verify hero tag
      expect(hero.tag, testHeroTag);
    });

    testWidgets('Image.network uses correct URL', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Find Image.network widget
      final imageWidget = tester.widget<Image>(find.byType(Image).first);

      // Verify it's a NetworkImage with correct URL
      expect(imageWidget.image, isA<NetworkImage>());
      final networkImage = imageWidget.image as NetworkImage;
      expect(networkImage.url, testImageUrl);
    });

    testWidgets('Image uses BoxFit.contain for fullscreen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Find Image widget
      final imageWidget = tester.widget<Image>(find.byType(Image).first);

      // Verify BoxFit.contain is used
      expect(imageWidget.fit, BoxFit.contain);
    });

    testWidgets('displays error widget when image fails to load', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Find Image widget
      final imageWidget = tester.widget<Image>(find.byType(Image).first);

      // Trigger error builder
      final errorWidget = imageWidget.errorBuilder!(
        tester.element(find.byType(Image).first),
        Exception('Test error'),
        null,
      );

      // Rebuild with error widget
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: errorWidget)));

      // Verify error icon and message
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Erreur de chargement de l\'image'), findsOneWidget);
    });

    testWidgets('works without heroTag', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            // No heroTag provided
          ),
        ),
      );

      // Should still display InteractiveViewer
      expect(find.byType(InteractiveViewer), findsOneWidget);

      // Should display Image.network
      expect(find.byType(Image), findsWidgets);

      // Should NOT use Hero when no heroTag
      expect(find.byType(Hero), findsNothing);
    });

    testWidgets('fullscreen uses Positioned.fill for entire screen coverage',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImageFullscreenScreen(
            imageUrl: testImageUrl,
            heroTag: testHeroTag,
          ),
        ),
      );

      // Find Scaffold
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));

      // Verify it uses Container with dark background
      expect(scaffold.body, isA<Container>());

      // Verify InteractiveViewer is in a Positioned.fill (taking full screen)
      final positionedFill = find.ancestor(
        of: find.byType(InteractiveViewer),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Positioned &&
              widget.top == 0 &&
              widget.bottom == 0 &&
              widget.left == 0 &&
              widget.right == 0,
        ),
      );
      expect(positionedFill, findsOneWidget,
          reason:
              'InteractiveViewer must be in a Positioned.fill to take full screen');

      // Verify boundaryMargin for iOS-like pan behavior
      final interactiveViewer =
          tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
      expect(interactiveViewer.boundaryMargin,
          const EdgeInsets.all(double.infinity),
          reason:
              'CRITICAL: boundaryMargin must be infinite to allow panning beyond screen when zoomed');
    });
  });
}
