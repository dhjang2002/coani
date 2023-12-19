// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'package:coani/Constants/HostInfo.dart';
import 'package:coani/Models/Animal.dart';
import 'package:coani/Models/Codes.dart';
import 'package:coani/Models/Files.dart';
import 'package:coani/Models/Message.dart';
import 'package:coani/Models/Person.dart';
import 'package:coani/Models/QResult.dart';
import 'package:coani/Models/QuestionStatus.dart';
import 'package:coani/Models/Questions.dart';
import 'package:coani/Models/AResult.dart';
import 'package:coani/Models/itemFeed.dart';
import 'package:coani/Models/qItemReport.dart';
import 'package:coani/Models/qMenuData.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
//import 'dart:developer' as logDev;

// http://http://211.175.164.71/data/file/report/1889929298_lHb8uikx_c6f725d752871a270687568fdf7fba915a32690c.pdf
// http://211.175.164.71/app/req_message.php?command=LIST&users_id=20;

// http://211.175.164.71/app/req_checkup_results.php?command=SERVICE
// http://211.175.164.71/app/req_checkup_results.php?command=INFO
// http://211.175.164.71/app/req_checkup_results.php?command=ANIMALS
// http://211.175.164.71/app/req_checkup_results.php?command=OWNER&users_id=20;

// http://211.175.164.71/app/req_install.php?command=CHECKUP
// http://211.175.164.71/app/req_install.php?command=RESULT

// http://211.175.164.71/app/req_animals.php?command=UPDATE&id=4&name=해탈이
// http://211.175.164.71/app/req_animals.php?command=LIST&users_id=20

// http://211.175.164.71/app/req_question.php?command=INFO&id=1
// http://211.175.164.71/app/req_question.php?command=LIST&users_id=20
// http://211.175.164.71/app/req_question.php?command=UPDATE&id=1&is_complete=N

// http://211.175.164.71/app/req_question.php?command=STATUS&users_id=20
// http://211.175.164.71/app/req_question.php?command=STATUS&animals_id=0

// http://211.175.164.71/app/req_users.php?command=INFO&mb_no=2
// http://211.175.164.71/app/req_users.php?command=CHECK&mb_id=dhjang2002
// http://211.175.164.71/app/req_users.php?command=LOGIN&mb_id=dhjang2002&mb_password=sdmk1221
// http://211.175.164.71/app/req_users.php?command=UPDATE&mb_no=2&mb_name=홍길동
// http://211.175.164.71/app/req_users.php?command=UPDATE&mb_no=2&mb_password=sdmk1221

// http://211.175.164.71/app/req_codes.php?command=LIST&group=반려견품종


class Remote{
  static Future login({required String uid, required String pwd,
    required Function(int status, Person person) onResponse}) async {
    await request(target: "req_users", params: {"command":"LOGIN", "mb_id":uid, "mb_password":pwd},
        onResult: (AResult result) {
          if(result.result=="NETWORK"){
            return onResponse(-1, Person());
          }
          if(result.result=="OK" && result.isData=="Y") {
            return onResponse(1, Person.fromJson(result.list!.elementAt(0)));
          }
          return onResponse(0, Person());
    });
  }

  static Future getMessage({required String users_id,
    required Function(List <Message> list) onResponse}) async {
    await request(target: "req_message", params: {"command":"LIST", "users_id":users_id},
        onResult: (AResult result) {
          List <Message> list = <Message>[];
          if(result.result=="OK" && result.isData=="Y"){
            for(int n=0; n<result.list!.length; n++){
              list.add(Message.fromJson(result.list!.elementAt(n)));
            }
          }
          onResponse(list);
    });
  }

  static Future addMessage({required String users_id, required String q_id,
    required String a_name, required String message,
    required Function(int result) onResponse}) async {
    await request(target: "req_message",
        params: {
          "command":"ADD",
          "users_id":users_id,
          "q_id":q_id,
          "a_name":a_name,
          "message":message,
          "status":"검사신청"
        },
        onResult: (AResult result) {
          if(result.result=="OK") {
            onResponse(1);
          } else {
            onResponse(0);
          }
        });
  }

  static Future getServiceCount({required String users_id,
    required Function(String count) onResponse}) async {
    String count = "10000";
    await request(target: "req_checkup_results", params: {"command":"SERVICE", "users_id":users_id},
        onResult: (AResult result) {
          if(result.result=="OK"){
            count = result.message!;
          }
        });
    onResponse(count);
  }

