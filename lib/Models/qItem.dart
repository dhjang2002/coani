import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class QItem {
  int lId;
  int type;
  String sItem;
  bool bSelect;

  QItem({
    this.lId=0,
    this.type = 0,
    this.sItem="",
    this.bSelect=false
  });

  // static void trimLabel(final List<QItem> list) {
  //   final RegExp regExp = RegExp(r'<p class="fs-13 text-grey-500">(.*?)</p>');
  //   // String text = "<p class="fs-13 text-grey-500">보호자에게 의존적이지 않을 것으로 보입니다. </p>";
  //   // String extractedText = regExp.firstMatch(text)?.group(1) ?? "";
  //   // print(extractedText);
  //   for (var value in list) {
  //     value.sItem = regExp.firstMatch(value.sItem)?.group(1) ?? "";
  //     value.sItem = value.sItem.replaceAll("<p class=\"fs-13 text-grey-500\">", "");
  //     value.sItem = value.sItem.replaceAll("</p>", "");
  //   }
  // }

  static List<QItem> fromMenuList(List<String> list) {
    int id = 1;
    List<QItem> itemList = [];
    for (var element in list) {
      itemList.add(QItem(sItem: element, lId:id++));
    }
    return itemList;
    // return list.map((data) {
    //   return QItem.fromText(data);
    // }).toList();
  }

  factory QItem.fromText(String label, int id) {
    return QItem(sItem: label, lId: id, type:0, bSelect: false);
  }

  static List<QItem> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return QItem.fromJson(data);
    }).toList();
  }

  factory QItem.fromJson(Map<String, dynamic> jdata)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    QItem item = QItem(
      lId: (jdata['inx'] != null)
          ? int.parse(jdata['inx'].toString().trim()) : 0,

      sItem: (jdata['label'] != null)
          ? jdata['label'].toString().trim() : "",

    );
    return item;
  }
}