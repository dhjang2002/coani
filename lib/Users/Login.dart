// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print

import 'package:coani/Constants/HostInfo.dart';
import 'package:coani/Models/Config.dart';
import 'package:coani/Models/Person.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:coani/Utils/utils.dart';
import 'package:coani/Webview/WebExplorer.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.m_config}) : super(key: key);
  final Config m_config;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController idsController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool _isChecked = false;
  @override
  void initState() {
    setState(() {
      _isChecked = (widget.m_config.auto_login == "Y") ? true : false;
      idsController.text = widget.m_config.uid!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Container(),
              /*
          IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white,), // (isPageBegin) ? Icons.close :
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          */
          title: SizedBox(
              width: 96,
              height: 44,
              child: Image.asset(
                "assets/icon/logo.png",
              )),
        ),
        body: WillPopScope(
            onWillPop: _onWillPop,
            child: GestureDetector(
            onTap: () { FocusScope.of(context).unfocus();},
            child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    color: Colors.brown,
                  )),
              Positioned(
                top: 130,
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // ids
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            controller: idsController,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, ),
                            decoration: const InputDecoration(
                                border: const OutlineInputBorder(),

                                //labelText: '사용자 계정',
                                hintText: 'ID 입력'),
                          ),
                        ),
                        // pwd
                        Container(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10, bottom: 0),
                          child: TextField(
                            obscureText: true,
                            controller: pwdController,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, ),
                            decoration: const InputDecoration(
                                border: const OutlineInputBorder(),
                                //labelText: '비밀번호',
                                hintText: '비밀번호'),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        // auto login
                        SizedBox(
                          //height: 50,
                          width: 200,
                          child: Row(
                            children: [
                              const Text('자동 로그인',
                                style: TextStyle(color: Colors.black, fontSize: 18),
                              ),
                              const SizedBox(width: 5),
                              Switch(
                                activeColor: Colors.blueAccent,
                                value: _isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // 로그인 버튼
                        ElevatedButton(
                          onPressed: () async {
                            doLogin();
                          },
                          child: const Text('로그인',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              fixedSize: const Size(250, 44),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),

                        ),
                        const SizedBox(height: 15,),
                        // 회원가입
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(height: 30),
                          child: TextButton(
                              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent, padding: const EdgeInsets.all(0)),
                              child: const Text('계정이 없으신가요 ? 회원가입 >', style: const TextStyle(fontSize:14.0)),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                  context,
                                  Transition(
                                      child: WebExplorer(
                                          title: '회원가입',
                                          website: "$URL_HOME/bbs/register3.php"),
                                      transitionEffect:
                                      TransitionEffect.RIGHT_TO_LEFT),
                                );
                              },
                            )
                        ),

                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(height: 30),
                          child: TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.blueAccent,
                                    padding: const EdgeInsets.all(0)
                                ),
                                child: Row(
                                    children: const [
                                      Spacer(),
                                      Text('비밀번호 찾기',
                                          style: TextStyle(fontSize:14.0,
                                              fontWeight: FontWeight.normal)
                                      ),
                                      Spacer(),
                                    ]
                                ),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  Navigator.push(
                                    context,
                                    Transition(
                                        child: WebExplorer(
                                            title: '비밀번호',
                                            website: "$URL_HOME/bbs/password_lost_app.php"),
                                        transitionEffect:
                                        TransitionEffect.RIGHT_TO_LEFT),
                                  );
                                },
                              )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 70,
                  right: 20,
                  child: Container(
                    width: 90,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Image.asset("assets/icon/animals.png", fit: BoxFit.fill),
                  )),
            ],
          ))
        ),
    );
  }

  Future <void> doLogin() async {
    FocusScope.of(context).unfocus();
    if(idsController.text.length<2 ){

      showPopupMessage(context,
        const Text("아이디를 입력해주세요.",
          style: const TextStyle(fontSize: 18, color: Colors.redAccent,
              fontWeight: FontWeight.bold),),);
      return;
    }

    if(pwdController.text.length<2) {
      showPopupMessage(context,
        const Text("비밀번호를 입력해주세요.",
          style: TextStyle(fontSize: 18, color: Colors.redAccent,
              fontWeight: FontWeight.bold),),);
      return;
    }

    //print("IDS:" + idsController.text);
    //print("PWD:" + pwdController.text);
    await Remote.login(
        uid: idsController.text,
        pwd: pwdController.text,
        onResponse: (int status, Person person) async {
          if (status==1 && person.mb_id!.isNotEmpty) {
            widget.m_config.users_id = person.mb_no;
            widget.m_config.uid = person.mb_id;
            widget.m_config.firebase_token = person.mb_firebase_token;
            widget.m_config.pwd = pwdController.text;
            widget.m_config.skip_intro = "Y";
            widget.m_config.auto_login =
            (_isChecked) ? "Y" : "";
            await widget.m_config.setPref();
            Navigator.pop(context, person);
          }
          else if(status==0){
            showPopupMessage(context,
              const Text("아이디, 비밀번호를 확인하세요 !",
                style: const TextStyle(fontSize: 18, color: Colors.redAccent,
                    fontWeight: FontWeight.bold),),);
          }
          else{
            showPopupMessage(context,
              const Text("네트워크 오류입니다.",
                style: const TextStyle(fontSize: 18, color: Colors.redAccent,
                    fontWeight: FontWeight.bold),),);
          }
        });
  }

  Future <bool> _onWillPop() async {
    return false;
  }
}
