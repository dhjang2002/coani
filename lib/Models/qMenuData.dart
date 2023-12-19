// ignore_for_file: non_constant_identifier_names, file_names
import 'package:coani/Models/qItem.dart';

class QMenuData {
  List<QItem> co_bcs;                // 1. 체형
  List<QItem> co_environment_part11; // 2.예방접종 주기
  List<QItem> co_environment_part12; // 3.심장사상충 예방
  List<QItem> co_environment_part13; // 15. 산책횟수
  List<QItem> co_environment_part13_1; // 15-1. 주간 산책 횟수

  List<QItem> co_environment_part21; // 11. 혼자있는 시간
  List<QItem> co_environment_part22; // 12. 담배연기 노출
  List<QItem> co_environment_part23; // 15. 장난감
  List<QItem> co_q19_environment_part24; // 19. 켄넬 사용

  List<QItem> co_treat;               // 6. 간식의 제형
  List<QItem> co_defecation1;         // 8. 소변 횟수
  List<QItem> co_defecation2;         // 9. 대변 횟수
  List<QItem> co_disease;             // 10-1. 현재 질환
  List<QItem> co_prevention;          // 10-6. 질병 예장 조치

  List<QItem> co_q17_behavior1;           // 17. 생활습관
  List<QItem> co_q18_behavior2;           // 18. 생활모습
  List<QItem> co_behavior3;           // 23. 이벤트

  List<QItem> co_behavior_step1;      // 공격성
  List<QItem> co_behavior_step2;      // 짖음
  List<QItem> co_behavior_step3;      // 분리불안
  List<QItem> co_behavior_step4;      // 보호자의존
  List<QItem> co_q20_sociality;           // 20. 사회화 정도

  final List<QItem> co_q05 = QItem.fromMenuList(const [
    "건사료",
    "습식사료",
    "동결건조사료",
    "화식사료",
    "생식사료",
    "반건조사료",
    "해당사항 없음"
  ]);

  final List<QItem> co_q07 = QItem.fromMenuList(const [
  "오리",
  "닭",
  "돼지",
  "소고기",
  "사슴",
  "캥거루",
  "양",
  "흰살생선",
  "연어",
  "비건사료",
  "멧돼지",
  "해당사항 없음"
  ]);

  final List<QItem> co_q5_5 = QItem.fromMenuList(const [
    "예",
    "아니오",
  ]);

  final List<QItem> co_q7 = QItem.fromMenuList(const [
  "사용중",
  "사용안함",
  "사용하다가 안하는중",
  ]);

  final List<QItem> co_q10 = QItem.fromMenuList(const [
  "1개월 이내",
  "2~3개월 이내",
  "6개월 이내",
  "9개월 이내",
  "1년 이내",
  "2년 이내",
    //"기타 보호자 입력"
  ]);

  final List<QItem> co_q10_3 = QItem.fromMenuList(const [
  "종합비타민",
  "면역 관련",
  "피부 관련",
  "관절 관련",
  "구강 관련",
  "비뇨기 관련",
  "심장 관련",
  "눈 관련",
  "간 관련",
  "장 관련",
  "신장 관련",
  "해당없음",
  ]);

  final List<QItem> co_q10_4 = QItem.fromMenuList(const [
  "종합비타민",
  "면역 관련",
  "피부 관련",
  "관절 관련",
  "구강 관련",
  "비뇨기 관련",
  "심장 관련",
  "눈 관련",
  "간 관련",
  "장 관련",
  "신장 관련",
  "해당없음",
  ]);

  /*
  final List<QItem> co_q10_6  = QItem.fromMenuList(const [
  "비만 관리",
  "소화기 관리",
  "비뇨기 관리",
  "관절 관리",
  "피부 관리",
  "눈 관리",
  "구강 관리",
  "면역 관리",
  "눈물 관리",
  ]);
   */

  /*
  final List<QItem> co_q11 = QItem.fromMenuList(const [
  "3시간 이내",
  "3~6시간 이내",
  "6~9시간 이내",
  "9시간 이상"
  ]);
  */
  final List<QItem> co_q13 = QItem.fromMenuList(const [
  "3일 이내",
  "7일 이내",
  "14일 이내",
  "1달 이내",
  "1달 보다 오래됨",
  "목욕을 하지 않음"
  ]);

  final List<QItem> co_q14 = QItem.fromMenuList(const [
  "1개월 이내",
  "3개월 이내",
  "6개월 이내",
  "1년 이내",
  "2년 이내",
  "미용 안함"
  ]);

