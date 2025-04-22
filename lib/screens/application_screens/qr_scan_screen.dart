import 'package:agri_chem/screens/application_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _hasNavigated = false;

  void _onBarcodeDetected(BarcodeCapture capture) async {
    if (_hasNavigated) return;

    final barcode = capture.barcodes.first;
    final code = barcode.rawValue;
    if (code == null) return;

    setState(() => _hasNavigated = true);
    controller.stop();

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('agri_products')
              .doc(code)
              .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && context.mounted) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productData: data),
            ),
          );
        }
      } else {
        _showSnackBar("No product found for barcode: $code");
      }
    } catch (e) {
      _showSnackBar("Error fetching product info.");
    }

    if (mounted) {
      setState(() => _hasNavigated = false);
      controller.start();
    }
  }

  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Product")),
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _onBarcodeDetected),
          // Optional: Custom transparent overlay for alignment
        ],
      ),
    );
  }
}
