import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service d'authentification Apple (stockage local uniquement)
class AuthService {
  static const _storage = FlutterSecureStorage();

  // Clés de stockage
  static const String _keyUserId = 'apple_user_id';
  static const String _keyIdentityToken = 'apple_identity_token';
  static const String _keyEmail = 'apple_email';
  static const String _keyName = 'apple_name';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Se connecter avec Apple
  static Future<AuthResult> signInWithApple() async {
    try {
      print('🍏 Démarrage Sign in with Apple...');

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print('✅ Authentification Apple réussie');
      print('   User ID: ${credential.userIdentifier}');
      print('   Email: ${credential.email ?? "Non fourni"}');

      // Sauvegarder les données localement de manière sécurisée
      await _storage.write(key: _keyUserId, value: credential.userIdentifier);

      if (credential.identityToken != null) {
        await _storage.write(
          key: _keyIdentityToken,
          value: credential.identityToken,
        );
      }

      if (credential.email != null) {
        await _storage.write(key: _keyEmail, value: credential.email);
      }

      // Le nom complet n'est fourni que lors de la première connexion
      if (credential.givenName != null || credential.familyName != null) {
        final fullName =
            '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                .trim();
        await _storage.write(key: _keyName, value: fullName);
      }

      await _storage.write(key: _keyIsLoggedIn, value: 'true');

      print('💾 Données sauvegardées localement');

      return AuthResult(
        success: true,
        userId: credential.userIdentifier,
        email: credential.email,
        name: await _storage.read(key: _keyName),
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      // Gérer les erreurs spécifiques Apple
      if (e.code == AuthorizationErrorCode.canceled) {
        print('ℹ️ Connexion annulée par l\'utilisateur');
        return AuthResult(success: false, canceled: true);
      } else if (e.code == AuthorizationErrorCode.unknown) {
        // Erreur 1000 - Généralement annulation ou problème config
        print('ℹ️ Connexion annulée ou problème de configuration');
        return AuthResult(success: false, canceled: true);
      } else {
        print('❌ Erreur Sign in with Apple: ${e.code} - ${e.message}');
        return AuthResult(
          success: false,
          error: 'Erreur d\'authentification Apple',
        );
      }
    } catch (e) {
      print('❌ Erreur inattendue: $e');
      return AuthResult(success: false, error: 'Erreur de connexion');
    }
  }

  /// Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final userId = await _storage.read(key: _keyUserId);
    final isLoggedIn = await _storage.read(key: _keyIsLoggedIn);
    return userId != null && isLoggedIn == 'true';
  }

  /// Récupérer les informations de l'utilisateur connecté
  static Future<UserInfo?> getUserInfo() async {
    final userId = await _storage.read(key: _keyUserId);
    if (userId == null) return null;

    return UserInfo(
      userId: userId,
      email: await _storage.read(key: _keyEmail),
      name: await _storage.read(key: _keyName),
    );
  }

  /// Se déconnecter
  static Future<void> logout() async {
    print('🚪 Déconnexion...');

    // Supprimer uniquement les données d'authentification
    // Garder les favoris et l'historique
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyIdentityToken);
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyName);
    await _storage.delete(key: _keyIsLoggedIn);

    print('✅ Déconnexion terminée');
  }

  /// Supprimer complètement le compte et toutes les données
  static Future<void> deleteAccount() async {
    print('🗑️ Suppression du compte...');

    // Supprimer toutes les données sécurisées
    await _storage.deleteAll();

    // TODO: Supprimer aussi les favoris et l'historique si nécessaire

    print('✅ Compte supprimé');
  }
}

/// Résultat de l'authentification
class AuthResult {
  final bool success;
  final String? userId;
  final String? email;
  final String? name;
  final String? error;
  final bool canceled; // True si l'utilisateur a annulé

  AuthResult({
    required this.success,
    this.userId,
    this.email,
    this.name,
    this.error,
    this.canceled = false,
  });
}

/// Informations utilisateur
class UserInfo {
  final String userId;
  final String? email;
  final String? name;

  UserInfo({required this.userId, this.email, this.name});
}
