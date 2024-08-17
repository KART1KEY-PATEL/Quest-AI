import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:questias/providers/user_provider.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/customTextField.dart';
import 'package:questias/utils/textUtil.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String imageUrl = "";
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    nameController.text = userProvider.user!.name;
    emailController.text = userProvider.user!.email;
    phoneController.text = userProvider.user!.phone;
    imageUrl = userProvider.user!.imageUrl;
    super.initState();
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

  void onSubmit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    String? updatedImageUrl;
    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${nameController.text}${DateTime.now()}.jpg');
      await storageRef.putFile(_image!);
      updatedImageUrl = await storageRef.getDownloadURL();
    }

    // Get the current user ID from the provider or authentication
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user!.id; // Assuming you have user ID stored

    // Create a map of the updated data
    Map<String, dynamic> updatedData = {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      if (updatedImageUrl != null) "imageUrl": updatedImageUrl,
    };

    // Update the Firestore document
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(updatedData)
        .then((_) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/base', (Route<dynamic> route) => false);
    }).catchError((error) {
      // Handle any errors here
      print("Failed to update user: $error");
      Navigator.of(context).pop(); // Close the loading dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double sW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,            color: AppColors.backButtonColor,
),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: "Edit Profile",
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: sH * 0.12,
                          width: sW * 0.5,
                          decoration: BoxDecoration(
                            image: _image != null
                                ? DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: sW * 0.09,
                          child: Container(
                            height: sH * 0.04,
                            width: sW * 0.1,
                            decoration: BoxDecoration(
                              color: AppColors.primaryButtonColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
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
                    hintText: "Name",
                    controller: nameController,
                    validate: true,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: sH * 0.02,
                  ),
                  CustomTextField(
                    hintText: "Email",
                    controller: emailController,
                    validate: true,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: sH * 0.02,
                  ),
                  CustomTextField(
                    hintText: "Phone",
                    controller: phoneController,
                    validate: true,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: sH * 0.02,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: sW * 0.96,
        height: sH * 0.06,
        child: ElevatedButton(
          onPressed: () {
            onSubmit();
          },
          child: txt(
            "Save",
            size: 20,
            weight: FontWeight.w600,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryButtonColor,
            // primary: AppColors.primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
