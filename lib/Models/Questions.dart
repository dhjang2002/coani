// ignore_for_file: non_constant_identifier_names

import 'package:coani/Models/Model.dart';

class Questions extends Model{
  String id;                     // 문진표 번호:  '1'
  String users_id;               // 사용자 번호:  '2'
  String animals_id;             // 반려동물 번호: '1'
  String a_kind;                 // 종류: '개/고양이'
  String a_name;                 // 이름: '진돌이'
  String a_birthday;             // 출생일자: '2020.04.15'
  String a_sex;                  // 암수구분: '수컷/암컷'
  String a_spayed;               // 중성화: '예/아니오'
  String a_weightn;              // 몸무게: '1.7'
  String a_breed;                // 품종: '푸들'
  String a_register_number;      // 등록번호: '123456'
  String kit_number;             // 키트번호: '123456'
  String request_stamp;          // 신청일자: '2021.10.22'
  String process_status;         // 처리상태: '신청완료/접수완료/검사완료'
  String is_complete;            // 최종등록: 'Y/N'

  String i01_ai_a01, i01_ai_a01_attach,
          i01_ai_a012_attach; // 2022.10.26. add.

  String i02_ai_a02, i02_ai_a02_attach;
  String i03_ai_a03, i03_ai_a03_attach;
  String i04_ai_a04, i04_ai_a04_attach;
  String i05_eh_a01, i05_eh_a01_attach;
  String i06_eh_a02,
      i06_eh_a02_attach,
      i06_eh_a022_attach; // 2022.10.26. add.
  String i07_eh_a03, i07_eh_a03_attach;


  String i08_eh_a04, i08_eh_a04_attach;
  String i09_eh_a05, i09_eh_a05_attach;
  String i10_ls_a01, i10_ls_a01_attach;
  String i11_ls_a02, i11_ls_a02_attach;
  String i12_ls_a03, i12_ls_a03_attach;
  String i13_ls_a04, i13_ls_a04_attach;
  String i14_ls_a05, i14_ls_a05_attach;
  String i15_ls_a06, i15_ls_a06_attach;
  String i16_hi_a01, i16_hi_a01_attach;
  String i17_hi_a02, i17_hi_a02_attach;
  String i18_hi_a03, i18_hi_a03_attach;
  String i19_ad_a01, i19_ad_a01_attach;
  String i20_ad_a02, i20_ad_a02_attach;
  String i21_ad_a03, i21_ad_a03_attach;
  String i22_ad_a04, i22_ad_a04_attach;
  String i23_ad_a05, i23_ad_a05_attach;
  String i24_ad_a06, i24_ad_a06_attach;
  String i25_ad_a07, i25_ad_a07_attach;
  String i26_md_a01, i26_md_a01_attach;
  String i27_md_a02, i27_md_a02_attach;
  String i28_md_a03,
      i28_md_a03_attach;

  // 2022.10.26 add.
  String i29_ex_a01, i29_ex_a01_attach;
  String i30_ex_a02, i30_ex_a02_attach;
  String i31_ex_a03, i31_ex_a03_attach;
  String i32_ex_a04, i32_ex_a04_attach;
  String i33_ex_a05, i33_ex_a05_attach;
  String i34_ex_a06, i34_ex_a06_attach;

  String i35_ex_a06, i35_ex_a06_attach;
  String i36_ex_a07, i36_ex_a07_attach;
  String i37_ex_a08, i37_ex_a08_attach;
  String i38_ex_a08, i38_ex_a08_attach;

