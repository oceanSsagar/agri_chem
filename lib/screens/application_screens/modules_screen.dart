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
  void _loadCourseModules() async {
    FirebaseService firebaseService = FirebaseService();
    List<CourseModule> modules = await firebaseService.fetchCourseModules();

    if (!mounted) return;
    setState(() {
      courseModules = modules;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
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
                                    CourseModuleDetailsScreen(module: module),
                          ),
                        );
                      },
                      // ListTile(
                      //   title: Text(module.title ?? 'Untitled'),
                      //   subtitle: Text(module.description ?? 'No description'),
                      //   trailing: Icon(Icons.arrow_forward_ios),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder:
                      //             (_) =>
                      //                 CourseModuleDetailsScreen(module: module),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ),
                  );
                },
              ),
    );
  }
}