  /*
  final List<QItem> co_q15 = QItem.fromMenuList(const [
  "1회",
  "2회",
  "3회",
  "4회",
  "5회 이상",
  "거의 하지 않음"
  ]);
  */

  /*
  final List<QItem> co_q16 = QItem.fromMenuList(const [
  "장난감을 가지고 놀지 않아요",
  "장난감을 거의 가지고 놀지 않아요",
  "보호자와 놀 때만 가지고 놀아요",
  "보호자 없이도 혼자서 장난감을 가지고 놀아요",
  "늘 장난감을 물고 다녀요",
  ]);
  */
  final List<QItem> co_q20 = QItem.fromMenuList(const [
  "1", "2", "3", "4", "5",
  "6", "7", "8", "9", "10",
  ]);


  final List<QItem> co_q21 = QItem.fromMenuList(const [
  "예",
  "아니오",
  ]);


  /*
  final List<QItem> co_q24_2 = QItem.fromMenuList(const [
  "1. 약하게 무는 경우: 장난감을 가지고 놀든 할 때 약간의 장난삼아 무는 경우로 끝난다면,"
  "열려할 정도는 아니지만 반복이 되면 공격성 단계가 올라갈 수 있으므로 올바른 놀이 "
  "교육이 필요합니다.",
  "2. 평소 얌전하지만 싫다는 표현으로 세게 무는 경우: 목욕, 발톱깎이 등 싫어하는 행위에"
  "대해서 공격성이 발생한 것으로 전문적인 수준의 교육이 필요합니다. 코애니로 문의 "
  "주시면 전문 훈련사와의 상담을 통해 조치를 해드리겠습니다.",
  "3. 싫다는 표현을 넘어 따라와서 공격하고 물려서 피가 나고 상처가 나는 경우: 목욕, 발톱깎이"
  " 등 싫어하는 행위에 대해서 공격성을 보이는 정도를 넘어, 그 행동에 대해 불편함 정도를"
  " 강하게 표현하는 경우에 해당합니다. 성품이 굥격적이고 예민할 수 있지만, 특정 행동에 "
  "대한 잘못된 교육으로 인한 공격성이 습관이 되어 더 진행하기 어려운 상황으로 전문적인 "
  "수준의 교육이 필요합니다. 코애니로 문의 주시면 전문 훈련사와의 상담을 통해 "
  "조치해드리겠습니다.",
  "4. 별 거 아닌 상황에도 습관적으로 물어 상처를 내고 피가 나는 경우: 상당한 수준의 교육이 "
  "필요하며, 그냥 지켜보고 있을 수 없는 수준으로, 전문적인 훈련사의 도움이 필요합니다. "
  "즉각적인 조치가 필요한 상황으로 코애니로 문의주시면 바로 조치를 취해드리겠습니다."
  ]);
  */

  final List<QItem> co_q24_3 = QItem.fromMenuList(const [
  "1. 벨소리, 모르는 사람이 왔을 경우, 차에 있을 경우 살짝 짖다가 마는 정도",
  "2. 벨소리, 모르는 사람이 왔을 경우, 차에 있을 경우 소리가 나지 않을 때까지 짖는 경우",
  "3. 벨소리, 모르는 사람이 왔을 경우, 차에 있을 경우 몇 분 이상을 쉬지 않고 계속해서 "
  "짖는 경우",
  ]);

  // 공격성
  final List<QItem> co_q24_4 = QItem.fromMenuList(const [
  "1. 보호자와의 살짝의 거리감으로도 낑낑거리고 짖음이 있으나, 집 안을 어지럽히지 않는 경우",
  "2. 보호자가 집 밖에 나가는 순간 짖고, 하울링 하며 집 안을 어지럽히는 경우",
  "3. 보호자가 집 밖에 나가는 순간 짖고, 하울링하며 집 안을 어지럽히며 대소변을 가리지 "
  "못하고 실수를 잦게 하는 경우",
  ]);

