import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/OnBoarding/controller/OnBoardingController.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:questias/widget/dot.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _pages = [
    const Onboarding(
      title: "Introduction to Quest AI",
      description:
          "Meet Chatbot, your personal AI language model & discover the benefits of using Chatbot_AI for language tasks",
      imageAsset: "assets/images/onboarding_1.png",
    ),
    const Onboarding(
      title: "Explore categories of all topics",
      description:
          "Ask question to chatbot_AI with help of different categories and get answer that you want.",
      imageAsset: "assets/images/onboarding_2.png",
    ),
    const Onboarding(
      title: "Getting started with Quest AI",
      description: "Try out different language tasks and modes. ",
      imageAsset: "assets/images/onboarding_3.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF17C3CE),
              Color(0xFF02969F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: sH * 0.07,
              left: sW * 0.08,
              right: 0,
              child: Container(
                height: 10,
                width: 30,
                child: const Dot(),
              ),
            ),
            Consumer<OnBoardingController>(
              builder: (context, controller, child) {
                return PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    controller.changePageIndex(index);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _pages[index];
                  },
                );
              },
            ),
            Consumer<OnBoardingController>(
              builder: (context, controller, child) {
                return Positioned(
                  bottom: sH * 0.04,
                  right: sW * 0.08,
                  child: InkWell(
                    onTap: () {
                      if (_pageController.page!.toInt() < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pushNamed(context, '/signUp');
                      }
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      child: NextArrow(
                        progress: controller.pageIndex == 0
                            ? 0.3
                            : controller.pageIndex == 1
                                ? 0.6
                                : 1.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Onboarding extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;

  const Onboarding({
    required this.title,
    required this.description,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
          top: sH * 0.18, bottom: sH * 0.15, left: sW * 0.06, right: sW * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: sH * 0.4,
            width: sH * 0.4,
            child: Image.asset(
              imageAsset,
            ),
          ),
          SizedBox(height: sH * 0.0),
          txt(
            title,
            size: sW * 0.08,
            weight: FontWeight.w600,
            color: Colors.white,
          ),
          SizedBox(
            height: sH * 0.02,
          ),
          txt(
            description,
            color: Colors.white,
            size: sW * 0.04,
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }
}
