import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/widgets/SenderMessageTextField.dart';
import 'package:questias/pages/model/chatTile.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;
    TextEditingController _senderMessageController = TextEditingController();
    return Scaffold(
      appBar: customAppBar(
        title: "Hello",
        centerTitle: true,
        leading:
            Consumer<ChatController>(builder: (context, controller, child) {
          return InkWell(
            onTap: () {
              controller.addChat(ChatTile(
                id: "",
                title: "ChatBot",
                lastMessage: controller.messages.last.text,
                time: DateTime.now().toString(),
                messages: controller.messages,
              ));
              Navigator.pop(context);
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
                separatorBuilder: (context, index) => SizedBox(
                  height: sH * 0.02,
                ),
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: controller.messages[index].isSender
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.content_copy,
                        color: AppColors.accentTextColor,
                        size: sH * 0.02,
                      ),
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
                            bottomLeft: controller.messages[index].isSender
                                ? Radius.circular(12)
                                : Radius.circular(0),
                            bottomRight: controller.messages[index].isSender
                                ? Radius.circular(0)
                                : Radius.circular(12),
                          ),
                          color: controller.messages[index].isSender
                              ? AppColors.senderColor
                              : AppColors.receiverColor,
                        ),
                        child: txt(
                          controller.messages[index].text,
                          size: sH * 0.018,
                          color: controller.messages[index].isSender
                              ? Colors.white
                              : Colors.black,
                        ),
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
        SenderMessageTextField(
          sW: sW,
          sH: sH,
          senderMessageController: _senderMessageController,
        )
      ],
    );
  }
}
