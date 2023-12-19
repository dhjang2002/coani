// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:coani/Constants/Patterns.dart';
import 'package:coani/Webview/DaumAddress.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RegisterWebview extends StatefulWidget {
  const RegisterWebview({Key? key, required this.website, required this.title}) : super(key: key);
  final String title;
  final String website;
  @override
  _RegisterWebviewState createState() => _RegisterWebviewState();
}

class _RegisterWebviewState extends State<RegisterWebview> {
  WebViewController? _controller;

  _RegisterWebviewState();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppBar_Color,
        elevation: 1.0,
        title: Text(widget.title,
            style: TextStyle(color: AppBar_Title)),
      ),

      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: WebView(
            initialUrl: widget.website,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },

            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: <JavascriptChannel>{
              //_toasterJavascriptChannel(context),
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
      }),
    );
  }

  void _goCancle() {
    Navigator.pop(context);
  }

  Future<void> _callAddrView() async {
    print("_callAddrView()");
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
    await _controller!.runJavascript(
        "window.appToSetAddr('$postCode','$address', '$bname')");
  }

  JavascriptChannel _webToAppCoani(BuildContext context) {
    return JavascriptChannel(
        name: 'webToAppCoani',
        onMessageReceived: (JavascriptMessage message) {
          print("webToAppCoani():${message.message}");
          dynamic param = jsonDecode(message.message)[0];
          var cmd = param['command'];
          switch(cmd) {
            case "OK":
              _goCancle();
              break;
            case "CANCEL":
              _goCancle();
              break;
            case "ADDR":
              _callAddrView();
              break;
            default:
              break;
          }
        }
        );
  }
}


