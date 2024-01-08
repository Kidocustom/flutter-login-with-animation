// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:http/http.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/Services/global_methods.dart';
import 'package:login_app/Services/global_variables.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUp> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _fullNameController =
      TextEditingController(text: "");
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passController = TextEditingController(text: "");
  final TextEditingController _phoneNumberController =
      TextEditingController(text: "");
  final TextEditingController _locationController =
      TextEditingController(text: "");

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _positionCPFocusNode = FocusNode();

  final _signUpFormKey = GlobalKey<FormState>();
  bool _obscureText = true;
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Please choose an option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: GoogleFonts.acme(color: Colors.purple),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGalery();
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Gallery",
                        style: GoogleFonts.acme(color: Colors.purple),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGalery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
            error: "please pick an image", ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim().toLowerCase(),
            password: _passController.text.trim());
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child("userImages")
            .child("$_uid.jpg");

        await ref.putFile(imageFile!);

        FirebaseFirestore.instance.collection("users").doc(_uid).set({
          "id": _uid,
          "name": _fullNameController.text,
          "email": _emailController.text,
          "user image": imageUrl,
          "phone Number": _phoneNumberController.text,
          "location": _locationController.text,
          "createdAt": Timestamp.now()
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        CachedNetworkImage(
          imageUrl: signUpUrlImages,
          placeholder: (context, url) => Image.asset(
            "assets/images/three.png",
            fit: BoxFit.fill,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: FractionalOffset(_animation.value, 0),
        ),
        Container(
          color: Colors.black54,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 80,
              ),
              child: ListView(
                children: [
                  Form(
                    key: _signUpFormKey,
                    child: Column(children: [
                      GestureDetector(
                          onTap: () {
                            _showImageDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: w * 0.24,
                              height: h * 0.13,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.purple.shade300),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: imageFile == null
                                      ? Icon(Icons.camera_enhance_sharp,
                                          color: Colors.purple.shade200,
                                          size: 30)
                                      : Image.file(
                                          imageFile!,
                                          fit: BoxFit.fill,
                                        )),
                            ),
                          )),
                      SizedBox(
                        height: h * 0.020,
                      ),
                      // Full Name
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is missing";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Full name /Company name",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500.withOpacity(0.5)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)))),
                      SizedBox(height: h * 0.020),
                      //Email
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains("@")) {
                              return "Please enter a valid email address";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500.withOpacity(0.5)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)))),
                      SizedBox(
                        height: h * 0.020,
                      ),
                      //Password
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_phoneNumberFocusNode),
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passController,
                          obscureText: !_obscureText,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return "Please enter a valid Password";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500.withOpacity(0.5)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)))),
                      SizedBox(height: h * 0.020),
                      //phone Number
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionCPFocusNode),
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is  missing";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500.withOpacity(0.5)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)))),
                      SizedBox(
                        height: h * 0.020,
                      ),
                      //Company Address
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionCPFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _locationController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is  missing";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Company Address",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500.withOpacity(0.5)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)))),
                      SizedBox(
                        height: h * 0.025,
                      ),
                      _isLoading
                          ? Center(
                              child: SizedBox(
                                width: w * 0.135,
                                height: h * 0.070,
                                child: const CircularProgressIndicator(
                                  color: Colors.purple,
                                ),
                              ),
                            )
                          : MaterialButton(
                              onPressed: () {
                                _submitFormOnSignUp();
                              },
                              color: Colors.purple.shade200,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: h * 0.014),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Sign Up",
                                        style: GoogleFonts.acme(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            ),
                      SizedBox(
                        height: h * 0.040,
                      ),
                      Center(
                          child: RichText(
                              text: TextSpan(children: [
                        TextSpan(
                            text: "Already have an account?",
                            style: GoogleFonts.acme(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        const TextSpan(text: "     "),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null,
                            text: "login",
                            style: GoogleFonts.acme(
                                color: Colors.purple.shade400,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))
                      ]))),
                    ]),
                  )
                ],
              )),
        )
      ]),
    );
  }
}
