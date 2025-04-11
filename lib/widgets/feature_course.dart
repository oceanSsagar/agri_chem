import 'package:agri_chem/models/course.dart';
import 'package:agri_chem/widgets/category_title.dart';
import 'package:flutter/material.dart';

class FeatureCourse extends StatelessWidget {
  final coursesList = Course.generateCourse();

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [CategoryTitle("Top of the Week", "view all"), Container(height: 300, child: ListView.builder(itemBuilder: , itemCoun),)],),);

  }
}
