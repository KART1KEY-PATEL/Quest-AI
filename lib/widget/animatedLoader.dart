import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({super.key});

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader> {
  double _height1 = 50.0;
  double _height2 = 50.0;
  double _height3 = 50.0;
  bool _increasing = true;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_increasing) {
          _height1 += 20;
          _height2 += 30;
          _height3 += 40;
          if (_height1 >= 150 || _height2 >= 150 || _height3 >= 150) {
            _increasing = false;
          }
        } else {
          _height1 -= 20;
          _height2 -= 30;
          _height3 -= 40;
          if (_height1 <= 50 || _height2 <= 50 || _height3 <= 50) {
            _increasing = true;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 50,
          height: _height1,
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 50,
          height: _height2,
          color: Colors.red,
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 50,
          height: _height3,
          color: Colors.green,
        ),
      ],
    );
  }
}
