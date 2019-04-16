import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String> upload(String name, int gallery) async {
  print("pressed");
  File img;
  if (gallery == 1)
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
  else
    img = await ImagePicker.pickImage(source: ImageSource.camera);
  if (img != null) {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(name)
        .child(img.path.split("/")[img.path.split("/").length - 1]);
    StorageUploadTask uploadTask = ref.putFile(img);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }
  return null;
}
