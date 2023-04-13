import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadMedia(File file) async {
    Reference ref = _firebaseStorage.ref().child(
        "${DateTime.now().microsecondsSinceEpoch}.${file.path.split('.').last}");
    UploadTask uploadTask = ref.putFile(file);

    uploadTask.snapshotEvents.listen((event) {});

    return uploadTask.whenComplete(() async {
      String url = await ref.getDownloadURL();
    }).toString();
  }
}
