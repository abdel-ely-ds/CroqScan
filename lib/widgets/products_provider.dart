import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../constants/app_colors.dart';

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

class ProductsLoader extends StatefulWidget {
  final Widget Function(List<Product> products) builder;

  const ProductsLoader({super.key, required this.builder});

  @override
  State<ProductsLoader> createState() => _ProductsLoaderState();
}

class _ProductsLoaderState extends State<ProductsLoader> {
  List<Product>? _products;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      print('🔄 Chargement des produits...');
      final products = await ProductService.loadProducts();
      print('✅ ${products.length} produits chargés');
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Erreur de chargement: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_error != null) {
      return _buildErrorScreen();
    }

    if (_products == null || _products!.isEmpty) {
      return _buildErrorScreen();
    }

    print(
      '📦 ProductsLoader: Fournit ${_products!.length} produits au provider',
    );

    return ProductsProvider(
      products: _products!,
      child: widget.builder(_products!),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pets, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            const Text(
              'CroqScan',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chargement de la base de données...',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.scorePoor,
              ),
              const SizedBox(height: 24),
              const Text(
                'Erreur de Chargement',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _error ??
                    'Impossible de charger la base de données des produits.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadProducts();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
