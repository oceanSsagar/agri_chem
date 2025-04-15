import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

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
