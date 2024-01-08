import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Job/job_screen.dart';
import 'package:login_app/Job/upload_job.dart';
import 'package:login_app/Job/user_state.dart';
import 'package:login_app/Profile/profile.dart';
import 'package:login_app/Search/search_companies.dart';

class BottomNavAppBar extends StatelessWidget {
  int indexNum = 0;
  BottomNavAppBar({required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Sign Out",
                  style: GoogleFonts.acme(color: Colors.black, fontSize: 28),
                ),
              ),
            ),
            content: Text(
              "Do you want to Logout?",
              style: GoogleFonts.acme(color: Colors.black, fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.acme(color: Colors.black, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => UserState()));
                },
                child: Text(
                  "Confirm",
                  style: GoogleFonts.acme(color: Colors.purple, fontSize: 18),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return CurvedNavigationBar(
        color: Colors.deepPurple.shade400,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.deepPurple.shade500,
        height: h * 0.060,
        index: indexNum,
        items: const [
          Icon(
            Icons.list,
            size: 19,
            color: Colors.white,
          ),
          Icon(
            Icons.search,
            size: 19,
            color: Colors.white,
          ),
          Icon(
            Icons.add,
            size: 19,
            color: Colors.white,
          ),
          Icon(
            Icons.person_pin,
            size: 19,
            color: Colors.white,
          ),
          Icon(
            Icons.exit_to_app,
            size: 19,
            color: Colors.white,
          ),
        ],
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const JobScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Search()));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const UploadJobs()));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Profile()));
          } else if (index == 4) {
            _logout(context);
          }
        });
  }
}