  Questions({
    this.id = "",
    this.users_id = "",
    this.animals_id= "",
    this.a_kind="",
    this.a_name="",
    this.a_birthday="",
    this.a_sex="",
    this.a_spayed="",
    this.a_weightn="",
    this.a_breed="",
    this.a_register_number="",
    this.kit_number="",
    this.request_stamp="",
    this.process_status="",
    this.is_complete = "N",
    this.i01_ai_a01="", this.i01_ai_a01_attach="",
    this.i01_ai_a012_attach="",  // 2022.10.26. add.

    this.i02_ai_a02="", this.i02_ai_a02_attach="",
    this.i03_ai_a03="", this.i03_ai_a03_attach="",
    this.i04_ai_a04="", this.i04_ai_a04_attach="",
    this.i05_eh_a01="", this.i05_eh_a01_attach="",
    this.i06_eh_a02="", this.i06_eh_a02_attach="",
    this.i07_eh_a03="", this.i07_eh_a03_attach="",
    this.i06_eh_a022_attach="", // 2022.10.26. add.

    this.i08_eh_a04="", this.i08_eh_a04_attach="",
    this.i09_eh_a05="", this.i09_eh_a05_attach="",
    this.i10_ls_a01="", this.i10_ls_a01_attach="",
    this.i11_ls_a02="", this.i11_ls_a02_attach="",
    this.i12_ls_a03="", this.i12_ls_a03_attach="",
    this.i13_ls_a04="", this.i13_ls_a04_attach="",
    this.i14_ls_a05="", this.i14_ls_a05_attach="",
    this.i15_ls_a06="", this.i15_ls_a06_attach="",
    this.i16_hi_a01="", this.i16_hi_a01_attach="",
    this.i17_hi_a02="", this.i17_hi_a02_attach="",
    this.i18_hi_a03="", this.i18_hi_a03_attach="",
    this.i19_ad_a01="", this.i19_ad_a01_attach="",
    this.i20_ad_a02="", this.i20_ad_a02_attach="",
    this.i21_ad_a03="", this.i21_ad_a03_attach="",
    this.i22_ad_a04="", this.i22_ad_a04_attach="",
    this.i23_ad_a05="", this.i23_ad_a05_attach="",
    this.i24_ad_a06="", this.i24_ad_a06_attach="",
    this.i25_ad_a07="", this.i25_ad_a07_attach="",
    this.i26_md_a01="", this.i26_md_a01_attach="",
    this.i27_md_a02="", this.i27_md_a02_attach="",
    this.i28_md_a03="",
    this.i28_md_a03_attach="",

    this.i29_ex_a01="", this.i29_ex_a01_attach="",
    this.i30_ex_a02="", this.i30_ex_a02_attach="",
    this.i31_ex_a03="", this.i31_ex_a03_attach="",
    this.i32_ex_a04="", this.i32_ex_a04_attach="",
    this.i33_ex_a05="", this.i33_ex_a05_attach="",
    this.i34_ex_a06="", this.i34_ex_a06_attach="",

    this.i35_ex_a06="", this.i35_ex_a06_attach="",
    this.i36_ex_a07="", this.i36_ex_a07_attach="",
    this.i37_ex_a08="", this.i37_ex_a08_attach="",
    this.i38_ex_a08="", this.i38_ex_a08_attach="",
  });

