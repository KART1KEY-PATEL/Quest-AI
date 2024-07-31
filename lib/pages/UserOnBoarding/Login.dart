import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questias/services/BackendService.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/customTextField.dart';
import 'package:questias/utils/textUtil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  BackendService backendService = BackendService();
  bool isLoading = false;

  void onSubmit() async {
    setState(() {
      isLoading = true;
    });
    bool response = await backendService.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );
    setState(() {
      isLoading = false;
    });

    (response)
        ? Navigator.pushNamed(context, "/base")
        : SnackBar(
            content: txt(
            "Error in the login",
          ));
  }

  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double sW = MediaQuery.of(context).size.height;
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
                "Welcome Back 👋",
                weight: FontWeight.w600,
                size: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: txt(
                  "Please enter your email and password log back in",
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              CustomTextField(
                hintText: "Enter your Email",
                controller: emailController,
                validate: true,
                maxLines: 1,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter your Password",
                controller: passwordController,
                validate: true,
                maxLines: 1,
              ),
              SizedBox(
                height: sH * 0.1,
              ),
              InkWell(
                onTap: () {
                  onSubmit();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF17C3CE),
                    borderRadius: BorderRadius.circular(10),
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
                    child: isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          )
                        : txt(
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/signUp");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    txt("Do not have an account?"),
                    txt(
                      "  Sign Up",
                      color: const Color(0xFF17C3CE),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: sH * 0.24,
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
