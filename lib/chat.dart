import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final Map<String, String> _navigationKeywords = {
    "شكوى": "/reportPage",
    "طرق": "/roadPage",
    "زراعة": "/agriculturePage",
    "نظافة": "/cleaningPage",
    "خريطة": "/mapPage",
    "مهام": "/tasksPage",
  };

  void _handleUserMessage(String input) {
    setState(() {
      _messages.add({"sender": "user", "text": input});
    });

    final matchedRoute = _getNavigationDestination(input);

    if (matchedRoute != null) {
      _addBotMessage("حسنًا، سأقودك إلى الصفحة المطلوبة...");
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamed(context, matchedRoute);
      });
    } else {
      _addBotMessage("لم أفهم رسالتك، حاول استخدام كلمات مثل 'شكوى' أو 'خريطة'");
    }

    _controller.clear();
  }

  String? _getNavigationDestination(String input) {
    input = input.toLowerCase();
    for (final entry in _navigationKeywords.entries) {
      if (input.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add({"sender": "bot", "text": text});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مساعد التطبيق')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message['text']!, textAlign: TextAlign.right),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _handleUserMessage,
                    decoration: InputDecoration(
                      hintText: 'اكتب سؤالك...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      _handleUserMessage(text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