  factory Questions.fromJson(Map<String, dynamic> parsedJson)
  {
      return Questions(
        id: parsedJson['id'],
        users_id: parsedJson['users_id'],
        animals_id: parsedJson['animals_id'],
        a_kind: parsedJson['a_kind'],
        a_name: parsedJson['a_name'],
        a_birthday: parsedJson['a_birthday'],
        a_sex: parsedJson['a_sex'],
        a_spayed: parsedJson['a_spayed'],
        a_weightn: parsedJson['a_weightn'],
        a_breed: parsedJson['a_breed'],
        a_register_number: parsedJson['a_register_number'],
        kit_number: parsedJson['kit_number'],
        request_stamp: parsedJson['request_stamp'],
        process_status: parsedJson['process_status'],
        is_complete: parsedJson['is_complete'],
        i01_ai_a01: parsedJson['i01_ai_a01'],
        i01_ai_a01_attach: parsedJson['i01_ai_a01_attach'],
        i01_ai_a012_attach: parsedJson['i01_ai_a012_attach'],
        i02_ai_a02: parsedJson['i02_ai_a02'],
        i02_ai_a02_attach: parsedJson['i02_ai_a02_attach'],
        i03_ai_a03: parsedJson['i03_ai_a03'],
        i03_ai_a03_attach: parsedJson['i03_ai_a03_attach'],
        i04_ai_a04: parsedJson['i04_ai_a04'],
        i04_ai_a04_attach: parsedJson['i04_ai_a04_attach'],
        i05_eh_a01: parsedJson['i05_eh_a01'],
        i05_eh_a01_attach: parsedJson['i05_eh_a01_attach'],
        i06_eh_a02: parsedJson['i06_eh_a02'],
        i06_eh_a02_attach: parsedJson['i06_eh_a02_attach'],
        i06_eh_a022_attach: parsedJson['i06_eh_a022_attach'],
        i07_eh_a03: parsedJson['i07_eh_a03'],
        i07_eh_a03_attach: parsedJson['i07_eh_a03_attach'],
        i08_eh_a04: parsedJson['i08_eh_a04'],
        i08_eh_a04_attach: parsedJson['i08_eh_a04_attach'],
        i09_eh_a05: parsedJson['i09_eh_a05'],
        i09_eh_a05_attach: parsedJson['i09_eh_a05_attach'],
        i10_ls_a01: parsedJson['i10_ls_a01'],
        i10_ls_a01_attach: parsedJson['i10_ls_a01_attach'],
        i11_ls_a02: parsedJson['i11_ls_a02'],
        i11_ls_a02_attach: parsedJson['i11_ls_a02_attach'],
        i12_ls_a03: parsedJson['i12_ls_a03'],
        i12_ls_a03_attach: parsedJson['i12_ls_a03_attach'],
        i13_ls_a04: parsedJson['i13_ls_a04'],
        i13_ls_a04_attach: parsedJson['i13_ls_a04_attach'],
        i14_ls_a05: parsedJson['i14_ls_a05'],
        i14_ls_a05_attach: parsedJson['i14_ls_a05_attach'],
        i15_ls_a06: parsedJson['i15_ls_a06'],
        i15_ls_a06_attach: parsedJson['i15_ls_a06_attach'],
        i16_hi_a01: parsedJson['i16_hi_a01'],
        i16_hi_a01_attach: parsedJson['i16_hi_a01_attach'],
        i17_hi_a02: parsedJson['i17_hi_a02'],
        i17_hi_a02_attach: parsedJson['i17_hi_a02_attach'],
        i18_hi_a03: parsedJson['i18_hi_a03'],
        i18_hi_a03_attach: parsedJson['i18_hi_a03_attach'],
        i19_ad_a01: parsedJson['i19_ad_a01'],
        i19_ad_a01_attach: parsedJson['i19_ad_a01_attach'],
        i20_ad_a02: parsedJson['i20_ad_a02'],
        i20_ad_a02_attach: parsedJson['i20_ad_a02_attach'],
        i21_ad_a03: parsedJson['i21_ad_a03'],
        i21_ad_a03_attach: parsedJson['i21_ad_a03_attach'],
        i22_ad_a04: parsedJson['i22_ad_a04'],
        i22_ad_a04_attach: parsedJson['i22_ad_a04_attach'],
        i23_ad_a05: parsedJson['i23_ad_a05'],
        i23_ad_a05_attach: parsedJson['i23_ad_a05_attach'],
        i24_ad_a06: parsedJson['i24_ad_a06'],
        i24_ad_a06_attach: parsedJson['i24_ad_a06_attach'],
        i25_ad_a07: parsedJson['i25_ad_a07'],
        i25_ad_a07_attach: parsedJson['i25_ad_a07_attach'],

        i26_md_a01: parsedJson['i26_md_a01'],
        i26_md_a01_attach: parsedJson['i26_md_a01_attach'],
        i27_md_a02: parsedJson['i27_md_a02'],
        i27_md_a02_attach: parsedJson['i27_md_a02_attach'],
        i28_md_a03: parsedJson['i28_md_a03'],
        i28_md_a03_attach: parsedJson['i28_md_a03_attach'],

        // 2022.10.26 add.
        i29_ex_a01:parsedJson['i29_ex_a01'],
        i29_ex_a01_attach: parsedJson['i29_ex_a01_attach'],
        i30_ex_a02:parsedJson['i30_ex_a02'],
        i30_ex_a02_attach: parsedJson['i30_ex_a02_attach'],
        i31_ex_a03:parsedJson['i31_ex_a03'],
        i31_ex_a03_attach: parsedJson['i31_ex_a03_attach'],
        i32_ex_a04:parsedJson['i32_ex_a04'],
        i32_ex_a04_attach: parsedJson['i32_ex_a04_attach'],
        i33_ex_a05:parsedJson['i33_ex_a05'],
        i33_ex_a05_attach: parsedJson['i33_ex_a05_attach'],
        i34_ex_a06:parsedJson['i34_ex_a06'],
        i34_ex_a06_attach: parsedJson['i34_ex_a06_attach'],

        i35_ex_a06:parsedJson['i35_ex_a06'],
        i35_ex_a06_attach: parsedJson['i35_ex_a06_attach'],
        i36_ex_a07:parsedJson['i36_ex_a07'],
        i36_ex_a07_attach: parsedJson['i36_ex_a07_attach'],
        i37_ex_a08:parsedJson['i37_ex_a08'],
        i37_ex_a08_attach: parsedJson['i37_ex_a08_attach'],
        i38_ex_a08:parsedJson['i38_ex_a08'],
        i38_ex_a08_attach: parsedJson['i38_ex_a08_attach'],
      );
    }

