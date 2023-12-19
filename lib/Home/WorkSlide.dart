// ignore_for_file: file_names

import 'package:flutter/material.dart';
class WorkSlide extends StatefulWidget {
  const WorkSlide({Key? key, required Null Function(title) onItemClick}) : super(key: key);

  @override
  _WorkSlideState createState() => _WorkSlideState();
}

mixin title {
}

class _WorkSlideState extends State<WorkSlide> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 64.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/icon/app_icon.png',
              ),
            ),
            ListTile(
              onTap: () {

              },
              selected: true,
              selectedTileColor: Colors.blueAccent,
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
            ),
            ListTile(
              onTap: () {

              },
              leading: const Icon(Icons.add),
              title: const Text('반려동물 등록하기'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.home),
              title: const Text('홈페이지'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            const Spacer(),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: const Text('Terms of Service | Privacy Policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
