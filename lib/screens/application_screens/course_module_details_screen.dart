import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_chem/models/course_module.dart';
import 'package:agri_chem/screens/application_screens/lesson_viewer_screen.dart';

class CourseModuleDetailsScreen extends StatefulWidget {
  final CourseModule course;

  const CourseModuleDetailsScreen({super.key, required this.course});

  @override
  _CourseModuleDetailsScreenState createState() =>
      _CourseModuleDetailsScreenState();
}

class _CourseModuleDetailsScreenState extends State<CourseModuleDetailsScreen> {
  late CourseModule course;
  List<String> completedContentIds = [];

  @override
  void initState() {
    super.initState();
    course = widget.course;
    _loadCompletedProgress();
  }

  Future<void> _loadCompletedProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || course.id == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('agri_users')
            .doc(user.uid)
            .collection('progress')
            .doc(course.id)
            .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        completedContentIds = List<String>.from(
          data['completedContentIds'] ?? [],
        );
      });
    }
  }

  double _getCourseProgress() {
    if (course.content == null || course.content!.isEmpty) return 0.0;
    int completedCount =
        course.content!
            .where((item) => completedContentIds.contains(item.id))
            .length;
    return completedCount / course.content!.length;
  }

  Future<void> toggleContentCompletion(String contentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || course.id == null) return;

    // Optimistically update the UI first
    List<String> updatedCompleted = List.from(completedContentIds);

    if (updatedCompleted.contains(contentId)) {
      updatedCompleted.remove(contentId);
    } else {
      updatedCompleted.add(contentId);
    }

    // Update the local state to reflect the change immediately
    setState(() {
      completedContentIds = updatedCompleted;
    });

    // Perform Firestore update in the background
    final docRef = FirebaseFirestore.instance
        .collection('agri_users')
        .doc(user.uid)
        .collection('progress')
        .doc(course.id);

    await docRef.set({
      'completedContentIds': updatedCompleted,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getCourseProgress();

    return Scaffold(
      appBar: AppBar(title: Text(course.title ?? 'Course Details')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% Completed',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadCompletedProgress,
              child: ListView.builder(
                itemCount: course.content?.length ?? 0,
                itemBuilder: (context, index) {
                  final contentItem = course.content![index];
                  final isCompleted = completedContentIds.contains(
                    contentItem.id,
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isCompleted ? Colors.green : Colors.grey,
                        size: 32, // Increased icon size for better visibility
                      ),
                      title: Text(contentItem.title ?? 'Untitled'),
                      subtitle: Text(
                        contentItem.description ?? 'No description',
                      ),
                      onTap: () async {
                        // Navigate to the content screen and wait until user returns
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => LessonViewerScreen(item: contentItem),
                          ),
                        );

                        // After returning, mark it as completed in the background
                        if (!completedContentIds.contains(contentItem.id)) {
                          toggleContentCompletion(contentItem.id!);
                        }
                      },

                      trailing: IconButton(
                        icon: Icon(
                          isCompleted ? Icons.close : Icons.done,
                          color: isCompleted ? Colors.red : Colors.blueAccent,
                        ),
                        tooltip:
                            isCompleted
                                ? 'Mark as not completed'
                                : 'Mark as completed',
                        onPressed: () async {
                          await toggleContentCompletion(contentItem.id!);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
