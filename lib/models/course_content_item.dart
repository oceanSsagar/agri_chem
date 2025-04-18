class CourseContentItem {
  final String? id;
  final String? title;
  final String? description;
  final String? contentType;
  final String? content; // Content data (text, image URL, etc.)
  bool isCompleted;

  CourseContentItem({
    this.id,
    this.title,
    this.description,
    this.contentType,
    this.content,
    this.isCompleted = false,
  });

  factory CourseContentItem.fromJson(Map<String, dynamic> json) {
    return CourseContentItem(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      contentType: json['contentType'] as String?,
      content: json['content'] as String?, // Now we store content here
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'contentType': contentType,
      'content': content, // Ensure content is serialized correctly
      'isCompleted': isCompleted,
    };
  }
}
