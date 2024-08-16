import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questias/providers/user_provider.dart';
import 'package:questias/services/BackendService.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/customTextField.dart';
import 'package:questias/utils/textUtil.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool checked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  BackendService backendService = BackendService();
  UserProvider userProvider = UserProvider();
  void onSubmit() async {
    await backendService.signUpWithEmailAndPassword(
      emailController.text,
      passwordController.text,
      nameController.text,
      userProvider,
    );
    // var userId = FirebaseAuth.instance.currentUser!.uid;
    // print("Is user logged in");
    // await backendService.addUserToFirestore(
    //   userId: userId,
    //   email: emailController.text,
    //   name: nameController.text,
    //   password: passwordController.text,
    // );
  }

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
              CustomTextField(
                hintText: "Enter your Name",
                controller: nameController,
                validate: true,
                maxLines: 1,
              ),
              SizedBox(
                height: 20,
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
                hintText: "Create your Password",
                controller: passwordController,
                validate: true,
                maxLines: 1,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Confirm your Password",
                controller: confirmPasswordController,
                validate: true,
                maxLines: 1,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: checked,
                    checkColor: Colors.white,
                    activeColor: const Color(0xFF17C3CE),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checked = newValue!;
                      });
                    },
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login");
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
                height: 20,
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
