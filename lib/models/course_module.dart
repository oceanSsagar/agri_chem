import 'package:agri_chem/models/course_content_item.dart';

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
