class AResult {
  String? result;
  String? message;
  String? added_id;
  String? pageNo;
  String? isData;
  List<dynamic>? list;
  dynamic?    data;

  AResult({this.result, this.message, this.added_id, this.pageNo, this.isData, this.list, this.data});

  factory AResult.fromJson(Map<String, dynamic> parsedJson)
  {
    if(parsedJson ['isData'].toString() == "Y") {
      return AResult(
          result: parsedJson['RESULT'],
          message: parsedJson['MESG'],
          added_id: parsedJson ['added_id'],
          pageNo: parsedJson ['page_no'],
          isData: parsedJson ['isData'],
          list: parsedJson ['list'] as List,
          data: parsedJson['data']
      );
    }
    else{
      return AResult(
          result: parsedJson['RESULT'],
          message: parsedJson['MESG'],
          added_id: parsedJson ['added_id'],
          pageNo: parsedJson ['page_no'],
          isData: parsedJson ['isData'],
          list:null,
          data:null,
      );
    }
  }

  static List<AResult> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return AResult.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Result {result:$result, message:$message, added_id:$added_id, pageNo:$pageNo, list: $list}';
  }

}