import 'package:agri_chem/utility/feature_tile_grid.dart';
import 'package:agri_chem/widgets/active_course.dart';
import 'package:agri_chem/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FeatureTileGrid(
            onFeatureSelected: (feature) {
              switch (feature) {
                case 'courses':
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => CoursesScreen()));
                  break;
                case 'chatbot':
                  // ...
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
