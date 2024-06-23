import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:intl/intl.dart';

class SavedChatPage extends StatefulWidget {
  const SavedChatPage({super.key});

  @override
  State<SavedChatPage> createState() => _SavedChatPageState();
}

class _SavedChatPageState extends State<SavedChatPage> {
  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double sW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar(
        title: "All Chat",
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sW * 0.04,
          vertical: sH * 0.02,
        ),
        child: Consumer<ChatController>(builder: (context, controller, child) {
          return controller.savedChats.isEmpty
              ? Center(
                  child: txt(
                    "No Chat Saved Yet",
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: sH * 0.02,
                  ),
                  itemCount: controller.savedChats.length,
                  itemBuilder: (context, index) {
                    // Convert the time to date format
                    String formattedDate = DateFormat('yyyy-MM-dd')
                        .format(controller.savedChats[index].time);

                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/chat');
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: sH * 0.1,
                            width: sW,
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
                                    txt(
                                      " ${controller.savedChats[index].title}",
                                      size: sH * 0.02,
                                    ),
                                    Container(
                                      height: sH * 0.045,
                                      width: sW * 0.7,
                                      child: txt(
                                        " ${controller.savedChats[index].lastMessage}",
                                        size: sH * 0.018,
                                        color: AppColors.accentTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.primaryTextColor,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 5,
                            child: txt(
                              " $formattedDate",
                              size: sH * 0.014,
                              color: AppColors.accentTextColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
