// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Services/global_variables.dart';
import 'package:login_app/login%20Page/login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _forgetPassTextController =
      TextEditingController(text: " ");

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 60));
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

  void _forgetPassSubmitForgetForm() async {
    try {
      await _auth.sendPasswordResetEmail(email: _forgetPassTextController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      CachedNetworkImage(
        imageUrl: forgetUrlimages,
        placeholder: (context, url) => Image.asset(
          "assets/images/three.png",
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        alignment: FractionalOffset(_animation.value, 0),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.016),
        child: ListView(children: [
          SizedBox(
            height: h * 0.1,
          ),
          Text(
            "Forget Password", //Daddy12345
            style: GoogleFonts.acme(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50),
          ),
          SizedBox(height: h * 0.010),
          Text(
            "Email Address",
            style: GoogleFonts.acme(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18),
          ),
          SizedBox(
            height: h * 0.020,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.010),
            child: TextField(
              controller: _forgetPassTextController,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white54,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
          ),
          SizedBox(
            height: h * 0.0660,
          ),
          MaterialButton(
            onPressed: () {
              _forgetPassSubmitForgetForm();
            },
            color: Colors.black,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: h * 0.014),
              child: Text(
                'Reset now',
                style: GoogleFonts.acme(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          )
        ]),
      )
    ]));
  }
}