  final List<QItem> co_q24_5 = QItem.fromMenuList(const [
  "1. 보호자에게 지나치게 의존적일 수 있으며, 보호자가 없어지면 상당히 불안해 할 수 있으며, "
  "그로 인한 짖음 등이 심해질 수 있음. 보호자와 떨어져 있는 시간이 많지 않거나, 3차 접종 "
  "후 생후 약 6주차 이후에  야외 활동이 적었을 것으로 판단됩니다. 1년 미만일 때, "
  "다른 강아지와 함께 보냈던 시간이 거의 없거나, 공격을 당한 트라우마가 있는 경우일 수 "
  "있습니다. 주 보호자의 역할이 매우 중요하며, 주 보호자에게 너무 의존적이지 않도록 "
  "교육훈련이 필요한 상황입니다.",
  "2. 보호자에게 많이 의존적일 수 있으며, 보호자가 없어지면 상당히 불안해 할 수 있음. "
  "그로 인한 짖음 등의 문제가 발생할 수 있음. 보호자와 떨어져 있는 시간이 적고, "
  "3차 접종 후 생후 약 6주차 이후에  야외 활동이 적었을 것으로 판단됩니다. "
  "1년 미만일 때, 다른 강아지와 함께 보냈던 시간이 거의 없거나, 공격을 당한 트라우마가 "
  "있는 경우일 수 있습니다. 주 보호자의 역할이 매우 중요하며, 주 보호자에게 너무 "
  "의존적이지 않도록 교육훈련이 필요한 상황입니다.",
  "3. 보호자에게 다소 의존적일 수 있으며, 보호자가 없어지면 상당히 불안해 할 수 있음. "
  "그로 인한 짖음 등의 문제가 발생할 수 있음. 보호자와 떨어져 있는 시간이 적고, "
  "생후 6주 이후에 야외 활동이 적었을 것으로 판단됩니다. 다른 강아지와 함께 보냈던 "
  "시간이 거의 없을 것으로 판단됩니다. 주 보호자의 역할이 매우 중요하며, 주 보호자에게 "
  "너무 의존적이지 않도록 교육훈련이 필요한 상황입니다.",
  "4. 보호자에게 약간 의존적일 수 있으며, 보호자가 없어지면 조금은 불안해 할 수 있음. "
  "그로 인한 짖음 등의 문제가 발생할 수 있음. 보호자와 떨어져 있는 시간이 적고, "
  "생후 6주 이후에 야외 활동이 많지는 않았을 것으로 판단됩니다. 주 보호자의 역할이 매우 "
  "중요하며, 주 보호자의 약간의 교육을 통해서도 다른 강아지와 사회성을 높일 수 있습니다.",
  "5. 보호자에게 의존적일 수 있으나, 크게 걱정할 수준은 아닙니다. 하지만, 보호자가 없어지면 "
  "조금은 불안해 할 수 있습니다. 보호자와 떨어져 있는 시간이 길지 않을 것으로 판단됩니다. "
  "생후 6주 이후에 어느정도의 야외 활동이 있었을 것으로 판단됩니다. "
  "주 보호자의 약간의 교육을 통해서 올바른 사회성 교육을 할 수 있습니다.",
  "6. 보호자에게 크게 의존적이지 않을 것으로 보입니다. 하지만, 보호자가 없어지면 약간 불안해 "
  "할 수 있습니다. 생후 6주 이후에 어느 정도의 야외 활동이 있었을 것으로 판단됩니다. "
  "주 보호자의 약간의 교육을 통해서 올바른 사회성 교육을 할 수 있습니다.",
  "7. 보호자에게 의존적이지 않을 것으로 보입니다. 하지만, 보호자가 없어지면 약간 불안해 할 수 "
  "있습니다. 생후 6주 이후 적정 수준의 야외 활동이 있었을 것으로 판단됩니다. "
  "주 보호자의 약간의 교육을 통해서 올바른 사회성 교육을 할 수 있습니다.",
  "8. 보호자에게 의존적이지 않을 것으로 보입니다. 보호자가 없어져도 크게 불안해하지 않을 수 "
  "있습니다. 생후 6주 이후 적당한 수준의 야외 활동이 있었을 것으로 판단됩니다. "
  "주 보호자의 약간의 교육을 통해서 더욱 올바른 사회성 교육을 할 수 있습니다.",
  "9. 보호자에게 거의 의존적이지 않을 것으로 보입니다. 보호자가 없어져도 크게 불안해하지 않을 "
  "수 있습니다. 생후 6주 이후 많은 야외 활동이 있었을 것으로 판단됩니다. 주 보호자의 "
  "약간의 교육을 통해서 더욱 올바른 사회성 교육을 할 수  있으며, 아이의 성품이 예민하지 "
  "않고 상당히 좋을 것으로 판단됩니다.",
  "10. 보호자에게 전혀 의존적이지 않을 것으로 보입니다. 보호자가 없어져도 전혀 불안해하지 않을 "
  "수 있습니다. 생후 6주 이후 많은 환경에 노출이되었을 것으로 판단됩니다. "
  "주 보호자의 약간의 교육을 통해서 더욱 올바른 사회성 교육을 할 수  있으며, "
  "아이의 성품이 예민하지 않고 상당히 좋을 것으로 판단됩니다."
  ]);


