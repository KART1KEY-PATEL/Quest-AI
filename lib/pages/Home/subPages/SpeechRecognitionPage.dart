import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechRecognitionPage extends StatefulWidget {
  @override
  _SpeechRecognitionPageState createState() => _SpeechRecognitionPageState();
}

class _SpeechRecognitionPageState extends State<SpeechRecognitionPage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
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

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    if (result.finalResult) {
      Navigator.pop(context, _lastWords);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _isListening ? 200.0 : 100.0,
          height: _isListening ? 200.0 : 100.0,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Center(
            child: _isListening
                ? Icon(Icons.mic, size: 80, color: Colors.white)
                : Icon(Icons.mic_off, size: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
