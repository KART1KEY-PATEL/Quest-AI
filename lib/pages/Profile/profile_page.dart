import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/extension/string_extension.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/providers/user_provider.dart';
import 'package:questias/services/BackendService.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:intl/intl.dart';
import 'package:questias/widget/profile_setting_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch the user details when the page is loaded
    Provider.of<UserProvider>(context, listen: false).fetchUser(context);
  }

  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double sW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar(title: "Profile", centerTitle: true, actions: [
        IconButton(
          onPressed: () {
            BackendService().signOutUser();
          },
          icon: Icon(
            Icons.logout,
            color: AppColors.accentTextColor,
          ),
        ),
      ]),
      body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sW * 0.04,
            vertical: sH * 0.02,
          ),
          child: Consumer<UserProvider>(builder: (context, controller, child) {
            return Column(
              children: [
                Container(
                  height: sH * 0.3,
                  width: sW,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.bottomNavColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: sH * 0.12,
                        width: sW * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              controller.user?.imageUrl ?? '',
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(
                        height: sH * 0.01,
                      ),
                      txt(
                        controller.user?.name ?? 'Loading...',
                        size: sH * 0.02,
                      ),
                      SizedBox(
                        height: sH * 0.005,
                      ),
                      txt(
                        "Institute: Quest IAS",
                        size: sH * 0.012,
                        color: const Color.fromARGB(255, 74, 74, 74),
                      ),
                      SizedBox(
                        height: sH * 0.005,
                      ),
                      Container(
                        height: sH * 0.028,
                        width: sW * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.activeSVGBottomNavBar,
                        ),
                        child: Center(
                          child: txt(
                            controller.user?.plan.capitalize() ?? 'Loading...',
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: sH * 0.02,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            txt(
                              "Email: ${controller.user?.email ?? 'Loading...'}",
                            ),
                            txt(
                              "Phone: ${controller.user?.phone ?? 'Loading...'}",
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: sH * 0.02,
                ),
                ProfileSettingWidget(
                  sH: sH,
                  title: "Edit Profile",
                  routeToRedirect: "/editProfilePage",
                ),
                SizedBox(
                  height: sH * 0.02,
                ),
                ProfileSettingWidget(
                  sH: sH,
                  title: "Subscription Details",
                  routeToRedirect: "/subscriptionPage",
                ),
                SizedBox(
                  height: sH * 0.02,
                ),
              ],
            );
          })),
    );
  }
}
