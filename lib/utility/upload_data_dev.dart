import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:agri_chem/models/course_module.dart';

Future<void> uploadCourseModulesFromJsonToFirestore() async {
  try {
    // 1. Load local JSON file
    String jsonString = await rootBundle.loadString(
      'assets/data/course_modules.json',
    );

    // 2. Decode JSON to a list
    List<dynamic> jsonData = json.decode(jsonString);

    // 3. Convert to List<CourseModule>
    List<CourseModule> modules =
        jsonData
            .map((e) => CourseModule.fromJson(e as Map<String, dynamic>))
            .toList();

    // 4. Reference to Firestore collection
    CollectionReference coursesRef = FirebaseFirestore.instance.collection(
      'agri_courses',
    );

    // 5. Upload each module
    for (var module in modules) {
      await coursesRef.doc(module.id).set(module.toJson());
    }

    print("✅ Course modules uploaded successfully.");
  } catch (e) {
    print("❌ Failed to upload course modules: $e");
  }
}

Future<void> uploadChemicalsToFirestore() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/chemicals.json',
  );
  final List<dynamic> chemicalList = json.decode(jsonString);

  final CollectionReference chemicalsRef = FirebaseFirestore.instance
      .collection('agri_chemicals');

  for (var chemical in chemicalList) {
    await chemicalsRef.add({
      'name_lower': chemical['name'].toLowerCase(),
      'name': chemical['name'],
      'usageGuidelines': chemical['usageGuidelines'],
      'safetyRating': chemical['safetyRating'],
      'soilImpact': chemical['soilImpact'],
      'compatibleCrops': List<String>.from(chemical['compatibleCrops']),
      'status': chemical['status'],
    });
  }

  print('Chemicals uploaded successfully!');
}
