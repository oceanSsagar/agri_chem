import 'package:agri_chem/providers/navigation_provider.dart';
import 'package:agri_chem/screens/application_screens/account_screen.dart';
import 'package:agri_chem/screens/application_screens/qr_scan_screen.dart';
import 'package:agri_chem/utility/feature_tile_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Smart Agri-Chem Tools",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              FeatureTileGrid(
                onFeatureSelected: (feature) {
                  switch (feature) {
                    case 'chemicals':
                      navProvider.setIndex(1);
                      break;
                    case 'courses':
                      navProvider.setIndex(2);
                      break;
                    case 'chatbot':
                      navProvider.setIndex(3);
                      break;
                    case 'scanner':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QrScanScreen()),
                      );
                      break;
                    case 'profile':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AccountScreen()),
                      );
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
