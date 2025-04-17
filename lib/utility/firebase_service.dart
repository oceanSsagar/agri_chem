import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_chem/models/course_module.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload course modules to Firestore
  Future<void> uploadCourseModules(List<CourseModule> modules) async {
    try {
      // Reference to the 'agri_courses' collection in Firestore
      CollectionReference courses = _firestore.collection('agri_courses');

      // Iterate over the modules and add or update each one to Firestore
      for (var module in modules) {
        // Use doc(module.id) to ensure the module is saved with a specific ID
        await courses.doc(module.id).set(module.toJson());
      }
    } catch (e) {
      print('Error uploading course modules: $e');
    }
  }

  // Save a single course module to Firestore
  Future<void> saveCourseModule(CourseModule module) async {
    try {
      // Reference to the 'agri_courses' collection
      CollectionReference courses = _firestore.collection('agri_courses');

      // Use doc(module.id) to add/update a module with a specific ID
      await courses.doc(module.id).set(module.toJson());
    } catch (e) {
      print('Error saving course module: $e');
    }
  }

  // Fetch course modules from Firestore
  Future<List<CourseModule>> fetchCourseModules() async {
    try {
      // Fetch the 'agri_courses' collection
      QuerySnapshot snapshot =
          await _firestore.collection('agri_courses').get();

      // Map the documents to CourseModule objects
      List<CourseModule> courseModules =
          snapshot.docs
              .map(
                (doc) =>
                    CourseModule.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      return courseModules;
    } catch (e) {
      print('Error fetching course modules: $e');
      return [];
    }
  }
}
