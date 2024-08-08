import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/subPages/ChatPage.dart';
import 'package:questias/pages/model/chatTile.dart';
import 'package:questias/pages/model/openAIChatModel.dart';
import 'package:questias/services/BackendService.dart';
import 'package:questias/utils/color.dart';

class SenderTextField extends StatelessWidget {
  SenderTextField({
    super.key,
    required this.sW,
    required this.homePage,
    required TextEditingController senderMessageController,
    required this.sH,
    required this.speechToText,
    required this.speechEnabled,
    required this.startListening,
    required this.stopListening,
    required this.chatId,
  }) : _senderMessageController = senderMessageController;

  final double sW;
  final TextEditingController _senderMessageController;
  final double sH;
  final dynamic speechToText; // Changed to dynamic
  final bool speechEnabled;
  final Function startListening;
  final bool homePage;
  final Function stopListening;
  final String chatId;
  BackendService _backendService = BackendService();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          elevation: 8,
          shadowColor: Colors.black45,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: sW * 0.7,
            child: TextField(
              controller: _senderMessageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.document_scanner,
                      color: AppColors.primaryButtonColor,
                    ),
                    SizedBox(width: 15), // space between icons
                    GestureDetector(
                      onTap: () {
                        homePage ? Navigator.pushNamed(context, '/chat') : null;
                        print("Mic button pressed");
                        startListening();
                      },
                      child: Icon(
                        Icons.mic,
                        color: AppColors.primaryButtonColor,
                      ),
                    ),
                    SizedBox(width: 15), // space between icons
                  ],
                ),
                hintText: 'Ask me anything... ',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amber, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: sW * 0.04,
        ),
        Material(
          elevation: 8,
          shadowColor: Colors.black45,
          borderRadius: BorderRadius.circular(sH * 0.1),
          child:
              Consumer<ChatController>(builder: (context, controller, child) {
            return InkWell(
              onTap: () async {
                homePage
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(chatId: chatId)),
                      )
                    : null;
                controller.addMessage(
                  chatId,
                  OpenAIChatModel(
                    content: _senderMessageController.text,
                    role: "user",
                  ),
                );
                controller.setLoading();
                String response = await _backendService.getOpenAIResponse(
                  messages: controller.messages,
                );
                controller.setLoading();
                controller.addMessage(
                  chatId,
                  OpenAIChatModel(
                    content: response,
                    role: "assistant",
                  ),
                );
              },
              child: Container(
                height: sH * 0.065,
                width: sH * 0.065,
                decoration: BoxDecoration(
                  color: AppColors.primaryButtonColor,
                  borderRadius: BorderRadius.circular(sH * 0.1),
                ),
                child: Center(
                  child: const Icon(
                    Icons.send,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
