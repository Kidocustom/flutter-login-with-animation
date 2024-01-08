import 'package:flutter/material.dart';

class SearchJobs extends StatefulWidget {
  const SearchJobs({super.key});

  @override
  State<SearchJobs> createState() => _SearchJobsState();
}

class _SearchJobsState extends State<SearchJobs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepOrange.shade400, Colors.blueAccent],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [0.2, 0.9])),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Search Job Screen"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrange.shade400, Colors.blueAccent],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: const [0.2, 0.9])),
          ),
        ),
      ),
    );
  }
}
