import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:questias/pages/Books/Book.dart';
import 'package:questias/pages/Home/Home.dart';
import 'package:questias/pages/Profile/profile_page.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customNavBar.dart';

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            // screen: SpeechRecognitionPage(
            //   chatId: "",
            // ),
            screen: HomePage(),
            // screen: SavedChatPage(),
            item: ItemConfig(
              icon: const Icon(
                Icons.question_answer,
                size: 28,
              ),
              title: "Chat",
            ),
          ),
          PersistentTabConfig(
            screen: BookPage(),
            item: ItemConfig(
              icon: const Icon(
                Icons.library_books,
                size: 28,
              ),
              title: "Books",
            ),
          ),
          PersistentTabConfig(
            screen: const ProfilePage(),
            item: ItemConfig(
              icon: const Icon(
                Icons.bookmark_border,
                size: 28,
              ),
              title: "Saved",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => CustomNavBar(
          navBarDecoration: const NavBarDecoration(
            color: AppColors.primaryBottomNavBar,
            padding: EdgeInsets.only(
              top: 8,
              bottom: 2,
            ),
          ),
          navBarConfig: navBarConfig,
        ),
      ),
    );
  }
}