  static List<Questions> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Questions.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Questions {id:$id, '
        'users_id:$users_id, animals_id:$animals_id, '
        'a_kind:$a_kind, a_name:$a_name, '
        'a_birthday:$a_birthday, a_sex:$a_sex, '
        'a_weightn:$a_weightn, a_breed:$a_breed, '
        'a_register_number:$a_register_number, '
        'kit_number:$kit_number, request_stamp:$request_stamp, '
        'process_status:$process_status, '
        'i01_ai_a01:$i01_ai_a01, i01_ai_a01_attach:$i01_ai_a01_attach, i01_ai_a012_attach:$i01_ai_a012_attach,'
        'i02_ai_a02:$i02_ai_a02, i02_ai_a02_attach:$i02_ai_a02_attach, '
        'i03_ai_a03:$i03_ai_a03, i03_ai_a03_attach:$i03_ai_a03_attach, '
        'i04_ai_a04:$i04_ai_a04, i04_ai_a04_attach:$i04_ai_a04_attach, '
        'i05_eh_a01:$i05_eh_a01, i05_eh_a01_attach:$i05_eh_a01_attach, '
        'i06_eh_a02:$i06_eh_a02, '
        'i06_eh_a02_attach:$i06_eh_a02_attach, '
        'i06_eh_a022_attach:$i06_eh_a022_attach,'
        'i07_eh_a03:$i07_eh_a03, i07_eh_a03_attach:$i07_eh_a03_attach, '
        'i08_eh_a04:$i08_eh_a04, i08_eh_a04_attach:$i08_eh_a04_attach, '
        'i09_eh_a05:$i09_eh_a05, '
        'i09_eh_a05_attach:$i09_eh_a05_attach, '
        'i10_ls_a01:$i10_ls_a01, i10_ls_a01_attach:$i10_ls_a01_attach, '
        'i11_ls_a02:$i11_ls_a02, i11_ls_a02_attach:$i11_ls_a02_attach, '
        'i12_ls_a03:$i12_ls_a03, '
        'i12_ls_a03_attach:$i12_ls_a03_attach, '
        'i13_ls_a04:$i13_ls_a04, i13_ls_a04_attach:$i13_ls_a04_attach, '
        'i14_ls_a05:$i14_ls_a05, i14_ls_a05_attach:$i14_ls_a05_attach, '
        'i15_ls_a06:$i15_ls_a06, i15_ls_a06_attach:$i15_ls_a06_attach, '
        'i16_hi_a01:$i16_hi_a01, i16_hi_a01_attach:$i16_hi_a01_attach, '
        'i17_hi_a02:$i17_hi_a02, i17_hi_a02_attach:$i17_hi_a02_attach, '
        'i18_hi_a03:$i18_hi_a03, i18_hi_a03_attach:$i18_hi_a03_attach, '
        'i19_ad_a01:$i19_ad_a01, i19_ad_a01_attach:$i19_ad_a01_attach, '
        'i20_ad_a02:$i20_ad_a02, i20_ad_a02_attach:$i20_ad_a02_attach, '
        'i21_ad_a03:$i21_ad_a03, i21_ad_a03_attach:$i21_ad_a03_attach, '
        'i22_ad_a04:$i22_ad_a04, i22_ad_a04_attach:$i22_ad_a04_attach, '
        'i23_ad_a05:$i23_ad_a05, i23_ad_a05_attach:$i23_ad_a05_attach, '
        'i24_ad_a06:$i24_ad_a06, i24_ad_a06_attach:$i24_ad_a06_attach, '
        'i25_ad_a07:$i25_ad_a07, i25_ad_a07_attach:$i25_ad_a07_attach, '
        'i26_md_a01:$i26_md_a01, i26_md_a01_attach:$i26_md_a01_attach, '
        'i27_md_a02:$i27_md_a02, i27_md_a02_attach:$i27_md_a02_attach, '
        'i28_md_a03:$i28_md_a03, '
        'i28_md_a03_attach:$i28_md_a03_attach, '

        // 2022.10.26 add.
        'i29_ex_a01:$i29_ex_a01, i29_ex_a01_attach:$i29_ex_a01_attach, '
        'i30_ex_a02:$i30_ex_a02, i30_ex_a02_attach:$i30_ex_a02_attach, '
        'i31_ex_a03:$i31_ex_a03, i31_ex_a03_attach:$i31_ex_a03_attach, '
        'i32_ex_a04:$i32_ex_a04, i32_ex_a04_attach:$i32_ex_a04_attach, '
        'i33_ex_a05:$i33_ex_a05, i33_ex_a05_attach:$i33_ex_a05_attach, '
        'i34_ex_a06:$i34_ex_a06, i34_ex_a06_attach:$i34_ex_a06_attach, '

        'i35_ex_a06:$i35_ex_a06, i35_ex_a06_attach:$i35_ex_a06_attach, '
        'i36_ex_a07:$i36_ex_a07, i36_ex_a07_attach:$i36_ex_a07_attach, '
        'i37_ex_a08:$i37_ex_a08, i37_ex_a08_attach:$i37_ex_a08_attach, '
        'i38_ex_a08:$i38_ex_a08, i38_ex_a08_attach:$i38_ex_a08_attach, '
        '}';
  }

