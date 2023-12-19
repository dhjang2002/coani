import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WorkHome extends StatefulWidget {
  const WorkHome({Key? key}) : super(key: key);

  @override
  _WorkHomeState createState() => _WorkHomeState();
}

class _WorkHomeState extends State<WorkHome> {
  List<String> reportList = ["방울이 검사결과가 도착 했습니다.", "접수하신 검사가 진행중 입니다.",
    "설문검사를 제출하였습니다.", "검사를 진행한지 6개월이 지났어요."];

  @override
  void deactivate() {
    super.deactivate();
    if (kDebugMode) {
      print("WorkHome::deactivate():");
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print("WorkHome::dispose():");
    }
    super.dispose();
  }

  @override
  void initState() {
    if (kDebugMode) {
      print("WorkHome::initState():");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // 배경이미지
      Positioned(
          top:0,
          left:0,
          right:0,
          child: Container(
            height: 376,
            color: Colors.brown,
        )
      ),
      // coani 아이콘
      Positioned(
        top:47,
        left: (MediaQuery.of(context).size.width-100)/2,
        child: SizedBox(
            width: 100,
            height: 50,
            //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Image.asset("assets/icon/logo.png",)
        ),
      ),
      /*
      Align(
          alignment: Alignment.topCenter,
          child: Container(
              width: 100,
              height: 50,
              //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Image.asset("assets/icon/logo.png",)
          ),
      ),
       */
      // 로그인 정보
      const Positioned(
        top:105,
        left:20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("홍길동님,", style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 1.0,),),
            SizedBox(height: 1,),
            Text("안녕하세요!", style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.normal),),
          ],
        )
      ),
      // 반려동물정보
      Positioned(
        top:246,
          child: Container(
            height: 260,
            width:MediaQuery.of(context).size.width-40,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(color:Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5),
              ]
            ),
            child: Column(
              children: [
                Container(
                  height: 130,
                  color: Colors.brown,
                  child: PageView.builder(
                        itemCount: reportList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            key: UniqueKey(),
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width-40,
                              color:Colors.brown,
                              child:Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 반려동물 사진.
                                  Center(
                                    child: Container(
                                      width:80,
                                      height:80,
                                      color: Colors.brown,
                                      child: const CircleAvatar(
                                        backgroundImage: AssetImage("assets/icon/dog_img.png"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  // 반려동물 정보(이름, 날짜, 검사시작 버튼)
                                  Expanded(
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          color: Colors.brown,
                                          child:Column(
                                            //mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text("방울이", style:TextStyle(fontSize:18.0, color:Colors.white, fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 3,),
                                              const Text("만난지 6434일 ♥︎", style:TextStyle(fontSize:16.0, color:Colors.white)),
                                              const Spacer(),
                                              Container(
                                                height: 42,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                                child: ElevatedButton(
                                                  onPressed: () async {

                                                  },
                                                  child: const Text('검사하기', style: TextStyle(color: Colors.white, fontSize: 18),),
                                                ),
                                              ),
                                            ],
                                        )
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 120,
                  //color: Colors.yellow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 검사진행 정보 표시영역.
                      const SizedBox(height: 5,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(width:15),
                            Image.asset("assets/icon/dog.png", width: 16, height: 16,),
                            const SizedBox(width:8),
                            const Text("23,109 마리 반려동물의 검사를 진행했어요.",
                                style:TextStyle(fontSize:14.0, /*fontWeight:FontWeight.bold*/ color:Colors.black)),
                          ],
                        ),
                      ),

                      //SizedBox(height: 15,),
                      Divider(height: 25.0,thickness: 2.0,color:Colors.grey.shade200),
                      //SizedBox(height: 10,),
                      // 툴바 영역.
                      Container(
                        width: MediaQuery.of(context).size.width-100,
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap:(){
                                if (kDebugMode) {
                                  print("카트구입 클릭!!");
                                }
                              },
                              child:Container(
                                color: Colors.transparent,
                                  child:Column(
                                    children: [
                                      Image.asset("assets/icon/icon_01.png", width: 30, height: 30,),
                                      const SizedBox(height: 5),
                                      const Text("카트구입", style:TextStyle(fontSize:12.0, color:Colors.black))
                                    ],
                                  )
                              ),
                            ),

                            GestureDetector(
                              onTap:(){
                                if (kDebugMode) {
                                  print("가이드 클릭!!");
                                }
                              },
                              child:Column(children: [
                                Image.asset("assets/icon/icon_02.png", width: 30, height: 30,),
                                const SizedBox(height: 5),
                                const Text("가이드", style:TextStyle(fontSize:12.0, color:Colors.black))
                              ],),
                            ),

                            GestureDetector(
                              onTap:(){
                                if (kDebugMode) {
                                  print("고객센터 클릭!!");
                                }
                              },
                              child:Column(children: [
                                Image.asset("assets/icon/icon_03.png", width: 30, height: 30,),
                                const SizedBox(height: 5),
                                const Text("고객센터", style:TextStyle(fontSize:12.0, color:Colors.black))
                              ],),
                            ),

                            GestureDetector(
                              onTap:(){
                                if (kDebugMode) {
                                  print("질병사전 클릭!!");
                                }
                              },
                              child:Column(children: [
                                Image.asset("assets/icon/icon_04.png", width: 30, height: 29,),
                                const SizedBox(height: 5),
                                const Text("질병사전", style:TextStyle(fontSize:12.0, color:Colors.black))
                              ],),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
      )
      ),
      // 스위치
      Positioned(
          top:190,
          left:20,
          right:20,
          child: SizedBox(
            height: 60,
            child: Row(
                children:[
                  Expanded(
                  child: ElevatedButton(
                      child: const Text('마이펫', style:TextStyle(fontSize:16.0, color:Colors.black)),
                      style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(300, 44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                  child: ElevatedButton(
                    child: const Text('결과 보고서', style:TextStyle(fontSize:16.0, color:Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        fixedSize: const Size(300, 44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {},
                  ),
                  ),
                ]
            ),
          ),
      ),
      // 반려동물 심볼
      Positioned(
        top:106,
          right:36,
          child: Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color:Colors.transparent,
              borderRadius: BorderRadius.circular(50.0),
              
            ),
            child: Image.asset(
                "assets/icon/animals.png",
                fit: BoxFit.fill),
          )
      ),
      // 리포트 영역
      Positioned(
          top:520,
          left:20,
          right:20,
          child: Container(
            padding: const EdgeInsets.all(5),
            height:MediaQuery.of(context).size.height-540,
            //color: Colors.grey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(" 리포트 내역: 4",
                    style:TextStyle(fontSize:20.0, color:Colors.brown)),
                const SizedBox(height: 5,),
                Expanded(
                    child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: reportList.length,
                        padding: const EdgeInsets.all(1),
                        itemBuilder: (context, index) {
                          return Card(
                              key: UniqueKey(),
                              child:Padding(
                                padding: const EdgeInsets.fromLTRB(8,10,8,10),
                                child: Row(
                                  children: [
                                    Text(reportList[index],
                                        style:const TextStyle(fontSize:15.0, color:Colors.black)),
                                    const Spacer(),
                                    const Text("2021.10.24", style:TextStyle(fontSize:13.0, color:Colors.grey)),
                                  ],
                                )

                              ),
                          );
                        }),
                )
              )
              ],
            ),
          )),
    ]);
  }
}
