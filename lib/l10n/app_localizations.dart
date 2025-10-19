import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Titre de l'application
  ///
  /// In fr, this message translates to:
  /// **'PetScan'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour'**
  String get welcomeBack;

  /// Message d'accueil personnalisé
  ///
  /// In fr, this message translates to:
  /// **'Des produits sains pour {petName} 🐾'**
  String forYourPet(String petName);

  /// No description provided for @scanProduct.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un produit'**
  String get scanProduct;

  /// No description provided for @recentProducts.
  ///
  /// In fr, this message translates to:
  /// **'Mes derniers produits'**
  String get recentProducts;

  /// No description provided for @recommendations.
  ///
  /// In fr, this message translates to:
  /// **'Recommandations'**
  String get recommendations;

  /// No description provided for @exploreByCategory.
  ///
  /// In fr, this message translates to:
  /// **'Explorer par catégorie'**
  String get exploreByCategory;

  /// No description provided for @dryFood.
  ///
  /// In fr, this message translates to:
  /// **'Croquettes'**
  String get dryFood;

  /// No description provided for @wetFood.
  ///
  /// In fr, this message translates to:
  /// **'Pâtées'**
  String get wetFood;

  /// No description provided for @treats.
  ///
  /// In fr, this message translates to:
  /// **'Friandises'**
  String get treats;

  /// No description provided for @supplements.
  ///
  /// In fr, this message translates to:
  /// **'Compléments'**
  String get supplements;

  /// No description provided for @home.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get home;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get search;

  /// No description provided for @scanner.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
  String get scanner;

  /// No description provided for @favorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get favorites;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @addToFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get addToFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté à vos favoris'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Retiré de vos favoris'**
  String get removedFromFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get removeFromFavorites;

  /// No description provided for @globalHealthScore.
  ///
  /// In fr, this message translates to:
  /// **'Score Santé Global'**
  String get globalHealthScore;

  /// No description provided for @nutritionalValues.
  ///
  /// In fr, this message translates to:
  /// **'Valeurs Nutritionnelles'**
  String get nutritionalValues;

  /// No description provided for @per100g.
  ///
  /// In fr, this message translates to:
  /// **'Pour 100g de produit'**
  String get per100g;

  /// No description provided for @ingredients.
  ///
  /// In fr, this message translates to:
  /// **'Ingrédients'**
  String get ingredients;

  /// No description provided for @analysis.
  ///
  /// In fr, this message translates to:
  /// **'Analyse'**
  String get analysis;

  /// No description provided for @description.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @information.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get information;

  /// No description provided for @protein.
  ///
  /// In fr, this message translates to:
  /// **'Protéines'**
  String get protein;

  /// No description provided for @fat.
  ///
  /// In fr, this message translates to:
  /// **'Matières grasses'**
  String get fat;

  /// No description provided for @fiber.
  ///
  /// In fr, this message translates to:
  /// **'Fibres'**
  String get fiber;

  /// No description provided for @ash.
  ///
  /// In fr, this message translates to:
  /// **'Cendres'**
  String get ash;

  /// No description provided for @moisture.
  ///
  /// In fr, this message translates to:
  /// **'Humidité'**
  String get moisture;

  /// No description provided for @energy.
  ///
  /// In fr, this message translates to:
  /// **'Énergie'**
  String get energy;

  /// No description provided for @goodIngredients.
  ///
  /// In fr, this message translates to:
  /// **'Bon'**
  String get goodIngredients;

  /// No description provided for @watchOutIngredients.
  ///
  /// In fr, this message translates to:
  /// **'À surveiller'**
  String get watchOutIngredients;

  /// No description provided for @positivePoints.
  ///
  /// In fr, this message translates to:
  /// **'Points positifs'**
  String get positivePoints;

  /// No description provided for @attentionPoints.
  ///
  /// In fr, this message translates to:
  /// **'Points d\'attention'**
  String get attentionPoints;

  /// No description provided for @categories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categories;

  /// No description provided for @origin.
  ///
  /// In fr, this message translates to:
  /// **'Origine'**
  String get origin;

  /// No description provided for @brand.
  ///
  /// In fr, this message translates to:
  /// **'Marque'**
  String get brand;

  /// No description provided for @scoreExcellent.
  ///
  /// In fr, this message translates to:
  /// **'Excellent'**
  String get scoreExcellent;

  /// No description provided for @scoreVeryGood.
  ///
  /// In fr, this message translates to:
  /// **'Très bon'**
  String get scoreVeryGood;

  /// No description provided for @scoreGood.
  ///
  /// In fr, this message translates to:
  /// **'Bon'**
  String get scoreGood;

  /// No description provided for @scoreMediocre.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get scoreMediocre;

  /// No description provided for @scoreFair.
  ///
  /// In fr, this message translates to:
  /// **'Passable'**
  String get scoreFair;

  /// No description provided for @scorePoor.
  ///
  /// In fr, this message translates to:
  /// **'Médiocre'**
  String get scorePoor;

  /// No description provided for @scoreAvoid.
  ///
  /// In fr, this message translates to:
  /// **'À éviter'**
  String get scoreAvoid;

  /// No description provided for @noFavoritesYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori pour le moment'**
  String get noFavoritesYet;

  /// No description provided for @noFavoritesDescription.
  ///
  /// In fr, this message translates to:
  /// **'Scannez ou recherchez des produits pour les ajouter à vos favoris'**
  String get noFavoritesDescription;

  /// No description provided for @scanAProduct.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un produit'**
  String get scanAProduct;

  /// No description provided for @exploreCategories.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les catégories'**
  String get exploreCategories;

  /// No description provided for @myFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Mes Favoris'**
  String get myFavorites;

  /// Nombre de favoris
  ///
  /// In fr, this message translates to:
  /// **'{count} produit'**
  String favoriteCount(int count);

  /// Nombre de favoris (pluriel)
  ///
  /// In fr, this message translates to:
  /// **'{count} produits'**
  String favoriteCountPlural(int count);

  /// No description provided for @searchPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un produit...'**
  String get searchPlaceholder;

  /// No description provided for @searchByName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du produit'**
  String get searchByName;

  /// No description provided for @filters.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filters;

  /// No description provided for @resetFilters.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resetFilters;

  /// No description provided for @applyFilters.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get applyFilters;

  /// No description provided for @selectAnimal.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un animal'**
  String get selectAnimal;

  /// No description provided for @selectCategory.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une catégorie'**
  String get selectCategory;

  /// No description provided for @selectSubCategory.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une sous-catégorie'**
  String get selectSubCategory;

  /// No description provided for @dog.
  ///
  /// In fr, this message translates to:
  /// **'Chien'**
  String get dog;

  /// No description provided for @cat.
  ///
  /// In fr, this message translates to:
  /// **'Chat'**
  String get cat;

  /// No description provided for @bird.
  ///
  /// In fr, this message translates to:
  /// **'Oiseau'**
  String get bird;

  /// No description provided for @rabbit.
  ///
  /// In fr, this message translates to:
  /// **'Lapin'**
  String get rabbit;

  /// No description provided for @other.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get other;

  /// No description provided for @noResultsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat trouvé'**
  String get noResultsFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In fr, this message translates to:
  /// **'Essayez une autre recherche ou ajustez les filtres'**
  String get tryDifferentSearch;

  /// No description provided for @scannerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
  String get scannerTitle;

  /// No description provided for @scanInstructions.
  ///
  /// In fr, this message translates to:
  /// **'Placez le code-barres dans le cadre'**
  String get scanInstructions;

  /// No description provided for @scanningProduct.
  ///
  /// In fr, this message translates to:
  /// **'Scan en cours...'**
  String get scanningProduct;

  /// No description provided for @productFound.
  ///
  /// In fr, this message translates to:
  /// **'Produit trouvé !'**
  String get productFound;

  /// No description provided for @myProfile.
  ///
  /// In fr, this message translates to:
  /// **'Mon Profil'**
  String get myProfile;

  /// No description provided for @myPet.
  ///
  /// In fr, this message translates to:
  /// **'Mon Animal'**
  String get myPet;

  /// No description provided for @animalInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations de l\'animal'**
  String get animalInfo;

  /// No description provided for @foodPreferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences Alimentaires'**
  String get foodPreferences;

  /// No description provided for @appSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get appSettings;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @type.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @age.
  ///
  /// In fr, this message translates to:
  /// **'Âge'**
  String get age;

  /// No description provided for @weight.
  ///
  /// In fr, this message translates to:
  /// **'Poids'**
  String get weight;

  /// No description provided for @breed.
  ///
  /// In fr, this message translates to:
  /// **'Race'**
  String get breed;

  /// No description provided for @neutered.
  ///
  /// In fr, this message translates to:
  /// **'Stérilisé'**
  String get neutered;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @signInWithApple.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Apple'**
  String get signInWithApple;

  /// No description provided for @continueWithoutAccount.
  ///
  /// In fr, this message translates to:
  /// **'Continuer sans compte'**
  String get continueWithoutAccount;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte'**
  String get deleteAccount;

  /// No description provided for @guestMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode Invité'**
  String get guestMode;

  /// No description provided for @notConnected.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'êtes pas connecté'**
  String get notConnected;

  /// No description provided for @connectPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour sauvegarder vos données'**
  String get connectPrompt;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get refresh;

  /// No description provided for @shareProduct.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get shareProduct;

  /// No description provided for @shareFunctionalityComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'📤 Fonctionnalité de partage à venir'**
  String get shareFunctionalityComingSoon;

  /// No description provided for @pullToRefresh.
  ///
  /// In fr, this message translates to:
  /// **'Tirer pour actualiser'**
  String get pullToRefresh;

  /// No description provided for @kcal.
  ///
  /// In fr, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @grams.
  ///
  /// In fr, this message translates to:
  /// **'g'**
  String get grams;

  /// No description provided for @percent.
  ///
  /// In fr, this message translates to:
  /// **'%'**
  String get percent;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur PetScan'**
  String get welcome;

  /// No description provided for @welcomeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Analyse pour animaux'**
  String get welcomeDescription;

  /// No description provided for @confirmLogout.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la déconnexion'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ?'**
  String get confirmLogoutMessage;

  /// No description provided for @confirmDeleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte'**
  String get confirmDeleteAccount;

  /// No description provided for @confirmDeleteAccountMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Toutes vos données seront supprimées.'**
  String get confirmDeleteAccountMessage;

  /// No description provided for @logoutSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion réussie'**
  String get logoutSuccess;

  /// Message de succès de connexion
  ///
  /// In fr, this message translates to:
  /// **'Connexion réussie ! Bienvenue {name}'**
  String loginSuccess(String name);

  /// No description provided for @authError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur d\'authentification'**
  String get authError;

  /// No description provided for @networkError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur réseau'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inconnue'**
  String get unknownError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