  @override
  Map<String, String> toMap() => {
    'id': id.toString(),
    'users_id':   users_id.toString(),
    'animals_id':   animals_id.toString(),
    'a_name':     a_name.toString(),
    'a_kind':     a_kind.toString(),
    'a_birthday': a_birthday.toString(),
    'a_sex':      a_sex.toString(),
    'a_spayed':   a_spayed.toString(),
    'a_weightn':  a_weightn.toString(),
    'a_breed':    a_breed.toString(),
    'a_register_number': a_register_number.toString(),
    'kit_number': kit_number.toString(),
    'request_stamp': request_stamp.toString(),
    'process_status': process_status.toString(),
    'is_complete': is_complete.toString(),

    'i01_ai_a01': i01_ai_a01.toString(), 'i01_ai_a01_attach': i01_ai_a01_attach.toString(),
    'i01_ai_a012_attach': i01_ai_a012_attach.toString(), // 2022.10.26. add.

    'i02_ai_a02': i02_ai_a02.toString(), 'i02_ai_a02_attach': i02_ai_a02_attach.toString(),
    'i03_ai_a03': i03_ai_a03.toString(), 'i03_ai_a03_attach': i03_ai_a03_attach.toString(),
    'i04_ai_a04': i04_ai_a04.toString(), 'i04_ai_a04_attach': i04_ai_a04_attach.toString(),
    'i05_eh_a01': i05_eh_a01.toString(), 'i05_eh_a01_attach': i05_eh_a01_attach.toString(),
    'i06_eh_a02': i06_eh_a02.toString(),
    'i06_eh_a02_attach': i06_eh_a02_attach.toString(),
    'i06_eh_a022_attach': i06_eh_a022_attach.toString(), // 2022.10.26. add.
    'i07_eh_a03': i07_eh_a03.toString(), 'i07_eh_a03_attach': i07_eh_a03_attach.toString(),
    'i08_eh_a04': i08_eh_a04.toString(), 'i08_eh_a04_attach': i08_eh_a04_attach.toString(),
    'i09_eh_a05': i09_eh_a05.toString(),
    'i09_eh_a05_attach': i09_eh_a05_attach.toString(),
    'i10_ls_a01': i10_ls_a01.toString(), 'i10_ls_a01_attach': i10_ls_a01_attach.toString(),

    'i11_ls_a02': i11_ls_a02.toString(), 'i11_ls_a02_attach': i11_ls_a02_attach.toString(),
    'i12_ls_a03': i12_ls_a03.toString(),
    'i12_ls_a03_attach': i12_ls_a03_attach.toString(),
    'i13_ls_a04': i13_ls_a04.toString(), 'i13_ls_a04_attach': i13_ls_a04_attach.toString(),
    'i14_ls_a05': i14_ls_a05.toString(), 'i14_ls_a05_attach': i14_ls_a05_attach.toString(),
    'i15_ls_a06': i15_ls_a06.toString(), 'i15_ls_a06_attach': i15_ls_a06_attach.toString(),
    'i16_hi_a01': i16_hi_a01.toString(), 'i16_hi_a01_attach': i16_hi_a01_attach.toString(),
    'i17_hi_a02': i17_hi_a02.toString(), 'i17_hi_a02_attach': i17_hi_a02_attach.toString(),
    'i18_hi_a03': i18_hi_a03.toString(), 'i18_hi_a03_attach': i18_hi_a03_attach.toString(),
    'i19_ad_a01': i19_ad_a01.toString(), 'i19_ad_a01_attach': i19_ad_a01_attach.toString(),
    'i20_ad_a02': i20_ad_a02.toString(), 'i20_ad_a02_attach': i20_ad_a02_attach.toString(),

    'i21_ad_a03': i21_ad_a03.toString(), 'i21_ad_a03_attach': i21_ad_a03_attach.toString(),
    'i22_ad_a04': i22_ad_a04.toString(), 'i22_ad_a04_attach': i22_ad_a04_attach.toString(),
    'i23_ad_a05': i23_ad_a05.toString(), 'i23_ad_a05_attach': i23_ad_a05_attach.toString(),
    'i24_ad_a06': i24_ad_a06.toString(), 'i24_ad_a06_attach': i24_ad_a06_attach.toString(),
    'i25_ad_a07': i25_ad_a07.toString(), 'i25_ad_a07_attach': i25_ad_a07_attach.toString(),
    'i26_md_a01': i26_md_a01.toString(), 'i26_md_a01_attach': i26_md_a01_attach.toString(),
    'i27_md_a02': i27_md_a02.toString(), 'i27_md_a02_attach': i27_md_a02_attach.toString(),
    'i28_md_a03': i28_md_a03.toString(),
    'i28_md_a03_attach': i28_md_a03_attach.toString(),

    // 2022.10.26. add.
    'i29_ex_a01': i29_ex_a01.toString(), 'i29_ex_a01_attach': i29_ex_a01_attach.toString(),
    'i30_ex_a02': i30_ex_a02.toString(), 'i30_ex_a02_attach': i30_ex_a02_attach.toString(),
    'i31_ex_a03': i31_ex_a03.toString(), 'i31_ex_a03_attach': i31_ex_a03_attach.toString(),
    'i32_ex_a04': i32_ex_a04.toString(), 'i32_ex_a04_attach': i32_ex_a04_attach.toString(),
    'i33_ex_a05': i33_ex_a05.toString(), 'i33_ex_a05_attach': i33_ex_a05_attach.toString(),
    'i34_ex_a06': i34_ex_a06.toString(), 'i34_ex_a06_attach': i34_ex_a06_attach.toString(),

    'i35_ex_a06': i35_ex_a06.toString(), 'i35_ex_a06_attach': i35_ex_a06_attach.toString(),
    'i36_ex_a07': i36_ex_a07.toString(), 'i36_ex_a07_attach': i36_ex_a07_attach.toString(),
    'i37_ex_a08': i37_ex_a08.toString(), 'i37_ex_a08_attach': i37_ex_a08_attach.toString(),
    'i38_ex_a08': i38_ex_a08.toString(), 'i38_ex_a08_attach': i38_ex_a08_attach.toString(),
  };

