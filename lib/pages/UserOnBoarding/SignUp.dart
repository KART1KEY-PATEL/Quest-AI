import 'package:flutter/material.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "",
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              txt(
                "Hello there 👋",
                weight: FontWeight.w600,
                size: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              txt(
                "Please enter your email and password to create an",
                color: Colors.grey.shade400,
              ),
              txt(
                "account",
                color: Colors.grey.shade400,
              ),
              const SizedBox(
                height: 60,
              ),
              const TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.grey,
                  ),
                  labelText: 'Your Email',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF17C3CE)), // Change the underline color when not focused
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue), // Change the border color on focus
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const TextField(
                obscureText: true,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.grey,
                  ),
                  labelText: 'Create your Password',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF17C3CE)), // Change the underline color when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue), // Change the border color on focus
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: true,
                    checkColor: Colors.white,
                    activeColor: const Color(0xFF17C3CE),
                    onChanged: (bool? newValue) {},
                  ),
                  txt("I agree to ChatBot_AI"),
                  txt(
                    " Terms & Conditions",
                    color: const Color(0xFF17C3CE),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/completeProfile');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const CompleteProfilePage()),
                  // );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF17C3CE),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF17C3CE), // Shadow color
                        blurRadius: 10, // Spread radius
                        offset: Offset(0, 2), // Offset of the shadow
                      ),
                    ],
                  ),
                  height: 60,
                  width: double.infinity,
                  child: Center(
                    child: txt(
                      'Continue',
                      isBold: true,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Center(
              //   child: txt(
              //     "Forgot Password?",
              //     color: Color(0xFF17C3CE),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const SignInPage()),
                  // );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    txt("Already have an account"),
                    txt(
                      "  Sign In",
                      color: const Color(0xFF17C3CE),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Container(
                    height: 1.0,
                    width: 123.2,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  txt('or continue with',
                      color: Colors.grey.shade400, size: 14),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 1.0,
                    width: 123.2,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  height: 55,
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SizedBox(
                        height: 35,
                        width: 35,
                        child: Image.asset("assets/icons/google.png")),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
