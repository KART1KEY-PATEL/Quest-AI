import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/subPages/SpeechRecognitionPage.dart';
import 'package:questias/pages/Home/widgets/SenderTextFeild.dart';
import 'package:questias/pages/model/chatTile.dart';
import 'package:questias/pages/model/openAIChatModel.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/services/BackendService.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Add this import

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _senderMessageController = TextEditingController();
  BackendService _backendService = BackendService();
  FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
      });
    });
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  void _sendMessage(String message) async {
    if (message.isEmpty) return;

    final chatController = Provider.of<ChatController>(context, listen: false);
    chatController.addMessage(OpenAIChatModel(content: message, role: "user"));
    chatController.setLoading();

    String response = await _backendService.getOpenAIResponse(
      messages: chatController.messages,
    );

    chatController.setLoading();
    chatController
        .addMessage(OpenAIChatModel(content: response, role: "assistant"));

    // Speak the response
    _speak(response);
  }

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: customAppBar(
        title: "Hello",
        centerTitle: true,
        actions: [
          Consumer<ChatController>(builder: (context, controller, child) {
            return InkWell(
              onTap: () {
                controller.addSavedChat(ChatTile(
                  id: "",
                  title: "ChatBot",
                  lastMessage: controller.messages.last.content.toString(),
                  time: DateTime.now(),
                  messages: controller.messages,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chat saved successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Icon(
                Icons.bookmark_add,
              ),
            );
          }),
          SizedBox(
            width: 10,
          )
        ],
        leading:
            Consumer<ChatController>(builder: (context, controller, child) {
          return InkWell(
            onTap: () {
              controller.addChat(ChatTile(
                id: "",
                title: "ChatBot",
                lastMessage: controller.messages.last.content.toString(),
                time: DateTime.now(),
                messages: controller.messages,
              ));
              Navigator.pop(context);
              Navigator.pushNamed(context, '/allChat');
            },
            child: Icon(
              Icons.arrow_back_ios,
            ),
          );
        }),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sH * 0.02,
          vertical: sH * 0.02,
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(child:
                Consumer<ChatController>(builder: (context, controller, child) {
              return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(
                  height: sH * 0.02,
                ),
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: controller.messages[index].role == "user"
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.messages[index].role == "user")
                        Icon(
                          Icons.content_copy,
                          color: AppColors.accentTextColor,
                          size: sH * 0.02,
                        ),
                      if (controller.messages[index].role == "user")
                        SizedBox(
                          width: sW * 0.015,
                        ),
                      Container(
                        width: sW * 0.6,
                        padding: EdgeInsets.symmetric(
                          horizontal: sW * 0.02,
                          vertical: sH * 0.02,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft:
                                controller.messages[index].role == "user"
                                    ? Radius.circular(12)
                                    : Radius.circular(0),
                            bottomRight:
                                controller.messages[index].role == "user"
                                    ? Radius.circular(0)
                                    : Radius.circular(12),
                          ),
                          color: controller.messages[index].role == "user"
                              ? AppColors.senderColor
                              : AppColors.receiverColor,
                        ),
                        child: Text(
                          controller.messages[index].content.toString(),
                          style: TextStyle(
                            fontSize: sH * 0.018,
                            color: controller.messages[index].role == "user"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      if (controller.messages[index].role == "assistant")
                        SizedBox(
                          width: sW * 0.015,
                        ),
                      if (controller.messages[index].role == "assistant")
                        Icon(
                          Icons.content_copy,
                          color: AppColors.accentTextColor,
                          size: sH * 0.02,
                        ),
                    ],
                  );
                },
                itemCount: controller.messages.length,
              );
            })),
          ],
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        SenderTextField(
          sW: sW,
          sH: sH,
          senderMessageController: _senderMessageController,
          speechToText: null,
          speechEnabled: false,
          startListening: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpeechRecognitionPage(),
              ),
            );
            if (result != null && result is String) {
              _sendMessage(result);
            }
          },
          stopListening: () {},
        )
      ],
    );
  }
}
