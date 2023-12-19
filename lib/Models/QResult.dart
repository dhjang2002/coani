import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class QResult {
  String rpt_id;
  String q_id;
  String users_id;
  String animals_id;
  String subject;
  String content;
  String stitle;
  String kit_number;
  String attach_file;
  String attach_source;
  String create_at;

  QResult({
    this.rpt_id="",
    this.q_id="",
    this.users_id="",
    this.animals_id="",
    this.subject="",
    this.content="",
    this.stitle="",
    this.kit_number="",
    this.attach_file="",
    this.attach_source="",
    this.create_at="",
  });

  factory QResult.fromJson(Map<String, dynamic> parsedJson)
  {

    if (kDebugMode) {
      var logger = Logger();
      logger.d(parsedJson);
    }

    return QResult(
        rpt_id: (parsedJson['rpt_id'] != null) ? parsedJson['rpt_id'] : "",
        q_id: (parsedJson['q_id'] != null) ? parsedJson['q_id'] : "",
        users_id: (parsedJson['users_id'] != null) ? parsedJson['users_id'] : "",
        animals_id: (parsedJson['animals_id'] != null) ? parsedJson['animals_id'] : "",
        subject: (parsedJson['subject'] != null) ? parsedJson['subject'] : "",
        content: (parsedJson['content'] != null) ? parsedJson['content'] : "",
        stitle: (parsedJson['stitle'] != null) ? parsedJson['stitle'] : "",
        kit_number: (parsedJson['kit_number'] != null) ? parsedJson['kit_number'] : "",
        attach_file: (parsedJson['attach_file'] != null) ? parsedJson['attach_file'] : "",
        attach_source: (parsedJson['attach_source'] != null) ? parsedJson['attach_source'] : "",
        create_at: (parsedJson['create_at'] != null) ? parsedJson['create_at'] : "",
    );
  }

  static List<QResult> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return QResult.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Result {id:$rpt_id, q_id:$q_id, users_id:$users_id, animals_id:$animals_id, subject: $subject, '
        'content:$content, stitle:$stitle, kit_number:$kit_number, attach_file: $attach_file, '
        'attach_source:$attach_source, create_at:$create_at}';
  }
}