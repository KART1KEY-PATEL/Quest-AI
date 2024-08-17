// // import 'package:flutter/material.dart';
// // import 'package:loading_animation_widget/loading_animation_widget.dart';
// // import 'package:questias/utils/color.dart';
// // import 'package:simple_ripple_animation/simple_ripple_animation.dart';

// // class TestPage extends StatelessWidget {
// //   const TestPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     double sW = MediaQuery.of(context).size.width;
// //     double sH = MediaQuery.of(context).size.height;
// //     return Scaffold(
// //       body: Center(
// //         child: RippleAnimation(
// //           color: AppColors.primaryButtonColor,
// //           delay: const Duration(milliseconds: 300),
// //           repeat: true,
// //           minRadius: 75,
// //           ripplesCount: 6,
// //           duration: const Duration(milliseconds: 6 * 300),
// //           child: CircleAvatar(
// //             minRadius: sH * 0.05,
// //             maxRadius: sH * 0.05,
// //             // cos
// //             backgroundColor: AppColors.primaryButtonColor,
// //             child: Icon(
// //               Icons.mic,
// //               size: sH * 0.04,
// //               color: AppColors.whiteTextColor,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //     // return Scaffold(
// //     //   body: Center(
// //     //     child: Container(
// //     //       height: sH * 0.04,
// //     //       width: sW * 0.2,
// //     //       decoration: BoxDecoration(
// //     //         color: AppColors.primaryButtonColor,
// //     //         borderRadius: BorderRadius.only(
// //     //           topLeft: Radius.circular(10),
// //     //           topRight: Radius.circular(10),
// //     //           bottomRight: Radius.circular(10),
// //     //         ),
// //     //       ),
// //     //       padding: EdgeInsets.symmetric(
// //     //         horizontal: sH * 0.025,
// //     //         vertical: sH * 0.015,
// //     //       ),
// //     //       child: LoadingAnimationWidget.prograssiveDots(
// //     //         color: AppColors.whiteTextColor,
// //     //         size: 40,
// //     //       ),
// //     //     ),
// //     //   ),
// //     // );
// //   }
// // }

// // //  Consumer<ChatController>(
// // //                     builder: (context, controller, child) {
// // //                       return controller.isLoading
// // //                           ? Align(
// // //                               alignment: Alignment.centerLeft,
// // //                               child: Container(
// // //                                 height: sH * 0.04,
// // //                                 width: sW * 0.2,
// // //                                 decoration: BoxDecoration(
// // //                                   color: AppColors.primaryButtonColor,
// // //                                   borderRadius: BorderRadius.only(
// // //                                     topLeft: Radius.circular(10),
// // //                                     topRight: Radius.circular(10),
// // //                                     bottomRight: Radius.circular(10),
// // //                                   ),
// // //                                 ),
// // //                                 padding: EdgeInsets.symmetric(
// // //                                   horizontal: sH * 0.025,
// // //                                   vertical: sH * 0.015,
// // //                                 ),
// // //                                 child: LoadingAnimationWidget.prograssiveDots(
// // //                                   color: AppColors.whiteTextColor,
// // //                                   size: 40,
// // //                                 ),
// // //                               ),
// // //                             )
// // //                           : SizedBox.shrink();
// // //                     },
// // //                   ),
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:async';

// class VoiceAnimatedContainer extends StatefulWidget {
//   @override
//   _VoiceAnimatedContainerState createState() => _VoiceAnimatedContainerState();
// }

// class _VoiceAnimatedContainerState extends State<VoiceAnimatedContainer> {
//   FlutterSoundRecorder? _recorder;
//   double _currentAmplitude = 0.0;
//   StreamSubscription? _recorderSubscription;
//     // AudioSource audioSource = AudioSource.defaultSource;
//   @override
//   void initState() {
//     super.initState();
//     _initializeRecorder();
//   }

//   Future<void> _initializeRecorder() async {
//     _recorder = FlutterSoundRecorder();

//     await _recorder!.openRecorder(); // Only open the recorder here

//     // Request microphone permission
//     if (await Permission.microphone.request().isGranted) {
//       await _recorder!.startRecorder(
//         codec: Codec.pcm16,
//         numChannels: 1,
//         sampleRate: 44100,
//         // audioSource: ,
//       );

//       _recorderSubscription = _recorder!.onProgress!.listen((event) {
//         if (event != null && event.decibels != null) {
//           setState(() {
//             _currentAmplitude =
//                 (event.decibels! + 160) / 160; // Normalized amplitude (0-1)
//           });
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _recorderSubscription?.cancel();
//     _recorder!.closeRecorder();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Voice Animated Container'),
//       ),
//       body: Center(
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 100),
//           width: _currentAmplitude * 200 + 100,
//           height: _currentAmplitude * 200 + 100,
//           decoration: BoxDecoration(
//             color: Colors.blueAccent,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Center(
//             child: Text(
//               'Speak Now',
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
