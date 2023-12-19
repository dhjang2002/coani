class QItemReport {
  String rpt_id;
  String req_id;
  String users_id;
  String animals_id;
  String a_sex;
  String a_breed;
  String a_age;
  String a_name;
  String a_spayed;
  String weight_manual;
  String datetime;

  QItemReport({
    this.rpt_id="",
    this.req_id="",
    this.users_id="",
    this.animals_id="",
    this.a_sex="",
    this.a_breed="",
    this.a_age="",
    this.a_name="",
    this.a_spayed="",
    this.weight_manual="",
    this.datetime="",
  });

  factory QItemReport.fromJson(Map<String, dynamic> parsedJson)
  {
    return QItemReport(
        rpt_id: (parsedJson['rpt_id'] != null) ? parsedJson['rpt_id'] : "",
        req_id: (parsedJson['req_id'] != null) ? parsedJson['req_id'] : "",
        users_id: (parsedJson['users_id'] != null) ? parsedJson['users_id'] : "",
        animals_id: (parsedJson['animals_id'] != null) ? parsedJson['animals_id'] : "",
        a_sex: (parsedJson['a_sex'] != null) ? parsedJson['a_sex'] : "",
        a_breed: (parsedJson['a_breed'] != null) ? parsedJson['a_breed'] : "",
        a_age: (parsedJson['a_age'] != null) ? parsedJson['a_age'] : "",
        a_name: (parsedJson['a_name'] != null) ? parsedJson['a_name'] : "",
        a_spayed: (parsedJson['a_spayed'] != null) ? parsedJson['a_spayed'] : "",
        weight_manual: (parsedJson['weight_manual'] != null) ? parsedJson['weight_manual'] : "",
        datetime: (parsedJson['datetime'] != null) ? parsedJson['datetime'] : "",
    );
  }

  static List<QItemReport> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return QItemReport.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Result {id:$rpt_id, q_id:$req_id, users_id:$users_id, animals_id:$animals_id, subject: $a_sex, '
        'content:$a_breed, stitle:$a_age, kit_number:$a_name, attach_file: $a_spayed, '
        'attach_source:$weight_manual, create_at:$datetime}';
  }
}