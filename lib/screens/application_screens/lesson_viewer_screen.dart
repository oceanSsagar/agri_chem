import 'package:flutter/material.dart';
import 'package:agri_chem/models/course_content_item.dart';

class LessonViewerScreen extends StatelessWidget {
  final CourseContentItem item;

  const LessonViewerScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;

    switch (item.contentType) {
      case 'text':
        contentWidget = Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(item.content ?? ''),
        );
        break;
      case 'image':
        contentWidget = Image.network(
          item.content ?? '',
          errorBuilder:
              (context, error, stackTrace) => Icon(Icons.broken_image),
        );
        break;
      case 'quiz':
        contentWidget = Text('Quiz Viewer coming soon!'); // placeholder
        break;
      default:
        contentWidget = Text('Unknown content type');
    }

    return Scaffold(
      appBar: AppBar(title: Text(item.title ?? 'Untitled')),
      body: contentWidget,
    );
  }
}
