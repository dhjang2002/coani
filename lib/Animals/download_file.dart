// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:coani/Animals/pdf_viewer.dart';
import 'package:coani/Utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';

class DownloadFile extends StatefulWidget {
  DownloadFile({Key? key, this.url}) : super(key: key);
  String? url;

  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State {
  //var imageUrl =
   //   "https://www.itl.cat/pngfile/big/10-100326_desktop-wallpaper-hd-full-screen-free-download-full.jpg";

  var imageUrl =
      "http://211.175.164.71/data/file/report/1889929298_lHb8uikx_c6f725d752871a270687568fdf7fba915a32690c.pdf";
  bool downloading = true;
  String downloadingStr = "No data";
  String savePath = "";

  @override
  void initState() {
    super.initState();
    downloadFile(imageUrl, "test.pdf");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.pink),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Download File"),
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: downloading
              ? SizedBox(
            height: 250,
            width: 250,
            child: Card(
              color: Colors.pink,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    downloadingStr,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
              : SizedBox(
            height: 250,
            width: 250,
            child: Center(
              child: Image.file(
                File(savePath),
                height: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future downloadFile(String srcUrl, String fileName) async {
    try {
      Dio dio = Dio();
      //String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
      savePath = await getFilePath(fileName);

      if (kDebugMode) {
        print("downloadFile():savePath=$savePath");
      }

      await dio.download(srcUrl, savePath,
          onReceiveProgress: (rec, total) {
            setState(() {
              downloading = true;
              double download = (rec / total) * 100;
              downloadingStr = "Downloading Image : ${download.toInt()}" ;
              if (kDebugMode) {
                print("download() => $downloadingStr");
              }
            });
          }
      );

      setState(() {
        downloading = false;
        downloadingStr = "Completed";
        if (kDebugMode) {
          print("download() => $downloadingStr");
        }
        showPdf(savePath);
      });

    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void showPdf(String path){
    Navigator.push(
      context,
      Transition(
          child:PdfViewer(
              path: path),
          transitionEffect:
          TransitionEffect.RIGHT_TO_LEFT),
    );
  }



}