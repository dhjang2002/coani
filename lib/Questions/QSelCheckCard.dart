// ignore_for_file: non_constant_identifier_names, invalid_use_of_visible_for_testing_member, must_be_immutable, file_names
import 'package:coani/Models/itemAttach.dart';
import 'package:coani/Models/qItem.dart';
import 'package:coani/Questions/CardAttach.dart';
import 'package:coani/Questions/QTitle.dart';
import 'package:flutter/material.dart';

class QSelCheckCard extends StatefulWidget {
  final List<String> title;
  final String subTitle;
  final List<QItem> aList;
  final String initValue;
  final String tag;
  final bool isMulti;
  final bool isUseCode;
  final Function(String tag, String value, String attached) onSubmit;
  String? users_id;
  bool? attach;
  List<ItemAttach>? attachList;
  QSelCheckCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.aList,
    required this.initValue,
    required this.onSubmit,
    required this.tag,
    required this.isMulti,
    required this.isUseCode,
    this.attach = false,
    this.attachList = const [],
    this.users_id = "0"
  }) : super(key: key);

  @override
  _QSelSCardState createState() => _QSelSCardState();
}

class _QSelSCardState extends State<QSelCheckCard> {
  String answer = "";
  String attach_name = "";
  bool isCheckAll = false;

  List<String> _getInitValues() {
    List<String> result = [];
    String values = widget.initValue;
    List iList = values.split("|");
    for (var element in iList) {
      result.add(element);
    }
    return result;
  }

  int _findMenuIndex(String value) {
    for(int n=0; n<widget.aList.length; n++) {
      if(widget.aList[n].sItem==value || widget.aList[n].lId.toString()==value) {
        return n;
      }
    }
    return -1;
  }

  @override
  void initState() {
    setState(() {
      answer = widget.initValue;
      for(int n=0; n<widget.aList.length; n++) {
        widget.aList[n].bSelect = false;
      }

      var valueList = _getInitValues();
      for (int n = 0; n<valueList.length; n++) {
        int inx = _findMenuIndex(valueList[n]);
        if (inx >= 0) {
          widget.aList[inx].bSelect = true;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 1,
                spreadRadius: 1)
          ]
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QTitle(
              titles: widget.title,
              subTitle: widget.subTitle,
              titleColor: Colors.black,
              subColor: Colors.black54,
            ),
            const SizedBox(
              height: 10,
            ),

            // 전체선택
            GestureDetector(
                onTap: () {
                  setState(() {
                  isCheckAll = !isCheckAll;
                    for(int n=0; n<widget.aList.length; n++) {
                      widget.aList[n].bSelect = isCheckAll;
                    }
                  });
                  widget.onSubmit(
                      widget.tag,
                      _getSelectValues(),
                      ""
                  );
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Row(
                      children: [
                        Icon( (isCheckAll) ? Icons.check_box : Icons.check_box_outline_blank,
                          color: (isCheckAll) ? Colors.blueAccent : Colors.black,
                        ),
                        const SizedBox(width: 10),
                        const Text("전체선택",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                )
            ),

            const Divider(height: 10,),
            Container(
              color: Colors.white,
              //padding: const EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: widget.aList.length,
                itemBuilder: (BuildContext context, int index) {
                  String value  = widget.aList[index].sItem;
                  return GestureDetector(
                      onTap: (){
                        _onTab(index);
                        widget.onSubmit(widget.tag, answer, "");
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(0,7,5,7),
                        color: Colors.transparent,
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon((widget.aList[index].bSelect) ? Icons.check_box : Icons.check_box_outline_blank,
                              color: (widget.aList[index].bSelect) ? Colors.blueAccent : Colors.black,
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(value,
                              maxLines: 5,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -0.8,
                                  fontSize: 15.0),
                            )),
                          ],
                        ),
                      )
                  );
                },
              ),
            ),

            (widget.attach! && widget.attachList!.isNotEmpty)
                ? CardAttach(
                users_id: widget.users_id!,
                attachList: widget.attachList!,
                onUpdate: (tag, attach_value) {
                  widget.onSubmit(tag, answer, attach_value);
                })
                : Container(),
      ]),
    );
  }

  void _onTab(int index) {
    if (widget.isMulti) {
      setState(() {
        widget.aList[index].bSelect = !widget.aList[index].bSelect;
      });
    }
    else
    {
      setState(() {
        widget.aList[index].bSelect = !widget.aList[index].bSelect;
        for (int n = 0; n < widget.aList.length; n++) {
          if (n != index) {
            if (widget.aList[n].bSelect) {
              widget.aList[n].bSelect = false;
            }
          }
        }
      });
    }
    answer = _getSelectValues();
  }

  String _getSelectValues() {
    String codestring = "";
    for (int n = 0; n < widget.aList.length; n++) {
      if (widget.aList[n].bSelect) {
        if (codestring.isNotEmpty) {
          codestring += "|";
        }
        if(widget.isUseCode) {
          codestring += widget.aList[n].lId.toString();
        } else {
          codestring += widget.aList[n].sItem;
        }
      }
    }
    return codestring;
  }
}
