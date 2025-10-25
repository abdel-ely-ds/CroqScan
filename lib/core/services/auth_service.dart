import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for managing authentication (Apple Sign-In and Google Sign-In)
/// 
/// Handles user authentication using Apple ID and Google Sign-In, stores
/// credentials securely using [FlutterSecureStorage].
/// 
/// Features:
/// - Sign in with Apple ID
/// - Sign in with Google
/// - Secure token storage
/// - Session management
/// - User info retrieval
class AuthService {
  static const _storage = FlutterSecureStorage();
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Clés de stockage
  static const String _keyUserId = 'user_id';
  static const String _keyUserType = 'user_type'; // 'apple' or 'google'
  static const String _keyIdentityToken = 'identity_token';
  static const String _keyEmail = 'user_email';
  static const String _keyName = 'user_name';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Signs in user with Apple ID
  /// 
  /// Requests email and full name scopes from Apple.
  /// Stores user credentials securely in device storage.
  /// 
  /// Returns [AuthResult] with:
  /// - `success`: true if authentication succeeded
  /// - `userId`: Apple user identifier
  /// - `email`: User email (if provided)
  /// - `name`: User full name (if provided)
  /// - `errorMessage`: Error description if failed
  /// 
  /// Throws [SignInWithAppleAuthorizationException] if user cancels.
  static Future<AuthResult> signInWithApple() async {
    try {
      debugPrint('🍏 Démarrage Sign in with Apple...');

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      debugPrint('✅ Authentification Apple réussie');
      debugPrint('   User ID: ${credential.userIdentifier}');
      debugPrint('   Email: ${credential.email ?? "Non fourni"}');

      // Sauvegarder les données localement de manière sécurisée
      await _storage.write(key: _keyUserId, value: credential.userIdentifier);
      await _storage.write(key: _keyUserType, value: 'apple');

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

      debugPrint('💾 Données sauvegardées localement');

      return AuthResult(
        success: true,
        userId: credential.userIdentifier,
        email: credential.email,
        name: await _storage.read(key: _keyName),
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      // Gérer les erreurs spécifiques Apple
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('ℹ️ Connexion annulée par l\'utilisateur');
        return AuthResult(success: false, canceled: true);
      } else if (e.code == AuthorizationErrorCode.unknown) {
        // Erreur 1000 - Généralement annulation ou problème config
        debugPrint('ℹ️ Connexion annulée ou problème de configuration');
        return AuthResult(success: false, canceled: true);
      } else {
        debugPrint('❌ Erreur Sign in with Apple: ${e.code} - ${e.message}');
        return AuthResult(
          success: false,
          error: 'Erreur d\'authentification Apple',
        );
      }
    } catch (e) {
      debugPrint('❌ Erreur inattendue: $e');
      return AuthResult(success: false, error: 'Erreur de connexion');
    }
  }

  /// Signs in user with Google
  /// 
  /// Requests email and profile scopes from Google.
  /// Stores user credentials securely in device storage.
  /// 
  /// Returns [AuthResult] with:
  /// - `success`: true if authentication succeeded
  /// - `userId`: Google user identifier
  /// - `email`: User email
  /// - `name`: User full name
  /// - `errorMessage`: Error description if failed
  /// 
  /// Throws [GoogleSignInException] if user cancels or error occurs.
  static Future<AuthResult> signInWithGoogle() async {
    try {
      debugPrint('🔍 Démarrage Sign in with Google...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint('ℹ️ Connexion Google annulée par l\'utilisateur');
        return AuthResult(success: false, canceled: true);
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      debugPrint('✅ Authentification Google réussie');
      debugPrint('   User ID: ${googleUser.id}');
      debugPrint('   Email: ${googleUser.email}');
      debugPrint('   Name: ${googleUser.displayName}');

      // Sauvegarder les données localement de manière sécurisée
      await _storage.write(key: _keyUserId, value: googleUser.id);
      await _storage.write(key: _keyUserType, value: 'google');

      if (googleAuth.accessToken != null) {
        await _storage.write(
          key: _keyIdentityToken,
          value: googleAuth.accessToken,
        );
      }

      if (googleUser.email != null) {
        await _storage.write(key: _keyEmail, value: googleUser.email);
      }

      if (googleUser.displayName != null) {
        await _storage.write(key: _keyName, value: googleUser.displayName);
      }

      await _storage.write(key: _keyIsLoggedIn, value: 'true');

      debugPrint('💾 Données sauvegardées localement');

      return AuthResult(
        success: true,
        userId: googleUser.id,
        email: googleUser.email,
        name: googleUser.displayName,
      );
    } catch (e) {
      debugPrint('❌ Erreur Sign in with Google: $e');
      return AuthResult(success: false, error: 'Erreur de connexion Google');
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
      userType: await _storage.read(key: _keyUserType),
    );
  }

  /// Se déconnecter
  static Future<void> logout() async {
    debugPrint('🚪 Déconnexion...');

    // Déconnexion Google si nécessaire
    final userType = await _storage.read(key: _keyUserType);
    if (userType == 'google') {
      await _googleSignIn.signOut();
    }

    // Supprimer uniquement les données d'authentification
    // Garder les favoris et l'historique
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserType);
    await _storage.delete(key: _keyIdentityToken);
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyName);
    await _storage.delete(key: _keyIsLoggedIn);

    debugPrint('✅ Déconnexion terminée');
  }

  /// Supprimer complètement le compte et toutes les données
  static Future<void> deleteAccount() async {
    debugPrint('🗑️ Suppression du compte...');

    // Supprimer toutes les données sécurisées
    await _storage.deleteAll();

    // TODO: Supprimer aussi les favoris et l'historique si nécessaire

    debugPrint('✅ Compte supprimé');
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
  final String? userType; // 'apple' or 'google'

  UserInfo({required this.userId, this.email, this.name, this.userType});
}
