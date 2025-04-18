import 'dart:convert'; // For json.decode()

// Model for Course Content Item
class CourseContentItem {
  final String? id;
  final String? title;
  final String? contentType;
  final String? content;
  bool isCompleted;

  CourseContentItem({
    this.id,
    this.title,
    this.contentType,
    this.content,
    this.isCompleted = false,
  });

  factory CourseContentItem.fromJson(Map<String, dynamic> json) {
    return CourseContentItem(
      id: json['id'] as String?,
      title: json['title'] as String?,
      contentType: json['contentType'] as String?,
      content: json['content'] as String?,
      isCompleted:
          json['isCompleted'] ?? false, // Default to false if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'contentType': contentType,
      'content': content,
      'isCompleted': isCompleted,
    };
  }
}

// Model for Course Module
class CourseModule {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? estimateTime;
  final String? category;
  final List<CourseContentItem>? content;

  CourseModule({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.estimateTime,
    this.category,
    this.content,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      estimateTime: json['estimateTime'] as String?,
      category: json['category'] as String?,
      content:
          (json['content'] as List?)
              ?.map(
                (e) => CourseContentItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'estimateTime': estimateTime,
      'category': category,
      'content': content?.map((e) => e.toJson()).toList(),
    };
  }
}

// Function to parse course modules from a JSON string
List<CourseModule> parseCourseModules(String jsonData) {
  final List<dynamic> parsedData = json.decode(
    jsonData,
  ); // Decode JSON string to List

  return parsedData.map((jsonModule) {
    // Convert each module's JSON data into a CourseModule object
    return CourseModule.fromJson(jsonModule as Map<String, dynamic>);
  }).toList(); // Return as a List of CourseModule objects
}

// Fetch course modules (example with hardcoded JSON)
Future<List<CourseModule>> fetchCourseModules() async {
  // Example raw JSON data (normally fetched from Firestore or an API)
  String jsonData = '''[
    {
      "id": "module1",
      "title": "Introduction to Agrochemicals",
      "description": "This is an introductory module to agrochemicals.",
      "imageUrl": "https://example.com/image1.jpg",
      "estimateTime": "30 minutes",
      "category": "Chemicals",
      "content": [
        {
          "id": "content1",
          "title": "What is Agrochemicals?",
          "contentType": "text",
          "content": "Agrochemicals are substances used in agriculture to control pests, weeds, and diseases."
        },
        {
          "id": "content2",
          "title": "Types of Agrochemicals",
          "contentType": "video",
          "content": "This video explains the different types of agrochemicals used in farming."
        }
      ]
    }
  ]''';

  // Call the parseCourseModules function to convert JSON into objects
  return parseCourseModules(jsonData);
}
