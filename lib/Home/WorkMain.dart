// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, unnecessary_null_comparison
import 'package:coani/Animals/animal_register.dart';
import 'package:coani/Animals/animal_Info.dart';
import 'package:coani/Animals/download_file.dart';
import 'package:coani/Camera/ImageCrop.dart';
import 'package:coani/Constants/HostInfo.dart';
import 'package:coani/Constants/Patterns.dart';
import 'package:coani/Intro/intro_screen_page.dart';
import 'package:coani/LocalNotification/localNotification.dart';
import 'package:coani/Models/Animal.dart';
import 'package:coani/Models/Config.dart';
import 'package:coani/Models/Message.dart';
import 'package:coani/Models/Person.dart';
import 'package:coani/Questions/QMyInfo.dart';
import 'package:coani/Questions/QMyResult.dart';
import 'package:coani/Questions/QuestionStep.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:coani/Users/Login.dart';
import 'package:coani/Utils/utils.dart';
import 'package:coani/Webview/WebExplorer.dart';
//import 'package:extended_image/extended_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transition/transition.dart';

class WorkMain extends StatefulWidget {
  const WorkMain({
    Key? key,
  }) : super(key: key);

  @override
  _WorkMainState createState() => _WorkMainState();
}

class _WorkMainState extends State<WorkMain> with WidgetsBindingObserver {
  final LocalNotification notification = LocalNotification();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  final _currentPageNotifier = ValueNotifier<int>(0);

  late List<Message> m_rList;
  bool m_rLoaded = false;

  late List<Animal> m_aList;
  bool m_aLoaded = false;
  late Animal m_aInfo;

  late Person m_person;
  bool m_isSigned = false;

  String userName = ""; // '홍길동님,'
  String userMesg = "로그인 해주세요!"; // '반갑습니다!'
  String countMessage = "";

  bool isLoading = false;
  late Config m_config;
  
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _reload();
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async {
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }


  String firebase_token = "";
  Future <void> procFirebaseMassing() async {
    if (kDebugMode) {
      print("procFirebaseMassing()::start.");
    }

    await requestNotificationPermission();

    messaging.getToken().then((token) {
      firebase_token = token.toString();
      if (kDebugMode) {
        print("procFirebaseMassing()::getToken(): ---- > $firebase_token");
      }

    });

    // 사용자가 클릭한 메시지를 제공함.
    messaging.getInitialMessage().then((message) {
      if (kDebugMode) {
        print("getInitialMessage(user tab) -----------------> ");
      }

      if(message != null && message.notification != null) {
        String action = "";
        if(message.data["action"] != null) {
          action = message.data["action"];
        }

        if (kDebugMode) {
          print("title=${message.notification!.title.toString()},\n"
              "body=${message.notification!.body.toString()},\n"
              "action=$action");
        }

        if(message.notification?.android != null) {
          notification.show(
              message.notification!.title.toString(),
              message.notification!.body.toString()
          );
        }
      }

      // 엡이 죽지않고 백그라운드 상태일때...
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        if (kDebugMode) {
          print("Background Status(alive) -----------------> ");
        }

        if(message.notification != null) {
          String action = "";
          if(message.data["action"] != null) {
            action = message.data["action"];
          }
          if (kDebugMode) {
            print("title=${message.notification!.title.toString()},\n"
                "body=${message.notification!.body.toString()},\n"
                "action=$action");
          }

          // notification.show(
          //     message.notification!.title.toString(),
          //     message.notification!.body.toString()
          // );
        }
      });

      // if foreground state here.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print("Foreground Status(active) -----------------> ");
        }

