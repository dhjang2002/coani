// ignore_for_file: non_constant_identifier_names, must_be_immutable, invalid_use_of_visible_for_testing_member

import 'package:coani/Codes/SelectFeedList.dart';
import 'package:coani/Codes/SelectList.dart';
import 'package:coani/Models/Codes.dart';
import 'package:coani/Models/itemAttach.dart';
import 'package:coani/Models/itemFeed.dart';
import 'package:coani/Questions/CardAttach.dart';
import 'package:coani/Questions/QTitle.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:coani/Utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';

class QFormCard extends StatefulWidget {
  final String tag;
  final List<String> title;
  final String initValue;
  final String hint;
  final String subTitle;

  int ? maxLines = 1;
  final bool useSelect;
  final bool? allowTap;
  final String  selKind;


  String?  users_id;

  bool?    attach;
  List<ItemAttach>? attachList;

  bool ? shareText;
  bool ? edit_unlock;

  TextInputType? keyboardType = TextInputType.text;
  final Function(String tag, String value, String attached) onChanged;
  QFormCard({
    Key? key,
    required this.title,
    required this.subTitle,
    this.allowTap = true,
    this.keyboardType,
    this.maxLines,
    required this.initValue,
    required this.tag,
    required this.hint,
    required this.onChanged,
    this.useSelect=false ,
    required this.selKind,
    this.attach=false,
    this.attachList = const [],
    this.users_id="0",
    this.shareText=false,
    this.edit_unlock=false
  }) : super(key: key);

  @override
  _QFormCardState createState() => _QFormCardState();
}

class _QFormCardState extends State<QFormCard> {
  TextEditingController tController = TextEditingController();
  String attach_name = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      tController.text = widget.initValue;
    });
  }

  @override
  void dispose() {
    tController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool read_only = false;
    if(widget.useSelect && widget.allowTap!) {
      read_only = true;
      if(widget.edit_unlock!) {
        read_only = false;
      }
    }

    //final shareText = Provider.of<ShareText>(context);
    return Container(
      margin: const EdgeInsets.all(6),
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
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QTitle(
            titles: widget.title,
            subTitle:widget.subTitle,
            titleColor:Colors.black,
            subColor: Colors.black54,),
          const SizedBox(height:10),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: tController,
                readOnly: read_only,//(widget.useSelect) ? true : false,
                keyboardType: widget.keyboardType,//TextInputType.text,
                maxLines: widget.maxLines,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold, ),
                onTap: () {
                  if(widget.allowTap! && widget.useSelect) {
                    _openMenu();
                  }
                },
                onChanged: (String value){
                  widget.onChanged(widget.tag, value, "");
                },
                decoration: (widget.useSelect)
                    ? InputDecoration(
                  hintText: widget.hint,
                  border: const OutlineInputBorder(),
                  hintStyle: TextStyle(
                      color: Colors.grey[500]),
                  suffixIcon: IconButton (
                    onPressed: () async {
                      _openMenu();
                    },
                    icon: const Icon(Icons.list),
                  ) ,
                )
                    : InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: const OutlineInputBorder(),
                  hintText: widget.hint,
                )
              ),
            ),
          ),

          (widget.attach! && widget.attachList!.isNotEmpty)
              ? CardAttach(
              users_id: widget.users_id!,
              attachList: widget.attachList!,
              onUpdate: (tag, attach_value) {
                widget.onChanged(tag, tController.text, attach_value);
              })
              : Container(),
        ]
      ),
    );
  }

  Future <void> _openMenu() async {
    // 1: 반려견품종, 2:반려묘품종, 3:관심사항
    int minCheckCount = 1;
    bool isMulti = false;
    String category = "반려견품종";
    if(widget.selKind=="강아지"){
      minCheckCount = 1;
      isMulti = false;
      category = "반려견품종";
    }
    else if(widget.selKind=="고양이"){
      minCheckCount = 1;
      isMulti = false;
      category = "반려묘품종";
    }
    else if(widget.selKind=="관심사항"){
      minCheckCount = 2;
      isMulti = true;
      category = "관심사항";
    }
    else if(widget.selKind=="사료이름"){
      minCheckCount = 1;
      isMulti = false;
      category = "사료이름";
    }else{
      category = "";
    }

    if(category=="사료이름") {
      await Remote.getFeed(
          category: category,
          key: "",
          onResponse: (List<ItemFeed> items) async {
            var result = await Navigator.push(context,
              Transition(
                  child: SelectFeedList(),
                  transitionEffect: TransitionEffect
                      .RIGHT_TO_LEFT),
            );

            if (result != null) {
              setState(() {
                tController.text = result;
                widget.onChanged(widget.tag, result, "");
                if (kDebugMode) {
                  print("사료명칭 ===> " + result);
                }
              });
            }
          }
      );
    }
    else if(category.isNotEmpty) {
      await Remote.getCodes(
          category: category,
          key: "",
          onResponse: (List<Codes> list) async {
            List<String> items = <String>[];
            for (var element in list) {
              items.add(element.name.toString());
            }
            var result = await Navigator.push(context,
              Transition(
                  child: SelectList(cotegory: category,
                      items: items,
                      minCheckCount: minCheckCount,
                      isMulti: isMulti),
                  transitionEffect: TransitionEffect
                      .RIGHT_TO_LEFT),
            );

            if (result != null) {
              setState(() {
                tController.text = result;
                widget.onChanged(widget.tag, result, "");
                if (kDebugMode) {
                  print("반려견품종 ===> " + result);
                }
              });
            }
          }
      );
    }
    else{
      showPopupMessage(context,
        const Text("반려동물의 유형을 선택해 주세요.",
          style: TextStyle(fontSize: 16, color: Colors.black,
              fontWeight: FontWeight.bold),),);
    }
  }


}
