import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/pages/model/chatMessage.dart';

class SenderMessageTextField extends StatelessWidget {
  const SenderMessageTextField({
    super.key,
    required this.sW,
    required TextEditingController senderMessageController,
    required this.sH,
  }) : _senderMessageController = senderMessageController;

  final double sW;
  final TextEditingController _senderMessageController;
  final double sH;

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
                    Icon(
                      Icons.mic,
                      color: AppColors.primaryButtonColor,
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
              onTap: () {
                controller.addMessage(
                  ChatMessage(
                    text: _senderMessageController.text,
                    isSender: true,
                  ),
                );
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/chat');
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
