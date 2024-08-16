import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:questias/providers/user_provider.dart';
import 'package:questias/services/BackendService.dart';
import 'package:questias/utils/color.dart';
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
  TextEditingController phoneController = TextEditingController();

  BackendService backendService = BackendService();
  UserProvider userProvider = UserProvider();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  void onSubmit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    String? imageUrl;
    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${DateTime.now()}.jpg');
      await storageRef.putFile(_image!);
      imageUrl = await storageRef.getDownloadURL();
    }
    await backendService.signUpWithEmailAndPassword(
      emailController.text,
      passwordController.text,
      nameController.text,
      userProvider,
      phoneController.text,
      imageUrl ?? "",
    );
    Navigator.pop(context);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/base', (Route<dynamic> route) => false);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
                height: 10,
              ),
              InkWell(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      height: sH * 0.14,
                      width: sW * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage(
                                    "assets/images/default_profile.png"),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: sH * 0.001,
                      right: sW * 0.14,
                      child: Container(
                        height: sH * 0.03,
                        width: sH * 0.03,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryButtonColor,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: sH * 0.02,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: sH * 0.02,
              ),
              CustomTextField(
                hintText: "Enter your Name",
                controller: nameController,
                validate: true,
                maxLines: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter your Email",
                controller: emailController,
                validate: true,
                maxLines: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Create your Password",
                controller: passwordController,
                validate: true,
                maxLines: 1,
              ),
              const SizedBox(
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
                onTap: onSubmit,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