        if(message.notification != null) {
          String action = "";
          if(message.data["action"] != null) {
            action = message.data["action"];
          }
          if (kDebugMode) {
            print("title=${message.notification!.title.toString()},\n"
                "body=${message.notification!.body.toString()},\n"
                "action=$action");
          }
          notification.show(
              message.notification!.title.toString(),
              message.notification!.body.toString()
          );
        }
      });


    });
  }

  Future <void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      //print('알림 권한이 승인되었습니다.');
      //_session.bDeniedNotice = true;
      showToastMessage("알림 수신이 거부되었습니다.");
    }
  }

  Future <void> setFirebaseSubcribed(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print("subscribeToTopic($topic)");
    // String topic = _session.FireBaseTopic!;
    // if (kDebugMode) {
    //   print("setFirebaseSubcribed($topic)");
    // }
    //
    // if(_session.FireBaseTopic!.isNotEmpty
    //     && _session.FireBaseTopic != _session.FireBaseTopicSaved) {
    //   if (kDebugMode) {
    //     print("updated Topics .....");
    //   }
    //   await _session.setFirebaseTopic(_session.FireBaseTopic!);
    //
    //   // 이전 구독정보 삭제
    //   //bool isValidTopic = RegExp(r'^[a-zA-Z0-9-_.~%]{1,900}$').hasMatch(topic);
    //   // "본사(HD)", "직영점(SB)", "매출처(SS)", "매입처(RR)"
    //   await FirebaseMessaging.instance.unsubscribeFromTopic("HD");    // "본사(HD)"
    //   await FirebaseMessaging.instance.unsubscribeFromTopic("SB");    // "직영점(SB)"
    //   await FirebaseMessaging.instance.unsubscribeFromTopic("SS");    // "매출처(SS)"
    //   await FirebaseMessaging.instance.unsubscribeFromTopic("RR");    // "매입처(RR)"
    //
    //   // 새 구독정보 등록
    //   if (_session.FireBaseTopic == "SR") {
    //     await FirebaseMessaging.instance.subscribeToTopic("SS");
    //     await FirebaseMessaging.instance.subscribeToTopic("RR");
    //   }
    //   else {
    //     await FirebaseMessaging.instance.subscribeToTopic(topic);
    //   }
    // }
  }

  bool _bReady = false;

  String _versionInfo = "";
  Future <void> setVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _versionInfo = "${packageInfo.version} (${packageInfo.buildNumber})";
  }

  @override
  void initState()  {
    //print("WorkMain::initState():m_config=" + m_config.toString());
    Future.microtask(() async {
      m_config = Config();
      await m_config.getPref();
      
      if(m_config.skip_intro != "Y") {
        await Navigator.push(context,
          Transition(
              child: const IntroScreenPage(),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          ),
        );
        m_config.skip_intro = "Y";
        await m_config.setPref();
      }

      await setVersionInfo();
      WidgetsBinding.instance.addObserver(this);
      await notification.init();
      await notification.requestPermissions();
      await notification.cancel();
      await procFirebaseMassing();
      await setFirebaseSubcribed("ALL");

      fetchCount();
      if (m_config.auto_login == "Y") {
        await _autoLogin();
        setState(() {
          _bReady = true;
        });
      }
      if(!m_isSigned) {
        await _login();
        setState(() {
          _bReady = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    print("WorkMain::dispose():");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldStateKey,
        backgroundColor: Colors.black45,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: SizedBox(
              width: 96,
              height: 44,
              child: Image.asset(
                "assets/icon/logo.png",
              )
          ),
          actions: [
            // 로그인
            Visibility(
              visible: !m_isSigned,
              child: IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    _login();
                  }),
            ),
            // 알림
            IconButton(
                icon: Image.asset(
                  "assets/icon/notice.png",
                  width: 17,
                  height: 17,
                ),
                onPressed: () {
                  _onPushMessage();
                  //_goHome(URL_HOME, "홈페이지");
                  //_reload();
                }),
            Visibility(
              visible: m_isSigned,
              child: IconButton(
                  icon: Image.asset(
                    "assets/icon/quick.png",
                    width: 17,
                    height: 17,
                  ),
                  onPressed: () {
                    _scaffoldStateKey.currentState!.openEndDrawer();
                  }),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        endDrawer: (m_isSigned) ? _renderDrawer() : Container(),
        bottomNavigationBar: (_bReady) ? BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.brown,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: (int index) {
            switch (index) {
              case 0:
                _goHome(URL_HOME, "홈페이지");
                break;
              case 1:
                _myStatus();
                break;
              case 2:
                _myResult();
                break;
              case 3:
                _animalAdd();
                break;
            }
          },
          currentIndex: 0, //_selectedIndex, //현재 선택된 Index
          items: [
            BottomNavigationBarItem(
              label: '홈페이지',
              icon: Image.asset(
                "assets/icon/icon_bottom_home.png",
                width: 18,
                height: 18,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              label: '검사진행',
              icon: Image.asset(
                "assets/icon/icon_bottom_list.png",
                width: 18,
                height: 18,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              label: '검사결과',
              icon: Image.asset(
                "assets/icon/icon_bottom_report.png",
                width: 18,
                height: 18,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              label: '반려동물 등록',
              icon: Image.asset(
                "assets/icon/icon_bottom_add.png",
                width: 18,
                height: 18,
                color: Colors.white,
              ),
            ),
          ],
        ) : null,
        floatingActionButton: Visibility(
          visible: (_bReady && m_isSigned && m_aLoaded),
          child: FloatingActionButton.extended(
            icon: Image.asset("assets/icon/icon_edit.png", width: 16, height: 16),
            label: const Text("검사신청"),
          onPressed: (){
            addQuestion();
          },
        )),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: const WaterDropHeader(
            waterDropColor: Colors.brown,
            complete: Text("업데이트 완료",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight
                        .bold)), // you can customize this whatever you like
            failed: Text('Failed',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          //onLoading: _onLoading,
          child: BuildBodyWidget(),
        ));
  }
  Widget _renderDrawer() {
    final width = MediaQuery.of(context).size.width * 0.85;
    return Drawer(
      width: width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
                color: Colors.brown,
                height: 240,
                width: 1000,
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      m_person.mb_id.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      m_person.mb_nickname.toString()+"님",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    //SizedBox(height: 10),
                    Text(
                      m_person.mb_email.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                            icon: const Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text("로그아웃",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                )),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white, shadowColor: Colors.white,
                              backgroundColor: Colors.brown,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _logout();
                            }),
                        OutlinedButton.icon(
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text("정보수정",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                )),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white, shadowColor: Colors.white,
                              backgroundColor: Colors.brown,
                            ),
                            onPressed: () {
                              //https://co-ani.com/bbs/member_confirm2.php?url=https://co-ani.com/bbs/register_form2.php&mb_no=9
                              String url = "$URL_HOME/bbs/member_confirm2.php?url=https://co-ani.com/bbs/register_form3.php&mb_no=${m_person.mb_no}";
                              var result = Navigator.push(context,
                                Transition(
                                    child: WebExplorer(title: '정보수정', website: url),
                                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                                ),
                              );
                            }),
                        OutlinedButton.icon(
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text("회원탈퇴",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                )),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white, shadowColor: Colors.white,
                              backgroundColor: Colors.brown,
                            ),
                            onPressed: () async {
                              //https://co-ani.com/bbs/member_confirm2.php?url=https://co-ani.com/bbs/register_form2.php&mb_no=9
                              //https://co-ani.com/bbs/member_confirm2.php?url=member_leave2.php&mb_no=2
                              String url = "$URL_HOME/bbs/member_confirm2.php?url=member_leave2.php&mb_no=${m_person.mb_no}";
                              var result = await Navigator.push(context,
                                Transition(
                                    child: WebExplorer(title: '회원탈퇴', website: url),
                                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                                ),
                              );
                              if(result!=null && result==true) {
                                _logout();
                              }
                            }),
                      ],
                    ),
                    const Spacer(),
                  ],
                )
            ),


            // ToolBar
            Visibility(
              visible: false, //
              child: Container(
                  width: 1000,
                  padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                  color: Colors.grey[150],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            Transition(
                                child: DownloadFile(url: ""),
                                transitionEffect:
                                    TransitionEffect.RIGHT_TO_LEFT),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icon/icon_01.png",
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(height: 8),
                            const Text("카트구입",
                                style: const TextStyle(
                                    fontSize: 10.0, color: Colors.black))
                          ],
                        ),
                      ),
                      // 하단 팝업 테스트
                      GestureDetector(
                        onTap: () async {},
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icon/icon_02.png",
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(height: 8),
                            const Text("PDF 보기",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.black))
                          ],
                        ),
                      ),
                      // Crop 테스트
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                            context,
                            Transition(
                                child: const ImageCropAction(title: "Image Crop"),
                                transitionEffect:
                                    TransitionEffect.RIGHT_TO_LEFT),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icon/icon_03.png",
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(height: 8),
                            const Text("Crop 테스트",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.black))
                          ],
                        ),
                      ),
                      // 처리결과 조회
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icon/icon_04.png",
                              width: 18,
                              height: 17,
                            ),
                            const SizedBox(height: 8),
                            const Text("처리결과",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.black))
                          ],
                        ),
                      ),
                    ],
                  )),
            ),

            // Add Animal
            Container(
              color: Colors.white,
              child: ListTile(
                // 반려동물 등록
                leading: Image.asset(
                  "assets/icon/dog.png",
                  width: 24,
                  height: 24,
                ),
                title: const Text(
                  '반려동물 등록하기',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 20.0,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    _animalAdd();
                  },
                ),
                onTap: () => _animalAdd(),
              ),
            ),

            // Animal ListView
            Container(
              color: Colors.white,
              child: ListView(
                //physics: ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                //itemExtent: 150,
                scrollDirection: Axis.vertical,
                children:
                    List.generate((m_aLoaded) ? m_aList.length : 0, (index) {
                  String url = "$URL_IMAGE/${m_aList[index].photo_url}";
                  return ListTile(
                      onTap: () {
                        _animalShow(m_aList[index]);
                      },
                      leading: Container(
                        width: 52,
                        height: 80,
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(url),
                          backgroundColor: Colors.transparent,
                        )
                      ),
                      title: Text(
                        m_aList[index].name.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      subtitle: Text(
                        m_aList[index].kind.toString(),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0),
                      ),
                      trailing: IconButton(
                        icon: Image.asset(
                          "assets/icon/write.png",
                          width: 20,
                          height: 20,
                          color: Colors.black,
                        ),
                        //icon: Icon(Icons.edit,size: 20.0,color: Colors.grey[600],),
                        onPressed: () {
                          _animalUpdate(m_aList[index]);
                        },
                      ));
                }),
              ),
            ),
            // 버전정보
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              //color: Colors.grey,
              child: Row(
                children: [
                  const Spacer(),
                  Text("version: $_versionInfo",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildBodyWidget() {
    if(!_bReady) {
      return Container(
        color:Colors.white,
        child: const Stack(
          children: [
            // Positioned(child: Center(
            //   child: Image.asset("assets/icon/app_icon.png",
            //     width: 80, height: 80,),
            // )),
            Positioned(child: Center(child: CircularProgressIndicator(),))
          ],
        ),
      );
    }

    double haltHeight = 320.0; //MediaQuery.of(context).size.height*0.35;
    return SingleChildScrollView(
        child:SizedBox(
      //color: Colors.brown,
          height: MediaQuery.of(context).size.height-10,
        child: Stack(children: [
          // 배경이미지
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey.shade200,
              )),
          // 배경이미지
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: haltHeight,
                color: Colors.brown,
              )),

          // 로그인 정보
          Positioned(
              top: 105,
              left: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    userMesg,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              )),

          // 반려동물정보
          Positioned(
            top: 190,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width - 30,
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                  color: Colors.white, // 전체 배경색
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 3,
                        spreadRadius: 0.2),
                  ]),
              child: Stack(children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(children: [
                    Container(
                      height: 130,
                      padding: const EdgeInsets.fromLTRB(1, 10, 1, 1),
                      color: Colors.brown, // 상단 정보영역 배경색
                      child: Center(
                        child: (m_aLoaded)
                            ? SizedBox(
                          height: 110,
                          child: PageView.builder(
                              itemCount: (m_aLoaded) ? (m_aList.length) : 0,
                              itemBuilder: (context, index) {
                                return BuildAnimalItem(index);
                              },
                              onPageChanged: (int position) {
                                _currentPageNotifier.value = position;
                                _onAnimalChanged(position);
                              }),
                        )
                            : BuildEmptyAnimals(),
                      ),
                    ),
                    Container(
                      //padding: EdgeInsets.all(5),
                      height: 160,
                      color: Colors.white,
                      // 검사진행+툴바
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 검사진행 정보 표시영역.
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 15),
                                Image.asset(
                                  "assets/icon/dog.png",
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(countMessage,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black))),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                              height: 8.0,
                              thickness: 2.0,
                              color: Colors.grey.shade200),
                          const SizedBox(
                            height: 10,
                          ),
                          // 툴바 영역.
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 90,
                              //padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print("키트구입 클릭!!");
                                      _goHome(URL_HOME_KIT, "키트 안내");
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/icon/icon_01.png",
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(height: 5),
                                        const Text("키트구입",
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black))
                                      ],
                                    ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      _goHome(URL_HOME_SERVICE, "서비스 안내");
                                    },
                                    child: Container(
                                        color: Colors.transparent,
                                        child:Column(
                                      children: [
                                        Image.asset(
                                          "assets/icon/icon_02.png",
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(height: 5),
                                        const Text("가이드",
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black))
                                      ],
                                    )
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      _goHome(URL_HOME_CUSTOMER, "고객센터");
                                      //print("고객센터 클릭!!");
                                    },
                                    child: Container(
                                        color: Colors.transparent,
                                        child:Column(
                                      children: [
                                        Image.asset(
                                          "assets/icon/icon_03.png",
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(height: 5),
                                        const Text("고객센터",
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black))
                                      ],
                                    )),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      _myStatus();
                                    },
                                    child: Container(
                                        color: Colors.transparent,
                                        child:Column(
                                      children: [
                                        Image.asset(
                                          "assets/icon/icon_04.png",
                                          width: 24,
                                          height: 23,
                                        ),
                                        const SizedBox(height: 5),
                                        const Text("검사진행",
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black))
                                      ],
                                    )
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ]),
                ),
                // Page Indicator
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CirclePageIndicator(
                      itemCount: (m_aLoaded) ? (m_aList.length) : 0,
                      dotColor: Colors.black,
                      selectedDotColor: Colors.white,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                  ),
                ),

                // 검사신청 버튼
                Visibility(
                  visible: m_aLoaded,
                  child: Positioned(
                    top: 60,
                    right: 10,
                    child: SizedBox(
                        width: 58,
                        height: 58,
                        child: RawMaterialButton(
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icon/icon_req3.png", width: 25, height: 25),
                                const SizedBox(height:3),
                                const Text("검사신청",
                                    style: TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold)),
                            ]),
                          shape: const CircleBorder(),
                          onPressed: () {
                            addQuestion();
                          },
                        )),
                  ),
                ),
              ]),
            ),
          ),

          // 반려동물 심볼
          Positioned(
              top: 120,
              right: 20,
              child: Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Image.asset("assets/icon/animals.png", fit: BoxFit.fill),
              )),

          // 리포트 영역
          Positioned(
            top: 500,
            left: 0,
            right: 0,
            child: BuildReport(),
          ),
        ])));
  }

  Widget BuildReport() {
    return Container(
      padding: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height - 540,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text((m_rLoaded) ? "리포트 내역: ${m_rList.length}" : "리포트 내역:",
              style: const TextStyle(fontSize: 15.0, color: Colors.brown)),
          const SizedBox(
            height: 5,
          ),
          Expanded(
              child: Container(
                  width: 2400,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white, // 전체 배경색
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3,
                            spreadRadius: 0.2),
                      ]),
                  child: (m_rLoaded)
                      ? ListView.builder(
                          itemCount: (m_rLoaded) ? m_rList.length : 0,
                          padding: const EdgeInsets.all(1),
                          itemBuilder: (context, index) {
                            return Card(
                              key: UniqueKey(),
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(m_rList[index].message.toString(),
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black)),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            m_rList[index]
                                                .created_at
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.grey)),
                                      ),
                                    ],
                                  )),
                            );
                          })
                      : Center(
                          child: SizedBox(
                          height: 100,
                          child: Image.asset(
                            "assets/icon/icon_report_empty.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ))))
        ],
      ),
    );
  }

  Widget BuildAnimalItem(int index) {
    if (!m_aLoaded || m_aList.isEmpty) {
      return Container(
        key: UniqueKey(),
        padding: const EdgeInsets.all(10),
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          color: Colors.grey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 반려동물 사진.
              const Center(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  //color: Colors.brown,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/icon/dog_img.png"),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              // 반려동물 정보(이름, 날짜, 검사시작 버튼)
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.brown,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("방울이",
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text("만난지 6434일 ♥︎",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                        const Spacer(),
                        Container(
                          height: 42,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            onPressed: () async {},
                            child: const Text(
                              '검사하기',
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      );
    } else {
      Animal animal = m_aList[index];
      String url = "$URL_IMAGE/${animal.photo_url}";
      String title = "${animal.name}";
      String dayCount = getDayCount(animal.birthday.toString());
      return BuildAnimalCard(true, url, title, dayCount);
    }
  }

  Widget BuildAnimalCard(bool isLoad, String photo_url, String title, String subTitle) {
    if (isLoad) {
      return GestureDetector(
        onTap: () => _animalShow(m_aInfo),
        child: Container(
          //height: 100,
          //color: Colors.white,
          key: UniqueKey(),
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Container(
              height: 100, //MediaQuery.of(context).size.width*0.25,
              padding: const EdgeInsets.all(5),
              //color: Colors.white,//grey[200],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 반려동물 사진.
                  Center(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(photo_url),
                  backgroundColor: Colors.transparent,
                )

                      // child: Image.network(
                      //   photo_url,
                      //   fit: BoxFit.fill,
                      //   // cache: true,
                      //   // shape: BoxShape.circle,
                      // ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  // 반려동물 정보(이름, 날짜)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(subTitle,
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.white)),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          "assets/icon/icon_heart.png",
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget BuildEmptyAnimals() {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Stack(
          children: [
            Positioned(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset("assets/icon/icon_empty.png"),
                  )),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: RawMaterialButton(
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: const Icon(
                        CupertinoIcons.add,
                        size: 20.0,
                      ),
                      shape: const CircleBorder(),
                      onPressed: () {
                        _animalAdd();
                      },
                    )),
              ),
            ),
          ],
        ));
  }

  void _onAnimalChanged(int index) {
    if (m_aLoaded) {
      setState(() {
        m_aInfo = m_aList[index];
      });
    }
  }

  // "dragon","1234"
  // "aaaa", "1234"
  Future <void> _autoLogin() async {
    print("_autoLogin()::");
    String uid = m_config.uid.toString();
    String pwd = m_config.pwd.toString();
    await Remote.login(
        uid: uid,
        pwd: pwd,
        onResponse: (int status, Person person) async {
          if (status == 0) {
            _networkError();
          }
          if (status == 1) {
            await applyLoginInfo(person);
            await fetchAnimals();
            await fetchRepoprts();
          }
        }
    );
  }

  Future<void> _login() async {
    dynamic person = await Navigator.push(
      context,
      Transition(
          child: Login(m_config: m_config),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );

    if (person != null) {
      await applyLoginInfo(person);
      await fetchAnimals();
      await fetchRepoprts();
      setState(() {

      });
    }
  }

  Future <void> _logout() async {
    m_config.clear();
    m_config.setPref();
    m_isSigned = false;
    fetchAnimals();
    fetchRepoprts();

    setState(() {
      userName = "";
      userMesg = "로그인 해주세요!";
      //m_config.clearSignInfo();
    });

    _login();
    //SystemNavigator.pop();
  }

  Future<void> applyLoginInfo(Person person) async {

    if(firebase_token.isNotEmpty && firebase_token != person.mb_firebase_token) {
      await _updateFirebaseToken(person.mb_no!, firebase_token);
    }

    setState(() {
      if (person != null) {
        m_person = person;
        m_isSigned = true;
        userName = "${m_person.mb_nickname!}님,";
        userMesg = "반갑습니다!";
      } else {
        m_isSigned = false;
        userName = "";
        userMesg = "로그인 해주세요!";
      }
    });
  }

  void _req_login() {
    showDialogPop(
        context: context,
        title: "확인",
        body: const Text(
          "로그인이 필요한 서비스입니다.",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          "로그인 화면으로 이동할까요?",
          style: const TextStyle(
              fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
        ),
        choiceCount: 2,
        yesText: "예",
        cancelText: "아니오",
        onResult: (bool isOK) async {
          if (isOK) {
            _login();
          }
        });
  }

  Future<void> fetchCount() async {
    print("fetchCount():------------------------");
    //if(m_isSigned) {
    Remote.getServiceCount(
        users_id: m_config.users_id.toString(),
        onResponse: (String countInfo) {
          setState(() {
            countMessage = "$countInfo 마리의\n반려동물이 검사를 진행했어요.";
          });
        });
    print("fetchCount():countMessage=$countMessage");
    // }
  }

  Future<void> fetchAnimals() async {
    print("fetchAnimals():...........................");
    m_aLoaded = false;
    if (m_isSigned) {
      Remote.getAnimals(
          users_id: m_config.users_id.toString(),
          onResponse: (List<Animal> list) {
            setState(() {
              m_aList = list;
              if (m_aList.isNotEmpty) {
                m_aInfo = m_aList[0];
                m_aLoaded = true;
              }
              print(m_aList.toString());
            });
          });
    }
  }

  Future<void> fetchRepoprts() async {
    print("fetchRepoprts():------------------------");
    m_rLoaded = false;
    if (m_isSigned) {
      Remote.getMessage(
          users_id: m_config.users_id.toString(),
          onResponse: (List<Message> list) {
            setState(() {
              m_rList = list;
              if (m_rList.isNotEmpty) {
                m_rLoaded = true;
              }
              print(m_rList.toString());
            });
          });
    }
  }

  Future<void> _animalAdd() async {
    if (!m_isSigned) return _req_login();

    Animal info = Animal();
    info.clear();
    var flag = await Navigator.push(
      context,
      Transition(
          child: AnimalRegister(
            command: "ADD",
            animal: info,
            canDelete: false,
            users_id: m_config.users_id.toString(),
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );

    if (flag != null && flag) {
      fetchAnimals();
    }
  }

  Future<void> _animalUpdate(Animal animal) async {
    gDeleteFlag = false;
    Animal info = Animal();
    info.copy(animal);
    var flag = await Navigator.push(
      context,
      Transition(
          child: AnimalRegister(
            animal: info,
            command: "UPDATE",
            canDelete: true,
            users_id: m_config.users_id.toString(),
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );

    print("_animalUpdate():gDeleteFlag=$gDeleteFlag");

    if ((flag != null && flag) || gDeleteFlag) {
      fetchAnimals();
      fetchRepoprts();
    }
  }

  Future<void> _animalShow(Animal animal) async {
    gDeleteFlag = false;
    Animal info = Animal();
    info.copy(animal);
    //print("_animalShow():: gDeleteFlag=$gDeleteFlag");
    var flag = await Navigator.push(
      context,
      Transition(
          child: AnimalInfo(
            animal: info,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );

    print("_animalShow():: gDeleteFlag=$gDeleteFlag");

    if ((flag != null && flag) || gDeleteFlag) {
      fetchAnimals();
      fetchRepoprts();
    }
  }

  Future<void> _goHome(String url, String title) async {
    await Navigator.push(
      context,
      Transition(
            child: WebExplorer(
            title: title,
            website: url,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future<void> addQuestion() async {
    if (m_aLoaded) {
      // Questions qsheet = Questions();
      // qsheet.clear();
      var flag = await Navigator.push(
        context,
        Transition(
            child: QuestionStep(
              users_id: m_config.users_id.toString(),
              animal: m_aInfo,
              //sheet: qsheet,
            ),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
      );

      if (flag != null && flag == true) {
        fetchRepoprts();
      }
    }
  }

  Future<void> _myStatus() async {
    if (!m_isSigned) return _req_login();

    Animal info = Animal();
    info.clear();
    await Navigator.push(
      context,
      Transition(
          child: QMyInfo(users_id: m_config.users_id.toString()),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future<void> _myResult() async {
    if (!m_isSigned)
      return _req_login();

    Animal info = Animal();
    info.clear();
    await Navigator.push(
      context,
      Transition(
          child: QMyResult(users_id: m_config.users_id.toString()),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future<void> _reload() async {
    fetchCount();
    fetchAnimals();
    fetchRepoprts();
  }

  void _networkError() {
    showPopupMessage(
      context,
      const Text(
        "네트워크 오류 입니다.",
        style: TextStyle(
            fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future <void> _onPushMessage() async {
    //await notification.cancel();
    //await notification.requestPermissions();
    //notification.show("코애니 알림", "사랑이의 검사요청이 접수되었습니다.");
  }

  Future <void> _updateFirebaseToken(String mb_no, String firebase_token) async {
    print("_updateFirebaseToken(): mb_no=$mb_no, firebase_token=$firebase_token");
    //if(m_isSigned) {

    await Remote.updatePersonInfo(
        params: {"mb_no":mb_no, "mb_firebase_token":firebase_token},
        onResponse: (result) {
        }
    );
  }
}
