import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final String _apiKey = 'AIzaSyAC3BW36hIbnOiQET8QMH4x8J58ZkC2Q2s';
  final String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  Future<void> _sendMessage(String text) async {
    if (text.trim().isNotEmpty) {
      ChatMessage userMessage = ChatMessage(text: text, isUser: true);
      setState(() {
        _messages.insert(0, userMessage);
      });
      _textController.clear();

      try {
        final response = await http.post(
          Uri.parse('$_apiUrl?key=$_apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': text},
                ],
              },
            ],
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['candidates'] != null &&
              responseData['candidates'].isNotEmpty) {
            final botReply =
                responseData['candidates'][0]['content']['parts'][0]['text'];
            ChatMessage botMessage = ChatMessage(text: botReply, isUser: false);
            setState(() {
              _messages.insert(0, botMessage);
            });
          } else {
            _addErrorMessage('Failed to get a response from the chatbot.');
          }
        } else {
          print('Error: ${response.statusCode}, ${response.body}');
          _addErrorMessage('Failed to connect to the chatbot.');
        }
      } catch (error) {
        print('Error sending message: $error');
        _addErrorMessage('An error occurred while sending the message.');
      }
    }
  }

  void _addErrorMessage(String message) {
    ChatMessage errorMessage = ChatMessage(text: message, isError: true);
    setState(() {
      _messages.insert(0, errorMessage);
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _sendMessage,
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _sendMessage(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gemini Chatbot')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.text,
    this.isUser = false,
    this.isError = false,
  });
  final String text;
  final bool isUser;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: isUser ? Colors.blue : Colors.green,
              foregroundColor: Colors.white,
              child: Text(isUser ? 'You' : 'Bot'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isUser ? 'You' : 'Gemini',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(text, style: TextStyle(color: Colors.black)),
                ),
                if (isError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(text, style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
