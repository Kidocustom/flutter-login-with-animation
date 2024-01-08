import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalMethod {
  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Icon(
                  Icons.logout,
                  color: Colors.grey,
                  size: 35,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Error Occured",
                  ),
                )
              ],
            ),
            content: Text(
              error,
              style: GoogleFonts.acme(
                  color: Colors.black,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    "OK",
                    style: GoogleFonts.acme(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
