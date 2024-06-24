import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.questias/tts');
  String _text = "Hello, how are you?";

  Future<void> _speak() async {
    try {
      final String result =
          await platform.invokeMethod('speak', {"text": _text});
      print(result);
    } on PlatformException catch (e) {
      print("Failed to invoke: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text to Speech Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_text),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speak,
              child: Text("Speak"),
            ),
          ],
        ),
      ),
    );
  }
}
