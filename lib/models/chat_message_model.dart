import 'package:hive/hive.dart';

part 'package:agri_chem/models/chat_message_model.g.dart';

@HiveType(typeId: 0)
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;

  @HiveField(2)
  final bool isError;

  ChatMessageModel({
    required this.text,
    required this.isUser,
    required this.isError,
  });
}
