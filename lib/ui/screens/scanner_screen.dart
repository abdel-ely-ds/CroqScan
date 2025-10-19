import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/openpetfoodfacts_service.dart';
import '../../core/services/scan_history_service.dart';
import 'product_details_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;
  bool _isScreenActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('📷 Scanner initialisé');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    debugPrint('📷 Scanner disposé');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Gérer le cycle de vie de l'app
    switch (state) {
      case AppLifecycleState.resumed:
        // L'app revient au premier plan
        if (_isScreenActive && !_isProcessing) {
          cameraController.start();
          debugPrint('📷 Caméra redémarrée');
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        // L'app passe en arrière-plan
        cameraController.stop();
        debugPrint('📷 Caméra arrêtée (app en arrière-plan)');
        break;
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) async {
    // Ne scanner que si l'écran est actif et qu'on ne traite pas déjà un code
    if (_isProcessing || !_isScreenActive) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first.rawValue;
    if (barcode == null) return;

    setState(() {
      _isProcessing = true;
    });

    // Pause the camera to prevent multiple scans
    await cameraController.stop();

    // Recherche directe sur l'API OpenPetFoodFacts
    debugPrint('🌐 Recherche du code-barres sur l\'API: $barcode');
    final product = await OpenPetFoodFactsService.fetchProductByBarcode(
      barcode,
    );

    if (product != null && mounted) {
      // Ajouter à l'historique
      await ScanHistoryService.addToHistory(
        product.barcode,
        product.name,
        product.brand,
        product.imageUrl,
        product.healthScore,
      );

      // Marquer l'écran comme inactif pour arrêter les scans
      _isScreenActive = false;

      // Product found - navigate to details
      // Camera will be disposed when we leave this screen
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(product: product),
        ),
      );
    } else if (mounted) {
      // Product not found anywhere - show dialog
      await _showProductNotFound(barcode);

      // Restart camera after dialog is dismissed
      if (mounted && _isScreenActive) {
        await cameraController.start();
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _showProductNotFound(String barcode) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.scoreMediocre),
            const SizedBox(width: 12),
            Text(l10n.productNotFound),
          ],
        ),
        content: Text(
          'Le produit avec le code-barres "$barcode" n\'est pas encore dans notre base de données.\n\nNous mettons constamment à jour notre base de données. Réessayez plus tard ou recherchez d\'autres produits.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text(l10n.tryAnother),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home screen
            },
            child: Text(l10n.back),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        // Arrêter la caméra avant de quitter
        _isScreenActive = false;
        await cameraController.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          // Détection du swipe horizontal pour revenir en arrière
          onHorizontalDragEnd: (details) {
            // Si le swipe est vers la droite et assez rapide
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 500) {
              _isScreenActive = false;
              cameraController.stop();
              Navigator.pop(context);
            }
          },
          child: Stack(
            children: [
              // Camera view
              MobileScanner(
                controller: cameraController,
                onDetect: _onBarcodeDetected,
              ),

              // Overlay
              CustomPaint(painter: ScannerOverlay(), child: Container()),

              // Top bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            _isScreenActive = false;
                            cameraController.stop();
                            Navigator.pop(context);
                          },
                          tooltip: 'Retour',
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            cameraController.torchEnabled
                                ? Icons.flash_on
                                : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            cameraController.toggleTorch();
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Instructions
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Positionnez le code-barres dans le cadre',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Le scan se fera automatiquement',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Processing indicator
              if (_isProcessing)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2.5),
        width: size.width * 0.7,
        height: size.height * 0.3,
      ),
      const Radius.circular(20),
    );

    // Dark overlay
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(backgroundRect),
        Path()..addRRect(rrect),
      ),
      paint,
    );

    // Border
    final borderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(rrect, borderPaint);

    // Corner markers
    final cornerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final cornerLength = 30.0;
    final rect = rrect.outerRect;

    // Top-left
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + Offset(0, cornerLength),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      rect.topRight,
      rect.topRight + Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + Offset(0, cornerLength),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + Offset(0, -cornerLength),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + Offset(0, -cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
