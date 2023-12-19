// ignore_for_file: non_constant_identifier_names, file_names
import 'package:coani/Models/qItemReport.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:coani/Webview/WebExplorer.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';
import 'package:coani/Constants/Patterns.dart';

class QMyResult extends StatefulWidget {
  const QMyResult({
    Key? key,
    required this.users_id,
  }) : super(key: key);
  final String users_id;

  @override
  _QMyResultState createState() => _QMyResultState();
}

class _QMyResultState extends State<QMyResult> {
  late List<QItemReport> rList;
  bool bLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("검사결과",),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppBar_Icon,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body:(bLoaded)
          ? (rList.isNotEmpty)
            ? ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: rList.length, //리스트의 개수
            itemBuilder: (BuildContext context, int index) {
              return _getListItem(index);
            },
              )
            : const Center( child: Text("데이터가 없습니다.", style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.grey)),)
          : const Center(child: CircularProgressIndicator(),)
    );
  }

  Widget _getListItem(int index){
    QItemReport item = rList[index];
    double labelSize = MediaQuery.of(context).size.width*0.25;

    return GestureDetector(
      //onTap: ()=>_onTab(index),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,10,10,10),
        margin: const EdgeInsets.fromLTRB(5,5,5,5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 타이틀
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: labelSize,
                  child: const Text("이름",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text(item.a_name,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),)

              ],
            ),
            // 키트번호

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: labelSize,
                  child: const Text("품종",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text(item.a_breed,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),)

              ],
            ),

            // 완료일자
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: labelSize,
                  child: const Text("작성일자",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text(item.datetime,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),),

              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(
                  visible: true,//(ext=="pdf") ? true : false,
                  child: ElevatedButton(
                    child: const Text('보고서', style: TextStyle(color: Colors.white, fontSize: 12),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        fixedSize: const Size(100, 38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      _showReportView(item.rpt_id, "${item.a_name} - 검사결과");
                    },
                  ),
                ),
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
      ),
    );
  }

  Future<void> _fetchData() async {
    await Remote.getQReport(params: {"command":"USER", "user_id":widget.users_id},
        onResponse: (List<QItemReport> list){
          setState(() {
            rList = list;
            bLoaded = true;
          });
        });
  }

  /*
  void _onTab(int index) {}

  void _showReport(String attachFile){
    String reportUrl = "$URL_REPORT/$attachFile";
    if (kDebugMode) {
      print("reportUrl=$reportUrl");
    }
    downloadFile(reportUrl, "report.pdf");
  }

  Future downloadFile(String srcUrl, String fileName) async {
    try {
      Dio dio = Dio();
      String savePath = await getFilePath(fileName);
      if (kDebugMode) {
        print("downloadFile():savePath=$savePath");
      }

      await dio.download(srcUrl, savePath,
          onReceiveProgress: (rec, total) {
            setState(() {
              double progress = (rec / total) * 100;
              if (kDebugMode) {
                print("download():: progress => ${progress.toInt()}.");
              }
            });
          }
      );

      setState(() {
        if (kDebugMode) {
          print("download() Finish => Completed.");
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
  */

  Future<void> _showReportView(String rpt_id, String title) async {
    String url = "https://co-ani.com/report?rpt_id=$rpt_id";
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

}
