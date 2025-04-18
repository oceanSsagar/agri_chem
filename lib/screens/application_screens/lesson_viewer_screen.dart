import 'package:flutter/material.dart';
import 'package:agri_chem/models/course_content_item.dart';

class LessonViewerScreen extends StatelessWidget {
  final CourseContentItem item;

  const LessonViewerScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;

    // Check the content type and display corresponding widget
    switch (item.contentType) {
      case 'text':
        contentWidget = Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(
              item.content ?? 'No content available',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        );
        break;
      case 'image':
        contentWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Image.network(
              item.content ?? '',
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 100, color: Colors.grey);
              },
              fit: BoxFit.cover,
            ),
          ),
        );
        break;
      case 'quiz':
        contentWidget = Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Quiz Viewer coming soon!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
        );
        break;
      default:
        contentWidget = Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Unknown content type',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title ?? 'Untitled'),
        backgroundColor: Colors.green, // Add a brand color to AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: contentWidget,
        ),
      ),
    );
  }
}
