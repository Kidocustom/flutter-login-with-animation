import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Job/Persistent/persistent.dart';

import 'package:login_app/Search/search_job.dart';
import 'package:login_app/Widgets/bottom_nav_bar.dart';
import 'package:login_app/Widgets/job_widgets.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobCategoryFilter;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Text(
              "Job Category",
              textAlign: TextAlign.center,
              style: GoogleFonts.sigmar(color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, Index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        jobCategoryFilter = Persistent.jobCategoryList[Index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print(
                          "jobCategoryList[Index], ${Persistent.jobCategoryList[Index]}");
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[Index],
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: Persistent.jobCategoryList.length,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    "Close",
                    style: GoogleFonts.acme(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    "Cancel Filter",
                    style: GoogleFonts.acme(color: Colors.white),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Scaffold(
            bottomNavigationBar: BottomNavAppBar(indexNum: 0),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    _showTaskCategoriesDialog(size: size);
                  },
                  icon: const Icon(
                    Icons.filter_list_sharp,
                    color: Colors.black,
                  )),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (c) => SearchJobs()));
                    },
                    icon: const Icon(
                      Icons.search_outlined,
                      color: Colors.black,
                    ))
              ],
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.deepOrange.shade400, Colors.blueAccent],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: const [0.2, 0.9])),
              ),
            ),
            body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("Jobs")
                    .where("JobCategory", isEqualTo: jobCategoryFilter)
                    .where("Recruitment", isEqualTo: true)
                    .orderBy("CreatedAt", descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.data?.docs.isNotEmpty == true) {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return JobWidget(
                            jobTitle: snapshot.data?.docs[index]["JobTitle"],
                            jobDescription: snapshot.data?.docs[index]
                                ["JobDescription"],
                            jobId: snapshot.data?.docs[index]["Job Id"],
                            uploadedBy: snapshot.data?.docs[index]
                                ["UploadedBy"],
                            userImage: snapshot.data?.docs[index]["UserImage"],
                            name: snapshot.data?.docs[index]["name"],
                            recriutment: snapshot.data?.docs[index]
                                ["Recritment"],
                            email: snapshot.data?.docs[index]["email"],
                            location: snapshot.data?.docs[index]["location"],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("There is no jobs"),
                      );
                    }
                  }
                  return Center(
                    child: Text("Something went wrong",
                        style: GoogleFonts.acme(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  );
                })));
  }
}
