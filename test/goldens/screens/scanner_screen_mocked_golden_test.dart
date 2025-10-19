import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../golden_test_helper.dart';

/// Scanner screen golden test with mocked camera
/// 
/// Instead of testing the real ScannerScreen (which requires camera permissions),
/// we test a simplified version that shows what the UI looks like without the camera.
void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  testWidgets('ScannerScreen mock - light mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const MockedScannerScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(MockedScannerScreen),
      matchesGoldenFile('images/scanner_screen_mocked_light.png'),
    );
  });

  testWidgets('ScannerScreen mock - dark mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const MockedScannerScreen(),
        themeMode: ThemeMode.dark,
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(MockedScannerScreen),
      matchesGoldenFile('images/scanner_screen_mocked_dark.png'),
    );
  });
}

/// Mocked version of ScannerScreen for testing
/// Shows the UI layout without requiring actual camera access
class MockedScannerScreen extends StatelessWidget {
  const MockedScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mock camera preview (gray box with camera icon)
          Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Camera Preview',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Scanning frame overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Instructions at bottom
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: const Text(
                'Placez le code-barres dans le cadre',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

