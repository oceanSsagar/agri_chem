import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> markContentAsCompleted(String courseId, String contentId) async {
  try {
    // Get the course document reference from Firestore
    DocumentReference courseRef = FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId);

    // Get the current course document
    DocumentSnapshot courseSnapshot = await courseRef.get();
    if (courseSnapshot.exists) {
      // Get the course content list from Firestore
      var courseData = courseSnapshot.data() as Map<String, dynamic>;
      var contentList = courseData['content'] as List<dynamic>;

      // Find the content item with the given contentId
      var contentIndex = contentList.indexWhere(
        (item) => item['id'] == contentId,
      );
      if (contentIndex != -1) {
        // Mark the content as completed by updating the isCompleted field
        contentList[contentIndex]['isCompleted'] = true;

        // Update the course content in Firestore
        await courseRef.update({'content': contentList});
        print("Content item marked as completed");
      }
    }
  } catch (e) {
    print("Error updating content completion: $e");
  }
}
