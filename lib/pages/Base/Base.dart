import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:questias/pages/Books/Book.dart';
import 'package:questias/pages/Home/Home.dart';
import 'package:questias/pages/Profile/profile_page.dart';
import 'package:questias/utils/color.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  bool isLoading = true;
  bool isCompany = false;
  final List _screens = [
    // HomePage(),
    const ProfilePage(),
    BookPage(),
    const ProfilePage(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.primaryBottomNavBar,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.activeSVGBottomNavBar,
          unselectedItemColor: AppColors.inactiveSVGBottomNavBar,
          selectedLabelStyle: const TextStyle(
            color: AppColors.activeSVGBottomNavBar,
          ),
          unselectedLabelStyle: const TextStyle(
            color: AppColors.inactiveSVGBottomNavBar,
          ),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.question_answer,
                size: 28,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
                size: 28,
              ),
              label: 'Books',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 28,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
