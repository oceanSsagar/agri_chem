import 'package:agri_chem/widgets/category_title.dart';
import 'package:agri_chem/widgets/course_progress.dart';
import 'package:flutter/material.dart';

class ActiveCourse extends StatelessWidget {
  const ActiveCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CategoryTitle("Currently active", "view all"),
          CourseProgress(),
        ],
      ),
    );
  }
}
