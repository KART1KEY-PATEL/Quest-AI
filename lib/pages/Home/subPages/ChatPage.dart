import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/subPages/SpeechRecognitionPage.dart';
import 'package:questias/pages/Home/widgets/SenderTextFeild.dart';
import 'package:questias/models/chatTile.dart';
import 'package:questias/models/openAIChatModel.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/services/BackendService.dart';
import 'package:http/http.dart' as http;

String EL_API_KEY = dotenv.env['EL_API_KEY'] as String;

class ChatPage extends StatefulWidget {
  final String chatId;
  const ChatPage({super.key, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const platform = MethodChannel('com.example.questias/tts');
  TextEditingController _senderMessageController = TextEditingController();
  BackendService _backendService = BackendService();
  final player = AudioPlayer();
  bool _isLoadingVoice = false;

  @override
  void initState() {
    super.initState();
    // Load messages for the current chat ID
    Provider.of<ChatController>(context, listen: false)
        .loadMessagesForChat(widget.chatId);
  }

  @override
  void dispose() {
    _senderMessageController.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    try {
      final String result =
          await platform.invokeMethod('speak', {"text": text});
      print(result);
    } on PlatformException catch (e) {
      print("Failed to invoke: '${e.message}'.");
    }
  }

  Future<void> playTextToSpeech(String text) async {
    setState(() {
      _isLoadingVoice = true;
    });

    await _speak(text);

    setState(() {
      _isLoadingVoice = false;
    });
  }

  void _sendMessage(String message) async {
    if (message.isEmpty) return;
    final chatController = Provider.of<ChatController>(context, listen: false);
    OpenAIChatModel newMessage =
        OpenAIChatModel(content: message, role: "user");

    // Send message to the backend
    chatController.addMessage(widget.chatId, newMessage);

    // Optionally add to local messages list for immediate UI update
    chatController.messages.add(newMessage);
    chatController.notifyListeners();

    // Get response and update accordingly
    String response = await _backendService.getOpenAIResponse(
        messages: chatController.messages);
    chatController.addMessage(
        widget.chatId, OpenAIChatModel(content: response, role: "assistant"));
  }

  Future<bool> _onWillPop() async {
    // Logic when back button is pressed
    final chatController = Provider.of<ChatController>(context, listen: false);
    chatController.addChat(
        widget.chatId,
        ChatTile(
          chatId: widget.chatId,
          title: "ChatBot",
          lastMessage: chatController.messages.last.content.toString(),
          time: DateTime.now(),
          messages: chatController.messages,
        ));
    Navigator.pop(context);
    Navigator.pushNamed(context, '/allChat');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;
    print("ChatId from ChatPage: ${widget.chatId}");

    return WillPopScope(
      onWillPop: _onWillPop, // Use our custom back button handling
      child: Scaffold(
        appBar: customAppBar(
          title: "Quest AI",
          centerTitle: true,
          leading:
              Consumer<ChatController>(builder: (context, controller, child) {
            return InkWell(
              onTap: () => _onWillPop(),
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Consumer<ChatController>(
                    builder: (context, controller, child) {
                      return ListView.separated(
                        itemCount: controller.isLoading
                            ? controller.messages.length + 1
                            : controller.messages.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: sH * 0.02,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          // Check if this is the position for the loading widget
                          if (index == controller.messages.length &&
                              controller.isLoading) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: sH * 0.05,
                                width: sW * 0.2,
                                decoration: BoxDecoration(
                                  color: AppColors.receiverColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: sH * 0.025,
                                  vertical: sH * 0.015,
                                ),
                                child: LoadingAnimationWidget.prograssiveDots(
                                  color: AppColors.whiteTextColor,
                                  size: 40,
                                ),
                              ),
                            );
                          }

                          // Normal message display
                          return Row(
                            mainAxisAlignment:
                                controller.messages[index].role == "user"
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
                                        controller.messages[index].role ==
                                                "user"
                                            ? Radius.circular(12)
                                            : Radius.circular(0),
                                    bottomRight:
                                        controller.messages[index].role ==
                                                "user"
                                            ? Radius.circular(0)
                                            : Radius.circular(12),
                                  ),
                                  color:
                                      controller.messages[index].role == "user"
                                          ? AppColors.senderColor
                                          : AppColors.receiverColor,
                                ),
                                child: Text(
                                  controller.messages[index].content.toString(),
                                  style: TextStyle(
                                    fontSize: sH * 0.018,
                                    color: controller.messages[index].role ==
                                            "user"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              if (controller.messages[index].role ==
                                  "assistant")
                                SizedBox(
                                  width: sW * 0.015,
                                ),
                              if (controller.messages[index].role ==
                                  "assistant")
                                Icon(
                                  Icons.content_copy,
                                  color: AppColors.accentTextColor,
                                  size: sH * 0.02,
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          SenderTextField(
            chatId: widget.chatId,
            homePage: false,
            sW: sW,
            sH: sH,
            senderMessageController: _senderMessageController,
            speechToText: null,
            speechEnabled: false,
            startListening: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpeechRecognitionPage(
                    chatId: widget.chatId,
                  ),
                ),
              );
            },
            stopListening: () {},
          )
        ],
      ),
    );
  }
}
