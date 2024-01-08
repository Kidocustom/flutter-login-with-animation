import 'package:flutter/material.dart';
import 'package:login_app/Widgets/bottom_nav_bar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
          bottomNavigationBar: BottomNavAppBar(indexNum: 1),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Search screen"),
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
