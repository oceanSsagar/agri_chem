class CourseContentItem {
  final String id;
  final String title;
  final String type;
  final String contentType; // e.g., "text", "image", "quiz"
  final dynamic content; // can be text, URL, etc.

  CourseContentItem({
    required this.id,
    required this.title,
    required this.type,
    required this.contentType,
    required this.content,
  });

  factory CourseContentItem.fromJson(Map<String, dynamic> json) {
    return CourseContentItem(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      contentType: json['contentType'] as String,
      content: json['content'], // content could be text, URL, etc.
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'contentType': contentType,
      'content': content,
    };
  }
}
