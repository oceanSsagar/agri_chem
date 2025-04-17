import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../../../providers/user_provider.dart';
import '../../models/chat_message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessageModel> _messages = [];
  late Box<ChatMessageModel> _chatBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _chatBox = await Hive.openBox<ChatMessageModel>('chatBox');
    setState(() {
      _messages.addAll(_chatBox.values.toList().reversed);
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    ChatMessageModel userMessage = ChatMessageModel(
      text: text,
      isUser: true,
      isError: false,
    );
    _addMessage(userMessage);

    _textController.clear();

    final apiKey = dotenv.env['OPENAI_API_KEY'];
    final apiUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': text},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final botReply =
            responseData['choices'][0]['message']['content'].trim();

        ChatMessageModel botMessage = ChatMessageModel(
          text: botReply,
          isUser: false,
          isError: false,
        );
        _addMessage(botMessage);
      } else {
        _addErrorMessage('Failed to connect to ChatGPT.');
      }
    } catch (e) {
      _addErrorMessage('An error occurred while sending the message.');
    }
  }

  void _addMessage(ChatMessageModel message) {
    setState(() => _messages.insert(0, message));
    _chatBox.add(message);
  }

  void _addErrorMessage(String message) {
    _addMessage(ChatMessageModel(text: message, isUser: false, isError: true));
  }

  Future<void> _clearAllMessages() async {
    setState(() {
      _messages.clear();
    });
    await _chatBox.clear();
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _sendMessage,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: () => _sendMessage(_textController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return ChatMessageWidget(
                        text: msg.text,
                        isUser: msg.isUser,
                        isError: msg.isError,
                        avatarUrl: user?.avatarUrl,
                      );
                    },
                  ),
                ),
                const Divider(height: 1.0),
                AnimatedPadding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: _buildTextComposer(),
                ),
              ],
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () async {
                  // Confirm before deleting all messages
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text("Delete All Messages"),
                          content: const Text(
                            "Are you sure you want to delete all chat messages?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                  );

                  if (shouldDelete == true) {
                    _clearAllMessages();
                  }
                },
                backgroundColor: Colors.orange,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isError;
  final String? avatarUrl;

  const ChatMessageWidget({
    super.key,
    required this.text,
    required this.isUser,
    required this.isError,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor:
                  isUser
                      ? Colors.blue
                      : isError
                      ? Colors.red
                      : Colors.black,
              foregroundColor: Colors.white,
              backgroundImage:
                  isUser && avatarUrl != null
                      ? CachedNetworkImageProvider(avatarUrl!)
                      : null,
              child:
                  isUser
                      ? null
                      : const Text('C', style: TextStyle(fontSize: 24)),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isUser
                      ? 'You'
                      : isError
                      ? 'Error'
                      : 'ChatGPT',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color:
                        isUser
                            ? Colors.blue[100]
                            : isError
                            ? Colors.red[100]
                            : Colors.green[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
