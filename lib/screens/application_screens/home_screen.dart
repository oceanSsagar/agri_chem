import 'package:agri_chem/models/course.dart';
import 'package:agri_chem/widgets/active_course.dart';
import 'package:agri_chem/widgets/category_title.dart';
import 'package:agri_chem/widgets/course_item.dart';
import 'package:agri_chem/widgets/feature_course.dart';
import 'package:agri_chem/widgets/search_input.dart';
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
          SearchInput(),
          SizedBox(height: 10),
          FeatureCourse(),
          ActiveCourse(),
        ],
      ),
    );
  }
}
