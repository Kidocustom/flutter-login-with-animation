// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Job/Persistent/persistent.dart';
import 'package:login_app/Services/global_methods.dart';
import 'package:login_app/Services/global_variables.dart';
import 'package:uuid/uuid.dart';

import '../Widgets/bottom_nav_bar.dart';

class UploadJobs extends StatefulWidget {
  const UploadJobs({super.key});

  @override
  State<UploadJobs> createState() => _UploadJobsState();
}

class _UploadJobsState extends State<UploadJobs> {
  final TextEditingController _jobCategoryController =
      TextEditingController(text: "Select Job category");

  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _deadlineDateController =
      TextEditingController(text: "Job Deadline Date");

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadLineDateTimeStamp;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _deadlineDateController.dispose();
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textFormFields(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Value is missing";
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(color: Colors.white),
          maxLines: valueKey == "JobDescription" ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.black54,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

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
                        _jobCategoryController.text =
                            Persistent.jobCategoryList[Index];
                      });
                      Navigator.pop(context);
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
                    "Cancel",
                    style: GoogleFonts.acme(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _deadlineDateController.text =
            "${picked!.year} - ${picked!.month}- ${picked!.day}";
        deadLineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async {
    final jobId = Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_deadlineDateController.text == "choose job deadline date" ||
          _jobCategoryController.text == "choose job category") {
        GlobalMethod.showErrorDialog(
            error: "please pick everything", ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection("Jobs").doc(jobId).set({
          "Job Id": jobId,
          "UploadedBy ": _uid,
          "email": user.email,
          "JobTitle": _jobTitleController.text,
          "JobDescription": _jobDescriptionController.text,
          "deadlineDate": _deadlineDateController.text,
          "deadlineDatetIMEStamp": deadLineDateTimeStamp,
          "JobCategory": _jobCategoryController.text,
          "JobComments": [],
          "Recritment": true,
          "CreatedAt": Timestamp.now(),
          "name": name,
          "UserImage": userImage,
          "location": location,
          "applicants": 0
        });
        await Fluttertoast.showToast(
            msg: "The task has been Uploaded",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 18);
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = "Choose job Category";
          _deadlineDateController.text = "Choose job Deadline date";
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("It is not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavAppBar(indexNum: 2),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h * 0.010,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please fill all fields",
                          style: GoogleFonts.sigmar(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.010,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black38,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textTitles(label: "Job Caegory :"),
                              _textFormFields(
                                  valueKey: "Job Category",
                                  controller: _jobCategoryController,
                                  enabled: false,
                                  fct: () {
                                    _showTaskCategoriesDialog(size: size);
                                  },
                                  maxLength: 100),
                              _textTitles(label: "Job Title :"),
                              _textFormFields(
                                  valueKey: "JobTitle",
                                  controller: _jobTitleController,
                                  enabled: true,
                                  fct: () {},
                                  maxLength: 100),
                              _textTitles(label: "Job Description :"),
                              _textFormFields(
                                  valueKey: "JobDescription",
                                  controller: _jobDescriptionController,
                                  enabled: true,
                                  fct: () {},
                                  maxLength: 100),
                              _textTitles(label: "Job Deadline Date :"),
                              _textFormFields(
                                  valueKey: "Deadline",
                                  controller: _deadlineDateController,
                                  enabled: false,
                                  fct: () {
                                    _pickDateDialog();
                                  },
                                  maxLength: 100),
                            ]),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : MaterialButton(
                                  onPressed: () {
                                    _uploadTask();
                                  },
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                  elevation: 8,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: h * 0.014),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Post Now",
                                          style: GoogleFonts.sigmar(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: w * 0.009,
                                        ),
                                        const Icon(
                                          Icons.upload_file_rounded,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
