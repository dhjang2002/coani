// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';
import 'package:coani/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropAction extends StatefulWidget {
  final String title;
  const ImageCropAction({Key? key, required this.title}) : super(key: key);

  @override
  _ImageCropActionState createState() => _ImageCropActionState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ImageCropActionState extends State<ImageCropAction> {
  late AppState state;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
    _pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          actions: [
          IconButton( icon: const Icon(Icons.phonelink_erase),
            onPressed: () {
              _clearImage();
              _pickImage();
            }),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: imageFile != null ? Image.file(imageFile!) : Container(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            if (state == AppState.free) {
              _pickImage();
            } else if (state == AppState.picked) {
              _cropImage();
            } else if (state == AppState.cropped) {
              String path = "";
              path = imageFile!.path;
              Navigator.pop(context, path);
            }
          },
          child: _buildButtonIcon(),
        ),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free) {
      return const Icon(Icons.camera);
    } else if (state == AppState.picked) {
      return const Icon(Icons.crop);
    } else if (state == AppState.cropped) {
      return const Icon(Icons.save);
    } else {
      return Container();
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await cropImage(imageFile!);
    if (croppedFile != null) {
      imageFile = File(croppedFile.path);
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}