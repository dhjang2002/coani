// ignore_for_file: non_constant_identifier_names, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:coani/Constants/HostInfo.dart';
import 'package:coani/Models/Files.dart';
import 'package:coani/Models/itemAttach.dart';
import 'package:coani/Questions/QTitle.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:coani/Utils/mediaView.dart';
import 'package:coani/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class CardAttach extends StatefulWidget {
  final String users_id;
  final List<ItemAttach> attachList;
  final Function(String tag, String attached) onUpdate;
  const CardAttach({
    Key? key,
    required this.users_id,
    required this.attachList,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<CardAttach> createState() => _CardAttachState();
}

class _CardAttachState extends State<CardAttach> {

  @override
  Widget build(BuildContext context) {
    return AttachCard();
  }

  Widget AttachCard() {
    final picHeight = MediaQuery.of(context).size.width * 4 / 6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 20, thickness: 2, color: Colors.grey[300]),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.attachList.length,
              itemBuilder: (context, index) {
                ItemAttach item = widget.attachList[index];
                String url = "";
                if(item.url.isNotEmpty) {
                  url = "$URL_IMAGE${item.url}";
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: item.title.isNotEmpty,
                        child: QTitle(
                          titles: item.title,
                          subTitle: item.subTitle,
                          titleColor: Colors.black,
                          subColor: Colors.black54,
                        )
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Text(item.label, style: const TextStyle(fontSize: 16, color: Colors.black),),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blueAccent,
                          ),
                          child: Text( (item.type=="V") ? "동영상촬영" : '사진촬영',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            if(item.type=="V") {
                              _takeVideo(item);
                            } else {
                              _takePicture(item);
                            }
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blueAccent,
                          ),
                          child: Text( (item.type=="V") ? "동영상선택" : '사진선택',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            if(item.type=="V") {
                              _pickupVideo(item);
                            } else {
                              _pickupPicture(item);
                            }
                          },
                        )
                      ],
                    ),
                    Visibility(
                        visible: true,
                        child: SizedBox(
                          width: double.infinity,
                          height: picHeight,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Container(
                                      width: double.infinity,
                                      height: picHeight,
                                      color: Colors.grey,
                                      child: _showPict(url, item.bProgress)
                                  )
                              ),
                              Positioned(
                                  child: Visibility(
                                      visible: item.bProgress,
                                      child: Container(
                                          width: double.infinity,
                                          height: picHeight,
                                          color: Colors.transparent,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                      ))
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                );
              }),
        )
      ],
    );
  }

  Widget _showPict(String url, bool bProgress) {
    if(url.isEmpty || bProgress) {
      return Container(
        color: Colors.grey,
        child: Icon(Icons.photo, size: 80, color:Colors.grey[350]),
      );
    }

    String ext = getExtFromPath(url).toUpperCase();
    //print(" ext===> $ext");
    String showUrl = url;//'${url}?random=${DateTime.now().millisecondsSinceEpoch}';
    if(ext=="MP4") {
      return MediaView(isMovie: true, sourceUrl: showUrl,);
    }
    return Image.network(showUrl, fit: BoxFit.fitWidth,);
  }

  Future <void> _takeVideo(ItemAttach item) async {
    var pickedMovie = await ImagePicker.platform.getVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 60));

    setState(() {item.bProgress = true;});
    if (pickedMovie != null) {
      showToastMessage("동영상 파일을 최적화 하는 중입니다.\n최대 용량은 최적화 후 99MB 입니다.\n파일 용량에 따라 몇분이 소요됩니다.", );
      MediaInfo? result = await VideoCompress.compressVideo(
        pickedMovie.path,
        deleteOrigin: false,
        quality: VideoQuality.MediumQuality,
      );

      if (result != null && result.path != null) {
        await Remote.reqFile(filePath:result.path!,
            params: {
              "command":"ADD",
              "users_id": widget.users_id.toString(),
              "photo_type": "Q",
            },
            onUpload: (int status, Files result) {
              if(status==1) {
                widget.onUpdate(item.tag, result.url.toString());
              }
            }
        );
      }
    }
    setState(() {item.bProgress = false;});
  }

  Future <void> _takePicture(ItemAttach item) async {
    var image = await ImagePicker.platform.pickImage(
        maxHeight: 1024,
        maxWidth: 1024,
        imageQuality: 90,
        source: ImageSource.camera);

    if (image != null) {

      setState(() {
        item.bProgress = true;
      });

      File rotatedImage = await FlutterExifRotation.rotateImage(path: image.path);

      await Remote.reqFile(
          filePath: rotatedImage.path,
          //filePath: image.path,
          params: {
            "command": "ADD",
            "users_id": widget.users_id.toString(),
            "photo_type": "Q",
          },
          onUpload: (int status, Files result) {
            if (status == 1) {
              widget.onUpdate(item.tag, result.url.toString());
            }
          }
      );

      setState(() {
        item.bProgress = false;
      });
    }
  }

  Future <void> _pickupPicture(ItemAttach item) async {
    File? pick = await pickupImage();

    if (pick != null) {
      setState(() {
        item.bProgress = true;
      });

      String ext = getExtFromPath(pick.path).toUpperCase();
      if (ext == "PNG" || ext == "JPG" || ext == "JPEG") {
        pick = await FlutterExifRotation.rotateImage(path: pick.path);
      }

      await Remote.reqFile(
          filePath: pick.path,
          params: {
            "command": "ADD",
            "users_id": widget.users_id.toString(),
            "photo_type": "Q",
          },
          onUpload: (int status, Files result) async {
            if (status == 1) {
              widget.onUpdate(item.tag, result.url.toString());
            }
          }
      );
      setState(() {
        item.bProgress = false;
      });
    }
  }

  Future <void> _pickupVideo(ItemAttach item) async {
    var pickedMovie = await pickupVideo();
    setState(() {item.bProgress = true;});
    if (pickedMovie != null) {
      showToastMessage("동영상 파일을 최적화 하는 중입니다.\n최대 용량은 최적화 후 99MB 입니다.\n파일 용량에 따라 몇분이 소요됩니다.");
      MediaInfo? result = await VideoCompress.compressVideo(
        pickedMovie.path,
        deleteOrigin: false,
        quality: VideoQuality.MediumQuality,
      );
      if (result != null && result.path != null) {
        await Remote.reqFile(filePath:result.path!,
            params: {
              "command":"ADD",
              "users_id": widget.users_id.toString(),
              "photo_type": "Q",
            },
            onUpload: (int status, Files result) {
              if(status==1) {
                widget.onUpdate(item.tag, result.url.toString());
              }
            }
        );
      }
    }
    setState(() {item.bProgress = false;});
  }
}
