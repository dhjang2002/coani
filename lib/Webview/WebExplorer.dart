// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, must_be_immutable, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:coani/Constants/Patterns.dart';
import 'package:coani/Webview/DaumAddress.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebExplorer extends StatefulWidget {
  WebExplorer({Key? key,
    required this.website,
    required this.title,
    this.supportZoom = true
  }) : super(key: key);
  final String title;
  final String website;
  bool? supportZoom;
  @override
  _WebExplorerState createState() => _WebExplorerState();
}

class _WebExplorerState extends State<WebExplorer> {
  _WebExplorerState();

  late WebViewController _webViewController;
  bool _bReady = false;

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    setState(() {
      _bReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppBar_Color,
        elevation: 1.0,
        title: Text(widget.title,
            style:TextStyle(color:AppBar_Title)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppBar_Icon,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: WillPopScope(
          onWillPop: () => _onBackPressed(context),
          child: _buildWebview()
      ),
    );
  }

  Widget _buildWebview() {
    if(!_bReady) {
      return const Center(child: const CircularProgressIndicator());
    }

    return SafeArea(
      child: WebView(
        userAgent: 'co-ani',
        zoomEnabled:widget.supportZoom!,
        initialUrl: widget.website,//'https://google.com',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },

        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },

        javascriptChannels: <JavascriptChannel>{
          _webToAppCoani(context),
        },

        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },

        onPageStarted: (String url) {
          print('Page started loading: $url');
        },

        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },

        gestureNavigationEnabled: true,
      ),
    );
  }

  JavascriptChannel _webToAppCoani(BuildContext context) {
    return JavascriptChannel(
        name: 'webToAppCoani',
        onMessageReceived: (JavascriptMessage message) {
          print("WebExplorer::webToAppCoani():${message.message}");
          dynamic param = jsonDecode(message.message)[0];
          var cmd = param['command'];

          switch(cmd) {
            case "OK":
              Navigator.pop(context);
              break;
            case "CANCLE":
              Navigator.pop(context);
              break;
            case "ADDR":
              callAddrView();
              break;
            case "DEL":
              _doClose(true);
              break;
          }
        });
  }

  Future <void> callAddrView() async {
    //print("_callAddrView()");
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DaumAddress(
          callback: (KAddress result) {
            _appToWeb(result.zipcode, result.addr, result.bname, result.lat.toString(), result.lon.toString());
          },
        ),
      ),
    );
  }

  Future<void> _appToWeb(String postCode, String address, String bname, String latitude, String longitude) async {
    print("postCode=$postCode");
    print("address=$address");
    print("latitude=${latitude.toString()}");
    print("longitude=${longitude.toString()}");
    await _webViewController.runJavascript(
        "window.appToSetAddr('$postCode','$address', '$bname')");
  }

  void _doClose(bool result) {
    Navigator.pop(context, result);
  }

  Future <bool> _canGoBack() async {
    return await _webViewController.canGoBack();
  }

  Future <void> _goBack() async {
    var flag = await _webViewController.canGoBack();
    if (flag) {
      await _webViewController.goBack();
    }
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    var flag = await _canGoBack();
    if (flag) {
      _goBack();
    }
    else {
      _doClose(false);
    }
    return Future(() => false);
  }
}