  Map<String, String> toAddMap() => {
    'is_complete': is_complete.toString(),
    'id': id.toString(),
    'users_id':   users_id.toString(),
    'animals_id':   animals_id.toString(),
    'a_name':     a_name.toString(),
    'a_kind':     a_kind.toString(),
    'a_birthday': a_birthday.toString(),
    'a_sex':      a_sex.toString(),
    'a_spayed':   a_spayed.toString(),
    'a_weightn':  a_weightn.toString(),
    'a_breed':    a_breed.toString(),
    'a_register_number': a_register_number.toString(),
    'kit_number': kit_number.toString(),

    //'request_stamp': request_stamp.toString(),
    //'process_status': process_status.toString(),


    'i01_ai_a01': i01_ai_a01.toString(), 'i01_ai_a01_attach': i01_ai_a01_attach.toString(),
    'i01_ai_a012_attach': i01_ai_a012_attach.toString(), // 2022.10.26. add.

    'i02_ai_a02': i02_ai_a02.toString(), 'i02_ai_a02_attach': i02_ai_a02_attach.toString(),
    'i03_ai_a03': i03_ai_a03.toString(), 'i03_ai_a03_attach': i03_ai_a03_attach.toString(),
    'i04_ai_a04': i04_ai_a04.toString(), 'i04_ai_a04_attach': i04_ai_a04_attach.toString(),
    'i05_eh_a01': i05_eh_a01.toString(), 'i05_eh_a01_attach': i05_eh_a01_attach.toString(),
    'i06_eh_a02': i06_eh_a02.toString(),
    'i06_eh_a02_attach': i06_eh_a02_attach.toString(),
    'i06_eh_a022_attach': i06_eh_a022_attach.toString(), // 2022.10.26. add.
    'i07_eh_a03': i07_eh_a03.toString(), 'i07_eh_a03_attach': i07_eh_a03_attach.toString(),
    'i08_eh_a04': i08_eh_a04.toString(), 'i08_eh_a04_attach': i08_eh_a04_attach.toString(),
    'i09_eh_a05': i09_eh_a05.toString(),
    'i09_eh_a05_attach': i09_eh_a05_attach.toString(),
    'i10_ls_a01': i10_ls_a01.toString(), 'i10_ls_a01_attach': i10_ls_a01_attach.toString(),

    'i11_ls_a02': i11_ls_a02.toString(), 'i11_ls_a02_attach': i11_ls_a02_attach.toString(),
    'i12_ls_a03': i12_ls_a03.toString(),
    'i12_ls_a03_attach': i12_ls_a03_attach.toString(),
    'i13_ls_a04': i13_ls_a04.toString(), 'i13_ls_a04_attach': i13_ls_a04_attach.toString(),
    'i14_ls_a05': i14_ls_a05.toString(), 'i14_ls_a05_attach': i14_ls_a05_attach.toString(),
    'i15_ls_a06': i15_ls_a06.toString(), 'i15_ls_a06_attach': i15_ls_a06_attach.toString(),
    'i16_hi_a01': i16_hi_a01.toString(), 'i16_hi_a01_attach': i16_hi_a01_attach.toString(),
    'i17_hi_a02': i17_hi_a02.toString(), 'i17_hi_a02_attach': i17_hi_a02_attach.toString(),
    'i18_hi_a03': i18_hi_a03.toString(), 'i18_hi_a03_attach': i18_hi_a03_attach.toString(),
    'i19_ad_a01': i19_ad_a01.toString(), 'i19_ad_a01_attach': i19_ad_a01_attach.toString(),
    'i20_ad_a02': i20_ad_a02.toString(), 'i20_ad_a02_attach': i20_ad_a02_attach.toString(),

    'i21_ad_a03': i21_ad_a03.toString(), 'i21_ad_a03_attach': i21_ad_a03_attach.toString(),
    'i22_ad_a04': i22_ad_a04.toString(), 'i22_ad_a04_attach': i22_ad_a04_attach.toString(),
    'i23_ad_a05': i23_ad_a05.toString(), 'i23_ad_a05_attach': i23_ad_a05_attach.toString(),
    'i24_ad_a06': i24_ad_a06.toString(), 'i24_ad_a06_attach': i24_ad_a06_attach.toString(),
    'i25_ad_a07': i25_ad_a07.toString(), 'i25_ad_a07_attach': i25_ad_a07_attach.toString(),
    'i26_md_a01': i26_md_a01.toString(), 'i26_md_a01_attach': i26_md_a01_attach.toString(),
    'i27_md_a02': i27_md_a02.toString(), 'i27_md_a02_attach': i27_md_a02_attach.toString(),
    'i28_md_a03': i28_md_a03.toString(),
    'i28_md_a03_attach': i28_md_a03_attach.toString(),

    // 2022.10.26. add.
    'i29_ex_a01': i29_ex_a01.toString(), 'i29_ex_a01_attach': i29_ex_a01_attach.toString(),
    'i30_ex_a02': i30_ex_a02.toString(), 'i30_ex_a02_attach': i30_ex_a02_attach.toString(),
    'i31_ex_a03': i31_ex_a03.toString(), 'i31_ex_a03_attach': i31_ex_a03_attach.toString(),
    'i32_ex_a04': i32_ex_a04.toString(), 'i32_ex_a04_attach': i32_ex_a04_attach.toString(),
    'i33_ex_a05': i33_ex_a05.toString(), 'i33_ex_a05_attach': i33_ex_a05_attach.toString(),
    'i34_ex_a06': i34_ex_a06.toString(), 'i34_ex_a06_attach': i34_ex_a06_attach.toString(),

    'i35_ex_a06': i35_ex_a06.toString(), 'i35_ex_a06_attach': i35_ex_a06_attach.toString(),
    'i36_ex_a07': i36_ex_a07.toString(), 'i36_ex_a07_attach': i36_ex_a07_attach.toString(),
    'i37_ex_a08': i37_ex_a08.toString(), 'i37_ex_a08_attach': i37_ex_a08_attach.toString(),
    'i38_ex_a08': i38_ex_a08.toString(), 'i38_ex_a08_attach': i38_ex_a08_attach.toString(),
  };

