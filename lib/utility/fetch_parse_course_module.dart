import 'dart:convert'; // For json.decode() if you are working with JSON strings
import 'package:agri_chem/models/course_module.dart';

List<CourseModule> parseCourseModules(String jsonData) {
  final List<dynamic> parsedData = json.decode(
    jsonData,
  ); // Decode the JSON string into a List

  return parsedData.map((jsonModule) {
    // Convert each module's JSON data into a CourseModule object
    return CourseModule.fromJson(jsonModule as Map<String, dynamic>);
  }).toList(); // Return as a List of CourseModule objects
}

Future<List<CourseModule>> fetchCourseModules() async {
  // Example raw JSON data (normally fetched from Firestore or an API)
  String jsonData = '''[
      {
        "id": "module1",
        "title": "Introduction to Agrochemicals",
        "description": "This is an introductory module to agrochemicals.",
        "imageUrl": "https://example.com/image1.jpg",
        "estimateTime": "30 minutes",
        "category": "Chemicals",
        "content": [
          {
            "id": "content1",
            "title": "What is Agrochemicals?",
            "type": "Lesson",
            "contentType": "text",
            "content": "Agrochemicals are substances used in agriculture to control pests, weeds, and diseases."
          }
        ]
      }
    ]''';

  // Call the parseCourseModules function to convert JSON into objects
  return parseCourseModules(jsonData);
}
