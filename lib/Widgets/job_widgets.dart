import 'package:flutter/material.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recriutment;
  final String location;
  final String email;

  const JobWidget(
      {super.key,
      required this.jobTitle,
      required this.jobDescription,
      required this.jobId,
      required this.uploadedBy,
      required this.userImage,
      required this.name,
      required this.recriutment,
      required this.location,
      required this.email});

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: w * 0.010, vertical: h * 0.008),
      child: ListTile(
        onTap: () {},
        onLongPress: () {},
        contentPadding:
            EdgeInsets.symmetric(horizontal: w * 0.020, vertical: h * 0.010),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration:
              const BoxDecoration(border: Border(right: BorderSide(width: 1))),
          child: Image.network(
            widget.userImage,
          ),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
            SizedBox(
              height: h * 0.008,
            ),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
