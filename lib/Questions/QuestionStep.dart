// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, constant_identifier_names, file_names

import 'package:coani/Animals/animal_register.dart';
import 'package:coani/Constants/Constants.dart';
import 'package:coani/Constants/HostInfo.dart';
import 'package:coani/Constants/Patterns.dart';
import 'package:coani/Models/Animal.dart';
import 'package:coani/Models/Questions.dart';
import 'package:coani/Models/itemAttach.dart';
import 'package:coani/Models/qItem.dart';
import 'package:coani/Models/qMenuData.dart';
import 'package:coani/Questions/QFormCard.dart';
import 'package:coani/Questions/QSelRadioCard.dart';
import 'package:coani/Questions/cardQButton.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:coani/Utils/utils.dart';
//import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/step_page_indicator.dart';
import 'package:transition/transition.dart';
import 'QSelCheckCard.dart';

const int STEP2_AINFO       = 0;   // 반려동물. 정보.
const int STEP1_AGREE       = 1;   // 정보동의.
const int STEP0_GUIDE       = 2;   // 절차안내.
const int STEP3_CHECK       = 3;   // 변동사항. (1/6)
const int STEP4_EAT         = 4;   // 식이습관. (2/6)
const int STEP6_LIFE        = 5;   // 생활습관. (4/6)
const int STEP5_HEALTH      = 6;   // 건강정보. (3/6)
const int STEP7_ACTION      = 7;   // 행동정의. (5/6)
const int STEP8_ADD         = 8;   // 문의사항. (6/6)
const int STEP9_QFINISH     = 9;   // 설문완료 확인.
const int STEP10_KIT_GUIDE  = 10;  // 키트사용 안내.
const int STEP11_KIT_REGIST = 11;  // 키트번호 등록하여 검사요청.
const int STEP_COUNT        = 12;

class QuestionStep extends StatefulWidget {
  final String users_id;
  final Animal animal;
  //final Questions qsheet;
  const QuestionStep({ Key? key,
    required this.animal,
    required this.users_id,
    //required this.qsheet
  }) : super(key: key);

  @override
  State<QuestionStep> createState() => _QuestionStepState();
}

class _QuestionStepState extends State<QuestionStep> {

  Questions _qInfo = Questions();
  QMenuData _qMenu = QMenuData();

  bool isPageDirty = false;
  double curr_progress = 0.0;
  bool isPageBegin = true;
  bool isPageLast  = false;
  int  curr_page_index = 0;
  int  past_page_index = 0;
  String app_title = "정보확인";
  String _missQuestion = "";
  var visible = List.filled(STEP_COUNT, true, growable: true);

  List<bool> showAapBar = [ false, false, false, true, true, true, true, true, true, false, false, false ];
  final PageController pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  final TextEditingController _kitNoController = TextEditingController();

  Future <void> _reqMenuItems() async {
    await Remote.getQItems(
        params: {},
        onResponse: (QMenuData data) {
          _qMenu = data;
        });
  }

  @override
  void initState() {
    _qInfo.users_id = widget.users_id;
    Future.microtask(() async {
      _updateAnimalInfo();
      await _reqMenuItems();
      await _reqTempData(widget.users_id, widget.animal.id!);
    });
    super.initState();
  }

  @override
  void dispose() {
    _kitNoController.dispose();
    super.dispose();
  }

