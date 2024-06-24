import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/subPages/ChatPage.dart';
import 'package:questias/pages/Home/subPages/SpeechRecognitionPage.dart';
import 'package:questias/pages/Home/widgets/SenderMessageTextField.dart';
import 'package:questias/pages/Home/widgets/SenderTextFeild.dart';
import 'package:questias/pages/OnBoarding/controller/OnBoardingController.dart';
import 'package:questias/pages/model/chatMessage.dart';
import 'package:questias/pages/model/openAIChatModel.dart';
import 'package:questias/services/BackendService.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> exampleMessage = [
    "I am a ChatBOT to help UPSC aspirants.",
    "You can ask me any question related to History, Geography, Polity and much more.",
    "You can also use the mic button to ask me a question. If you don't want to typ.e",
  ];
  static const platform = MethodChannel('com.example.questias/tts');
  TextEditingController _senderMessageController = TextEditingController();
  BackendService _backendService = BackendService();
  bool _isLoadingVoice = false;
  final player = AudioPlayer();
  String _text = "Hello, how are you?";

  Future<void> _speak(String text) async {
    print("speak");
    try {
      final String result =
          await platform.invokeMethod('speak', {"text": text});
      print(result);
    } on PlatformException catch (e) {
      print("Failed to invoke: '${e.message}'.");
    }
  }

  Future<void> playTextToSpeech(String text) async {
    print("speak1");
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
    chatController.addMessage(OpenAIChatModel(content: message, role: "user"));
    chatController.setLoading();

    String response = await _backendService.getOpenAIResponse(
      messages: chatController.messages,
    );
    print(response);
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
        title: "Quest IAS",
        centerTitle: true,
        // elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(
          sH * 0.02,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/robot.png",
                    width: sW * 0.35,
                  ),
                  SizedBox(
                    height: sH * 0.02,
                  ),
                  txt(
                    "ChatBot",
                    size: sH * 0.03,
                  ),
                  SizedBox(
                    height: sH * 0.02,
                  ),
                ],
              ),
            ),
            SliverList.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: sH * 0.02,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                return ExampleText(
                  sH: sH,
                  sW: sW,
                  title: exampleMessage[index],
                );
              },
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: sH * 0.02,
                  ),
                  txt(
                    "This is example that what can i do for you.",
                    color: AppColors.accentTextColor,
                    size: sH * 0.018,
                  ),
                  SizedBox(
                    height: sH * 0.08,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        SenderTextField(
          sW: sW,
          sH: sH,
          senderMessageController: _senderMessageController,
          speechToText: null,
          speechEnabled: false,
          homePage: true,
          startListening: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpeechRecognitionPage(),
              ),
            );
          },
          stopListening: () {},
        ),
      ],
    );
  }
}

class ExampleText extends StatelessWidget {
  const ExampleText({
    super.key,
    required this.sW,
    required this.sH,
    required this.title,
  });

  final double sW;
  final double sH;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sW * 0.9,
      height: sH * 0.1,
      padding: EdgeInsets.all(
        sH * 0.02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          sH * 0.02,
        ),
        color: AppColors.secondaryColor,
      ),
      child: Center(
        child: txt(
          title,
          size: sH * 0.018,
          textAlign: TextAlign.center,
          color: AppColors.accentTextColor,
        ),
      ),
    );
  }
}
