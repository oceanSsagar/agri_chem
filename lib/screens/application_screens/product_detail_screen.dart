import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productData['name'] ?? 'Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (productData['imageUrl'] != null)
                Image.network(productData['imageUrl']),
              const SizedBox(height: 20),
              Text("Usage", style: Theme.of(context).textTheme.titleLarge),
              if (productData['UsageHtml'] != null)
                Html(data: productData['UsageHtml']),
              const SizedBox(height: 16),
              Text("Handling", style: Theme.of(context).textTheme.titleLarge),
              if (productData['HandlingHtml'] != null)
                Html(data: productData['HandlingHtml']),
            ],
          ),
        ),
      ),
    );
  }
}
