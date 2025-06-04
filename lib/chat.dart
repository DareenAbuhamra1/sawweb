import 'package:flutter/material.dart';
import 'dart:async'; // لاستخدام Timer في محاكاة رد البوت

// نموذج لتمثيل رسالة في الشات
class ChatMessage {
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _userBubbleColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _botBubbleColor = Colors.white;
  final Color _chatBackgroundColor = const Color.fromARGB(255, 242, 242, 245); // نفس خلفية الشاشات الأخرى

  @override
  void initState() {
    super.initState();
    _addBotMessage("مرحباً بك! أنا المساعد الذكي. كيف يمكنني خدمتك اليوم؟");
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUserMessage: false, timestamp: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();
    FocusScope.of(context).unfocus(); // لإخفاء لوحة المفاتيح

    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUserMessage: true, timestamp: DateTime.now()));
    });
    _scrollToBottom();

Timer(const Duration(milliseconds: 800), () {
  String botResponse;
  String lowerCaseText = text.toLowerCase(); // للاستخدام في حال كانت بعض الكلمات المفتاحية بالإنجليزية أو للتناسق

  if (lowerCaseText.contains("مرحبا") || lowerCaseText.contains("أهلا") || lowerCaseText.contains("هاي")) {
    botResponse = "أهلاً بك! أنا المساعد الذكي. كيف يمكنني خدمتك اليوم؟";
  }
  // --- قواعد جديدة بناءً على التصنيفات من ملف JSON ---
  else if (lowerCaseText.contains("زراعة") || lowerCaseText.contains("أشجار") || lowerCaseText.contains("تقليم") || lowerCaseText.contains("حشرات") || lowerCaseText.contains("قوارض") || lowerCaseText.contains("كلاب ضالة")) {
    botResponse = "إذا كانت لديك مشكلة تتعلق بالزراعة، مخلفات تقليم الأشجار، أو مكافحة الآفات والحيوانات الضالة، يمكنك تقديم شكوى ضمن فئة 'زراعة'.";
  } else if (lowerCaseText.contains("طريق") || lowerCaseText.contains("شارع") || lowerCaseText.contains("حفرة") || lowerCaseText.contains("مطب") || lowerCaseText.contains("إشارة") || lowerCaseText.contains("رصيف") || lowerCaseText.contains("جسر") || lowerCaseText.contains("أنقاض") || lowerCaseText.contains("طمم") || lowerCaseText.contains("عوائق")) {
    botResponse = "لمشاكل الطرق، الحفر، المطبات، الأرصفة، عوائق السير، أو السلامة المرورية، يرجى تقديم شكوى من خلال اختيار فئة 'طرقات'.";
  } else if (lowerCaseText.contains("أمن") || lowerCaseText.contains("إنشاءات متأخرة") || lowerCaseText.contains("إزعاج بناء") || lowerCaseText.contains("حيوانات مؤذية") || lowerCaseText.contains("لوحة إعلانية") || lowerCaseText.contains("مرافق رياضية")) {
    botResponse = "للقضايا المتعلقة بالإزعاج من أعمال إنشائية، أو تربية حيوانات مؤذية بشكل غير مرخص، أو مخالفات اللوحات الإعلانية، أو صيانة المرافق الرياضية العامة، يمكنك اختيار فئة 'أمن'.";
  } else if (lowerCaseText.contains("ماء") || lowerCaseText.contains("مياه") || lowerCaseText.contains("مقطوعة") || lowerCaseText.contains("تسرب") || lowerCaseText.contains("صرف صحي") || lowerCaseText.contains("مجاري") || lowerCaseText.contains("منهل") || lowerCaseText.contains("أمطار")) {
    botResponse = "إذا كانت المشكلة تتعلق بالمياه، انقطاعها، التسرب، الصرف الصحي، المناهل، أو تجمعات مياه الأمطار، يرجى اختيار فئة 'مياه'.";
  } else if (lowerCaseText.contains("تلوث") || lowerCaseText.contains("نظافة") || lowerCaseText.contains("قمامة") || lowerCaseText.contains("نفايات") || lowerCaseText.contains("حاوية") || lowerCaseText.contains("دخان") || lowerCaseText.contains("روائح") || lowerCaseText.contains("صوت مزعج") || lowerCaseText.contains("شارع وسخ") || lowerCaseText.contains("تدخين") || lowerCaseText.contains("مكتبة عامة")) {
    botResponse = "للقضايا المتعلقة بالنظافة العامة، تراكم أو حرق النفايات، صيانة الحاويات، أو أي نوع من التلوث (روائح، دخان، ضوضاء)، أو نظافة المرافق العامة، يمكنك اختيار فئة 'تلوث'.";
  } else if (lowerCaseText.contains("كهرباء") || lowerCaseText.contains("إنارة") || lowerCaseText.contains("نور") || lowerCaseText.contains("مضوية") || lowerCaseText.contains("لمبة") || lowerCaseText.contains("عمود نور") || lowerCaseText.contains("كهربا مقطوعة")) {
    botResponse = "في حال وجود مشاكل بالكهرباء أو طلبات الإنارة وصيانتها، اختر فئة 'كهرباء' عند تقديم شكواك.";
  }
  else if (lowerCaseText.contains("شكوى")) {
    botResponse = "لتقديم شكوى، يرجى التوجه إلى قسم تقديم الشكاوى واختيار الفئة الأنسب من القائمة لوصف مشكلتك بدقة. إذا وصفت لي المشكلة، يمكنني مساعدتك في تحديد الفئة.";
  } else if (lowerCaseText.contains("اقتراح")) {
    botResponse = "يمكنك تقديم اقتراح من خلال قسم 'قدم اقتراحًا' في القائمة الرئيسية، ثم اضغط على مربع كن جزءًا من الحل";
  } else if (lowerCaseText.contains("ساعات العمل")) {
    botResponse = "ساعات العمل الرسمية للدوائر الحكومية هي عادةً من الأحد إلى الخميس، من الساعة 8:00 صباحاً حتى 3:00 مساءً. قد تختلف لبعض الأقسام الخدمية.";
  } else if (lowerCaseText.contains("مساعدة") || lowerCaseText.contains("دعم") || lowerCaseText.contains("استفسار")) {
    botResponse = "يمكنني مساعدتك في العثور على معلومات أو توجيهك للخدمة المناسبة. ما الذي تبحث عنه تحديداً؟ يمكنك أيضاً تصفح قسم 'المساعدة والدعم' في القائمة.";
  } else {
    botResponse = "support@sawweb.gov.jo شكراً على رسالتك. لم أفهم طلبك بالكامل بعد، ولكن يتم تطويري باستمرار. يمكنك محاولة طرح سؤال آخر بصيغة مختلفة، أو التواصل عن طريق الايميل support@";
  }
  _addBotMessage(botResponse);
});}

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUserMessage;
    final CrossAxisAlignment bubbleAlignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final Color bubbleColor = isUser ? _userBubbleColor : _botBubbleColor;
    final Color textColor = isUser ? Colors.white : Colors.black87;
    final BorderRadius borderRadius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
            topRight: Radius.circular(4), // زاوية مختلفة قليلاً لتمييز المستخدم
          )
        : const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            topLeft: Radius.circular(4), // زاوية مختلفة قليلاً لتمييز البوت
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: bubbleAlignment,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                )
              ]
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 15, height: 1.4),
              textAlign: isUser ? TextAlign.right : TextAlign.left,
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickReplyButton(String text) {
    return ActionChip(
      label: Text(text, style: TextStyle(color: _primaryColor, fontSize: 13)),
      onPressed: () => _handleSubmitted(text),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: _primaryColor.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _chatBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: AppBar(
              title: Text(
                "المساعد الذكي",
                style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: BackButton(color: _primaryColor, onPressed: () => Navigator.of(context).pop()),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _buildQuickReplyButton("كيف أقدم شكوى؟"),
                  const SizedBox(width: 8),
                  _buildQuickReplyButton("الاستعلام عن معاملة"),
                  const SizedBox(width: 8),
                  _buildQuickReplyButton("ساعات العمل"),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // --- منطقة عرض الرسائل ---
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // لعرض الرسائل من الأسفل للأعلى
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1.0),
          // --- منطقة إدخال النص ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    textAlign: TextAlign.right, // لمحاذاة النص إلى اليمين
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: "اكتب رسالتك هنا...",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: _primaryColor, width: 1.5),
                      ),
                      filled: true,
                      fillColor: _chatBackgroundColor.withOpacity(0.7), // لون خلفية حقل الإدخال
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    onSubmitted: _handleSubmitted,
                    minLines: 1,
                    maxLines: 4, 
                  ),
                ),
                const SizedBox(width: 8.0),
                Material(
                  color: _primaryColor,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _handleSubmitted(_textController.text),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
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