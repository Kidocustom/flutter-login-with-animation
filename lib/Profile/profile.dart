import 'package:flutter/material.dart';

import '../Widgets/bottom_nav_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
          bottomNavigationBar: BottomNavAppBar(indexNum: 3),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Profile screen"),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.deepOrange.shade400, Colors.blueAccent],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: const [0.2, 0.9])),
            ),
          )),
    );
  }
}
