import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_chem/models/course_module.dart';
import 'package:agri_chem/screens/application_screens/lesson_viewer_screen.dart';
import 'package:hive_flutter/adapters.dart';

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
      body: RefreshIndicator(
        onRefresh: _loadCompletedProgress,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: CachedNetworkImage(
                    imageUrl: course.imageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) => const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Container(
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
            ),
            ...List.generate(course.content?.length ?? 0, (index) {
              final contentItem = course.content![index];
              final isCompleted = completedContentIds.contains(contentItem.id);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isCompleted ? Colors.green : Colors.grey,
                    size: 32,
                  ),
                  title: Text(contentItem.title ?? 'Untitled'),
                  subtitle: Text(contentItem.description ?? 'No description'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonViewerScreen(item: contentItem),
                      ),
                    );
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
            }),
          ],
        ),
      ),
    );
  }
}
