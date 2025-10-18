import 'package:flutter/material.dart';
import '../models/product.dart';

/// Provider simple qui fournit une liste vide de produits
/// L'application utilise uniquement l'API OpenPetFoodFacts pour la recherche
class ProductsProvider extends InheritedWidget {
  final List<Product> products;

  const ProductsProvider({
    super.key,
    required this.products,
    required super.child,
  });

  static ProductsProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProductsProvider>();
  }

  @override
  bool updateShouldNotify(ProductsProvider oldWidget) {
    return products != oldWidget.products;
  }
}

/// Loader simplifié - pas de base de données locale
/// L'app utilise uniquement l'API OpenPetFoodFacts
class ProductsLoader extends StatelessWidget {
  final Widget Function(List<Product> products) builder;

  const ProductsLoader({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    print('🌐 Mode API uniquement - Pas de base de données locale');

    return ProductsProvider(
      products: const [], // Liste vide - données chargées via API uniquement
      child: builder(const []),
    );
  }
}
