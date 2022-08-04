import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _selectedImage == null
                ? Container(
                    child: Text('please select an image'),
                  )
                : Container(
                    child: Image.file(File(_selectedImage!.path)),
                  ),
            ElevatedButton(
                onPressed: () async {
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _selectedImage = image;
                  });

                  //TODO: pick an image
                },
                child: Text('select image')),
            ElevatedButton(
                onPressed: () {
                  uploadImage(File(_selectedImage!.path));
                  //TODO: upload the image to firebase storage
                },
                child: Text('upload the image')),
          ],
        ),
      ),
    );
  }

  uploadImage(File file) {
    //TODO: userImages/something.jpg
    final storageRef = FirebaseStorage.instance.ref();

    // Create a child reference
// imagesRef now points to "images"
    final imagesRef = storageRef.child("userImages");

    imagesRef.putFile(file);

// Child references can also take paths
// spaceRef now points to "images/space.jpg
// imagesRef still points to "images"
    final spaceRef = storageRef.child("userImages/space.jpg");
  }
}
