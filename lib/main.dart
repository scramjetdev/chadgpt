import 'dart:convert';

import 'package:chadgpt/constant.dart';
import 'package:flutter/material.dart';
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
      home: ChatPage(),
      debugShowCheckedModeBanner: false,
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
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Giga chad is thinking", style: TextStyle(color: Colors.white, fontSize: 20),),
                          ),
                          CircularProgressIndicator(
                            color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: Colors.white),
      controller: _textController,
      decoration: const InputDecoration(
        fillColor: botbackgroundColor,
        filled: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none
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
              setState(() {
                _messages.add(ChatMessage(text: _textController.text, chatMessageType: ChatMessageType.user));
                isLoading = true;
              });
              var input = _textController.text;
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
        children: [
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const CircleAvatar(foregroundImage: AssetImage("chad.png"),),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const CircleAvatar(child: Icon(Icons.person)),
                ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),),
                  )
                ],
              ),
          )
        ],
      ),
    );
  }
}


