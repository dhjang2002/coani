import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemFeed {
  String id;       // id
  String name;     // 사료명칭
  String photo;    // 사진
  bool bSelect;
  //bool selected = false;
  ItemFeed({
    this.id="",
    this.name="",
    this.photo="",
    this.bSelect = false,
  });

  factory ItemFeed.fromJson(Map<String, dynamic> parsedJson)
  {
    if (kDebugMode) {
      var logger = Logger();
      logger.d(parsedJson);
    }
      return ItemFeed(
          id: parsedJson['id'],
          name: parsedJson['name'],
          photo: parsedJson['photo']
      );
  }

  static List<ItemFeed> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemFeed.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'ItemFeed {id:$id, name:$name, photo:$photo}';
  }
}