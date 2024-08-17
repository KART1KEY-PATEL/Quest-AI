import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/models/openAIChatModel.dart';
import 'package:questias/services/BackendService.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechRecognitionPage extends StatefulWidget {
  final String chatId;
  const SpeechRecognitionPage({Key? key, required this.chatId})
      : super(key: key);
  @override
  _SpeechRecognitionPageState createState() => _SpeechRecognitionPageState();
}

class _SpeechRecognitionPageState extends State<SpeechRecognitionPage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  static const platform = MethodChannel('com.example.questias/tts');
  BackendService _backendService = BackendService();
  bool _isLoadingVoice = false;
  String _lastWords = '';
  bool _isListening = false;
  bool _isLoading = false;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _stopSpeaking(); // Stop any ongoing speech when the page is disposed
    super.dispose();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _speechEnabled = true;
        });
        _startListening();
      } else {
        // Handle the case when the initialization failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech recognition not available'),
          ),
        );
      }
    } else {
      // Handle the case when the permission is not granted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Microphone permission denied'),
        ),
      );
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    if (_speechEnabled) {
      await _stopSpeaking(); // Stop any ongoing speech
      setState(() {
        _isListening = true;
      });
      await _speechToText.listen(onResult: _onSpeechResult);
    }
  }

  /// Manually stop the active speech recognition session
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  /// Stop any ongoing text-to-speech
  Future<void> _stopSpeaking() async {
    try {
      await platform.invokeMethod('stop');
    } on PlatformException catch (e) {
      print("Failed to stop speaking: '${e.message}'.");
    }
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    if (result.finalResult) {
      _sendMessage(_lastWords);
    }
    // Navigator.pop(context);
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
      // isSpeaking = false;
      _isListening = false;
      _isLoadingVoice = false;
    });
  }

  void _sendMessage(String message) async {
    setState(() {
      _isLoading = true;
    });
    if (message.isEmpty) return;
    final chatController = Provider.of<ChatController>(context, listen: false);
    chatController.addMessage(
        widget.chatId, OpenAIChatModel(content: message, role: "user"));
    chatController.setLoading();
    String response = await _backendService.getOpenAIResponse(
      messages: chatController.messages,
    );
    chatController.setLoading();
    chatController.addMessage(
        widget.chatId, OpenAIChatModel(content: response, role: "assistant"));

    setState(() {
      _isLoading = false;
      isSpeaking = true;
    });

    playTextToSpeech(response);
  }

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: customAppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () async {
              await _stopSpeaking(); // Stop any ongoing speech
              Navigator.pop(context);
            },
          ),
        ],
        title: "",
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sH * 0.2,
            vertical: sH * 0.3,
          ),
          child: _isLoading
              ? LoadingAnimationWidget.fourRotatingDots(
                  color: AppColors.primaryButtonColor,
                  size: 70,
                )
              : _isListening
                  ? RippleAnimation(
                      color: AppColors.primaryButtonColor,
                      delay: const Duration(milliseconds: 300),
                      repeat: true,
                      minRadius: 75,
                      ripplesCount: 6,
                      duration: const Duration(milliseconds: 6 * 300),
                      child: CircleAvatar(
                        minRadius: sH * 0.06,
                        maxRadius: sH * 0.06,
                        backgroundColor: AppColors.primaryButtonColor,
                        child: Icon(
                          Icons.mic,
                          size: sH * 0.03,
                          color: AppColors.whiteTextColor,
                        ),
                      ),
                    )
                  : RippleAnimation(
                      color: AppColors.primaryButtonColor,
                      delay: const Duration(milliseconds: 300),
                      repeat: true,
                      minRadius: 75,
                      ripplesCount: 6,
                      duration: const Duration(milliseconds: 6 * 300),
                      child: CircleAvatar(
                        minRadius: sH * 0.06,
                        maxRadius: sH * 0.06,
                        backgroundColor: AppColors.primaryButtonColor,
                        child: Icon(
                          Icons.headphones,
                          size: sH * 0.04,
                          color: AppColors.whiteTextColor,
                        ),
                      ),
                    )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isListening
          ? Container(
              height: sH * 0.07,
              width: sW * 0.8,
              decoration: BoxDecoration(
                color: AppColors.primaryButtonColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: InkWell(
                onTap: _stopListening,
                child: Center(
                    child: txt(
                  "Stop Listening",
                  size: sW * 0.04,
                  isBold: true,
                  color: Colors.white,
                )),
              ),
            )
          : Container(
              height: sH * 0.07,
              width: sW * 0.8,
              decoration: BoxDecoration(
                color: AppColors.primaryButtonColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSpeaking = false;
                  });
                  _startListening();
                },
                child: Center(
                    child: txt(
                  "Start Listening",
                  size: sW * 0.04,
                  isBold: true,
                  color: Colors.white,
                )),
              ),
            ),
    );
  }
}
