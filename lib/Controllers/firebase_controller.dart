import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  //upload files to firebase storage
  uploadImagetFirebase(String imagePath, String filename) async {
    await FirebaseStorage.instance
        .ref(filename)
        .putFile(File(imagePath))
        .then((taskSnapshot) async {
      print("task done");

      // download url when it is uploaded
      if (taskSnapshot.state == TaskState.success) {
        await FirebaseStorage.instance
            .ref(imagePath)
            .getDownloadURL()
            .then((url) {
          print("Here is the URL of Image $url");
          return url;
        }).catchError((onError) {
          print("Got Error $onError");
        });
      }
    });
  }

  uploadDocumentDetailsToFirebase(docData) async {
    //firebase collection reference
    final CollectionReference docs =
        FirebaseFirestore.instance.collection('docs');

    await docs.add(docData);
    print('details uploaded');
  }
}
