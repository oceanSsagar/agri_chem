import 'package:agri_chem/models/course_content_item.dart';
import 'package:agri_chem/screens/application_screens/lesson_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:agri_chem/models/course_module.dart';

class CourseModuleDetailsScreen extends StatelessWidget {
  final CourseModule module;
  const CourseModuleDetailsScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final contentItems =
        module.content ?? []; // Get the content items from the module

    return Scaffold(
      appBar: AppBar(title: Text(module.title ?? 'Module')),
      body: ListView.builder(
        itemCount: contentItems.length,
        itemBuilder: (context, index) {
          final item = contentItems[index];
          return ListTile(
            title: Text(item.title ?? "Untitled"),
            subtitle: Text(item.contentType ?? "Unknown"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonViewerScreen(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