  // {"COMMAND":"OWNER", "users_id":"10"}
  // {"COMMAND":"ANIMALS", "animals_id":"10"}
  static Future getQResult({
    required Map<String, String> params,
    required Function(List <QResult> list) onResponse}) async {
    await request(target: "req_checkup_results", params: params,
        onResult: (AResult result) {
          List <QResult> list = <QResult>[];
          if(result.result=="OK" && result.isData=="Y"){
            for(int n=0; n<result.list!.length; n++){
              list.add(QResult.fromJson(result.list!.elementAt(n)));
            }
          }
          onResponse(list);
        });
  }

  static Future getQReport({
    required Map<String, String> params,
    required Function(List <QItemReport> list) onResponse}) async {
    await request(target: "req_report", params: params,
        onResult: (AResult result) {
          List <QItemReport> list = [];
          if(result.result=="OK" && result.isData=="Y"){
            list = QItemReport.fromSnapshot(result.list!);
          }
          onResponse(list);
        });
  }

  static Future updatePersonInfo({
    required Map<String, String> params,
    required Function(int result) onResponse}) async {
    //Map<String, String> params = person.toMap();
    params.addAll({"command":"UPDATE"});
    await request(target: "req_users",
        params: params,
        onResult: (AResult result) {
          if(result.result=="OK") {
            onResponse(1);
          } else {
            onResponse(0);
          }
        });
  }

  static Future updatePerson({
    required Person person,
    required Function(int result) onResponse}) async {
    Map<String, String> params = person.toMap();
    params.addAll({"command":"UPDATE"});
    await request(target: "req_users",
        params: params,
        onResult: (AResult result) {
          if(result.result=="OK") {
            onResponse(1);
          } else {
            onResponse(0);
          }
    });
  }

  static Future registPerson({required Person person,
    required Function(int result) onResponse}) async {
    Map<String, String> params = person.toMap();
    params.addAll({"command":"ADD"});
    await request(target: "req_users",
        params: params,
        onResult: (AResult result) {
          if(result.result=="OK") {
            onResponse(1);
          } else {
            onResponse(0);
          }
    });
  }

  static Future getCodes({required String category, required String key,
    required Function(List <Codes> list) onResponse}) async {
    await request(target: "req_codes",
        params: {"command":"LIST", "group":category, "key":key},
        onResult: (AResult result) {
          List <Codes> list = <Codes>[];
          if(result.result=="OK" && result.list!.isNotEmpty) {
            for(int n=0; n<result.list!.length; n++){
              list.add(Codes.fromJson(result.list!.elementAt(n)));
            }
          }
          onResponse(list);
      });
  }

  static Future getFeed({
    required String category,
    required String key,
    required Function(List <ItemFeed> list) onResponse}) async {
    await request(target: "req_codes",
        params: {"command":"LIST", "feed":category, "key":key},
        onResult: (AResult result) {
          List <ItemFeed> list = [];
          if(result.result=="OK" && result.list!.isNotEmpty) {
            for(int n=0; n<result.list!.length; n++){
              list.add(ItemFeed.fromJson(result.list!.elementAt(n)));
            }
          }
          onResponse(list);
        });
  }

  static Future getAnimals({required String users_id,
    required Function(List <Animal> info) onResponse}) async {
    List <Animal> list = <Animal>[];
    await request(target: "req_animals", params: {"command":"LIST", "users_id":users_id},
        onResult: (AResult result) {
          if(result.result=="OK" && result.list!.isNotEmpty){
            for(int n=0; n<result.list!.length; n++){
              list.add(Animal.fromJson(result.list!.elementAt(n)));
            }
          }
          onResponse(list);
        });
  }

  // static Future login({required String uid, required String pwd, required Function(Person person) onResponse}) async {
  static Future infoAnimal({required String id,
    required Function(Animal info) onResponse }) async {
    await request(target: "req_animals", params: {"command":"INFO", "id":id},
        onResult: (AResult result) {
          if(result.result=="OK") {
            return onResponse(Animal.fromJson(result.list!.elementAt(0)));
          }
    });
  }

