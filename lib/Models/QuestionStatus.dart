class QuestionStatus {
  String? id;
  String? users_id;
  String? animals_id;
  String? a_name;
  String? kit_number;
  String? request_stamp;
  String? process_status;

  QuestionStatus({this.id, this.users_id, this.animals_id, this.a_name, this.kit_number,
    this.request_stamp, this.process_status});

  factory QuestionStatus.fromJson(Map<String, dynamic> parsedJson)
  {
    return QuestionStatus(
        id: parsedJson['id'],
        users_id: parsedJson ['users_id'],
        animals_id: parsedJson ['animals_id'],
      a_name: parsedJson ['a_name'],
      request_stamp: parsedJson ['request_stamp'],
      process_status: parsedJson ['process_status'],
        kit_number: parsedJson ['kit_number'],
    );
  }

  static List<QuestionStatus> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return QuestionStatus.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Result {id:$id, users_id:$users_id, animals_id:$animals_id, a_name: $a_name, '
        'request_stamp:$request_stamp, process_status:$process_status, kit_number:$kit_number}';
  }
}