  @override
  String getFilename(){
    return "question.dat";
  }

  @override
  void clear() {
    id = "";                   // 기본키
    users_id = "";             // 사용자 등록번호(mb_no)
    animals_id = "";           // 반려동물 기본키
    a_kind = "";               // 종류
    a_name = "";               // 이름
    a_birthday = "";           // 출생일자
    a_sex = "";                // 성별
    a_spayed = "";             // 중성화
    a_weightn = "";            // 몸무게
    a_breed = "";              // 품종
    a_register_number = "";    // 반려동물 등록번호
    kit_number = "";           // 키트번호
    request_stamp = "";        // 신청시각
    process_status = "";       // 접수상태(처리상태) 진단신청->접수완료->검사완료
    is_complete = "";          // 설문지 완성여부

    i01_ai_a01 = ""; i01_ai_a01_attach = "";
    i01_ai_a012_attach = ""; // 2022.10.26. add.

    i02_ai_a02 = ""; i02_ai_a02_attach = "";  // 1-2 정기적 예방접종
    i03_ai_a03 = ""; i03_ai_a03_attach = "";  // 1-3 심장사상충 예방
    i04_ai_a04 = ""; i04_ai_a04_attach = "";  // 1-4 임신중 또는 수유기 ?
    i05_eh_a01 = ""; i05_eh_a01_attach = "";  // 2-1 사료의 제형
    i06_eh_a02 = "";
    i06_eh_a02_attach = "";  // 2-2 사료의 이름
    i06_eh_a022_attach = ""; // 2022.10.26. add.
    i07_eh_a03 = ""; i07_eh_a03_attach = "";  // 2-3 사료에서 가장 큰 비중을 차지하는 단백질원...
    i08_eh_a04 = ""; i08_eh_a04_attach = "";  // 2-4 간식의 제
    i09_eh_a05 = ""; i09_eh_a05_attach = "";  // 2-5 음수의 종류
    i10_ls_a01 = ""; i10_ls_a01_attach = "";  // 3-1 하루에 소변을 얼마나...
    i11_ls_a02 = ""; i11_ls_a02_attach = "";  // 3-2 하루에 대변을 얼마나...
    i12_ls_a03 = ""; i12_ls_a03_attach = "";  // 3-3 최근에 전체 목욕을 시킨 날짜 ...
    i13_ls_a04 = ""; i13_ls_a04_attach = "";  // 3-4 한주에 산책을 ...
    i14_ls_a05 = ""; i14_ls_a05_attach = "";  // 3-5 반려동물이 혼자있는 시간...
    i15_ls_a06 = ""; i15_ls_a06_attach = "";  // 3-6 담배연기에 주기적 노출...
    i16_hi_a01 = ""; i16_hi_a01_attach = "";  // 4-1 최근에 진단받거나 현재 가지고 있는
    i17_hi_a02 = ""; i17_hi_a02_attach = "";  // 4-2 3달 이내에 복용한 처방약...
    i18_hi_a03 = ""; i18_hi_a03_attach = "";  // 4-3 중요하게 보고있는 건강관리...
    i19_ad_a01 = ""; i19_ad_a01_attach = "";  // 6-1 사료의 급여시간
    i20_ad_a02 = ""; i20_ad_a02_attach = "";  // 6-2 반려동물의 전체 하루 일과...
    i21_ad_a03 = ""; i21_ad_a03_attach = "";  // 6-3 사회성 정도
    i22_ad_a04 = ""; i22_ad_a04_attach = "";  // 6-4 사회화 정도
    i23_ad_a05 = ""; i23_ad_a05_attach = "";  // 6-5 최근(한달) 이벤트
    i24_ad_a06 = ""; i24_ad_a06_attach = "";  // 사용않함
    i25_ad_a07 = ""; i25_ad_a07_attach = "";  // 사용않함
    i26_md_a01 = ""; i26_md_a01_attach = "";  // 행동정의 5-1 장난감을 가지고 놀때 습관...
    i27_md_a02 = ""; i27_md_a02_attach = "";  // 행동정의 5-2 반려동물의 생활습관
    i28_md_a03 = "";
    i28_md_a03_attach = "";  // 행동정의 5-3 반려동물에게서 자주 보이는 모습

    // 2022.10.26. add.
    i29_ex_a01 = ""; i29_ex_a01_attach = "";
    i30_ex_a02 = ""; i30_ex_a02_attach = "";
    i31_ex_a03 = ""; i31_ex_a03_attach = "";
    i32_ex_a04 = ""; i32_ex_a04_attach = "";
    i33_ex_a05 = ""; i33_ex_a05_attach = "";
    i34_ex_a06 = ""; i34_ex_a06_attach = "";

    i35_ex_a06 = ""; i35_ex_a06_attach = "";
    i36_ex_a07 = ""; i36_ex_a07_attach = "";
    i37_ex_a08 = ""; i37_ex_a08_attach = "";
    i38_ex_a08 = ""; i38_ex_a08_attach = "";
  }
}