import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class StoreData {
  Future<String> uploadImageToStorage(String userImages, Uint8List file) async {
    Reference ref = _storage.ref().child("userImages");
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot Snapshot = await uploadTask;
    String downloadUrl = await Snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
