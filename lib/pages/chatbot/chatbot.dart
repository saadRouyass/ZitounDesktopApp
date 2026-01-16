import 'package:flutter/material.dart';
import 'package:zitoun/services/openrouter.dart';
import 'package:zitoun/pages/chatbot/loader.dart';
import 'package:zitoun/services/get_facture.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  
  bool _isChatOpen = false;
  final TextEditingController _controller = TextEditingController();
  bool _isBotTyping = false;

  void _sendMessage() async {
  if (_controller.text.trim().isEmpty) return;

  setState(() {
    _messages.add({
      "role": "user",
      "text": _controller.text.trim(),
    });
    _isBotTyping = true;   // show loader
  });

  final userMessage = _controller.text.trim();
  _controller.clear();

  // Simulated delay (replace with API call)
  final chatbotMsg = await sendToLLM(userMessage);

  final items = [{"description": "OEUFS",
      "quantity": 80,
      "unitPrice": 45,
      "tax": 0,
      "total": 3600}];

  

  setState(() {
    _isBotTyping = false;  // hide loader
    _messages.add({
      "role": "assistant",
      "text": chatbotMsg,
    });
  });
  //if (chatbotMsg!='') {
    //await downloadPdf(context,DateTime.now().toString(), 'PRISON AL HOCEIMA', 'Rabat',items, 3600,'0', 3600);
  //}
  
  //SysNotif.showWidget(context, 'There you go Idiot!',presets['in_review']!,Icons.logo_dev);

}

  List<Map<String, dynamic>> _messages = [];

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        // Main clickable chatbot icon
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              setState(() => _isChatOpen = !_isChatOpen);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: BoxBorder.all(color:theme.colorScheme.onSurface ,width:1 ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Icon(Icons.chat_bubble, color:theme.colorScheme.onSurface,size: 24,),
            ),
          ),
        ),

        // Chat box overlay
        if (_isChatOpen)
          Positioned(
            bottom: 110,
            right: 30,
            child: _buildChatBox(context),
          ),
      ],
    );
  }

  Widget _buildChatBox(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 320,
        height: 480,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "AI Chatbot",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() => _isChatOpen = false);
                  },
                )
              ],
            ),

            const Divider(),

            // Messages list placeholder
            Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                // If this index is the loader → show loader
                if (_isBotTyping && index == 0) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: SysMessageLoader(),
                  );
                }

                // Otherwise show a message
                final msg = _messages[_messages.length - 1 - (index - (_isBotTyping ? 1 : 0))];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : theme.colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"],
                      style: TextStyle(color: isUser ? Colors.white : theme.colorScheme.surface),
                    ),
                  ),
                );
              },
            ),
          ),

            const SizedBox(height: 10),

            // Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 14),
                      minLines: 1,        // starts with one line
                      maxLines: 5,        // grows up to 5 lines (change as you want)
                      keyboardType: TextInputType.multiline,
                      
                    decoration: InputDecoration(
                      hintText: "3ndk question? Marhba",
                      
                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: theme.colorScheme.onSurface),
                    onPressed: () async {
                      _sendMessage();
                    },

                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
