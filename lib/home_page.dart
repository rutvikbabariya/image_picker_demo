import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Image Picker',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: MaterialButton(
                color: Colors.blue,
                child: const Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  checkPermission();
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            if (image != null) Image.file(File(image!.path))
          ],
        ),
      ),
    );
  }

  checkPermission() async {
    PermissionStatus status = await Permission.storage.status;
    log(status.toString());
    if (status == PermissionStatus.denied || status == PermissionStatus.limited) {
      Permission.storage.request().then(
        (value) {
          if (value == PermissionStatus.granted) {
            pickImage();
          }
        },
      );
    } else if (status == PermissionStatus.granted) {
      pickImage();
    } else if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
      openAppSettings();
    }
  }

  pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        image = value;
        setState(() {});
      }
    });
  }
}
