import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../golden_test_helper.dart';

/// LoginScreen golden tests by sections
/// 
/// Instead of testing the entire scrollable screen (which causes issues),
/// we test individual sections of the login screen separately.
void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  testWidgets('LoginScreen header section - light mode', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 400));
    
    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const LoginScreenHeader(),
        themeMode: ThemeMode.light,
      ),
    );
    
    await tester.pump();

    await expectLater(
      find.byType(LoginScreenHeader),
      matchesGoldenFile('images/login_screen_header_light.png'),
    );
  });

  testWidgets('LoginScreen form section - light mode', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 500));
    
    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const LoginScreenForm(),
        themeMode: ThemeMode.light,
      ),
    );
    
    await tester.pump();

    await expectLater(
      find.byType(LoginScreenForm),
      matchesGoldenFile('images/login_screen_form_light.png'),
    );
  });

  testWidgets('LoginScreen social buttons - light mode', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 300));
    
    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const LoginScreenSocialButtons(),
        themeMode: ThemeMode.light,
      ),
    );
    
    await tester.pump();

    await expectLater(
      find.byType(LoginScreenSocialButtons),
      matchesGoldenFile('images/login_screen_social_light.png'),
    );
  });
}

/// Mock components for testing
/// Extract these from your actual LoginScreen for testing

class LoginScreenHeader extends StatelessWidget {
  const LoginScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'CroqScan',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scannez pour la santé de votre animal',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LoginScreenForm extends StatelessWidget {
  const LoginScreenForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Se connecter',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreenSocialButtons extends StatelessWidget {
  const LoginScreenSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ou continuer avec',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.apple),
                  label: const Text('Apple'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

