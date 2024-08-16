import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:questias/pages/Books/Book.dart';
import 'package:questias/pages/Books/sub_pages/add_book.dart';
import 'package:questias/pages/Home/Home.dart';
import 'package:questias/pages/Home/subPages/AllChatPage.dart';
import 'package:questias/pages/Profile/profile_page.dart';
import 'package:questias/pages/Profile/sub_pages/subscription_page.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customNavBar.dart';

class Base extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            // screen: HomePage(),
            // screen: ProfilePage(),
            screen: SubscriptionPage(),

            // screen: AllChatPage(),
            item: ItemConfig(
              icon: Icon(
                Icons.question_answer,
                size: 28,
              ),
              title: "Chat",
            ),
          ),
          PersistentTabConfig(
            screen: BookPage(),
            item: ItemConfig(
              icon: Icon(
                Icons.library_books,
                size: 28,
              ),
              title: "Books",
            ),
          ),
          PersistentTabConfig(
            screen: ProfilePage(),
            item: ItemConfig(
              icon: Icon(
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
