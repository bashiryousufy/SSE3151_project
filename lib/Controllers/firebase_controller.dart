import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //upload files to firebase storage
  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await _storage.ref('/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
