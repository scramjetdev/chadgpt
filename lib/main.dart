import 'dart:convert';
import 'dart:html';

import 'package:chadgpt/constant.dart';
import 'package:chadgpt/informations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Informations(),
    );
  }
}

const backgroundColor = Color(0xff343541);
const botbackgroundColor = Color(0xff444654);

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late bool isLoading;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  Future<String> generateResponse(String prompt) async {
    var url = Uri.https("free.churchless.tech", "/v1/chat/completions");
    String finalPrompt = prePrompt + prompt;
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        //'messages': '[{"role": "user", "content": "$finalPrompt"}]',
        'messages': [{'role':'user', 'content': finalPrompt}],

      }),
    );
    final data = jsonDecode(response.body);
    String answer = data['choices'][0]['message']['content'];
    return utf8.decode(answer.runes.toList());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("ChadGPT v3.5-turbo", textAlign: TextAlign.center,),
            ),
            centerTitle: true,
          backgroundColor: botbackgroundColor,
          ),
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              //Chat body
              Expanded(
                  child: _buildList()
              ),
              Visibility(
                  visible: isLoading,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Giga chad is thinking", style: TextStyle(color: botbackgroundColor, fontSize: 20),),
                          ),
                          SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              backgroundColor: backgroundColor,
                              color: botbackgroundColor,
                              strokeWidth: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    _buildInput(),
                    _buildSubmit(),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  Expanded _buildInput() {
    return Expanded(child: TextField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 50,
      textInputAction: TextInputAction.newline,
      cursorColor: Colors.pink,
      textCapitalization: TextCapitalization.none,
      style: const TextStyle(color: Colors.white),
      controller: _textController,
      decoration: const InputDecoration(
        hintText: 'Entrer votre question',
        hintStyle: TextStyle(color: backgroundColor),
        fillColor: botbackgroundColor,
        filled: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    ));
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
        child: Container(
          color: botbackgroundColor,
          child: IconButton(icon: const Icon(Icons.send_rounded, color: Color.fromRGBO(142, 142, 160, 1),),
            onPressed: () {
              String input = _textController.text;
              setState(() {
                _messages.add(ChatMessage(text: input, chatMessageType: ChatMessageType.user));
                isLoading = true;
              });
              _textController.clear();
              Future.delayed(const Duration(milliseconds: 50)).then((value) => _scrollDown());
              generateResponse(input).then((value) {
                setState(() {
                  isLoading = false;
                  _messages.add(ChatMessage(text: value, chatMessageType: ChatMessageType.bot));

                });
              });
              _textController.clear();
              Future.delayed(const Duration(milliseconds: 50)).then((value) => _scrollDown());
          })));
  }

  void _scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  ListView _buildList() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: ((context, index) {
            var message = _messages[index];
            return ChatMessageWidget(text: message.text, chatMessageType: message.chatMessageType);
      })
    );
  }


}

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;

  const ChatMessageWidget({Key? key, required this.text, required this.chatMessageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot ? botbackgroundColor: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const CircleAvatar(foregroundImage: AssetImage("chad.png"),),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const CircleAvatar(backgroundColor: botbackgroundColor,child: Icon(Icons.person, color: backgroundColor,),),
                ),
          Expanded(
              child: GestureDetector(
                onDoubleTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: MarkdownBody(
                      data: text,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(color: Colors.white),
                          codeblockDecoration: const BoxDecoration(color: Colors.black54),
                          code: const TextStyle(backgroundColor: Colors.transparent, color: Colors.grey)
                      ),

                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}


