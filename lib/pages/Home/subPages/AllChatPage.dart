import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/subPages/ChatPage.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:intl/intl.dart';

class AllChatPage extends StatefulWidget {
  const AllChatPage({super.key});

  @override
  State<AllChatPage> createState() => _AllChatPageState();
}

class _AllChatPageState extends State<AllChatPage> {
  @override
  void initState() {
    super.initState();
    // Initialize the chat controller to load chats
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatController>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double sW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: customAppBar(title: "All Chats", centerTitle: true, actions: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/home'),
          child: Icon(Icons.add),
        ),
        SizedBox(width: 10),
      ]),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: sW * 0.04, vertical: sH * 0.02),
        child: Consumer<ChatController>(builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.allChats.isEmpty) {
            return Center(child: Text("No chats available"));
          }

          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: sH * 0.02),
            itemCount: controller.allChats.length,
            itemBuilder: (context, index) {
              final chat = controller.allChats[index];
              String formattedDate = DateFormat('yyyy-MM-dd').format(chat.time);

              return InkWell(
                onTap: () {
                  // Navigate to chat detail page with chatId
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(chatId: chat.chatId)));
                },
                child: Container(
                  height: sH * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.secondaryColor,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(chat.title,
                              style: TextStyle(fontSize: sH * 0.02)),
                          Container(
                            // color: Colors.amber,
                            width: sW * 0.8,
                            child: txt(chat.lastMessage,
                                maxLine: 2, color: AppColors.accentTextColor),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          color: AppColors.primaryTextColor),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
