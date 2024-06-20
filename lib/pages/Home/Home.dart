import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/widgets/SenderMessageTextField.dart';
import 'package:questias/pages/OnBoarding/controller/OnBoardingController.dart';
import 'package:questias/pages/model/chatMessage.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<ChatMessage> messages = [
  ChatMessage(
    text: "Hello, How can I help you?",
    isSender: false,
  ),
  ChatMessage(
    text: "I want to know about Flutter",
    isSender: true,
  ),
  ChatMessage(
    text: "Flutter is a UI toolkit developed by Google",
    isSender: false,
  ),
  ChatMessage(
    text: "Thank you",
    isSender: true,
  ),
];
List<String> exampleMessage = [
  "ChatGPT is an artificial-intelligence chatbot developed by Open AI",
  "ChatGPT launched in November 2022.",
  "ChatGPT is an artificial-intelligence chatbot developed by OpenAI",
];

class _HomePageState extends State<HomePage> {
  TextEditingController _senderMessageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: customAppBar(
        title: "ChatBot",
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
            SliverToBoxAdapter(
              child: SenderMessageTextField(sW: sW, senderMessageController: _senderMessageController, sH: sH),
            )
          ],
        ),
      ),
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
