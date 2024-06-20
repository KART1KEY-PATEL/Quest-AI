import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Base/Base.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/subPages/ChatPage.dart';
import 'package:questias/pages/OnBoarding/OnBoarding.dart';
import 'package:questias/pages/OnBoarding/controller/OnBoardingController.dart';
import 'package:questias/pages/UserOnBoarding/CompleteProfile.dart';
import 'package:questias/pages/UserOnBoarding/Login.dart';
import 'package:questias/pages/UserOnBoarding/SignUp.dart';
import 'package:questias/pages/Welcome/Welcome.dart';
import 'package:questias/utils/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute = await determineInitialRoute();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => OnBoardingController()),
      ChangeNotifierProvider(create: (_) => ChatController()),
      // Add other providers here
    ],
    child: DevicePreview(
      enabled: false,
      builder: (context) => MyApp(initialRoute: initialRoute),
    ),
  ));
}

Future<String> determineInitialRoute() async {
  return '/';
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryColor,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: const Color(0xFF4362FF),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF4362FF),
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.primaryColor,
          hintStyle: const TextStyle(
            color: Color(0xFF5A5A5A),
            fontSize: 14.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.primaryButtonColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.primaryButtonColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.primaryButtonColor,
            ),
          ),
          labelStyle: const TextStyle(color: Color(0xFFFFFFFF)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A24),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 0, 0, 0),
          selectionColor: Color(0xFF4362FF),
          selectionHandleColor: Color(0xFF4362FF),
        ),
        fontFamily: 'PlusJakartaSans',
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final phoneNumber = settings.arguments as String;
          // return MaterialPageRoute(
          //   builder: (context) => OTPPage(phoneNumber: phoneNumber),
          // );
        }
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => Base());
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case '/signUp':
            return MaterialPageRoute(builder: (_) => SignUpPage());
          case '/completeProfile':
            return MaterialPageRoute(builder: (_) => CompleteProfilePage());
          case '/welcome':
            return MaterialPageRoute(builder: (_) => WelcomePage());
          case '/base':
            return MaterialPageRoute(builder: (_) => Base());
          case '/chat':
            return MaterialPageRoute(builder: (_) => ChatPage());
          default:
            return null;
        }
      },
    );
  }
}
