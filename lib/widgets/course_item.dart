import 'package:agri_chem/models/course_module.dart';
import 'package:agri_chem/themes/my_colors.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  final CourseModule course;
  final VoidCallback onTap;

  const CourseItem({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double progress = course.progress ?? 0.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: kAccent.withOpacity(0.2),
      child: Container(
        height: 250,
        width: 250,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: kPrimaryLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image + Overlay + Badge + Icon
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Hero(
                      tag: 'course-image-${course.id}-${course.title}',
                      child:
                          course.imageUrl != null
                              ? Image.network(
                                course.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        Icon(Icons.broken_image, size: 50),
                              )
                              : Container(
                                color: Colors.grey.shade300,
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                    ),
                  ),

                  // Title Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        course.title ?? 'Untitled',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Category Badge
                  if (course.category != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          course.category!,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),

                  // Content Type Icon
                  if (course.content != null && course.content!.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(
                        _getContentTypeIcon(
                          course.content!.first.contentType,
                        ), // Corrected access
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            // Course Info & Progress
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: kFontLight),
                        SizedBox(width: 5),
                        Text(
                          course.estimateTime ?? 'Unknown duration',
                          style: TextStyle(fontSize: 13, color: kFontLight),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(kAccent),
                      minHeight: 6,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% completed',
                      style: TextStyle(fontSize: 12, color: kFontLight),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Tap to start",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getContentTypeIcon(String? type) {
    switch (type) {
      case 'text':
        return Icons.description;
      case 'image':
        return Icons.image;
      case 'quiz':
        return Icons.quiz;
      case 'video':
        return Icons.play_circle_fill;
      default:
        return Icons.book;
    }
  }
}