  static Future updateAnimal({required Animal animal,
    required Function(bool result) onResponse}) async {
    Map<String, String> params = animal.toMap();
    params.addAll({"command":"UPDATE"});
    await request(target: "req_animals", params: params,
        onResult: (AResult result) {
          if(result.result=="OK") {
            return onResponse(true);
          }
          return onResponse(false);
        });
    //return onResponse(false);
  }

  static Future deleteAnimal({required Animal animal,
    required Function(bool result) onResponse}) async {
    Map<String, String> params = animal.toMap();
    params.addAll({"command":"DELETE"});
    await request(target: "req_animals", params: params,
        onResult: (AResult result) {
          if(result.result=="OK") {
            return onResponse(true);
          }
          return onResponse(false);
        });
  }

  //static Future login({required String uid, required String pwd, required Function(Person person) onResponse}) async {
  static Future addAnimal({
    required users_id, required Animal animal,
    required Function(Animal info) onResponse}) async {
    Map<String, String> params = animal.toAddMap();
    params.addAll({"command":"ADD", "users_id":users_id});

    //print("addAnimal()=>" + params.toString());

    await request(target: "req_animals", params: params,
        onResult: (AResult result)
        {
          if (kDebugMode) {
            print(result.toString());
          }
          if(result.result=="OK" && result.isData=="Y") {
            onResponse(Animal.fromJson(result.list!.elementAt(0)));
          }
        });
  }

  static Future reqQuestion({
    required Questions question,
    required Function(String result) onResponse}) async {
    Map<String, String> data = question.toAddMap();
    Map<String, String> params = {};
    data.forEach((key, value) {
      if(value.isNotEmpty) {
        params.addAll({key:value});
      }
    });

    if(data['id'].toString().isNotEmpty) {
      params.addAll({"command": "UPDATE"});
    } else {
      params.addAll({"command": "ADD"});
    }

    if (kDebugMode) {
      String jdata = jsonEncode(params);
      if (kDebugMode) {
        print("ItemContent::fromJson()==========>");
        var logger = Logger();
        logger.d(jdata);
      }
      log(params.toString(),name:"myLog");
    }

    await request(target: "req_question",
        params: params,
        onResult: (AResult result) {
          if(result.result=="OK") {
            onResponse(result.added_id.toString());
          } else {
            onResponse("0");
          }
        });
  }

  // http://211.175.164.71/app/req_question.php?command=INFO&id=1
  static Future <Questions?> infoQuestion({
    required String id,
    required Function(Questions info) onResponse}) async {
    await request(target: "req_question", params: {"command":"INFO", "id":id},
        onResult: (AResult result) {
          if(result.result=="OK") {
            onResponse(Questions.fromJson(result.list!.elementAt(0)));
          }
    });
    return null;
  }

  static Future <void> infoTempQuestion({
    required String users_id,
    required String animal_id,
    required Function(Questions? info) onResponse}) async {
    await request(
        target: "req_question",
        params: {
          "command":"TEMP",
          "users_id":users_id,
          "animal_id":animal_id
      },
      onResult: (AResult result) {
        if(result.result=="OK" && result.list!.isNotEmpty) {
          onResponse(Questions.fromJson(result.list!.elementAt(0)));
        } else {
          onResponse(null);
        }
      }
    );
  }

  static Future <void> deleteQuestion({
    required String id,
    required Function(String result) onResponse}) async {
    await request(target: "req_question", params: {"command":"DELETE", "id":id},
        onResult: (AResult result) {
            onResponse(result.result!);
        }
    );
  }

  // {"command":"STATUS", "users_id":"20"}
  // {"command":"STATUS", "animals_id":"1"}
  static Future getQuestionStatus({
    required Map<String,String> params,
    required Function(List <QuestionStatus> info) onResponse}) async {
    List <QuestionStatus> list = <QuestionStatus>[];
    await request(target: "req_question", params: params,
        onResult: (AResult result) {
          if(result.result=="OK" && result.list!.isNotEmpty){
            for(int n=0; n<result.list!.length; n++){
              list.add(QuestionStatus.fromJson(result.list!.elementAt(n)));
            }
          }
          onResponse(list);
        });
  }

