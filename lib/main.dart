import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:questias/pages/Base/base.dart';
import 'package:questias/pages/Books/sub_pages/add_book.dart';
import 'package:questias/pages/Books/sub_pages/view_book.dart';
import 'package:questias/pages/Home/Home.dart';
import 'package:questias/pages/Home/controller/ChatController.dart';
import 'package:questias/pages/Home/subPages/AllChatPage.dart';
import 'package:questias/pages/Home/subPages/ChatPage.dart';
import 'package:questias/pages/OnBoarding/OnBoarding.dart';
import 'package:questias/pages/OnBoarding/controller/OnBoardingController.dart';
import 'package:questias/pages/Profile/sub_pages/edit_profile_page.dart';
import 'package:questias/pages/Profile/sub_pages/subscription_page.dart';
import 'package:questias/pages/UserOnBoarding/CompleteProfile.dart';
import 'package:questias/pages/UserOnBoarding/Login.dart';
import 'package:questias/pages/UserOnBoarding/SignUp.dart';
import 'package:questias/pages/Welcome/Welcome.dart';
import 'package:questias/providers/book_provider.dart';
import 'package:questias/providers/category_provider.dart';
import 'package:questias/providers/subscription_provider.dart';
import 'package:questias/providers/user_provider.dart'; // Import the UserProvider
import 'package:questias/utils/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // print("loading env");
  await dotenv.load(fileName: ".env");
  // print("done env");
  // await FlutterSoundRecorder().openRecorder();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => OnBoardingController()),
      ChangeNotifierProvider(create: (_) => ChatController()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => BookProvider()),
      ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ChangeNotifierProvider(
          create: (_) => UserProvider()), // Add UserProvider here
      // Add other providers here
    ],
    child: DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on initialization
  }

  Future<void> _fetchUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // textTheme: TextTheme(
        //   titleMedium:
        // ),

        scaffoldBackgroundColor: AppColors.primaryColor,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: const Color(0xFF4362FF),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryButtonColor,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF4362FF),
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.primaryColor,
          hintStyle: const TextStyle(
            color: AppColors.primaryTextColor,
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // print("Error: ${snapshot.error}");
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            // print("User is logged in");
            return Base();
          }

          // print("User is not logged in");
          return OnBoardingPage();
        },
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/signUp':
            return MaterialPageRoute(builder: (_) => const SignUpPage());
          case '/completeProfile':
            return MaterialPageRoute(
                builder: (_) => const CompleteProfilePage());
          case '/welcome':
            return MaterialPageRoute(builder: (_) => const WelcomePage());
          case '/base':
            return MaterialPageRoute(builder: (_) => Base());
          case '/chat':
            return MaterialPageRoute(
                builder: (_) => const ChatPage(
                      chatId: "",
                    ));
          case '/allChat':
            return MaterialPageRoute(builder: (_) => const AllChatPage());
          case '/home':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/addBook':
            return MaterialPageRoute(builder: (_) => AddBooksPage());
          case '/viewBook':
            return MaterialPageRoute(
                builder: (_) => ViewPdf(
                      title: "Book",
                      pdfUrl:
                          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                    ));
          case '/subscriptionPage':
            return MaterialPageRoute(builder: (_) => SubscriptionPage());
          case '/editProfilePage':
            return MaterialPageRoute(builder: (_) => EditProfilePage());
          default:
            return null;
        }
      },
    );
  }
}
