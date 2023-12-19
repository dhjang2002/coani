// ignore_for_file: non_constant_identifier_names, must_be_immutable, file_names, invalid_use_of_visible_for_testing_member
import 'package:coani/Models/itemAttach.dart';
import 'package:coani/Models/qItem.dart';
import 'package:coani/Questions/QTitle.dart';
import 'package:coani/Questions/CardAttach.dart';
import 'package:flutter/material.dart';

class QSelRadioCard extends StatefulWidget {
  final List<String> title;
  final String subTitle;
  final List<QItem> aList;
  final String initValue;
  final String tag;
  final bool isVertical;
  final bool isUseCode;
  final Function(String tag, String answerText, String attached) onSubmit;
  String? users_id;
  bool? attach;
  List<ItemAttach>? attachList;
  QSelRadioCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.aList,
    required this.initValue,
    required this.onSubmit,
    required this.tag,
    required this.isVertical,
    required this.isUseCode,
    this.attach = false,
    this.attachList   = const [],
    this.users_id = "0"
  }) : super(key: key);

  @override
  _QSelSCardState createState() => _QSelSCardState();
}

class _QSelSCardState extends State<QSelRadioCard> {
  String answerText = "";
  String answerCode = "";
  String attach_name = "";
  int    iSelect = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      iSelect = _getInitIndex();
      if(iSelect>=0) {
        answerCode = widget.aList[iSelect].lId.toString();
        answerText = widget.initValue;
      }
    });
  }

  int _getInitIndex() {
    for (int n = 0; n < widget.aList.length; n++) {
      if (widget.aList[n].sItem == widget.initValue ||
          widget.aList[n].lId.toString() == widget.initValue) {
        return n;
      }
    }
    return -1;
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
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        QTitle(
          titles: widget.title,
          subTitle: widget.subTitle,
          titleColor: Colors.black,
          subColor: Colors.black54,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
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
                    iSelect = index;
                    answerText = widget.aList[index].sItem;
                    answerCode = widget.aList[index].lId.toString();
                    if(widget.isUseCode) {
                      widget.onSubmit(widget.tag, answerCode, "");
                    } else {
                      widget.onSubmit(widget.tag, answerText, "");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(0,7,5,7),
                    color: Colors.transparent,
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon((iSelect==index)
                            ? Icons.radio_button_checked : Icons.radio_button_off_outlined,
                          color: (iSelect==index) ? Colors.blueAccent : Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(value,
                              maxLines: 20,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              letterSpacing: -0.8,
                              fontSize: 16.0),
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
              if(widget.isUseCode) {
                widget.onSubmit(tag, answerCode, attach_value);
              } else {
                widget.onSubmit(tag, answerText, attach_value);
              }
            })
            : Container(),
      ]),
    );
  }
}
