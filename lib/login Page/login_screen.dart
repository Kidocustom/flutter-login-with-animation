// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Forget%20Password/forget_password_screen.dart';
import 'package:login_app/Services/global_methods.dart';
import 'package:login_app/Services/global_variables.dart';
import 'package:login_app/Signup%20Page/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _emailTextController =
      TextEditingController(text: "");
  final TextEditingController _passTextController =
      TextEditingController(text: "");

  final FocusNode _passFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginformKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
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

  void _submitFormOnLogin() async {
    final isValid = _loginformKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim());
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print("error occured $error");
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
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImages,
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
          Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
              color: Colors.black54,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  Form(
                    key: _loginformKey,
                    child: Column(
                      children: [
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    color:
                                        Colors.grey.shade500.withOpacity(0.5)),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red)))),
                        SizedBox(
                          height: h * 0.005,
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _passFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passTextController,
                            obscureText:
                                !_obscureText, // will change it dynamically,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return "please enter a valid password";
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color:
                                        Colors.grey.shade500.withOpacity(0.5)),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red)))),
                        SizedBox(height: h * 0.015),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPassword()));
                            },
                            child: Text(
                              "Forget Password?",
                              style: GoogleFonts.acme(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.010,
                        ),
                        _isLoading
                            ? Center(
                                child: SizedBox(
                                  width: w * 0.135,
                                  height: h * 0.070,
                                  child: const CircularProgressIndicator(
                                      color: Colors.purple),
                                ),
                              )
                            : MaterialButton(
                                onPressed: _submitFormOnLogin,
                                color: Colors.purple.shade200,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Login",
                                        style: GoogleFonts.acme(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: h * 0.04,
                        ),
                        Center(
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "Don't you have an account?",
                                style: GoogleFonts.acme(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignUp(),
                                        ),
                                      ),
                                text: "   SignUp",
                                style: GoogleFonts.acme(
                                    color: Colors.purple.shade400,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))
                          ])),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
