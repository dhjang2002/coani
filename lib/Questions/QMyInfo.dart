// ignore_for_file: non_constant_identifier_names

import 'package:coani/Constants/Patterns.dart';
import 'package:coani/Models/QuestionStatus.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:flutter/material.dart';

class QMyInfo extends StatefulWidget {
  const QMyInfo({Key? key, required this.users_id,}) : super(key: key);
  final String users_id;

  @override
  _QMyInfoState createState() => _QMyInfoState();
}

class _QMyInfoState extends State<QMyInfo> {
  late List<QuestionStatus> sList;
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
        title: const Text("검사진행",),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppBar_Icon,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: (bLoaded)
          ? (sList.isNotEmpty)
              ? ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: sList.length, //리스트의 개수
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
    double labelSize = MediaQuery.of(context).size.width*0.25;
    return GestureDetector(
      onTap: ()=>_onTab(index),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,10,10,10),
        margin: const EdgeInsets.fromLTRB(5,5,5,5),
        //height: 100,
        //color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                Expanded(child: Text("${sList.elementAt(index).a_name}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: labelSize,
                  child: const Text("키트번호",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text("${sList.elementAt(index).kit_number}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: labelSize,
                  child: const Text("처리상태",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text("${sList.elementAt(index).process_status}",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: _getStatus(sList.elementAt(index).process_status.toString()))),)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: labelSize,
                  child: const Text("요청일자",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
                Expanded(child: Text("${sList.elementAt(index).request_stamp}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),),
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
    await Remote.getQuestionStatus(params: {"command":"STATUS", "users_id":widget.users_id},
        onResponse: (List<QuestionStatus> list){
          setState(() {
            bLoaded = true;
            sList = list;
          });
        });
  }

  void _onTab(int index) {

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
}