  void _checkValidate() {
    _missQuestion = "";
      switch(curr_page_index) {
        case STEP2_AINFO: // 반려동물 정보.
          visible[curr_page_index] = true;
          break;

        case STEP0_GUIDE: // 절차안내.
          visible[curr_page_index] = true;
          break;

        case STEP1_AGREE: // 정보동의.
          visible[curr_page_index] = true;
          break;

        case STEP3_CHECK: // 기본정보(5)
          visible[curr_page_index] = false;
          if( _qInfo.i01_ai_a01.isNotEmpty &&
              _qInfo.i02_ai_a02.isNotEmpty &&
              _qInfo.i03_ai_a03.isNotEmpty &&
              _qInfo.i04_ai_a04.isNotEmpty)
          {
            visible[curr_page_index] = true;
          } else {
            if(_qInfo.i01_ai_a01.isEmpty) {
              _missQuestion = "1. 체형을 선택해주세요.";
            } else if(_qInfo.i02_ai_a02.isEmpty) {
              _missQuestion = "2. 예방접종 주기를 선택해주세요.";
            } else if(_qInfo.i03_ai_a03.isEmpty) {
              _missQuestion = "3. 심장사상충 예방주기를 선택해주세요.";
            } else if(_qInfo.i04_ai_a04.isEmpty) {
              _missQuestion = "4. 임신중/수유기 정보를 선택해주세요.";
            }
          }
          print("STEP3_CHECK:visible[$curr_page_index]=${visible[curr_page_index]}");
          print("STEP4_EAT:i01_ai_a01=${_qInfo.i01_ai_a01}");
          print("STEP4_EAT:i02_ai_a02=${_qInfo.i02_ai_a02}");
          print("STEP4_EAT:i03_ai_a03=${_qInfo.i03_ai_a03}");
          print("STEP4_EAT:i04_ai_a04=${_qInfo.i04_ai_a04}");
          break;

        case STEP4_EAT: // 식이습관(5)
          visible[curr_page_index] = false;
          if( _qInfo.i05_eh_a01.isNotEmpty &&
              _qInfo.i06_eh_a02.isNotEmpty &&
              _qInfo.i07_eh_a03.isNotEmpty &&
              _qInfo.i08_eh_a04.isNotEmpty &&
              _qInfo.i09_eh_a05.isNotEmpty &&
              _qInfo.i10_ls_a01.isNotEmpty &&
              _qInfo.i11_ls_a02.isNotEmpty &&
              _qInfo.i12_ls_a03.isNotEmpty)
          {
            visible[curr_page_index] = true;
          }
          else {
            if(_qInfo.i05_eh_a01.isEmpty) {
              _missQuestion = "5. 사료의 제형 선택해주세요.";
            } else if(_qInfo.i06_eh_a02.isEmpty) {
              _missQuestion = "5-2. 사료의 이름을 적어주세요.";
            } else if(_qInfo.i07_eh_a03.isEmpty) {
              _missQuestion = "5-4. 사료의 단백질원을 선택해주세요.";
            } else if(_qInfo.i08_eh_a04.isEmpty) {
              _missQuestion = "5-5. 가수분해 사료급여 여부를 선택해주세요.";
            }else if(_qInfo.i09_eh_a05.isEmpty) {
              _missQuestion = "6. 간식의 제형을 선택해주세요.";
            } else if(_qInfo.i10_ls_a01.isEmpty) {
              _missQuestion = "7. 펫 정수기 사용여부를 선택해주세요.";
            } else if(_qInfo.i11_ls_a02.isEmpty) {
              _missQuestion = "8. 하루 소변횟수를 선택해주세요.";
            } else if(_qInfo.i12_ls_a03.isEmpty) {
              _missQuestion = "9. 하루 대변횟수를 선택해주세요.";
            }
          }
          print("STEP4_EAT:visible[$curr_page_index]=${visible[curr_page_index]}");
          print("STEP4_EAT:i05_eh_a01=${_qInfo.i05_eh_a01}");
          print("STEP4_EAT:i06_eh_a02=${_qInfo.i06_eh_a02}");
          print("STEP4_EAT:i06_eh_a02_attach=${_qInfo.i06_eh_a02_attach}");
          print("STEP4_EAT:i06_eh_a022_attach=${_qInfo.i06_eh_a022_attach}");
          print("STEP4_EAT:i07_eh_a03=${_qInfo.i07_eh_a03}");
          print("STEP4_EAT:i08_eh_a04=${_qInfo.i08_eh_a04}");
          print("STEP4_EAT:i09_eh_a05=${_qInfo.i09_eh_a05}");
          print("STEP4_EAT:i09_eh_a05_attach=${_qInfo.i09_eh_a05_attach}");
          print("STEP4_EAT:i10_ls_a01=${_qInfo.i10_ls_a01}");
          print("STEP4_EAT:i11_ls_a02=${_qInfo.i11_ls_a02}");
          print("STEP4_EAT:i11_ls_a02_attach=${_qInfo.i11_ls_a02_attach}");
          print("STEP4_EAT:i12_ls_a03=${_qInfo.i12_ls_a03}");
          print("STEP4_EAT:i12_ls_a03_attach=${_qInfo.i12_ls_a03_attach}");
          break;

        case STEP6_LIFE: // 생활습관(5)
          visible[curr_page_index] = false;
          if( _qInfo.i13_ls_a04.isNotEmpty &&
              _qInfo.i14_ls_a05.isNotEmpty &&
              _qInfo.i15_ls_a06.isNotEmpty &&
              _qInfo.i16_hi_a01.isNotEmpty &&
              _qInfo.i17_hi_a02.isNotEmpty )
          {
            visible[curr_page_index] = true;
          }
          else {
            if(_qInfo.i13_ls_a04.isEmpty) {
              _missQuestion = "10. 최근 병원을 방문 한적이 있나요?";
            } else if(_qInfo.i14_ls_a05.isEmpty) {
              _missQuestion = "10-1. 현재 앓고있는 질환을 선택해주세요.";
            } else if(_qInfo.i15_ls_a06.isEmpty) {
              _missQuestion = "10-3. 3달이내 처방받은 약를 선택해주세요.";
            } else if(_qInfo.i16_hi_a01.isEmpty) {
              _missQuestion = "10-4. 3달이내 금여한 영양제를 선택해주세요.";
            } else if(_qInfo.i17_hi_a02.isEmpty) {
              _missQuestion = "10-6. 질병예방 건강관리를 선택해주세요.";
            }
          }
          print("STEP6_LIFE:visible[$curr_page_index]=${visible[curr_page_index]}");
          print("STEP4_EAT:i13_ls_a04=${_qInfo.i13_ls_a04}");
          print("STEP4_EAT:i14_ls_a05=${_qInfo.i14_ls_a05}");
          print("STEP4_EAT:i15_ls_a06=${_qInfo.i15_ls_a06}");
          print("STEP4_EAT:i16_hi_a01=${_qInfo.i16_hi_a01}");
          print("STEP4_EAT:i17_hi_a02=${_qInfo.i17_hi_a02}");
          break;

        case STEP5_HEALTH: // 건강정보(5)
          visible[curr_page_index] = false;
          if( _qInfo.i18_hi_a03.isNotEmpty &&
              _qInfo.i19_ad_a01.isNotEmpty &&
              _qInfo.i20_ad_a02.isNotEmpty &&
              _qInfo.i21_ad_a03.isNotEmpty &&
              _qInfo.i22_ad_a04.isNotEmpty &&
              _qInfo.i38_ex_a08.isNotEmpty)
          {
            visible[curr_page_index] = true;
          } else {
            if(_qInfo.i18_hi_a03.isEmpty) {
              _missQuestion = "11. 하루 중 혼자 있는 시간을 선택해주세요.";
            } else if(_qInfo.i19_ad_a01.isEmpty) {
              _missQuestion = "12. 담배 연기에 주기적으로 노출이 되고 있는지 선택해주세요.";
            } else if(_qInfo.i20_ad_a02.isEmpty) {
              _missQuestion = "13. 전체 목욕을 시킨 날짜를 선택해주세요.";
            } else if(_qInfo.i21_ad_a03.isEmpty) {
              _missQuestion = "14. 미용 시기를 선택해주세요.";
            } else if(_qInfo.i22_ad_a04.isEmpty) {
              _missQuestion = "15. 하루 산책 횟수를 선택해주세요.";
            } else if(_qInfo.i38_ex_a08.isEmpty) {
              _missQuestion = "15-1. 주간 산책 횟수를 선택해주세요.";
            }
          }
          print("STEP5_HEALTH:visible[$curr_page_index]=${visible[curr_page_index]}");
          print("STEP4_EAT:i18_hi_a03=${_qInfo.i18_hi_a03}");
          print("STEP4_EAT:i19_ad_a01=${_qInfo.i19_ad_a01}");
          print("STEP4_EAT:i20_ad_a02=${_qInfo.i20_ad_a02}");
          print("STEP4_EAT:i21_ad_a03=${_qInfo.i21_ad_a03}");
          print("STEP4_EAT:i22_ad_a04=${_qInfo.i22_ad_a04}");
          break;

        case STEP7_ACTION:// 행동정의(5)
          visible[curr_page_index] = false;
          if( _qInfo.i23_ad_a05.isNotEmpty &&
              _qInfo.i24_ad_a06.isNotEmpty &&
              _qInfo.i25_ad_a07.isNotEmpty &&
              _qInfo.i26_md_a01.isNotEmpty &&
              _qInfo.i27_md_a02.isNotEmpty &&
              _qInfo.i37_ex_a08.isNotEmpty )
          {
            visible[curr_page_index] = true;
          } else {
            if(_qInfo.i23_ad_a05.isEmpty) {
              _missQuestion = "16. 장남감을 가지고 놀 때의 습관을 선택해주세요.";
            } else if(_qInfo.i24_ad_a06.isEmpty) {
              _missQuestion = "17. 평소의 반려동물 습관을 선택해주세요.";
            } else if(_qInfo.i25_ad_a07.isEmpty) {
              _missQuestion = "18. 반려동물에게서 자주 보이는 모습을 선택해주세요.";
            } else if(_qInfo.i26_md_a01.isEmpty) {
              _missQuestion = "19. 켄넬 및 하우스 사용 가능 여부를  선택해주세요.";
            } else if(_qInfo.i27_md_a02.isEmpty) {
              _missQuestion = "20. 사회성 정도를 선택해주세요.";
            } else if(_qInfo.i37_ex_a08.isEmpty) {
              _missQuestion = "20-1. 의존성 정도를 선택해주세요.";
            }
          }
          print("STEP7_ACTION:visible[$curr_page_index]=${visible[curr_page_index]}");
          print("STEP4_EAT:i23_ad_a05=${_qInfo.i23_ad_a05}");
          print("STEP4_EAT:i24_ad_a06=${_qInfo.i24_ad_a06}");
          print("STEP4_EAT:i25_ad_a07=${_qInfo.i25_ad_a07}");
          print("STEP4_EAT:i26_md_a01=${_qInfo.i26_md_a01}");
          print("STEP4_EAT:i27_md_a02=${_qInfo.i27_md_a02}");
          break;

        case STEP8_ADD: // 구글시트 추가사항
        // i19_ad_a01 ~ i24_ad_a06
          visible[curr_page_index] = false;
          if(    _qInfo.i28_md_a03.isNotEmpty
              && _qInfo.i30_ex_a02.isNotEmpty
              && _qInfo.i34_ex_a06.isNotEmpty
              && _qInfo.i35_ex_a06.isNotEmpty
              && _qInfo.i36_ex_a07.isNotEmpty
          )
          {
            visible[curr_page_index] = true;
          } else {
            if(_qInfo.i28_md_a03.isEmpty) {
              _missQuestion = "21. 유치원 등원 여부를 선택해주세요.";
            } else if(_qInfo.i30_ex_a02.isEmpty) {
              _missQuestion = "23. 3개월 이내에 겪은 이벤트를 선택해주세요.";
            } else if(_qInfo.i34_ex_a06.isEmpty) {
              _missQuestion = "24-2. 공격성 정도를 선택해주세요.";
            } else if(_qInfo.i35_ex_a06.isEmpty) {
              _missQuestion = "24-3. 짖음 정도를  선택해주세요.";
            } else if(_qInfo.i36_ex_a07.isEmpty) {
              _missQuestion = "24-4. 분리불안 행동을 선택해주세요.";
            }
          }
          print("STEP8_ADD:visible[$curr_page_index]=${visible[curr_page_index]}");
          print("STEP4_EAT:i28_md_a03=${_qInfo.i28_md_a03}");
          print("STEP4_EAT:i29_ex_a01=${_qInfo.i29_ex_a01}");
          print("STEP4_EAT:i30_ex_a02=${_qInfo.i30_ex_a02}");
          print("STEP4_EAT:i31_ex_a03=${_qInfo.i31_ex_a03}");
          print("STEP4_EAT:i32_ex_a04=${_qInfo.i32_ex_a04}");
          break;

        case STEP9_QFINISH: // 설문완료 확인.
          visible[curr_page_index] = true;
          break;

        case STEP10_KIT_GUIDE: // 키트사용 안내.
          visible[curr_page_index] = true;
          break;

        case STEP11_KIT_REGIST:
          visible[curr_page_index] = (_kitNoController.text.length==7) ? true : false;
          break;
      }

      setState(() {});
  }

