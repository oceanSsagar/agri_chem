import 'package:agri_chem/models/course_module.dart';
import 'package:agri_chem/themes/my_colors.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  final CourseModule course;
  final VoidCallback onTap;

  const CourseItem({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Image
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child:
                        course.imageUrl != null
                            ? Image.network(
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.broken_image),
                              course.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
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
                // Title & Info
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          course.title ?? 'Untitled',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kFont,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          course.estimateTime ?? 'Unknown duration',
                          style: TextStyle(fontSize: 14, color: kFontLight),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Start Button
          Positioned(
            bottom: 60,
            right: 15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: onTap,
              child: Text("Start", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
