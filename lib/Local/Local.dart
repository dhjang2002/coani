
import 'dart:convert';
import 'dart:io';
import 'package:coani/Models/Model.dart';
import 'package:coani/Models/Person.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Local {
  Local();

  static Future<int> delete({required String fileName}) async {
    try {
      File file = await getDocPath(fileName: fileName);
      await file.delete();
      return 1;
    } catch (e) { return 0; }
  }

  static Future <File> getDocPath({required String fileName}) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(dir.path+"/"+fileName);
  }

  static Future <Person?> loadPerson() async {
    try {

      //String fileName = (new Person().getFilename());
      File file = await getDocPath(fileName: (Person().getFilename()));

      //String data = await file.readAsString(); // 파일 읽기.
      dynamic jsonData = jsonDecode(await file.readAsString());

      return Person.fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }

  static Future <int?> save({required Model model}) async {
    try {
      File file = await getDocPath(fileName: model.getFilename());
      //var data = model.toMap();
      String jsonData = jsonEncode(model.toMap());

      if (kDebugMode) {
        print(jsonData);
      }
      await file.writeAsString(jsonData); // 파일 쓰기.

      return 1;

    } catch (e) { return 0;}
  }
}