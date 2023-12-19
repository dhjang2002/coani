// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:transition/transition.dart';

class IntroScreenPage extends StatefulWidget {
  //final Widget target_widget;
  const IntroScreenPage({
    Key? key,
    //required this.target_widget
  }) : super(key: key);

  @override
  _IntroScreenPageState createState() => _IntroScreenPageState();
}

class _IntroScreenPageState extends State<IntroScreenPage> {
  bool isLast = false;
  final List<String> pageList = <String>["bg_01.png","bg_02.png","bg_03.png","bg_04.png"];
  int currentPage = 0;
  PageController pageController = PageController(initialPage: 0,);
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: Colors.white,
              child: SafeArea(
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageNotifier.value = index;
                        isLast = (index>=pageList.length-1) ? true : false;
                      });
                    },
                    itemCount: pageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String imageName = pageList[index];
                      return Container(
                        decoration: BoxDecoration(
                          image:DecorationImage(
                            image: AssetImage("assets/intro/$imageName"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                height: 150,
                child: CirclePageIndicator(
                  itemCount: pageList.length,
                  dotColor: Colors.black,
                  selectedDotColor: Colors.red,
                  currentPageNotifier: _currentPageNotifier,
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Visibility(
        visible: isLast,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            label: const Text('     시작하기     '),
            icon: const Icon(Icons.arrow_forward),
            backgroundColor: Colors.brown,
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
