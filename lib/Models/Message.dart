class Message {

  String? id;         // 레코드 번호:  
  String? mb_no;      // 사용자 번호:  
  String? q_id;       // 문진료 번호:  
  String? a_name;     // 반려동물 이름 :  
  String? message;    // 메시지:
  String? status;     // 상태
  String? created_at; // 생성일자:   
  
  bool selected = false;
  Message({this.id, this.mb_no, this.q_id, this.a_name,this.message, this.status, this.created_at});

  factory Message.fromJson(Map<String, dynamic> parsedJson)
  {
      return Message(
          id: parsedJson['id'], 
          mb_no: parsedJson['mb_no'],
        q_id: parsedJson['q_id'],
        a_name: parsedJson['a_name'],
        message: parsedJson['message'],
          status: parsedJson['status'],
        created_at: parsedJson['created_at']
      );
    }

  static List<Message> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Message.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Message {id:$id, mb_no:$mb_no, q_id:$q_id, a_name:$a_name, '
        'message:$message, status:$status, created_at:$created_at}';
  }
}