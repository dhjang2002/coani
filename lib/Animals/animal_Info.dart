// ignore_for_file: file_names, non_constant_identifier_names
import 'package:coani/Animals/pdf_viewer.dart';
import 'package:coani/Constants/HostInfo.dart';
import 'package:coani/Constants/Patterns.dart';
import 'package:coani/Models/Animal.dart';
import 'package:coani/Models/QuestionStatus.dart';
import 'package:coani/Models/qItemReport.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:coani/Utils/utils.dart';
import 'package:coani/Webview/WebExplorer.dart';
import 'package:dio/dio.dart';
//import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';

import 'animal_register.dart';

class AnimalInfo extends StatefulWidget {
  const AnimalInfo({Key? key, required this.animal}) : super(key: key);
  final Animal animal;

  @override
  _InfoAnimalState createState() => _InfoAnimalState();
}

class _InfoAnimalState extends State<AnimalInfo> {
  bool bDirty = false;  // 데이터 수정여부  판단.
  String dayCount = "";

  bool sLoaded = false;
  late List<QuestionStatus> sList;

  late List<QItemReport> rList;
  bool rLoaded = false;

  bool isDownload = false;
  bool isDownloading = false;

  @override
  void initState() {
    setState(() {
      dayCount = getDayCount(widget.animal.birthday.toString());
    });

    Future.microtask(() async {
      await _fetchStatusData();
      await _fetchResultData();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope (
        onWillPop: () => _onBackPressed(context),
        child:Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: AppBar_Color,
              elevation: 1.0,
              title: Text("등록정보", style:TextStyle(color:AppBar_Title)),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppBar_Icon,),
                  onPressed: () {
                    _goBack();
                  }),
              actions: [
                // 알림
                IconButton(
                    icon: Image.asset(
                      "assets/icon/write.png",
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _goModify();
                    }),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header info
                  BuildAnimalCard(true, "$URL_IMAGE/${widget.animal.photo_url}",
                      widget.animal.name.toString(), dayCount),
                  // 상단 Bar

                  // 반려동물 헤더
                  const SizedBox(height: 20,),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
                      child: Row(
                        children: [
                          Image.asset("assets/icon/info.png", width: 20, height: 20, color: Colors.black,),
                          const SizedBox(width: 10,),
                          const Text("등록정보",
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
                          const Spacer(),
                          GestureDetector(
                            onTap: ()=>_goModify(),
                            child: Image.asset("assets/icon/write.png",
                              width: 20, height: 20, color: Colors.black,),
                          ),
                        ],
                      )
                  ),
                  // 반려동물 정보
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const SizedBox(height: 20,),
                        // ---------------------------------------------------------------
                        _getInfoRow("이 름:",widget.animal.name.toString(),
                            "반려동물\n등록번호:", widget.animal.registered_number.toString()),
                        _getInfoRow("구 분:",widget.animal.kind.toString(),
                            "비만도:", widget.animal.body_mass.toString()),
                        _getInfoRow("생년월일:",widget.animal.birthday.toString(),
                            "사상충\n예방접종:", widget.animal.heartworm_vaccination.toString()),
                        _getInfoRow("성 별:",widget.animal.sex.toString(),
                            "기초\n예방접종:", widget.animal.basic_vaccination.toString()),
                        _getInfoRow("중성화\n여부:",widget.animal.spayed.toString(),
                            "일평균\n배변횟수:", widget.animal.frequency_of_urination.toString()),
                        _getInfoRow("품종:",widget.animal.breed.toString(),
                            "일평균\n배뇨횟수:", widget.animal.frequency_of_defecation.toString()),
                        _getInfoRow("몸무게:","${widget.animal.weight.toString()}Kg",
                            "일평균\n산책횟수:", widget.animal.walks_per_week.toString()),
                        //-------------------------------------------------------------------
                      ],
                    ),
                  ),
                  // 하단 Bar
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Divider(height: 5.0, thickness: 4.0, color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 30,),
                  // 최근 검사중 헤더
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                      child: Row(
                        children: [
                          Image.asset("assets/icon/quick.png", width: 18, height: 18, color: Colors.black,),
                          const SizedBox(width: 10,),
                          const Text("최근 검사진행",
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),),
                          //Spacer(),
                          //Image.asset("assets/icon/notice.png", width: 18, height: 18, color: Colors.grey,),
                        ],
                      )
                  ),
                  BuildStatuslCard(),
                  const SizedBox(height: 20),
                  // 최근 검사결과 헤더
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                      child: Row(
                        children: [
                          Image.asset("assets/icon/icon_report.png", width: 18, height: 18, color: Colors.black,),
                          const SizedBox(width: 10,),
                          const Text("최근 검사결과",
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),),
                          //Spacer(),
                          //Image.asset("assets/icon/notice.png", width: 18, height: 18, color: Colors.grey,),
                        ],
                      )
                  ),
                  BuildResultCard(),
                  const SizedBox(height: 100),
                ],
              ),
            )
        )
    );
  }
  
  Widget _getInfoRow(String t1, String v1, String t2, String v2) {
    double field_size = MediaQuery.of(context).size.width/4.5;
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child:Row(
          children: [
            SizedBox(
              width: field_size-20,
              child: Text(t1,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black)),
            ),
            SizedBox(
              width: field_size+20,
              child: Text(v1,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            const Spacer(),
            SizedBox(
              width: field_size-20,
              child: Text(t2,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black)),
            ),
            SizedBox(
              width: field_size+20,
              child: Text(v2,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ],
        )
    );
  }

  Widget BuildStatuslCard() {
    double labelSize = MediaQuery.of(context).size.width*0.25;
    if(sLoaded){
      QuestionStatus status = sList[0];
      return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0,5,10,0),
                  width: labelSize,
                  child: const Text("이름",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text("${status.a_name}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),),

              ],
            ),
            //const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0,5,10,0),
                  width: labelSize,
                  child: const Text("키트번호",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text("${status.kit_number}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),),

              ],
            ),
            //const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0,5,10,0),
                  width: labelSize,
                  child: const Text("요청일자",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text("${status.request_stamp}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),),

              ],
            ),
            //const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0,10,10,0),
                  width: labelSize,
                  child: const Text("처리상태",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text("${status.process_status}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: _getStatus(status.process_status.toString()))),),

              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color:Colors.black.withOpacity(0.3),
                  blurRadius: 1,
                  spreadRadius: 1
              )
            ]
        ),
      );
    }
    else {
      return Container(
        height: 150,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 1,
                  spreadRadius: 1
              )
            ]
        ),
        child: const Center(
          child: Text("진쟁중인 검사정보가 없습니다.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),
        ),
      );
    }
  }

  Widget BuildResultCard() {
    //double labelSize = MediaQuery.of(context).size.width*0.25;
    if(rLoaded){
      QItemReport result = rList[0];
      return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color:Colors.black.withOpacity(0.3),
                  blurRadius: 1,
                  spreadRadius: 1
              )
            ]
        ),
        child:ListView.builder(
            itemCount:rList.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index){
          QItemReport item = rList[index];
          return Container(
            child:Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${item.a_name} - 검사결과", style: const TextStyle(fontSize: 16,)),
                              Text("검사일자: ${item.datetime}", style: const TextStyle(fontSize: 14,)),
                            ]
                        )
                    ),
                    Visibility(
                      visible: item.rpt_id.isNotEmpty,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.list_alt_outlined,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                            Transition(
                                child: WebExplorer(
                                    title: '${result.a_name} - 검사결과',
                                    website: "https://co-ani.com/report/?rpt_id=${item.rpt_id}"),
                                transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                            ),
                          );
                          //   _onDeleteItemPressed(index);
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(height: 5,),
              ],
            )
          );
        }),


        /*
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 키트번호
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(10),
            //       width: labelSize,
            //       child: const Text("키트번호",
            //           textAlign: TextAlign.start,
            //           style: TextStyle(
            //               fontSize: 14.0,
            //               fontWeight: FontWeight.normal,
            //               color: Colors.black)),
            //     ),
            //     Expanded(child: Text("${result.kit_number}",
            //         textAlign: TextAlign.start,
            //         style: const TextStyle(
            //             fontSize: 16.0,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black)),),
            //
            //   ],
            // ),
            const SizedBox(height: 10,),
            // 타이틀
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(10),
            //       width: labelSize,
            //       child: const Text("타이틀",
            //           textAlign: TextAlign.start,
            //           style: TextStyle(
            //               fontSize: 14.0,
            //               fontWeight: FontWeight.normal,
            //               color: Colors.black)),
            //     ),
            //     Expanded(child: Text("${result.subject}",
            //         textAlign: TextAlign.start,
            //         style: const TextStyle(
            //             fontSize: 16.0,
            //             fontWeight: FontWeight.normal,
            //             color: Colors.black)),),
            //
            //   ],
            // ),
            // const SizedBox(height: 10,),
            // // 검사소견
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(10),
            //       width: labelSize,
            //       child: const Text("검사소견",
            //           textAlign: TextAlign.start,
            //           style: TextStyle(
            //               fontSize: 14.0,
            //               fontWeight: FontWeight.normal,
            //               color: Colors.black)),
            //     ),
            //     Expanded(child: Text("${result.content}",
            //         textAlign: TextAlign.justify,
            //         style: const TextStyle(
            //             fontSize: 16.0,
            //             fontWeight: FontWeight.normal,
            //             color: Colors.black)),),
            //   ],
            // ),
            const SizedBox(height: 10,),
            // 완료일자
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: labelSize,
                  child: const Text("완료일자",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text("${result.datetime}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),),

              ],
            ),
            const SizedBox(height: 10,),
            // 첨부파일
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: labelSize,
                  child: Text("검사결과(${result.rpt_id})",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                // Expanded(
                //   child:Text("${result.attach_source}",
                //     textAlign: TextAlign.justify,
                //     style: const TextStyle(
                //         fontSize: 16.0,
                //         fontWeight: FontWeight.normal,
                //         color: Colors.blueAccent)),)
              ],
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   //crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Visibility(
            //       visible: (ext=="pdf") ? true : false,
            //       child: ElevatedButton(
            //         child: const Text('보고서', style: TextStyle(color: Colors.white, fontSize: 13),),
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.blueAccent,
            //             fixedSize: const Size(120, 36),
            //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            //         onPressed: () async {
            //           _showReport(result.attach_file.toString());
            //         },
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        */
      );
    }
    else {
      return Container(
        height: 150,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 1,
                  spreadRadius: 1
              )
            ]
        ),
        child: const Center(
          child: Text("검사결과 정보가 없습니다.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),
        ),
      );
    }
  }

  Future<void> fetchAnimal() async {
    if (kDebugMode) {
      print("fetchAnimal():...........................");
    }
      await Remote.infoAnimal(
          id: widget.animal.id.toString(),
          onResponse: (Animal info) {
            setState(() {
            widget.animal.copy(info);
            });
      });
  }

  Future<void> _goModify() async {
    var value = await Navigator.push(
      context,
      Transition(
          child: AnimalRegister(
            command: "UPDATE",
            animal: widget.animal,
            users_id: widget.animal.users_id.toString(), canDelete: true,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),

    );

    if(value != null) {
      bDirty = value;
      fetchAnimal();
    }
  }

  void _showReport(String attach_file){
    String reportUrl = "$URL_REPORT/$attach_file";
    if (kDebugMode) {
      print("reportUrl=$reportUrl");
    }
    downloadFile(reportUrl, "report.pdf");
  }

  Future downloadFile(String srcUrl, String fileName) async {
    setState(() {
      isDownload = true;
      isDownloading = false;
    });
    try {
      Dio dio = Dio();
      //String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
      String savePath = await getFilePath(fileName);
      if (kDebugMode) {
        print("downloadFile():savePath=$savePath");
      }

      await dio.download(srcUrl, savePath,
          onReceiveProgress: (rec, total) {
            setState(() {
              isDownloading = true; // 다운로드 진행중.
              double progress = (rec / total) * 100;
              if (kDebugMode) {
                print("download():: progress => ${progress.toInt()}.");
              }
            });
          }
      );

      setState(() {
        isDownload = false; // 다운로드 작업 종료.
        isDownloading = false; // 다운로드 완료.

        if (kDebugMode) {
          print("download() Finish => Completed.");
        }
        showPdf(savePath);
      });

    } catch (e) {
      isDownload = false; // 다운로드 작업 종료.
      isDownloading = false;
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
  
  Color _getStatus(String status) {
    if(status=="진단요청") {
      return Colors.redAccent;
    } else if(status=="진단접수") {
      return Colors.blueAccent;
    } else if(status=="검사완료") {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  void _goBack() {
    Navigator.pop(context, bDirty);
  }


  Widget BuildAnimalCard(bool isLoad, String photo_url, String title, String subTitle) {
    if(isLoad) {
      return Center(
        child: SizedBox(
          key: UniqueKey(),
          height: MediaQuery.of(context).size.width*0.8,
          child: Container(
            margin: const EdgeInsets.all(2),
            child: Stack(
              children: [
                Positioned(
                  child:GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 2400,
                      height: 2400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(photo_url,
                          fit: BoxFit.fill,
                          //cache: true, shape: BoxShape.rectangle,
                        ),
                      )
                    ),
                  ),
                ),
                const Positioned(
                  child: Column(),
                ),
              ],
            ),
          )
        ),
      );
    }else {
      return Container();
    }
  }

  Future<bool> _onBackPressed(BuildContext context) {
    _goBack();
    return Future(() => false);
  }

  Future<void> _fetchStatusData() async {
    sLoaded = false;
    await Remote.getQuestionStatus(params: {"command":"STATUS", "animals_id":"${widget.animal.id}"},
        onResponse: (List<QuestionStatus> list){
          setState(() {
            sList = list;
            if(sList.isNotEmpty) {
              sLoaded = true;
            }
          });
        });
  }

  Future<void> _fetchResultData() async {
    rLoaded = false;
    await Remote.getQReport(params: {"command":"LIST", "animals_id":"${widget.animal.id}"},
        onResponse: (List<QItemReport> list){
          setState(() {
            rList = list;
            rLoaded = true;
            // if(rList.isNotEmpty) {
            //
            // }
          });
        });


  }
}
