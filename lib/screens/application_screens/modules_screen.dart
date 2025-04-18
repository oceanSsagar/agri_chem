import 'package:agri_chem/models/course_module.dart';
import 'package:agri_chem/screens/application_screens/course_module_details_screen.dart';
import 'package:agri_chem/utility/firebase_service.dart';
import 'package:agri_chem/widgets/course_item.dart';
import 'package:flutter/material.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  List<CourseModule> courseModules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourseModules();
  }

  // Load course modules from Firestore
  Future<void> _loadCourseModules() async {
    FirebaseService firebaseService = FirebaseService();
    List<CourseModule> modules = await firebaseService.fetchCourseModules();

    if (!mounted) return;
    setState(() {
      courseModules = modules;
      isLoading = false;
    });
  }

  // Refresh function to reload course modules
  Future<void> _refreshModules() async {
    setState(() {
      isLoading = true;
    });
    await _loadCourseModules(); // This will now work because _loadCourseModules returns Future<void>
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshModules, // onRefresh expects a Future<void>
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: courseModules.length,
                  itemBuilder: (context, index) {
                    final module = courseModules[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CourseItem(
                        course: module,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      CourseModuleDetailsScreen(course: module),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
