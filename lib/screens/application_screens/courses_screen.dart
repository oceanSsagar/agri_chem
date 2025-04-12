import 'package:agri_chem/widgets/course_card.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final List<Map<String, String>> modules = [
    {
      "title": "Introduction to Agrochemicals",
      "description":
          "Learn the basics of agrochemicals and their applications.",
    },
    {
      "title": "Pesticides and Their Uses",
      "description": "Understand the types of pesticides and how they work.",
    },
    {
      "title": "Fertilizers and Soil Health",
      "description":
          "Explore the role of fertilizers in improving soil health.",
    },
    {
      "title": "Organic Farming Techniques",
      "description": "Discover sustainable and organic farming practices.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return CourseCard();
        },
      ),
    );
  }
}