  void _onPageChanged(int page) {

      isPageDirty = false;
      _currentPageNotifier.value = page;
      curr_page_index = page;

      if(past_page_index<=curr_page_index) {
        past_page_index = curr_page_index;
      }

      visible[curr_page_index] = true;
      isPageBegin = (curr_page_index == 0) ? true : false;
      isPageLast  = (curr_page_index>=STEP_COUNT-1) ? true : false;

      double pos = (curr_page_index+1);
      curr_progress = pos/STEP_COUNT;
      _checkValidate();

      switch(curr_page_index) {
        case STEP0_GUIDE: // 절차안내.
          app_title = "검사안내";
          break;

        case STEP1_AGREE: // 정보동의.
          app_title = "정보동의";
          break;

        case STEP2_AINFO: // 반려동물 정보.
          app_title = "정보확인";
          break;

        case STEP3_CHECK: // 변동사항(5)
          app_title = "기본정보 (1/6)";
          break;

        case STEP4_EAT: // 식이습관(5)
          app_title = "식이습관 (2/6)";
          break;

        case STEP6_LIFE: // 생활습관(5)
          app_title = "건강정보 (3/6)";
          break;

        case STEP5_HEALTH: // 건강정보(5)
          app_title = "생활습관 (4/6)";
          break;

        case STEP7_ACTION:// 행동정의(5)
          app_title = "행동성향 (5/6)";
          break;

        case STEP8_ADD: // 구글시트 추가사항
          app_title = "이벤트 및 문의 (6/6)";
          break;

        case STEP9_QFINISH: // 설문완료 확인.
          app_title = "설문완료";
          break;

        case STEP10_KIT_GUIDE: // 키트사용 안내.
          app_title = "카드안내";
          break;

        case STEP11_KIT_REGIST:
          app_title = "키트번호 등록";
          _kitNoController.text = _qInfo.kit_number.toString();
          break;
      }

      //app_title += "- $curr_page_index[$STEP4_EAT ~ $STEP9_QFINISH]";

      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusScope.of(context).unfocus();},
      child: WillPopScope (
        onWillPop: () => _onBackPressed(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppBar_Color,
            elevation: 1.0,
            title: Text(app_title, style:TextStyle(color:AppBar_Title)),
            leading: Visibility(
              visible:  true,
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppBar_Icon,), // (isPageBegin) ? Icons.close :
                  onPressed: () {
                      _prevPage();
                  }
              ),
            ),
            actions: [
              Visibility(
                visible: false,//(curr_page_index>=STEP4_EAT && curr_page_index <= STEP9_QFINISH),// && isPageDirty),
                child: IconButton(
                    icon: Icon(Icons.save_outlined, color: AppBar_Icon),
                    onPressed: () async {
                      _doSumit(false);
                    }
                ),
              ),

              Visibility(
                visible: (isPageBegin) ? false: true,
                child: IconButton(
                    icon: Icon(Icons.close, color: AppBar_Icon),
                    onPressed: () {
                      doConfirmQuit();
                    }
                ),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10.0),
                child: StepPageIndicator(
                  itemCount: STEP_COUNT,
                  currentPageNotifier: _currentPageNotifier,
                  size: 16,
                  stepColor: Colors.brown,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: SafeArea(
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: pageController,
                            physics: const NeverScrollableScrollPhysics(), // disable swipe
                            onPageChanged: (int index) {
                              _onPageChanged(index);
                            },

                            itemCount: STEP_COUNT,
                            itemBuilder: (BuildContext context, int index) {
                              switch (index) {
                                case STEP0_GUIDE:     // 절차안내.
                                  return Stack(
                                    children: [
                                      Positioned(
                                        //top:0,
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("${_qInfo.a_name}의"
                                                      "\n모발검사는 이렇게 진행됩니다.",
                                                      style:const TextStyle(
                                                          fontSize:24.0,
                                                          fontWeight:FontWeight.bold,
                                                          color:Colors.black)),
                                                  const SizedBox(height:5),
                                                  const Text("정확한 검사를 위해 사전 설문 작성부터 "
                                                      "차례대로 진행해주세요.",
                                                      style:const TextStyle(
                                                          fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)),
                                                  const SizedBox(height:30),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("모발검사 진행 과정",
                                                        textAlign: TextAlign.center,
                                                        style:TextStyle(
                                                            fontSize:16.0,
                                                            fontWeight:FontWeight.normal,
                                                            color:Colors.black)),
                                                  ),
                                                  const SizedBox(height:10),
                                                  Center(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(20),
                                                      width:MediaQuery.of(context).size.width*0.9,
                                                      child:Image.asset("assets/icon/icon_steps.png"),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1,
                                                          color: Colors.grey.shade300,),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height:50),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("모발 키트 구성품을 꼭 확인해 주세요.",
                                                        textAlign: TextAlign.center,
                                                        style:const TextStyle(
                                                            fontSize:16.0,
                                                            fontWeight:FontWeight.normal,
                                                            color:Colors.black)),
                                                  ),
                                                  const SizedBox(height:10),
                                                  Center(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(20),
                                                      width:MediaQuery.of(context).size.width*0.9,
                                                      child:Image.asset("assets/icon/icon_items.png"),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey.shade300,),
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(height:100),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    btnText: '검사 시작하기',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),
                                                  const SizedBox(height:100),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP1_AGREE:     // 정보동의
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text("검사를 시작하기 전에"
                                                      "\n동반자님의 동의가 필요합니다.",
                                                      style:TextStyle(
                                                          fontSize:24.0,
                                                          fontWeight:FontWeight.bold,
                                                          color:Colors.black)
                                                  ),
                                                  const SizedBox(height:10),
                                                  const Text("모발검사를 진행할 경우, "
                                                      "관계자 간 원활한 의사소통 및 배송, "
                                                      "정확한 검사결과 제공을 위하여 동반자님의 개인정보를 "
                                                      "아래와 같이 제3자에 제공합니다.",
                                                      textAlign: TextAlign.justify,
                                                      style:const TextStyle(
                                                          fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)),
                                                  const SizedBox(height:30),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("개인정보 제공 내용",
                                                        textAlign: TextAlign.center,
                                                        style:const TextStyle(
                                                            fontSize:16.0,
                                                            fontWeight:FontWeight.normal,
                                                            color:Colors.black)),
                                                  ),
                                                  const SizedBox(height:20),
                                                  Container(
                                                    padding: const EdgeInsets.all(10),
                                                    width:MediaQuery.of(context).size.width*0.9,
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: const [
                                                        Text("정보를 제공받는자",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.bold,
                                                                color:Colors.black)
                                                        ),
                                                        Text("코애니",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                        Text("\n개인정보 수집 및 이용목적",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.bold,
                                                                color:Colors.black)
                                                        ),
                                                        Text("모발검사 결과 제공 업무.",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                        Text("\n개인정보 수집 및 이용 항목",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.bold,
                                                                color:Colors.black)
                                                        ),
                                                        Text("1. 회원정보: 이름, 전화번호, 이메일, 주소",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                        Text("2. 반려동물 정보: 반려동물의 기본정보 "
                                                            "및 설문 내용.",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                        Text("\n 귀하는 위 개인정보 수집 및 "
                                                            "이용에 대한 동의를 거부할 권리가 있으며, "
                                                            "동의 거부시 서비스 제공이 불가능함을 알려드립니다. ",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.bold,
                                                                color:Colors.black)
                                                        ),
                                                      ],
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 1,
                                                        color: Colors.grey.shade300,),
                                                    ),
                                                  ),

                                                  const SizedBox(height:30),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("유의사항",
                                                        textAlign: TextAlign.center,
                                                        style:const TextStyle(
                                                            fontSize:16.0,
                                                            fontWeight:FontWeight.normal,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:20),
                                                  Container(
                                                    padding: const EdgeInsets.all(10),
                                                    width:MediaQuery.of(context).size.width*0.9,
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: const [
                                                        Text("코애니 모발 스트레스 분석 서비스 이용시 유의사항",
                                                            textAlign: TextAlign.center,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                        Text("\n  코애니 모발 스트레스 분석 "
                                                            "(이하 “본 서비스”)는 "
                                                            "반려동물의 모발이 자라는 기간 동안의 스트레스 상태를 "
                                                            "분석·평가하여 현재의 건강상태와 미래의 건강 및 "
                                                            "질병에 대한 "
                                                            "취약도를 파악하는데 "
                                                            "도움을 주기 위한 선별 검사의 목적으로 수행됩니다.",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                        Text("\n  본 서비스는 반려동물을 진료하거나 "
                                                            "그 질병을 치료하는 "
                                                            "서비스가 아닙니다. "
                                                            "또한 본 서비스는 수의사의 진료행위를 대체할 "
                                                            "수 없습니다. "
                                                            "본 서비스에 따른 분석 결과는 코애니(이하 “회사”)의 "
                                                            "사전 동의 없이는 광고, "
                                                            "홍보, 유사 서비스 제공 등 상업적 목적이나 "
                                                            "법적 분쟁에서의 자료제출 "
                                                            "목적으로 사용할 수 없습니다.",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                        Text("\n  본 서비스 신청서에 기재되는 "
                                                            "보호자의 정보(성명 및 연락처 등)은 "
                                                            "반려동물의 식별 및 분석결과 전달을 위한 "
                                                            "목적으로만 사용되며, "
                                                            "회사의 개인정보 처리방침에 따라 관리 및 파기됩니다.",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                        Text("\n  본 서비스에 따른 분석 결과 및 반려동물의 "
                                                            "건강에 영향을 미치는 요인"
                                                            "(생활습관, 식습관 등)에 "
                                                            "대한 설문조사 내용은 검사결과 해석, 상담, 연구, "
                                                            "회사가 제공하는 "
                                                            "서비스 개선 등에 활용될 수 있습니다.",
                                                            textAlign: TextAlign.justify,
                                                            style:TextStyle(
                                                                fontSize:14.0,
                                                                fontWeight:FontWeight.normal,
                                                                color:Colors.black)
                                                        ),
                                                      ],
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey.shade300,),
                                                    ),
                                                  ),
                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    btnText: '동의하고 다음단계로',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),
                                                  /*
                                                  Visibility(
                                                    visible: visible[curr_page_index],
                                                    child: Center(
                                                      child:ElevatedButton(
                                                        child: const Text("동의하고 다음단계로",
                                                            style:const TextStyle(
                                                                fontSize:16.0,
                                                                color:Colors.white)
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.brown,
                                                            fixedSize: const Size(300, 60),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(50)
                                                            )
                                                        ),
                                                        onPressed:() {
                                                          _nextPage();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  */
                                                  const SizedBox(height:100),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP2_AINFO:     // 반려동물 정보.
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("${_qInfo.a_name}의 기본정보를 확인해주세요.",
                                                      style:const TextStyle(
                                                          fontSize:24.0,
                                                          fontWeight:FontWeight.bold,
                                                          color:Colors.black)),
                                                  const SizedBox(height:10),
                                                  const Text("프로필 정보에서 변경된 사항이 있으면 수정해주세요.",
                                                      style:TextStyle(fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)),

                                                  const SizedBox(height:30),
                                                  Column(
                                                    children: [
                                                      const SizedBox(height: 10),
                                                      Container(
                                                        key: UniqueKey(),
                                                        padding: const EdgeInsets.all(10),
                                                        child: Container(
                                                          height:MediaQuery.of(context).size.width*0.3,
                                                          padding: const EdgeInsets.all(11),
                                                          color: Colors.grey[100],
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              // 반려동물 사진.
                                                              //
                                                              Center(
                                                                child: Image.network(
                                                                  "$URL_IMAGE/${widget.animal.photo_url}",
                                                                    fit: BoxFit.fill,
                                                                  //cache: true,
                                                                  //shape: BoxShape.rectangle,
                                                                ),
                                                              ),
                                                              //
                                                              const SizedBox(width: 10,),
                                                              // 반려동물 정보(이름, 날짜, 검사시작 버튼)
                                                              Expanded(
                                                                child: Container(
                                                                    padding: const EdgeInsets.all(5),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(widget.animal.name.toString(),
                                                                            style: const TextStyle(
                                                                                fontSize: 20.0,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight
                                                                                    .bold)
                                                                        ),
                                                                        const SizedBox(height: 10,),
                                                                        Text(getDayCount(
                                                                            widget.animal.birthday.toString()),
                                                                            style: const TextStyle(
                                                                                fontSize: 16.0, color:
                                                                            Colors.black)),
                                                                        const Spacer(),
                                                                      ],
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(height: 10),
                                                      Container(
                                                        padding: const EdgeInsets.all(20),
                                                        width: MediaQuery.of(context).size.width * 0.9,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // 이름
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  width: 100,
                                                                  child: const Text("이름",
                                                                      textAlign: TextAlign.start,
                                                                      style: TextStyle(
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Colors.black)
                                                                  ),
                                                                ),
                                                                Text("${widget.animal.name}",
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black)
                                                                ),
                                                              ],
                                                            ),
                                                            // 생년월일
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  width: 100,
                                                                  child: const Text("생년월일",
                                                                      textAlign: TextAlign.start,
                                                                      style: const TextStyle(
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Colors.black)
                                                                  ),
                                                                ),
                                                                Text("${widget.animal.birthday}",
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black)
                                                                ),
                                                              ],
                                                            ),
                                                            // 성별
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  width: 100,
                                                                  child: const Text("성별",
                                                                      textAlign: TextAlign.start,
                                                                      style: const TextStyle(
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Colors.black)
                                                                  ),
                                                                ),
                                                                Text("${widget.animal.sex}",
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black)
                                                                ),
                                                              ],
                                                            ),
                                                            // 중성화 여부
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  width: 100,
                                                                  child: const Text("중성화 여부",
                                                                      textAlign: TextAlign.start,
                                                                      style: const TextStyle(
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Colors.black)
                                                                  ),
                                                                ),
                                                                Text("${widget.animal.spayed}",
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black)
                                                                ),
                                                              ],
                                                            ),
                                                            // 품종
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  width: 100,
                                                                  child: const Text("품종",
                                                                      textAlign: TextAlign.start,
                                                                      style: const TextStyle(
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Colors.black)
                                                                  ),
                                                                ),
                                                                Text("${widget.animal.breed}",
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black)
                                                                ),
                                                              ],
                                                            ),
                                                            // 몸무게
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  width: 100,
                                                                  child: const Text("몸무게",
                                                                      textAlign: TextAlign.start,
                                                                      style: TextStyle(
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Colors.black)
                                                                  ),
                                                                ),
                                                                Text("${widget.animal.weight}Kg",
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black)
                                                                ),
                                                              ],
                                                            ),
                                                            // 등록번호
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  width: 100,
                                                                  child: const Text("등록번호",
                                                                      textAlign: TextAlign.start,
                                                                      style: const TextStyle(
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Colors.black)
                                                                  ),
                                                                ),
                                                                Text("${widget.animal.registered_number}",
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black)
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey.shade300,
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  const SizedBox(height:30),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await Navigator.push(context,
                                                        Transition(
                                                            child: AnimalRegister(
                                                              animal: widget.animal,
                                                              command: "UPDATE",
                                                            users_id: widget.users_id,
                                                              canDelete: false,),
                                                            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                                                        ),
                                                      );
                                                      setState(() {
                                                        _updateAnimalInfo();
                                                      });
                                                    },
                                                    child: const SizedBox(
                                                      width: 1000,
                                                      child: const Text("등록정보 수정하기 >",
                                                          textAlign: TextAlign.center,
                                                          style:const TextStyle(fontSize:16.0,
                                                            fontWeight:FontWeight.normal,
                                                            color:Colors.blueAccent,
                                                            //decoration:TextDecoration.underline,
                                                          )),
                                                    ),
                                                  ),

                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    btnText: '확인하고 다음단계로',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),
                                                  const SizedBox(height:100),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP3_CHECK:     // 기본정보
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text("반려동물의 스트레스 원인을 파악하는 용도로 사용되고, "
                                                      "향후 코애니 서비스 개선을 위한 자료로 활용이 될 예정입니다.",
                                                      style:const TextStyle(fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)),
                                                  const SizedBox(height:20),

                                                  // 01. [i01_ai_a01] 1. xx의 체형을 체크해 주세요.
                                                  QSelRadioCard(
                                                    title: ["n1. ${_qInfo.a_name}의 ",
                                                      "b체형",
                                                      "n을 체크해 주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList:_qMenu.co_bcs,

                                                    isUseCode:true,
                                                    tag:"i01_ai_a01",
                                                    initValue: _qInfo.i01_ai_a01.toString(),
                                                    attach: true,
                                                    attachList: [
                                                      ItemAttach(
                                                          tag:"1",
                                                          title: ["n1-1. ${_qInfo.a_name}의 ",
                                                            "b체형을 사진으로 보내주세요."],
                                                          subTitle: "체형 사진을 윗모습, 옆모습 2번 찍어주세요",
                                                          label: "윗모습",
                                                          url: _qInfo.i01_ai_a01_attach,
                                                          type:"P"
                                                      ),
                                                      ItemAttach(
                                                          tag:"2",
                                                          title: [],
                                                          subTitle: "",
                                                          label: "옆모습",
                                                          url: _qInfo.i01_ai_a012_attach,
                                                          type:"P"
                                                      )
                                                    ],
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i01_ai_a01 = answerText;
                                                      if(tag=="1") {
                                                        _qInfo
                                                            .i01_ai_a01_attach =
                                                            attach;
                                                      }
                                                      if(tag=="2") {
                                                        _qInfo
                                                            .i01_ai_a012_attach =
                                                            attach;
                                                      }
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 02. [i02_ai_a02] 2. 예방접종 주기를 체크해 주세요.
                                                  QSelRadioCard(
                                                    title: const ["n2. ", "b예방접종 주기", "n를 체크해주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    isUseCode:true,
                                                    aList: _qMenu.co_environment_part11,
                                                    tag:"i02_ai_a02",
                                                    initValue: _qInfo.i02_ai_a02.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i02_ai_a02_attach = attach;
                                                      _qInfo.i02_ai_a02 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 03. [i03_ai_a03] 3. 심장사상충 예방은 얼마나 자주 하시나요?
                                                  QSelRadioCard(
                                                    title: const ["n3. ","b심장사상충 예방", "n은 얼마나 자주 하시나요?"],
                                                    subTitle: "",isVertical: true,
                                                    aList: _qMenu.co_environment_part12,
                                                    isUseCode:true,
                                                    tag:"i03_ai_a03",
                                                    initValue: _qInfo.i03_ai_a03.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i03_ai_a03_attach = attach;
                                                      _qInfo.i03_ai_a03 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 04. [i04_ai_a04] 4. 반려동물이 현재 임신중 또는 수유기 인가요?
                                                  QSelRadioCard(
                                                    title: const ["n4. 반려동물이 현재 ",
                                                      "b임신중", "n 또는 ","b수유기","n인가요?"],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    isUseCode:false,
                                                    aList: QItem.fromMenuList(AA4.toList()),
                                                    tag:"i04_ai_a04",
                                                    initValue: _qInfo.i04_ai_a04.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i04_ai_a04_attach = attach;
                                                      _qInfo.i04_ai_a04 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    btnText: '다음 단계로',
                                                    validText:_missQuestion,
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),
                                                  const SizedBox(height:100),
                                                ],),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP4_EAT:       // 식이습관
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text("평소의 식습관이 모발 내 영양소 "
                                                      "형성에 영향을 끼친다는 것, "
                                                      "알고 계셨나요?",
                                                      style:TextStyle(fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)
                                                  ),
                                                  const SizedBox(height:20),

                                                  // 05. [i05_eh_a01, i05_eh_a01_attach ]
                                                  // 5. 최근에 급여하고 있는 사료의 제형 을 알려주세요.(건사료)
                                                  QSelCheckCard(
                                                    title: const ["n5. 최근에 급여하고 있는 ",
                                                      "b사료의 제형",
                                                      "n을 알려주세요."],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:false,
                                                    aList: _qMenu.co_q05,
                                                    tag:"i05_eh_a01",
                                                    initValue: _qInfo.i05_eh_a01.toString(),
                                                    attach: true,
                                                    attachList: [
                                                      ItemAttach(
                                                          tag:"1",
                                                          title: ["n5-1. ",
                                                            "b사료의 제형",
                                                            "n을 사진으로 찍어서 보내주세요."],
                                                          subTitle: "",
                                                          label: "",
                                                          url: _qInfo.i05_eh_a01_attach,
                                                          type:"P"
                                                      ),],
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String value, String attach) {
                                                      _qInfo.i05_eh_a01 = value;
                                                      if(tag=="1") {
                                                        _qInfo
                                                            .i05_eh_a01_attach =
                                                            attach;
                                                      }

                                                       setState(() {
                                                        _checkValidate();
                                                       });
                                                    },
                                                  ),

                                                  // 06. [i06_eh_a02,
                                                  // i06_eh_a02_attach, i06_eh_a022_attach]
                                                  // 5-2. 사료명, 사진(2).
                                                  QFormCard(
                                                      title: const ["n5-2. 최근에 급여하고 있는 ",
                                                        "b사료의 이름을 전체 이름으로 적어주세요."],
                                                      subTitle: "가장 중요한 부분이므로 반드시 "
                                                          "자세하게 적어주셔야합니다.",
                                                      keyboardType:
                                                      TextInputType.text,
                                                      initValue: _qInfo.i06_eh_a02.toString(),
                                                      tag: "i06_eh_a02",
                                                      hint: "사료의 이름",
                                                      useSelect: true,
                                                      selKind:"사료이름",
                                                      allowTap: false,
                                                      attach:true,
                                                      attachList: [
                                                        ItemAttach(
                                                          tag:"1",
                                                          title: [
                                                            "n5-3. 최근 급여하고 있는 ",
                                                            "b사료의 사진",
                                                            "n을 등록해주세요. (제품 이미지 캡쳐 가능)"
                                                          ],
                                                          subTitle: "*사료 봉지 앞면과 뒷면을 "
                                                              "찍어서 올려주세요. (성분표시/함량/내용이 적혀있는 부분이 보이도록)",
                                                          label: "앞면",
                                                          url: _qInfo.i06_eh_a02_attach,
                                                          type:"P"
                                                        ),
                                                        ItemAttach(
                                                            tag:"2",
                                                            title: [],
                                                            subTitle: "",
                                                            label: "뒷면",
                                                            url: _qInfo.i06_eh_a022_attach,
                                                            type:"P"
                                                        )
                                                      ],
                                                      onChanged:(String tag, String value, String attach) {
                                                        _qInfo.i06_eh_a02 = value;
                                                        if(tag=="1") {
                                                          _qInfo
                                                              .i06_eh_a02_attach =
                                                              attach;
                                                        }
                                                        if(tag=="2") {
                                                          _qInfo
                                                              .i06_eh_a022_attach =
                                                              attach;
                                                        }
                                                        setState(() {
                                                         _checkValidate();
                                                        });
                                                      }),

                                                  // 07. [i07_eh_a03] 5-4.사료성분.
                                                  QSelCheckCard(
                                                    title: const ["n5-4. 사료에서 ",
                                                      "b가장 큰 비율",
                                                      "n을 차지하고 있는 ",
                                                      "b단백질원","n은 무엇인가요?"],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:false,
                                                    aList: _qMenu.co_q07,
                                                    tag:"i07_eh_a03",
                                                    initValue: _qInfo.i07_eh_a03.toString(),
                                                    attach: false,
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String value, String attach) {
                                                      //_qInfo.i07_eh_a03_attach = attach;
                                                      _qInfo.i07_eh_a03 = value;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 08. [i08_eh_a04]
                                                  // 5-5. 가수분해 사료 급여 여부.
                                                  QSelRadioCard(
                                                    isVertical: true,
                                                    title: const ["n5-5. ",
                                                      "b가수분해 사료",
                                                      "n 급여 여부를 확인해주세요."],
                                                    subTitle: "",
                                                    aList: _qMenu.co_q5_5,
                                                    isUseCode:false,
                                                    tag:"i08_eh_a04",
                                                    initValue: _qInfo.i08_eh_a04.toString(),
                                                    attach: false,
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i08_eh_a04 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 09. [i09_eh_a05, i09_eh_a05_attach]
                                                  // 6. 간식의 제형
                                                  QSelCheckCard(
                                                    title: const ["n6. 자주 급여하는 ",
                                                      "b간식의 제형","n을 알려주세요."],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:true,
                                                    aList: _qMenu.co_treat,
                                                    tag:"i09_eh_a05",
                                                    initValue: _qInfo.i09_eh_a05.toString(),
                                                    attach: true,
                                                    attachList: [
                                                      ItemAttach(
                                                          tag:"1",
                                                          title: ["n6-1. 급여하는 ",
                                                            "b간식 사진",
                                                            "n을 등록해주세요."],
                                                          subTitle: "* 성분표시/함량/내용이 적혀있는 부분이 보이도록 촬영해주세요.",
                                                          label: "",
                                                          url: _qInfo.i09_eh_a05_attach,
                                                          type:"P"
                                                      ),],
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String value, String attach) {
                                                      _qInfo.i09_eh_a05 = value;
                                                      if(tag=="1") {
                                                        _qInfo
                                                            .i09_eh_a05_attach =
                                                            attach;
                                                      }

                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 10. [i10_ls_a01]. 7. 펫 정수기 사용여부
                                                  QSelRadioCard(
                                                    isVertical: true,
                                                    title: const [
                                                      "n7. ",
                                                      "b펫 정수기 사용여부",
                                                      "n를 알려주세요."
                                                    ],
                                                    subTitle: "",
                                                    aList: _qMenu.co_q7,
                                                    isUseCode:false,
                                                    tag:"i10_ls_a01",
                                                    initValue: _qInfo.i10_ls_a01.toString(),
                                                    attach: false,
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i10_ls_a01 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 11. [i11_ls_a02, i11_ls_a02_attach]. 8. 하루 소변 횟수
                                                  QSelRadioCard(
                                                    title: const [
                                                      "n8. 하루에 ",
                                                      "b소변",
                                                      "n을 얼마나 자주 보나요?"
                                                    ],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_defecation1,
                                                    isUseCode:true,
                                                    attach: true,
                                                    attachList: [
                                                      ItemAttach(
                                                          tag:"1",
                                                          title: ["n8-1. ",
                                                            "b소변상태 사진",
                                                            "n을 등록해주세요."],
                                                          subTitle: "",
                                                          label: "",
                                                          url: _qInfo.i11_ls_a02_attach,
                                                          type:"P"
                                                      ),],
                                                    tag:"i11_ls_a02",
                                                    initValue: _qInfo.i11_ls_a02.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i11_ls_a02 = answerText;
                                                      if(tag=="1") {
                                                        _qInfo
                                                            .i11_ls_a02_attach =
                                                            attach;
                                                      }

                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 12. [i12_ls_a03, i12_ls_a03_attach].
                                                  // 9. 하루 대변 횟수
                                                  QSelRadioCard(
                                                    title: const [
                                                      "n9. 하루에 ",
                                                      "b대변",
                                                      "n을 얼마나 자주 보나요?"
                                                    ],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_defecation2,
                                                    isUseCode:true,
                                                    attach: true,
                                                    attachList: [
                                                      ItemAttach(
                                                          tag:"1",
                                                          title: ["n9-1. ",
                                                            "b대변상태 사진",
                                                            "n을 등록해주세요."],
                                                          subTitle: "",
                                                          label: "",
                                                          url: _qInfo.i12_ls_a03_attach,
                                                          type:"P"
                                                      ),],
                                                    tag:"i12_ls_a03",
                                                    initValue: _qInfo.i12_ls_a03.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i12_ls_a03 = answerText;
                                                      if(tag=="1") {
                                                        _qInfo
                                                            .i12_ls_a03_attach =
                                                            attach;
                                                      }

                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    btnText: '다음 단계로',
                                                    validText:_missQuestion,
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),
                                                  const SizedBox(height:100),
                                                ],),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP6_LIFE:      // 생활습관
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text("* 최근에 복용하거나 피부에 발랐던 약 성분이 "
                                                      "모발에 스며들 수도 있어요.",
                                                      style:const TextStyle(
                                                          fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)),
                                                  const SizedBox(height:20),

                                                  // 13. [i13_ls_a04]
                                                  // 10. 최근에 병원 방문...
                                                  QSelRadioCard(title: const [
                                                    "n10. 최근 ",
                                                    "b병원을 방문 한적",
                                                    "n이 있나요?"],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_q10,
                                                    isUseCode:false,
                                                    tag:"i13_ls_a04",
                                                    initValue: _qInfo.i13_ls_a04.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i13_ls_a04_attach = attach;
                                                      _qInfo.i13_ls_a04 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 14. [i14_ls_a05, i14_ls_a05_attach]
                                                  // 10-1. 최근 진단 받거나
                                                  QSelCheckCard(
                                                    title: const ["n10-1. 최근 진단 받거나 ",
                                                      "b현재 앓고있는 질환",
                                                      "n이 있나요?"],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:true,
                                                    aList: _qMenu.co_disease,
                                                    tag:"i14_ls_a05",
                                                    initValue: _qInfo.i14_ls_a05.toString(),
                                                    attach: true,
                                                    attachList: [
                                                      ItemAttach(
                                                          tag:"1",
                                                          title: ["n10-2. 최근 진단 받거나 ",
                                                            "b현재 앓고있는 질환",
                                                            "n상태 사진을 등록해주세요."],
                                                          subTitle: "( 눈물사진, x-ray사진, 초음파 사진, CT사진, MRI사진, 혈액검사 사진 등 ... )",
                                                          label: "",
                                                          url: _qInfo.i14_ls_a05_attach,
                                                          type:"P"
                                                      ),],
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String value, String attach) {
                                                      _qInfo.i14_ls_a05 = value;
                                                      if(tag=="1") {
                                                        _qInfo
                                                            .i14_ls_a05_attach =
                                                            attach;
                                                      }

                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 15. [i15_ls_a06]
                                                  // 10-3. 3달 이내에 처방받은 약
                                                  QSelCheckCard(
                                                    title: const ["n10-3. 3달 이내에 ",
                                                      "b처방 받은 약",
                                                      "n이 있으면 알려주세요."],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:false,
                                                    aList: _qMenu.co_q10_3,
                                                    tag:"i15_ls_a06",
                                                    initValue: _qInfo.i15_ls_a06.toString(),
                                                    attach: false,
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String value, String attach) {
                                                      _qInfo.i15_ls_a06 = value;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 16. [i16_hi_a01, i05_eh_a01_attach]
                                                  // 10-4. 3달 이내에 급여한 영양제
                                                  QSelCheckCard(
                                                    title: const ["n10-4. 3달 이내에 급여한 ",
                                                      "b영양제",
                                                      "n가 있으면 알려주세요."],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:false,
                                                    aList: _qMenu.co_q10_4,
                                                    tag:"i16_hi_a01",
                                                    initValue: _qInfo.i16_hi_a01.toString(),
                                                    attach: true,
                                                    attachList: [
                                                      ItemAttach(
                                                          tag:"1",
                                                          title: ["n10-5. 3달 이내에 급여한 ",
                                                            "b약 또는 영양제",
                                                            "n 사진을 등록해 주세요."],
                                                          subTitle: "",
                                                          label: "",
                                                          url: _qInfo.i16_hi_a01_attach,
                                                          type:"P"
                                                      ),],
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String value, String attach) {
                                                      _qInfo.i16_hi_a01 = value;
                                                      if(tag=="1") {
                                                        _qInfo.i16_hi_a01_attach = attach;
                                                      }
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 17. [i17_hi_a02] 10-6. 질병 예방을 위해
                                                  QSelCheckCard(
                                                    title: const ["n10-6. 질병 예방을 위해 가장 중요하게 생각하는 ",
                                                      "b건강관리",
                                                      "n를 골라주세요."],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:true,
                                                    aList: _qMenu.co_prevention,
                                                    tag:"i17_hi_a02",
                                                    initValue: _qInfo.i17_hi_a02.toString(),
                                                    attach: false,
                                                    users_id: widget.users_id,
                                                    onSubmit: (String tag, String value, String attach) {
                                                      _qInfo.i17_hi_a02 = value;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    validText:_missQuestion,
                                                    btnText: '다음 단계로',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),

                                                  const SizedBox(height:100),
                                                ],),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP5_HEALTH:    // 건강정보
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                  const Text("* 더 자세하고 믿을 수 있는 검사 결과를 드리기 위해 "
                                                      "추가적인 생활 정보를 수집합니다.",
                                                      style:const TextStyle(fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)),
                                                  const SizedBox(height:20),

                                                  // 18. [i18_hi_a03]
                                                  // 11. 반려동물이 하루 중 혼자 있는
                                                  QSelRadioCard(title: const ["n11. 반려동물이 하루 중 ",
                                                    "b혼자 있는 시간",
                                                    "n이 얼마나 되나요?"],
                                                    subTitle: "", isVertical: true,
                                                    aList: _qMenu.co_environment_part21,
                                                    isUseCode:true,
                                                    tag:"i18_hi_a03",
                                                    initValue: _qInfo.i18_hi_a03.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i18_hi_a03 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 19. [i19_ad_a01] 12. 집이나 밖에서 다른 사람이 피우는
                                                  QSelRadioCard(title: const ["n12. 집이나 밖에서 ",
                                                    "b담배 연기에 주기적으로 노출",
                                                    "n이 되고 있나요?"],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_environment_part22,//QItem.fromMenuList(AL6.toList()),
                                                    isUseCode:true,
                                                    tag:"i19_ad_a01",
                                                    initValue: _qInfo.i19_ad_a01.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i15_ls_a06_attach = attach;
                                                      _qInfo.i19_ad_a01 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 20. [i20_ad_a02]
                                                  // 13. 최근 전체 목욕을 시킨 날짜
                                                  QSelRadioCard(title: const [
                                                    "n13. 최근 ",
                                                    "b전체 목욕", "n을 시킨 날짜를 알려주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_q13,
                                                    isUseCode:false,
                                                    tag:"i20_ad_a02",
                                                    initValue: _qInfo.i20_ad_a02.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i20_ad_a02_attach = attach;
                                                      _qInfo.i20_ad_a02 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 21. [i21_ad_a03] 14. 최근 미용한 시기
                                                  QSelRadioCard(title: const [
                                                    "n14. 최근 ",
                                                    "b미용한 시기",
                                                    "n가 언제인가요?"],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_q14,
                                                    isUseCode:false,
                                                    tag:"i21_ad_a03",
                                                    initValue: _qInfo.i21_ad_a03.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i21_ad_a03_attach = attach;
                                                      _qInfo.i21_ad_a03 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 22. [i22_ad_a04] 15. 하루 산책 횟수
                                                  QSelRadioCard(title: const [
                                                    "n15. ",
                                                    "b하루 산책 횟수",
                                                    "n를 알려주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_environment_part13,
                                                    isUseCode:true,
                                                    tag:"i22_ad_a04",
                                                    initValue: _qInfo.i22_ad_a04.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i22_ad_a04_attach = attach;
                                                      _qInfo.i22_ad_a04 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 22. [i22_ad_a04] 15-1. 주간 산책 횟수
                                                  QSelRadioCard(title: const [
                                                    "n15-1. ",
                                                    "b주간 산책 횟수",
                                                    "n를 알려주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_environment_part13,
                                                    isUseCode:true,
                                                    tag:"i38_ex_a08",
                                                    initValue: _qInfo.i38_ex_a08.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i38_ex_a08 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    validText:_missQuestion,
                                                    btnText: '다음 단계로',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),

                                                  const SizedBox(height:100),
                                                ],),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP7_ACTION:    // 행동정의 (3)
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text("* 반려동물의 건강 상태를 투영하는 "
                                                      "행동 습관들도 함께 정리해볼게요.",
                                                      style:const TextStyle(
                                                          fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)),
                                                  const SizedBox(height:20),

                                                  // 23. [i23_ad_a05] 16. 장난감을 가지고 놀 때 습관
                                                  QSelRadioCard(title: const [
                                                    "n16. 장난감을 가지고 놀 때의",
                                                    "b습관",
                                                    "n를 알려주세요."],
                                                    subTitle: "", 
                                                    isVertical: true,
                                                    aList: _qMenu.co_environment_part23,
                                                    isUseCode:true,
                                                    tag:"i23_ad_a05",
                                                    initValue: _qInfo.i23_ad_a05.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i23_ad_a05_attach = attach;
                                                      _qInfo.i23_ad_a05 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 24. [i24_ad_a06]
                                                  // 17. 평소의 반려동물의 생활 습관
                                                  QSelCheckCard(title: const [
                                                    "n17. 평소의 반려동물의 ",
                                                    "b생활 습관","n을 알려주세요."],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:true,
                                                    aList: _qMenu.co_q17_behavior1,

                                                    tag:"i24_ad_a06",
                                                    initValue: _qInfo.i24_ad_a06.toString(),
                                                    onSubmit: (String tag, String value, String attach) {
                                                      //_qInfo.i24_ad_a06_attach = attach;
                                                      _qInfo.i24_ad_a06 = value;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 25. [i25_ad_a07]
                                                  // 18. 반려동물에게서 자주 보이는 모습
                                                  QSelCheckCard(title: const [
                                                    "n18. 반려동물에게서 ",
                                                    "b자주 보이는 모습","n을 알려주세요."
                                                  ],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:true,
                                                    aList: _qMenu.co_q18_behavior2,

                                                    tag:"i25_ad_a07",
                                                    initValue: _qInfo.i25_ad_a07.toString(),
                                                    onSubmit: (String tag, String value, String attach) {
                                                      //_qInfo.i25_ad_a07_attach = attach;
                                                      _qInfo.i25_ad_a07 = value;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 26. [i26_md_a01] 19. 반려동물 켄넬 및 하우스 사용
                                                  QSelCheckCard(title: const [
                                                    "n19. 반려동물 ",
                                                    "b켄넬 및 하우스 사용 가능 여부",
                                                    "n을 알려주세요."],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:true,
                                                    aList: _qMenu.co_q19_environment_part24,
                                                    /*
                                                    Item.fromMenuList(const [
                                                      "하우스 교육이 되어 있음",
                                                      "하우스를 한번도 사용해본적이 없음",
                                                      "하우스를 불쌍하게 생각해서 사용하지 않음",
                                                      "잘 때는 꼭 켄넬 및 하우스에 들어가서 잠"
                                                    ]),

                                                     */
                                                    tag:"i26_md_a01",
                                                    initValue: _qInfo.i26_md_a01.toString(),
                                                    onSubmit: (String tag, String value, String attach) {
                                                      //_qInfo.i26_md_a01_attach = attach;
                                                      _qInfo.i26_md_a01 = value;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 27. [i27_md_a02] 20. 다른사람 혹은 강아지의 사회성
                                                  QSelRadioCard(title: const [
                                                    "n20. 다른 사람 혹은 강아지의 ",
                                                    "b사회성 정도", "n를 선택해주세요."],
                                                    subTitle: "수치설명("
                                                        "1:사회성이 매우 떨어짐, "
                                                        "10:매우 사회성이 좋음)",
                                                    isVertical: true,
                                                    aList: _qMenu.co_q20,
                                                    isUseCode:true,
                                                    tag:"i27_md_a02",
                                                    initValue: _qInfo.i27_md_a02.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i27_md_a02_attach = attach;
                                                      _qInfo.i27_md_a02 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  QSelRadioCard(
                                                    title: const [
                                                    "n20-1. 반려 동물의 보호자 ",
                                                    "b의존 정도", "n를 선택해주세요."],
                                                    subTitle: "수치설명("
                                                        "1:의존성이 매우 낮음, "
                                                        "10:매우 의존성이 매우 높음)",
                                                    isVertical: true,
                                                    aList: _qMenu.co_behavior_step4,
                                                    isUseCode:true,
                                                    tag:"i27_md_a02",
                                                    initValue: _qInfo.i37_ex_a08.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i27_md_a02_attach = attach;
                                                      _qInfo.i37_ex_a08 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    validText:_missQuestion,
                                                    btnText: '다음 단계로',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),

                                                  const SizedBox(height:100),
                                                ],),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP8_ADD:       // 구글쉬트
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text("* 마지막 항목입니다. 반려동물의 이벤트 관련 사항 "
                                                      "및 궁금한 사항을 등록해주세요.",
                                                      style:const TextStyle(
                                                          fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)
                                                  ),
                                                  const SizedBox(height:20),

                                                  // 28. [i28_md_a03]
                                                  // 21. 반려동물의 유치원 등원
                                                  QSelRadioCard(title: const [
                                                    "n21. 반려동물 ",
                                                    "b유치원 등원",
                                                    "n여부를 알려주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_q21,
                                                    isUseCode:false,
                                                    tag:"i28_md_a03",
                                                    initValue: _qInfo.i28_md_a03.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      //_qInfo.i28_md_a03_attach = attach;
                                                      _qInfo.i28_md_a03 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 29. [i29_ex_a01]
                                                  // 22. 반려동물의 하루 일과를 알려주세요.
                                                  QFormCard(
                                                      maxLines: 5,
                                                      title: const ["n22. 반려동물의 ",
                                                        "b하루 일과",
                                                        "n를 알려주세요."],
                                                      subTitle: "예시)유치원 등원 9시~17시, 오전 산책 1시간, "
                                                          "오후 산책 1시간, 터그 놀이 30분 등, "
                                                          "보호자와 떨어져 있는 시간 6시간 켄넬에 있음 등.",
                                                      keyboardType:
                                                      TextInputType.text,
                                                      initValue: _qInfo.i29_ex_a01.toString(),
                                                      tag: "i29_ex_a01",
                                                      hint: "반려동물 하루 일과 입력",
                                                      useSelect: false,
                                                      selKind: "",
                                                      attach:false,
                                                      onChanged:(String tag, String value, String attach) {
                                                        _qInfo.i29_ex_a01 = value;
                                                        setState(() {
                                                          _checkValidate();
                                                        });
                                                      }),

                                                  // 30. [i30_ex_a02] 23. 반려동물의 최근 이벤트
                                                  QSelCheckCard(title: const [
                                                    "n23. 반려동물의 ",
                                                    "b최근 이벤트(3개월 이내)",
                                                    "n를 알려주세요."
                                                  ],
                                                    subTitle: "",
                                                    isMulti: true,
                                                    isUseCode:true,
                                                    aList: _qMenu.co_behavior3,
                                                    tag:"i30_ex_a02",
                                                    initValue: _qInfo.i30_ex_a02.toString(),
                                                    onSubmit: (String tag, String value, String attach) {
                                                      //_qInfo.i30_ex_a02_attach = attach;
                                                      _qInfo.i30_ex_a02 = value;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 31. [i31_ex_a03, i31_ex_a03_attach]
                                                  // 24. 반려동물의 행동 문제를 적어주세요.
                                                  QFormCard(
                                                      maxLines: 5,
                                                      title: const ["n24. 반려동물의 ",
                                                        "b행동 문제",
                                                        "n를 적어주세요."],
                                                      subTitle: "반려동물의 교육이 필요한 부분 혹은 행동문제가 있다면 "
                                                          "최대한 자세하게 적어주세요",
                                                      keyboardType:
                                                      TextInputType.text,
                                                      initValue: _qInfo.i31_ex_a03.toString(),
                                                      tag: "i31_ex_a03",
                                                      hint: "반려동물 행동문제 입력",
                                                      useSelect: false,
                                                      selKind: "",
                                                      attach:true,
                                                      attachList: [
                                                        ItemAttach(
                                                            tag:"1",
                                                            title: ["n24-1. 반려동물의 ",
                                                              "b행동 문제를 동영상","n으로 업로드해주세요."],
                                                            subTitle: "*동영상은 휴대폰에서 "
                                                                "촬영하는 파일(*.mp4)만 지원하며. "
                                                                "최대 용량은 20MB로 제한됩니다.",
                                                            label: "",
                                                            url: _qInfo.i31_ex_a03_attach,
                                                            type:"V"
                                                        ),],
                                                      onChanged:(String tag, String value, String attach) {
                                                        _qInfo.i31_ex_a03 = value;
                                                        if(tag=="1") {
                                                          _qInfo.i31_ex_a03_attach = attach;
                                                        }
                                                        setState(() {
                                                          _checkValidate();
                                                        });
                                                      }),


                                                  // 34. [i34_ex_a06]
                                                  // 24-2. 반려동물의 공격성
                                                  QSelRadioCard(title: const [
                                                    "n24-2. 반려동물의 ",
                                                    "b공격성 정도",
                                                    "n를 선택해주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_behavior_step1,
                                                    isUseCode:true,
                                                    tag:"i34_ex_a06",
                                                    initValue: _qInfo.i34_ex_a06.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i34_ex_a06 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 35. [i35_ex_a06]
                                                  // 24-3. 반려동물의 짖음 정도
                                                  QSelRadioCard(title: const [
                                                    "n24-3. 반려동물의 ",
                                                    "b짖음 정도",
                                                    "n를 선택해주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_behavior_step2,
                                                    isUseCode:true,
                                                    tag:"i35_ex_a06",
                                                    initValue: _qInfo.i35_ex_a06.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i35_ex_a06 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 36. [i36_ex_a07]
                                                  // 24-4. 반려동물의 분리불안 행동
                                                  QSelRadioCard(title: const [
                                                    "n24-4. 반려동물의 ",
                                                    "b불리불안 행동",
                                                    "n을 선택해주세요."],
                                                    subTitle: "",
                                                    isVertical: true,
                                                    aList: _qMenu.co_behavior_step3,
                                                    isUseCode:true,
                                                    tag:"i36_ex_a07",
                                                    initValue: _qInfo.i36_ex_a07.toString(),
                                                    onSubmit: (String tag, String answerText, String attach) {
                                                      _qInfo.i36_ex_a07 = answerText;
                                                      setState(() {
                                                        _checkValidate();
                                                      });
                                                    },
                                                  ),

                                                  // 32. [i32_ex_a04] 25. 반려동물 관련해서 궁금한 사항 아무거나.
                                                  QFormCard(
                                                      maxLines: 5,
                                                      title: const ["n25. 반려동물과 관련해서 ",
                                                        "b궁금한 사항 아무거나 ",
                                                        "n적어주세요. 상담해드립니다."],
                                                      subTitle: "예시) 눈물이 왜 이렇게 많이 날까요?"
                                                          "/초인종만 울리면 너무 짖어요"
                                                          "/우리 애는 너무 무서워해요 등...",
                                                      keyboardType:
                                                      TextInputType.text,
                                                      initValue: _qInfo.i32_ex_a04.toString(),
                                                      tag: "i32_ex_a04",
                                                      hint: "문의 내용...",
                                                      useSelect: false,
                                                      selKind: "",
                                                      attach:false,
                                                      onChanged:(String tag, String value, String attach) {
                                                        _qInfo.i32_ex_a04 = value;
                                                        setState(() {
                                                          _checkValidate();
                                                        });
                                                      }),

                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    validText:_missQuestion,
                                                    btnText: '설문조사 완료',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),

                                                  const SizedBox(height:100),
                                                ],),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP9_QFINISH:   // 설문완료.
                                  return Stack(
                                    children: [
                                      Positioned(
                                          top:0,
                                          //width: MediaQuery.of(context).size.width,
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text("설문완료!",
                                                      style:TextStyle(
                                                          fontSize:24.0,
                                                          fontWeight:FontWeight.bold,
                                                          color:Colors.black)
                                                  ),
                                                  const SizedBox(height:10),
                                                  const Text("다음 검사단계로 진행합니다.",
                                                      style:TextStyle(
                                                          fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)
                                                  ),
                                                  const SizedBox(height:100),
                                                  Center(
                                                    child: Container(
                                                        padding: const EdgeInsets.all(10),
                                                        width:MediaQuery.of(context).size.width*0.7,
                                                        child:Image.asset("assets/images/q_complete.png")
                                                    ),
                                                  ) ,
                                                  const SizedBox(height:50),

                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    btnText: '모발채취 시작하기',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),

                                                  const SizedBox(height:100),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP10_KIT_GUIDE: // 키트 사용안내
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: Text("이제 반려동물의\n모발을 채취해주세요.",
                                                        textAlign: TextAlign.start,
                                                        style:TextStyle(
                                                            fontSize:24.0,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:50),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("모발 채취 방법",
                                                        textAlign: TextAlign.center,
                                                        style:const TextStyle(
                                                            fontSize:20.0,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:20),
                                                  Container(
                                                      width:MediaQuery.of(context).size.width-50,
                                                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                                                      color: Colors.grey.shade200,
                                                      child:Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: const [
                                                          SizedBox(
                                                            width: 1000,
                                                            child: Text("Tip",
                                                                textAlign:
                                                                TextAlign.center,
                                                                style:TextStyle(
                                                                    fontSize:20.0,
                                                                    fontWeight:FontWeight.bold,
                                                                    color:Colors.black)
                                                            ),
                                                          ),
                                                          SizedBox(height:20),
                                                          Text("* 피모가 짧거나 채취가 어려운 반려동물의 경우 "
                                                              "솔질 시에 "
                                                              "빠진 피모도 괜찮습니다.",
                                                              style:TextStyle(
                                                                  fontSize:16.0,
                                                                  fontWeight:FontWeight.normal,
                                                                  color:Colors.black)
                                                          ),
                                                          SizedBox(height:10),
                                                          Text("* 여러 마리의 반려동물을 키우는 경우 "
                                                              "다른 반려동물의 "
                                                              "모발과 섞이지 않게 주의해 주세요.",
                                                              style:TextStyle(
                                                                  fontSize:16.0,
                                                                  fontWeight:FontWeight.normal,
                                                                  color:Colors.black)
                                                          ),
                                                          SizedBox(height:10),
                                                          Text("* 염색 모발의 경우 일부 미네랄이 실제보다 결과값이 "
                                                              "높게 나올 수 있으므로 검사시 주의하셔야 합니다.",
                                                              style:TextStyle(
                                                                  fontSize:16.0,
                                                                  fontWeight:FontWeight.normal,
                                                                  color:Colors.black)
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                  const SizedBox(height:50),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("1. 채취준비",
                                                        textAlign: TextAlign.center,
                                                        style:TextStyle(
                                                            fontSize:20.0,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:30),
                                                  Center(
                                                    child: Container(
                                                        width:MediaQuery.of(context).size.width*0.7,
                                                        padding: const EdgeInsets.all(10),
                                                        child:Image.asset("assets/images/q_pre01.png")
                                                    ),
                                                  ),
                                                  const SizedBox(height:80),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("2. 채취하기",
                                                        textAlign: TextAlign.center,
                                                        style:TextStyle(
                                                            fontSize:20.0,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:30),
                                                  Center(
                                                    child: Container(
                                                        width:MediaQuery.of(context).size.width*0.7,
                                                        padding: const EdgeInsets.all(20),
                                                        child:Image.asset("assets/images/q_pre02.png")
                                                    ),
                                                  ),
                                                  const SizedBox(height:30),
                                                  // 2. 채취하기 설명.
                                                  const Text("피부에 가까운 3~4cm의 모발을 잘라 사용합니다.",
                                                      style:TextStyle(
                                                          fontSize:16.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)
                                                  ),
                                                  const SizedBox(height:10),
                                                  Container(
                                                      width:MediaQuery.of(context).size.width-50,
                                                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                                                      color: Colors.grey.shade200,
                                                      child:Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: const [
                                                          Text("* 피모가 짧거나 채취가 어려운 반려동물의 경우 "
                                                              "솔질 시에 "
                                                              "빠진 피모도 괜찮습니다.",
                                                              style:TextStyle(
                                                                  fontSize:16.0,
                                                                  fontWeight:FontWeight.normal,
                                                                  color:Colors.black)
                                                          ),
                                                          SizedBox(height:10),
                                                          Text("* 여러 마리의 반려동물을 키우는 경우 다른 반려동물의 "
                                                              "모발과 섞이지 않게 주의해 주세요.",
                                                              style:TextStyle(
                                                                  fontSize:16.0,
                                                                  fontWeight:FontWeight.normal,
                                                                  color:Colors.black)
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                  const SizedBox(height:80),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("3. 무게측정",
                                                        textAlign: TextAlign.center,
                                                        style:const TextStyle(
                                                            fontSize:20.0,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:30),
                                                  Center(
                                                    child: Container(
                                                        width:MediaQuery.of(context).size.width*0.6,
                                                        padding: const EdgeInsets.all(10),
                                                        child:Image.asset("assets/images/q_pre03.png")
                                                    ),
                                                  ),
                                                  const SizedBox(height:20),
                                                  // 3. 무게측정 설명.
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("채취한 모발을 무게 측정 저울의 "
                                                        "모발 놓는 곳에 올려, "
                                                        "저울이(모발 쪽으로) 완전히 기울어질 때 까지 "
                                                        "모발을 추가합니다.",
                                                        textAlign: TextAlign.start,
                                                        style:TextStyle(
                                                            fontSize:16.0,
                                                            fontWeight:FontWeight.normal,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:80),
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("4. 정보기재",
                                                        textAlign: TextAlign.center,
                                                        style:TextStyle(
                                                            fontSize:20.0,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:30),
                                                  Center(
                                                    child: Container(
                                                        width:MediaQuery.of(context).size.width*0.7,
                                                        padding: const EdgeInsets.all(10),
                                                        child:Image.asset("assets/images/q_pre04.png")
                                                    ),
                                                  ),
                                                  const SizedBox(height:20),
                                                  // 3. 정보기재 설명.
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: Text("모발 채취 박스에 정보를 정확히 기재한 다음 무게를 "
                                                        "측정한 모발을 담아 밀봉합니다.",
                                                        textAlign: TextAlign.start,
                                                        style:TextStyle(
                                                            fontSize:16.0,
                                                            fontWeight:FontWeight.normal,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:50),

                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    btnText: '키트번호 등록하기',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),

                                                  const SizedBox(height:100),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                case STEP11_KIT_REGIST: // 키트번호 입력 및 전송
                                  return Stack(
                                    children: [
                                      Positioned(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text("키트를 등록해주세요.",
                                                      style:const TextStyle(
                                                          fontSize:24.0,
                                                          fontWeight:FontWeight.bold,
                                                          color:Colors.black)
                                                  ),
                                                  const SizedBox(height:10),
                                                  const Text("모발 채취 봉투 스티커에 위치한 7자리 고유 "
                                                      "식별자 코드를 정확하게 입력해주세요.",
                                                      style:const TextStyle(
                                                          fontSize:14.0,
                                                          fontWeight:FontWeight.normal,
                                                          color:Colors.black)
                                                  ),
                                                  const SizedBox(height:50),
                                                  Padding(
                                                     padding: const EdgeInsets.symmetric(horizontal: 15),
                                                    child: TextField(
                                                        controller: _kitNoController,
                                                        maxLength: 7,
                                                        textInputAction: TextInputAction.done,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 44,
                                                            fontWeight: FontWeight.bold),
                                                        onChanged: (String value) {
                                                          setState(() {
                                                            _qInfo.kit_number = value;
                                                            _checkValidate();
                                                          });
                                                        },
                                                        decoration: InputDecoration(
                                                          border: const OutlineInputBorder(),
                                                          labelText: '',
                                                          hintText: '식별코드 7자리',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey[300]),
                                                        ),
                                                      ),
                                                  ),
                                                  const SizedBox(height:80),
                                                  Center(
                                                    child: Container(
                                                        width:MediaQuery.of(context).size.width*0.6,
                                                        padding: const EdgeInsets.all(10),
                                                        child:Image.asset("assets/images/q_pre05.png")
                                                    ),
                                                  ),
                                                  const SizedBox(height:20),
                                                  // 3. 인증코드 설명.
                                                  const SizedBox(
                                                    width: 1000,
                                                    child: const Text("인증코드는 튜브에 붙어있어요.",
                                                        textAlign: TextAlign.center,
                                                        style:const TextStyle(
                                                            fontSize:14.0,
                                                            fontWeight:FontWeight.normal,
                                                            color:Colors.black)
                                                    ),
                                                  ),
                                                  const SizedBox(height:50),
                                                  CardQButton(
                                                    enable:visible[curr_page_index],
                                                    btnText: '검사 요청하기',
                                                    onClick: () {
                                                      _nextPage();
                                                    },
                                                  ),

                                                  const SizedBox(height:100),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  );
                                default:
                                  return Container();
                              }
                            }
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateAnimalInfo() {
    _qInfo.animals_id  = widget.animal.id!;
    _qInfo.a_name      = widget.animal.name!;
    _qInfo.a_sex       = widget.animal.sex!;
    _qInfo.a_breed     = widget.animal.breed!;
    _qInfo.a_spayed    = widget.animal.spayed!;
    _qInfo.a_birthday  = widget.animal.birthday!;
    _qInfo.a_kind      = widget.animal.kind!;
    _qInfo.a_birthday  = widget.animal.birthday!;
    _qInfo.a_weightn   = widget.animal.weight!;
    _qInfo.a_register_number  = widget.animal.registered_number!;
    //_kitNoController.text     = _qInfo.a_register_number;
    //_qInfo.i01_ai_a01 = widget.animal.body_mass!;
    //_qInfo.i03_ai_a03 = widget.animal.heartworm_vaccination!;
    // 소변횟수
    //_qInfo.i11_ls_a02 = widget.animal.frequency_of_urination!;
    // 배변횟수
    //_qInfo.i12_ls_a03 = widget.animal.frequency_of_defecation!;
    setState(() {
    });
    // _qInfo.i24_ad_a06 = "특이사항 없음";
    // _qInfo.i04_ai_a04 = widget.animal.;
  }

  Future<bool> _onBackPressed(BuildContext context) {
    if(isPageBegin) {
      doConfirmQuit();
    } else {
      _prevPage();
    }

    return Future(() => false);
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();

    if(isPageLast) {
      _doSumit(true);
    } else {
      pageController.animateToPage(pageController.page!.toInt() + 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn
      );
    }
  }

  void _prevPage() {
    FocusScope.of(context).unfocus();
    if(!isPageBegin) {
      pageController.animateToPage(pageController.page!.toInt() - 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn
      );
    }
    else{
      doConfirmQuit();
    }
  }

  Future <void> _reqDeleteQuestion(String id) async {
    await Remote.deleteQuestion(id: id,
        onResponse: (String info) async {

        }
    );
  }

  Future <void> _reqTempData(String users_id, String animal_id) async {
    await Remote.infoTempQuestion(users_id: users_id, animal_id:animal_id,
        onResponse: (Questions? info) async {
          if(info != null) {
            //showToastMessage("작성중인 문진표가 있습니다.");
            showDialogPop(
                context:context,
                title: "확인",
                body:const Text("작성중인 문진표가 있습니다.",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                content:const Text("이어서 문진표를 작성할까요?",
                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),),
                choiceCount:2, yesText: "예", cancelText: "신규작성",
                onResult:(bool isOK) async {
                  if(isOK) {
                    // 이어서 작업;
                    _qInfo = info;
                    pageController.animateToPage(3,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn
                    );
                    setState(() {});
                  } else {
                    // 기존 문진표 삭제
                    await _reqDeleteQuestion(info.id);
                  }
                }
            );
          }
        }
    );
  }

  Future<void> _doSumit(bool isCompleate) async {
    _qInfo.is_complete = (isCompleate) ? "Y" : "N";
    await Remote.reqQuestion(question: _qInfo,
        onResponse: (String add_id) async {
      if(isCompleate) {
        if(_qInfo.i29_ex_a01.isEmpty) {
          _qInfo.i29_ex_a01 = "하루 일과 미입력";
        }
        if(_qInfo.i31_ex_a03.isEmpty) {
          _qInfo.i31_ex_a03 = "행동문제 미입력";
        }
        if(_qInfo.i32_ex_a04.isEmpty) {
          _qInfo.i32_ex_a04 = "상담내용 미입력";
        }

        await Remote.addMessage(users_id: _qInfo.users_id.toString(),
            q_id: add_id,
            a_name: _qInfo.a_name.toString(),
            message: "${_qInfo.a_name}의 모발검사 신청이 접수되었습니다.",
            onResponse: (int result) {
              Navigator.pop(context, true);
              showToastMessage("저장 되었습니다.");
            });
      } else {
        if(_qInfo.id.isEmpty) {
          _qInfo.id = add_id;
        }
        showToastMessage("임시 저장되었습니다.");
      }
    });
  }

  void doConfirmQuit() {
    if(past_page_index>2){
      showDialog3Pop(
          context:context,
          title: "확인",
          body:const Text("검사 신청이 완료되지 않았습니다.\n작성중인 데이터는 임시 보관함에 저장됩니다.",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          content:const Text("작업을 종료하시겠습니까?",
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.black),
          ),
          btn1Text: "그냥 종료", btn2Text: "저장후 종료", btn3Text: "아니오",
          onResult:(int btnIndex) async {
            if(btnIndex==0) {
              if(_qInfo.id.isNotEmpty) {
                await _reqDeleteQuestion(_qInfo.id);
              }
              Navigator.pop(context);
            } else if(btnIndex==1) {
              await _doSumit(false);
              Navigator.pop(context);
            }
          }
        );
    }
    else{
      Navigator.pop(context);
    }
  }
}