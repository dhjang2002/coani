import 'Model.dart';

class Animal extends Model {
  String? id;                       // 레코드번호
  String? users_id;                 // 사용자 레코드번호
  String? name;                     // 이름 : '사랑이'
  String? kind;                     // 종류: '개'
  String? birthday;                 // 출생일자 : '2021.02.09'
  String? sex;                      // 암수구분: '암컷'
  String? spayed;                   // 중성화: '아니오'
  String? weight;                   // 몸무게(kg): '2.8'
  String? breed;                    // 품종: ''푸들
  String? body_mass;                // 체형(비만도): 1단계
  String? basic_vaccination;        // 기초 예방접종: '예'
  String? heartworm_vaccination;    // 심장사상충 : '예'
  String? walks_per_week;           // 주간 산책횟수: '2~3회'
  String? frequency_of_defecation;  // 일 소변횟수: '4~5회'
  String? frequency_of_urination;   // 일 대변횟수: '1~2회'
  String? case_history;             // 병력기록사항: '특이사항 없음'
  String? keyword;                  // 관심키워드: '#예방접종'
  String? photo_url;                // 사진: ''
  String? created_at;               // 생성일:
  String? updated_at;               // 변경일:
  String? registered_number;        // 반려동물 등록번호:

  Animal({this.id, this.users_id, this.name, this.kind, this.birthday,
    this.sex, this.spayed, this.weight, this.breed,
    this.body_mass, this.basic_vaccination, this.heartworm_vaccination,
    this.walks_per_week, this.frequency_of_defecation,this.frequency_of_urination,
    this.case_history, this.keyword, this.photo_url, this.created_at, this.updated_at,
    this.registered_number,
  });

  factory Animal.fromJson(Map<String, dynamic> parsedJson)
  {
      return Animal(
        id: parsedJson['id'],
        users_id: parsedJson['users_id'],
        name: parsedJson ['name'],
        kind: parsedJson ['kind'],
        birthday: parsedJson ['birthday'],
        sex: parsedJson ['sex'],
        spayed: parsedJson ['spayed'],
        weight: parsedJson ['weight'],
        breed: parsedJson ['breed'],
        body_mass: parsedJson['body_mass'],
        basic_vaccination: parsedJson['basic_vaccination'],
        heartworm_vaccination: parsedJson ['heartworm_vaccination'],
        walks_per_week: parsedJson ['walks_per_week'],
        frequency_of_defecation: parsedJson ['frequency_of_defecation'],
        frequency_of_urination: parsedJson ['frequency_of_urination'],
        case_history: parsedJson ['case_history'],
        keyword: parsedJson ['keyword'],
        photo_url: parsedJson ['photo_url'],
        created_at: parsedJson ['created_at'],
        updated_at: parsedJson ['updated_at'],
        registered_number: parsedJson ['registered_number'],
      );
    }

  static List<Animal> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Animal.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Animal {id:$id, users_id:$users_id, kind:$kind, name:$name, birthday:$birthday, '
        'sex:$sex, spayed:$spayed, weight:$weight, breed:$breed, '
        'body_mass:$body_mass, basic_vaccination:$basic_vaccination, heartworm_vaccination:$heartworm_vaccination, '
        'walks_per_week:$walks_per_week, frequency_of_defecation:$frequency_of_defecation, '
        'frequency_of_urination:$frequency_of_urination, case_history:$case_history, '
        'keyword:$keyword, photo_url:$photo_url, created_at:$created_at, updated_at:$updated_at, '
        'registered_number:$registered_number'
        '}';
  }

  Map<String, String> toMap() => {
    'id': id.toString(),
    'users_id': users_id.toString(),
    'name': name.toString(),
    'kind': kind.toString(),
    'birthday': birthday.toString(),
    'sex': sex.toString(),
    'spayed': spayed.toString(),
    'weight': weight.toString(),
    'breed': breed.toString(),
    'body_mass': body_mass.toString(),
    'basic_vaccination': basic_vaccination.toString(),
    'heartworm_vaccination': heartworm_vaccination.toString(),
    'walks_per_week': walks_per_week.toString(),
    'frequency_of_defecation': frequency_of_defecation.toString(),
    'frequency_of_urination': frequency_of_urination.toString(),
    'case_history': case_history.toString(),
    'keyword': keyword.toString(),
    'photo_url': photo_url.toString(),
    'registered_number': registered_number.toString()
  };

  Map<String, String> toAddMap() => {
    'id': id.toString(),
    //'users_id': users_id.toString(),
    'name': name.toString(),
    'kind': kind.toString(),
    'birthday': birthday.toString(),
    'sex': sex.toString(),
    'spayed': spayed.toString(),
    'weight': weight.toString(),
    'breed': breed.toString(),
    'body_mass': body_mass.toString(),
    'basic_vaccination': basic_vaccination.toString(),
    'heartworm_vaccination': heartworm_vaccination.toString(),
    'walks_per_week': walks_per_week.toString(),
    'frequency_of_defecation': frequency_of_defecation.toString(),
    'frequency_of_urination': frequency_of_urination.toString(),
    'case_history': case_history.toString(),
    'keyword': keyword.toString(),
    'photo_url': photo_url.toString(),
    'registered_number': registered_number.toString()
  };
  
  @override
  String getFilename(){
    return "animal.dat";
  }

  @override
  void clear() {
    this.id="";
    this.users_id="";
    this.name = "";
    this.kind = "";
    this.birthday = "";
    this.sex = "";
    this.spayed = "";
    this.weight = "";
    this.breed = "";
    this.body_mass = "";
    this.basic_vaccination = "";
    this.heartworm_vaccination = "";
    this.walks_per_week = "";
    this.frequency_of_defecation = "";
    this.frequency_of_urination = "";
    this.case_history = "";
    this.keyword = "";
    this.photo_url = "";
    this.created_at = "";
    this.updated_at = "";
    this.registered_number = "";

    //print("clear():"+toString());
  }
  
  void copy(Animal info){
    this.id=info.id;
    this.users_id=info.users_id;
    this.name = info.name;
    this.kind = info.kind;
    this.birthday = info.birthday;
    this.sex = info.sex;
    this.spayed = info.spayed;
    this.weight = info.weight;
    this.breed = info.breed;
    this.body_mass = info.body_mass;
    this.basic_vaccination = info.basic_vaccination;
    this.heartworm_vaccination = info.heartworm_vaccination;
    this.walks_per_week = info.walks_per_week;
    this.frequency_of_defecation = info.frequency_of_defecation;
    this.frequency_of_urination = info.frequency_of_urination;
    this.case_history = info.case_history;
    this.keyword = info.keyword;
    this.photo_url = info.photo_url;
    this.created_at = info.created_at;
    this.updated_at = info.updated_at;
    this.registered_number = info.registered_number;
  }
}