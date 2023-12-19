
//import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PhotoViewer extends StatefulWidget {
  const PhotoViewer({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("사진 보기"),
      ),
      body: Center(
        child:Image.network(widget.path,
          fit: BoxFit.fill,
          // cache: true,
          // shape: BoxShape.rectangle,
        ),
      )
    );
  }
}