  QMenuData({
    this.co_bcs = const [],
    this.co_environment_part11 = const [],
    this.co_environment_part12 = const [],
    this.co_environment_part13 = const [],
    this.co_environment_part13_1 = const [],
    this.co_environment_part21 = const [],
    this.co_environment_part22 = const [],
    this.co_environment_part23 = const [],
    this.co_q19_environment_part24 = const [],
    this.co_treat = const [],
    this.co_defecation1 = const [],
    this.co_defecation2 = const [],
    this.co_q17_behavior1 = const [],
    this.co_q18_behavior2 = const [],
    this.co_behavior3 = const [],

    this.co_behavior_step1 = const [],
    this.co_behavior_step2 = const [],
    this.co_behavior_step3 = const [],
    this.co_behavior_step4 = const [],

    this.co_disease = const [],
    this.co_prevention = const [],
    this.co_q20_sociality = const [],
  });

  static List<QMenuData> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return QMenuData.fromJson(data);
    }).toList();
  }

  factory QMenuData.fromJson(Map<String, dynamic> jdata)
  {
    var items = jdata['items'];
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(items);
    // }

    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(items['co_bcs']);
    //   logger.d(items['co_sociality']);
    // }
    QMenuData md = QMenuData(
      co_bcs: (items['co_bcs'] != null)
          ? QItem.fromSnapshot(items['co_bcs']) : [],
      co_environment_part11:(items['co_environment_part11'] != null)
            ? QItem.fromSnapshot(items['co_environment_part11']) : [],
      co_environment_part12:(items['co_environment_part12'] != null)
          ? QItem.fromSnapshot(items['co_environment_part12']) : [],
      co_environment_part13:(items['co_environment_part13'] != null)
          ? QItem.fromSnapshot(items['co_environment_part13']) : [],
      co_environment_part13_1:(items['co_environment_part13'] != null) // 주간 산책횟수
          ? QItem.fromSnapshot(items['co_environment_part13']) : [],
      co_environment_part21:(items['co_environment_part21'] != null)
          ? QItem.fromSnapshot(items['co_environment_part21']) : [],
      co_environment_part22:(items['co_environment_part22'] != null)
          ? QItem.fromSnapshot(items['co_environment_part22']) : [],
      co_environment_part23:(items['co_environment_part23'] != null)
          ? QItem.fromSnapshot(items['co_environment_part23']) : [],
      co_q19_environment_part24:(items['co_environment_part24'] != null)
          ? QItem.fromSnapshot(items['co_environment_part24']) : [],
      co_treat: (items['co_treat'] != null)
          ? QItem.fromSnapshot(items['co_treat']) : [],
      co_defecation1: (items['co_defecation1'] != null)
          ? QItem.fromSnapshot(items['co_defecation1']) : [],
      co_defecation2: (items['co_defecation2'] != null)
          ? QItem.fromSnapshot(items['co_defecation2']) : [],
      co_q17_behavior1: (items['co_behavior1'] != null)
          ? QItem.fromSnapshot(items['co_behavior1']) : [],
      co_q18_behavior2: (items['co_behavior2'] != null)
          ? QItem.fromSnapshot(items['co_behavior2']) : [],
      co_behavior3: (items['co_behavior3'] != null)
          ? QItem.fromSnapshot(items['co_behavior3']) : [],
      co_disease: (items['co_disease'] != null)
          ? QItem.fromSnapshot(items['co_disease']) : [],
      co_prevention: (items['co_prevention'] != null)
          ? QItem.fromSnapshot(items['co_prevention']) : [],

      co_behavior_step1: (items['co_behavior_step1'] != null)
          ? QItem.fromSnapshot(items['co_behavior_step1']) : [],
      co_behavior_step2: (items['co_behavior_step2'] != null)
          ? QItem.fromSnapshot(items['co_behavior_step2']) : [],
      co_behavior_step3: (items['co_behavior_step3'] != null)
          ? QItem.fromSnapshot(items['co_behavior_step3']) : [],
      co_behavior_step4: (items['co_behavior_step4'] != null)
          ? QItem.fromSnapshot(items['co_behavior_step4']) : [],

      co_q20_sociality: (items['co_sociality'] != null)
          ? QItem.fromSnapshot(items['co_sociality']) : [],
    );

    // QItem.trimLabel(md.co_behavior_step1);
    // QItem.trimLabel(md.co_behavior_step2);
    // QItem.trimLabel(md.co_behavior_step3);
    // QItem.trimLabel(md.co_behavior_step4);
    return md;
  }
}