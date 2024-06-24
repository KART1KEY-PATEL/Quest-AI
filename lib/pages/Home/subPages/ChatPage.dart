import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/subPages/SpeechRecognitionPage.dart';
import 'package:questias/pages/Home/widgets/SenderTextFeild.dart';
import 'package:questias/pages/model/chatTile.dart';
import 'package:questias/pages/model/openAIChatModel.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/services/BackendService.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter_tts/flutter_tts.dart'; // Add this import
// sk_42366f6528755a6e18e1be7917b6601f657d3671b9f43a58

String EL_API_KEY = dotenv.env['EL_API_KEY'] as String;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _senderMessageController = TextEditingController();
  BackendService _backendService = BackendService();
  final player = AudioPlayer();
  bool _isLoadingVoice = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _senderMessageController.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> playTextToSpeech(String text) async {
    setState(() {
      _isLoadingVoice = true;
    });

    String voiceRachel = '21m00Tcm4TlvDq8ikWAM';

    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceRachel';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'audio/mpeg',
        'xi-api-key': EL_API_KEY,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "text": text,
        "model_id": "eleven_monolingual_v1",
        "voice_settings": {"stability": .15, "similarity_boost": .75}
      }),
    );

    setState(() {
      _isLoadingVoice = false;
    });

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      await player.setAudioSource(MyCustomSource(bytes));
      player.play();
    } else {
      return;
    }
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

    playTextToSpeech(response);
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

// Feed your own stream of bytes into the player
class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