  // {"command":"LIST", "users_id":"20"}
  // {"command":"LIST", "animals_id":"1"}
  static Future getQuestions({
    required Map<String,String> params,
    required Function(List <Questions> info) onResponse}) async {
    List <Questions> list = <Questions>[];
    await request(target: "req_question", params: params,
        onResult: (AResult result) {
          if(result.result=="OK" && result.list!.isNotEmpty){
            for(int n=0; n<result.list!.length; n++){
              list.add(Questions.fromJson(result.list!.elementAt(n)));
            }
          }
          onResponse(list);
        });
  }

  static Future getQItems({
    required Map<String,String> params,
    required Function(QMenuData data) onResponse}) async {
await request(target: "req_items", params: params,
    onResult: (AResult result) {
      // if (kDebugMode) {
      //   var logger = Logger();
      //   logger.d(result);
      // }

      QMenuData data = QMenuData();
      if(result.result=="OK"){
        data = QMenuData.fromJson(result.data);
      }
      onResponse(data);
    }
);
}

  static Future reqFile({required String filePath,
    required Map<String,String> params,
    required Function(int result, Files info) onUpload}) async{
    List<String> splite = filePath.split(".");
    if(splite.length>1) {
      String ext = splite[splite.length - 1];
      params.addAll({"ext":ext});
    }

    if (kDebugMode) {
      print("reqFile()::params="+params.toString());
    }

    await upload(params: params, filePath: filePath,
        onResult: (AResult result) {
          if(result.result=="OK" && result.isData=="Y") {
            return onUpload(1, Files.fromJson(result.list!.elementAt(0)));
          } else {
            return onUpload(0, Files());
          }
    });
  }

  static Future <void> request({
    required String target,
    required Map<String,String> params,
    required Function(AResult result) onResult}) async {

    final Map<String,String> headers = { "Content-type": "multipart/form-data" };
    var request = http.MultipartRequest('POST', Uri.parse("$URL_API/$target.php"),);

    if (kDebugMode) {
      print("request()::"+Uri.parse("$URL_API/$target.php").toString());
    }

    request.headers.addAll(headers);
    if(params.isNotEmpty) {
      request.fields.addAll(params);
    }

    try {
      var res = await request.send();
      if (res.statusCode == 200) {
        String data = await res.stream.bytesToString();
        if (kDebugMode) {
          log(data,name:"myLog");
        }
        int start = data.indexOf('{', 0);
        if (start > 0) {
          data = data.substring(start);
        }
        return onResult(AResult.fromJson(jsonDecode(data)));
      }
      if (kDebugMode) {
        print("Response> Http Error CODE=" + res.statusCode.toString());
      }
      return onResult(AResult(
          result: "FAIL",
          message: "${res.statusCode}",
          added_id: "",
          pageNo: "",
          isData: "N"));
    }
    catch(e) {
      return onResult(AResult(result: "FAIL",
          message: "네트워크 장애!:${e.toString()}",
          added_id: "",
          pageNo: "",
          isData: "N"));
    }
   }

  static Future <void> upload({
    required String filePath,
    required Map<String,String> params,
    required Function(AResult result) onResult}) async {
    final Map<String,String> headers = { "Content-type": "multipart/form-data" };
    var request = http.MultipartRequest('POST',
      Uri.parse("$URL_API/req_files.php"),);

    request.headers.addAll(headers);
    request.fields.addAll(params);

    // 파일 업로드
    if (filePath.isNotEmpty) {
      //print("upload():Path="+filePath);
        if (await io.File(filePath).exists()) {
          request.files.add(await http.MultipartFile.fromPath('file_data', filePath));
        }
    }

    try {
      var res = await request.send();

      if (res.statusCode == 200) {
        String data = await res.stream.bytesToString();

        //print("Response>"+data);

        int start = data.indexOf('{', 0);
        if (start > 0) {
          data = data.substring(start);
        }
        return onResult(AResult.fromJson(jsonDecode(data)));
      }
      if (kDebugMode) {
        print("Response> Http Error CODE=" + res.statusCode.toString());
      }
      return onResult(AResult(result: "FAIL",
          message: "${res.statusCode}",
          added_id: "",
          pageNo: "",
          isData: "N"));
    }
    catch (e){
      if (kDebugMode) {
        print("Response> Http Error CODE=" + e.toString());
      }
      return onResult(AResult(result: "FAIL",
          message: "네트워크 장애!",
          added_id: "",
          pageNo: "",
          isData: "N"));
    }
  }
}