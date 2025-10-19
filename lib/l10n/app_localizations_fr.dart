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
  String get logoutSuccess => 'Déconnexion réussie - Mode invité activé';

  @override
  String get authError => 'Erreur d\'authentification';

  @override
  String get networkError => 'Erreur réseau';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String dailyStreak(int count) {
    return '$count jours';
  }

  @override
  String get premiumFeatureComingSoon => '✨ Fonctionnalité Premium à venir';

  @override
  String get recommendedForYou => 'Recommandé pour vous';

  @override
  String get newProducts => 'Nouveaux produits';

  @override
  String get createProfile => 'Créer un profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get petName => 'Nom de l\'animal';

  @override
  String get petBreed => 'Race';

  @override
  String get petWeight => 'Poids';

  @override
  String get years => 'ans';

  @override
  String get sterilized => 'Stérilisé';

  @override
  String get accountSettings => 'Paramètres du compte';

  @override
  String get about => 'À propos';

  @override
  String get searchHint => 'Rechercher par nom ou marque...';

  @override
  String get scanBarcode => 'Scanner un code-barres';

  @override
  String get ingredientsList => 'Liste des ingrédients';

  @override
  String get swipeToDelete => 'Glisser pour supprimer';

  @override
  String get popularProducts => 'Produits populaires';

  @override
  String get recentScans => 'Scans récents';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get saveProfile => 'Enregistrer le profil';

  @override
  String get profileSaved => 'Profil sauvegardé !';

  @override
  String get profileDeleted => 'Profil supprimé';

  @override
  String get petType => 'Type d\'animal';

  @override
  String get petAge => 'Âge';

  @override
  String get petNeutered => 'Stérilisé';

  @override
  String get petFoodType => 'Type d\'alimentation';

  @override
  String get selectBreed => 'Sélectionner une race';

  @override
  String get selectAge => 'Sélectionner l\'âge';

  @override
  String get selectWeight => 'Sélectionner le poids';

  @override
  String get months => 'mois';

  @override
  String get kg => 'kg';

  @override
  String get notSterilized => 'Non stérilisé';

  @override
  String get mixedFood => 'Mixte';

  @override
  String get appVersion => 'Version de l\'app';

  @override
  String get help => 'Aide';

  @override
  String get terms => 'Conditions d\'utilisation';

  @override
  String get privacy => 'Politique de confidentialité';

  @override
  String get deleteAccountConfirm =>
      'Êtes-vous sûr de vouloir supprimer votre compte ?';

  @override
  String get deleteAccountWarning => 'Cette action est irréversible';

  @override
  String get accountDeleted => 'Compte supprimé';

  @override
  String get notConnectedMessage =>
      'Connectez-vous pour synchroniser vos données';

  @override
  String get connectNow => 'Se connecter maintenant';

  @override
  String get filterByCategory => 'Filtrer par catégorie';

  @override
  String get mainCategory => 'Catégorie principale';

  @override
  String get subCategory => 'Sous-catégorie';

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get loadingProducts => 'Chargement des produits...';

  @override
  String get loadMore => 'Charger plus';

  @override
  String get noMoreProducts => 'Fin des résultats';

  @override
  String get scanInProgress => 'Scan en cours...';

  @override
  String get productScanned => 'Produit scanné';

  @override
  String get scanError => 'Erreur de scan';

  @override
  String get barcodeNotFound => 'Code-barres introuvable';

  @override
  String get pointsPositifs => 'Points positifs';

  @override
  String get pointsAttention => 'Points d\'attention';

  @override
  String get ingredientsAnalysis => 'Analyse des ingrédients';

  @override
  String get categoriesAndOrigin => 'Catégories et origine';

  @override
  String get productOrigin => 'Origine du produit';

  @override
  String get productCategories => 'Catégories';

  @override
  String get similarProducts => 'Produits similaires';

  @override
  String get contributeData => 'Contribuer aux données';

  @override
  String get reportProblem => 'Signaler un problème';

  @override
  String get deleted => 'Supprimé';

  @override
  String get undo => 'Annuler';

  @override
  String get pullToRefreshList => 'Tirer pour actualiser';

  @override
  String get refreshing => 'Actualisation...';

  @override
  String get updated => 'Mis à jour';

  @override
  String get errorLoadingData => 'Erreur lors du chargement';

  @override
  String get errorSavingData => 'Erreur lors de la sauvegarde';

  @override
  String get errorNetworkUnavailable => 'Réseau indisponible';

  @override
  String get errorTimeout => 'Délai d\'attente dépassé';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get close => 'Fermer';

  @override
  String get ok => 'OK';

  @override
  String get required => 'Requis';

  @override
  String get optional => 'Optionnel';

  @override
  String pleaseEnter(String field) {
    return 'Veuillez entrer $field';
  }

  @override
  String get signIn => 'Se connecter';

  @override
  String get continueButton => 'Continuer';

  @override
  String get loginSuccess => 'Connecté avec succès !';

  @override
  String get productNotFound => 'Produit Non Trouvé';

  @override
  String get tryAnother => 'Essayer un Autre';

  @override
  String get back => 'Retour';

  @override
  String get googleSignInComingSoon =>
      'Google Sign-In sera bientôt disponible !';

  @override
  String get selectSearchCriteria =>
      'Sélectionnez au moins un critère de recherche';

  @override
  String get connectionError => 'Erreur de connexion';
}
