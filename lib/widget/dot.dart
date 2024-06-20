import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/OnBoarding/controller/OnBoardingController.dart';

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    int selected = 2;
    return Consumer<OnBoardingController>(
        builder: (context, controller, child) {
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => SizedBox(
          width: 10,
        ),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: controller.pageIndex == index ? 30 : 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: controller.pageIndex == index
                  ? BorderRadius.circular(20)
                  : BorderRadius.circular(10),
            ),
          );
        },
        itemCount: 3,
      );
    });
  }
}

class NextArrow extends StatefulWidget {
  final double progress;

  const NextArrow({super.key, required this.progress});

  @override
  State<NextArrow> createState() => _NextArrowState();
}

class _NextArrowState extends State<NextArrow> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(NextArrow oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.value = widget.progress;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            color: Colors.white,
            value: controller.value,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.all(5),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
