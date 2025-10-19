// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'PetScan';

  @override
  String get welcomeBack => 'Bonjour';

  @override
  String forYourPet(String petName) {
    return 'Des produits sains pour $petName 🐾';
  }

  @override
  String get scanProduct => 'Scanner un produit';

  @override
  String get recentProducts => 'Mes derniers produits';

  @override
  String get recommendations => 'Recommandations';

  @override
  String get exploreByCategory => 'Explorer par catégorie';

  @override
  String get dryFood => 'Croquettes';

  @override
  String get wetFood => 'Pâtées';

  @override
  String get treats => 'Friandises';

  @override
  String get supplements => 'Compléments';

  @override
  String get home => 'Accueil';

  @override
  String get search => 'Recherche';

  @override
  String get scanner => 'Scanner';

  @override
  String get favorites => 'Favoris';

  @override
  String get profile => 'Profil';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get addedToFavorites => 'Ajouté à vos favoris';

  @override
  String get removedFromFavorites => 'Retiré de vos favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get globalHealthScore => 'Score Santé Global';

  @override
  String get nutritionalValues => 'Valeurs Nutritionnelles';

  @override
  String get per100g => 'Pour 100g de produit';

  @override
  String get ingredients => 'Ingrédients';

  @override
  String get analysis => 'Analyse';

  @override
  String get description => 'Description';

  @override
  String get information => 'Informations';

  @override
  String get protein => 'Protéines';

  @override
  String get fat => 'Matières grasses';

  @override
  String get fiber => 'Fibres';

  @override
  String get ash => 'Cendres';

  @override
  String get moisture => 'Humidité';

  @override
  String get energy => 'Énergie';

  @override
  String get goodIngredients => 'Bon';

  @override
  String get watchOutIngredients => 'À surveiller';

  @override
  String get positivePoints => 'Points positifs';

  @override
  String get attentionPoints => 'Points d\'attention';

  @override
  String get categories => 'Catégories';

  @override
  String get origin => 'Origine';

  @override
  String get brand => 'Marque';

  @override
  String get scoreExcellent => 'Excellent';

  @override
  String get scoreVeryGood => 'Très bon';

  @override
  String get scoreGood => 'Bon';

  @override
  String get scoreMediocre => 'Moyen';

  @override
  String get scoreFair => 'Passable';

  @override
  String get scorePoor => 'Médiocre';

  @override
  String get scoreAvoid => 'À éviter';

  @override
  String get noFavoritesYet => 'Aucun favori pour le moment';

  @override
  String get noFavoritesDescription =>
      'Scannez ou recherchez des produits pour les ajouter à vos favoris';

  @override
  String get scanAProduct => 'Scanner un produit';

  @override
  String get exploreCategories => 'Explorer les catégories';

  @override
  String get myFavorites => 'Mes Favoris';

  @override
  String favoriteCount(int count) {
    return '$count produit';
  }

  @override
  String favoriteCountPlural(int count) {
    return '$count produits';
  }

  @override
  String get searchPlaceholder => 'Rechercher un produit...';

  @override
  String get searchByName => 'Nom du produit';

  @override
  String get filters => 'Filtres';

  @override
  String get resetFilters => 'Réinitialiser';

  @override
  String get applyFilters => 'Appliquer';

  @override
  String get selectAnimal => 'Sélectionner un animal';

  @override
  String get selectCategory => 'Sélectionner une catégorie';

  @override
  String get selectSubCategory => 'Sélectionner une sous-catégorie';

  @override
  String get dog => 'Chien';

  @override
  String get cat => 'Chat';

  @override
  String get bird => 'Oiseau';

  @override
  String get rabbit => 'Lapin';

  @override
  String get other => 'Autre';

  @override
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String get tryDifferentSearch =>
      'Essayez une autre recherche ou ajustez les filtres';

  @override
  String get scannerTitle => 'Scanner';

  @override
  String get scanInstructions => 'Placez le code-barres dans le cadre';

  @override
  String get scanningProduct => 'Scan en cours...';

  @override
  String get productFound => 'Produit trouvé !';

  @override
  String get myProfile => 'Mon Profil';

  @override
  String get myPet => 'Mon Animal';

  @override
  String get animalInfo => 'Informations de l\'animal';

  @override
  String get foodPreferences => 'Préférences Alimentaires';

  @override
  String get appSettings => 'Paramètres';

  @override
  String get name => 'Nom';

  @override
  String get type => 'Type';

  @override
  String get age => 'Âge';

  @override
  String get weight => 'Poids';

  @override
  String get breed => 'Race';

  @override
  String get neutered => 'Stérilisé';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get signInWithApple => 'Continuer avec Apple';

  @override
  String get continueWithoutAccount => 'Continuer sans compte';

  @override
  String get logout => 'Déconnexion';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get guestMode => 'Mode Invité';

  @override
  String get notConnected => 'Vous n\'êtes pas connecté';

  @override
  String get connectPrompt => 'Connectez-vous pour sauvegarder vos données';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get retry => 'Réessayer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get shareProduct => 'Partager';

  @override
  String get shareFunctionalityComingSoon =>
      '📤 Fonctionnalité de partage à venir';

  @override
  String get pullToRefresh => 'Tirer pour actualiser';

  @override
  String get kcal => 'kcal';

  @override
  String get grams => 'g';

  @override
  String get percent => '%';

  @override
  String get welcome => 'Bienvenue sur PetScan';

  @override
  String get welcomeDescription => 'Analyse pour animaux';

  @override
  String get confirmLogout => 'Confirmer la déconnexion';

  @override
  String get confirmLogoutMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get confirmDeleteAccount => 'Supprimer le compte';

  @override
  String get confirmDeleteAccountMessage =>
      'Cette action est irréversible. Toutes vos données seront supprimées.';

  @override
  String get logoutSuccess => 'Déconnexion réussie';

  @override
  String loginSuccess(String name) {
    return 'Connexion réussie ! Bienvenue $name';
  }

  @override
  String get authError => 'Erreur d\'authentification';

  @override
  String get networkError => 'Erreur réseau';

  @override
  String get unknownError => 'Erreur inconnue';
}
