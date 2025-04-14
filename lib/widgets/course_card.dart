import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseCard extends StatelessWidget {
  final Stream<QuerySnapshot> courseStream;

  const CourseCard({Key? key, required this.courseStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: courseStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No courses available.'));
        }

        final courses = snapshot.data!.docs;

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            final courseData = course.data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(courseData['title'] ?? 'No Title'),
                subtitle: Text(courseData['description'] ?? 'No Description'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Handle course tap
                },
              ),
            );
          },
        );
      },
    );
  }
}
