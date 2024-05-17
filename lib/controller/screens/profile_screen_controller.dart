import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreenController extends ChangeNotifier {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<void> changeProfilePic() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) {
      return;
    }
    String uid = currentUser?.uid ?? 'unknown';
    final storageRef = FirebaseStorage.instance.ref();
    final folderRef = storageRef.child('user_files');
    final userRef = folderRef.child(currentUser?.uid ?? 'unknown');
    final imageRef = userRef.child('$uid.jpg');
    await imageRef.putFile(File(xFile.path));
    await currentUser?.updatePhotoURL(
      await imageRef.getDownloadURL(),
    );
    log(currentUser?.photoURL ?? 'null');
    notifyListeners();
  }
}
