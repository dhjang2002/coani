
import 'dart:convert';
import 'package:coani/Models/Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config extends Model {
  final String prefAuth = "Config";
  String? uid;
  String? pwd;
  String? users_id;
  String? isSigned;
  String? auto_login;
  String? skip_intro;
  String? firebase_token;

  //Config({this.uid, this.pwd, this.users_id, this.auto_login, this.skip_intro});
  Config() {
    clear();
  }

  @override
  void clear() {
    uid = "";
    pwd = "";
    users_id = "";
    auto_login = "";
    //skip_intro = "";
    isSigned = "";
    firebase_token = "";
  }

  void clearSignInfo() {
    uid = "";
    pwd = "";
    users_id = "";
    auto_login = "";
    isSigned = "";
  }

  Future<void> getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = await prefs.getString(prefAuth);
    if(value != null) {
      dynamic json = jsonDecode(value);
      uid = (json.containsKey("uid")) ? json['uid'] : "";
      pwd = (json.containsKey("pwd")) ? json['pwd'] : "";
      users_id = (json.containsKey("users_id")) ? json['users_id'] : "";
      skip_intro = (json.containsKey("skip_intro")) ? json['skip_intro'] : "";
      auto_login = (json.containsKey("auto_login")) ? json['auto_login'] : "";
      isSigned = (json.containsKey("isSigned")) ? json['isSigned'] : "";
      firebase_token = (json.containsKey("firebase_token")) ? json['firebase_token'] : "";
    }
    else{
      clear();
    }
  }

  Future<void> setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = toMap();
    final json = jsonEncode(map);
    await prefs.setString(prefAuth, json.toString());
  }

  @override
  String getFilename() {
    // TODO: implement getFilename
    throw UnimplementedError();
  }

  @override
  Map<String, String> toMap() => {
    'uid': uid.toString(),
    'pwd': pwd.toString(),
    'users_id': users_id.toString(),
    'auto_login': auto_login.toString(),
    'skip_intro': skip_intro.toString(),
    'isSigned': isSigned.toString(),
    'firebase_token': firebase_token.toString()
  };

  @override
  String toString(){
    return 'Config {'
        'uid:$uid, '
        'pwd:$pwd, '
        'users_id:$users_id, '
        'auto_login:$auto_login, '
        'isSigned:$isSigned, '
        'skip_intro:$skip_intro'
        'firebase_token:$firebase_token'
        '}';
  }
}