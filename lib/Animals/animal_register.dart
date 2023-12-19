
// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:coani/Animals/photo_viewer.dart';
import 'package:coani/Constants/Constants.dart';
import 'package:coani/Constants/HostInfo.dart';
import 'package:coani/Constants/Patterns.dart';
import 'package:coani/Models/Animal.dart';
import 'package:coani/Models/Files.dart';
import 'package:coani/Models/qItem.dart';
import 'package:coani/Provider/TextShare.dart';
import 'package:coani/Questions/QFormCard.dart';
import 'package:coani/Questions/QFormDate.dart';
import 'package:coani/Questions/QSelRadioCard.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:coani/Utils/utils.dart';
//import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

class AnimalRegister extends StatefulWidget {
  final String users_id;
  final String command;
  final Animal animal;
  final bool canDelete;

  const AnimalRegister({Key? key, required this.animal, required this.command,
    required this.users_id, required this.canDelete,}) : super(key: key);

  @override
  _AnimalRegisterState createState() => _AnimalRegisterState();
}

class _AnimalRegisterState extends State<AnimalRegister> {
  bool bDirty = false;
  bool bFlag  = false;
  String a_name="반려동물";
  String diffMessage = "";
  String? imageUrl;
  bool isValidateOK = true;
  bool isPhotoDirty = false;
  bool isAddAction = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      diffMessage = getDayCount(widget.animal.birthday.toString());
      isAddAction = (widget.command=="ADD") ? true : false;
    });
    if (kDebugMode) {
      print("-----> initState()");
    }
  }

  Future<String> fetchData() async {
    if (kDebugMode) {
      print("-----> fetchData()");
    }
    //await Future.delayed(Duration(seconds: 2));
    if(widget.animal.photo_url!.isNotEmpty) {
      imageUrl = "$URL_IMAGE/${widget.animal.photo_url}";
    } else {
      imageUrl = "";
    }

    if (kDebugMode) {
      print("fetchData():imageUrl="+imageUrl.toString());
    }
    return 'OK';
  }

  @override
  Widget build(BuildContext context) {
    final shareText = Provider.of<ShareText>(context);
    return WillPopScope (
        onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppBar_Color,
          elevation: 1.0,
          title:(widget.command=="ADD")
              ? Text("등록하기", style:TextStyle(color:AppBar_Title))
              : Text("정보수정", style:TextStyle(color:AppBar_Title)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppBar_Icon,),
              onPressed: () {
                _goBack();
              }),
        ),
        body: GestureDetector(
            onTap: () { FocusScope.of(context).unfocus();},
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 1. 헤더
                  _BuildHeader(),
                  //const SizedBox(height: 10.0,),
                  // 2. 이름
                  QFormCard(
                      //key:GlobalKey(),
                      title: const ["n반려동물의 ","b이름","n을 입력하세요."], subTitle: "(애칭 또는 별명을 입력하세요.)",
                      keyboardType: TextInputType.text,
                      initValue: widget.animal.name.toString(),
                      tag: "name", hint: "반려동물 이름", useSelect: false, selKind: "",
                      onChanged: (String tag, String value, String attach) {
                        widget.animal.name = value;
                        bDirty = true;
                        //a_name = value;
                        //setState(() {
                          //isValidate[position] = (value.length>0) ? true : false;
                        //});
                        if (kDebugMode) {
                          print(
                            "onSubmit():tag=$tag, value=$value");
                        }
                      }),

                  // 3. 유형(개/고양이)
                  QSelRadioCard(
                    //key:GlobalKey(),
                    title: ["n$a_name의 ","b반려동물 유형","n을 확인해주세요."], subTitle: "", isVertical: false,
                    aList: QItem.fromMenuList(const ["고양이", "강아지"]),
                    isUseCode: false,
                    tag:"kind", initValue: widget.animal.kind.toString(),
                    //attach: true,
                    //attach_url: "",
                    //attach_type: "A",
                    //users_id: widget.users_id,
                    onSubmit: (String tag, String value, String attach) {
                      setState(() {
                        widget.animal.kind = value;
                        bDirty = true;
                        widget.animal.breed = "";
                      });
                    },),
                  // 4. 품종
                  QFormCard(title: ["n$a_name의 ","b품종","n을 확인해 주세요."],
                      //key:GlobalKey(),
                      subTitle: "",
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      initValue: widget.animal.breed.toString(),
                      hint: "품종을 입력하세요.",
                      tag: "breed",
                      useSelect: true, selKind: widget.animal.kind.toString(),
                      edit_unlock: false,
                      onChanged: (String tag, String value, String attach) {
                        widget.animal.breed = value;
                        bDirty = true;
                        shareText.Set("");
                        if (kDebugMode) {
                          print(
                            "onSubmit():tag=$tag, value=$value");
                        }
                      }),
                  // 5. 생년월일
                  QFormDate(
                      title: ["n$a_name의 ","b생년월일","n을 입력해주세요."], subTitle: "",
                      initValue: widget.animal.birthday.toString(),
                      tag: "birthday", hint: "yyyy-mm-dd",
                      onChanged: (String tag, String value) {
                        bDirty = true;
                        widget.animal.birthday = value;
                        setState(() {
                          diffMessage = getDayCount(widget.animal.birthday.toString());
                        });
                      }),
                  // 6. 성별
                  QSelRadioCard(
                    title: ["n$a_name의 ","b성(암.수)","n을 확인해주세요."], subTitle: "", isVertical: false,
                    aList: QItem.fromMenuList(const ["암컷", "수컷"]),
                    isUseCode: false,
                    tag:"sex", initValue: widget.animal.sex.toString(),
                    onSubmit: (String tag, String value, String attach) {
                      widget.animal.sex = value;
                      bDirty = true;
                    },),
                  // 7. 중성화 여부
                  QSelRadioCard(
                    title: ["n$a_name의 ","b중성화","n 여부를 확인해주세요."],
                    subTitle: "", isVertical: false,
                    aList: QItem.fromMenuList(const ["했어요", "아니오"]),
                    isUseCode: false,
                    tag:"spayed",
                    initValue: widget.animal.spayed.toString(),
                    onSubmit: (String tag, String value, String attach) {
                      widget.animal.spayed = value;
                      bDirty = true;
                    },),
                  // 8. 몸무게
                  // TextInputType.number
                  // TextInputType.numberWithOptions(decimal: true)
                  QFormCard(title: ["n$a_name의 ","b몸무게","n를 입력해주세요."], subTitle: "",
                      keyboardType: const TextInputType.numberWithOptions(decimal: true), initValue: widget.animal.weight.toString(),
                      tag: "weight", hint: "kg", useSelect: false, selKind: "",
                      onChanged: (String tag, String value, String attach) {
                        widget.animal.weight = value;
                        bDirty = true;
                        if (kDebugMode) {
                          print(
                            "onSubmit():tag=$tag, value=$value");
                        }
                      }),
                  // 9. 등록번호
                  QFormCard(title: ["n$a_name의 ", "b등록번호", "n를 입력하세요."], subTitle: "(등록번호가 있는 경우에만 입력)",
                      keyboardType: TextInputType.number,
                      initValue: widget.animal.registered_number.toString(),
                      tag: "name", hint: "등록번호", useSelect: false, selKind: "",
                      onChanged: (String tag, String value, String attach) {
                        bDirty = true;
                        widget.animal.registered_number = value;
                        if (kDebugMode) {
                          print(
                            "onSubmit():tag=$tag, value=$value");
                        }
                      }),
                  // 10. 비만도
                  QSelRadioCard(
                    title: QA1.toList(),
                    subTitle: "", isVertical: true,
                    aList: QItem.fromMenuList(AA1_sumary.toList()),
                    isUseCode: false,
                    initValue: widget.animal.body_mass.toString(),
                    tag:"body_mass",
                    onSubmit: (String tag, String value, String attach) {
                      widget.animal.body_mass = value;
                      bDirty = true;
                    },),
                  // 11. 예방접종
                  QSelRadioCard(title: ["n$a_name의 ", "b기초 예방접종", "n 내역을 선택하세요."],
                    subTitle: "", isVertical: true,
                    aList: QItem.fromMenuList(const ["모름", "접종 전", "접종 완료"]),
                    isUseCode: false,
                    tag:"basic_vaccination",
                    initValue: widget.animal.basic_vaccination.toString(),
                    onSubmit: (String tag, String value, String attach) {
                      widget.animal.basic_vaccination = value;
                      bDirty = true;
                    },),
                  // 12. 심장사상충
                  QSelRadioCard(title: ["n$a_name의 ", "b사상충 예방접종", "n을 하셨나요?"],
                    subTitle: "", isVertical: false,
                    aList: QItem.fromMenuList(const ["예", "아니오"]),
                    isUseCode: false,
                    tag:"heartworm_vaccination",
                    initValue: widget.animal.heartworm_vaccination.toString(),
                    onSubmit: (String tag, String value, String attach) {
                      widget.animal.heartworm_vaccination = value;
                      bDirty = true;
                    },),
                  // 13. 주간 평균 산책횟수
                  QSelRadioCard(title: ["n$a_name의 주간 ", "b평균 산책 횟수", "n를 확인해 주세요."],
                    subTitle: "",
                    isVertical: true,
                    aList: QItem.fromMenuList(AL4.toList()),
                    isUseCode: false,
                    tag:"walks_per_week",
                    initValue: widget.animal.walks_per_week.toString(),
                    onSubmit: (String tag, String value, String attach) {
                      widget.animal.walks_per_week = value;
                      bDirty = true;
                    },),
                  // 14. 일평균 배변횟수
                  QSelRadioCard(title: ["n$a_name의 일 평균 ", "b배변 횟수", "n를 확인해 주세요."],
                    subTitle: "",
                    aList: QItem.fromMenuList(AL2.toList()),
                    isUseCode: false,
                    isVertical: true,
                    tag:"frequency_of_urination",
                    initValue: widget.animal.frequency_of_urination.toString(),
                    onSubmit: (String tag, String value, String attach) {
                      widget.animal.frequency_of_urination = value;
                      bDirty = true;
                    },),
                  // 15. 일평균 배뇨횟수
                  QSelRadioCard(title: ["n$a_name의 일 평균 ", "b배뇨 횟수", "n를 확인해 주세요."], subTitle: "",
                    aList: QItem.fromMenuList(AL1.toList()), //isMulti: true,
                    isUseCode: false,
                    tag:"frequency_of_defecation",
                    initValue: widget.animal.frequency_of_defecation.toString(),
                    onSubmit: (String tag, String value, String attach) {
                      widget.animal.frequency_of_defecation = value;
                      bDirty = true;
                    }, isVertical: true,),
                  // 16. 관심키워드
                  QFormCard(title: ["n$a_name의 ","b관심사항","n을 선택해주세요."],
                    subTitle: "*2개 이상 선택해주십시오.",
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    initValue: widget.animal.keyword.toString(),
                    hint: "관심사항을 선택하세요.",
                    tag: "breed",
                    useSelect: true,
                    selKind: "관심사항",
                    onChanged: (String tag, String value, String attach) {
                      widget.animal.keyword = value;
                      bDirty = true;
                      if (kDebugMode) {
                        print("onSubmit():tag=$tag, value=$value");
                      }
                    }, ),
                  // 17. 과거병력
                  QFormCard(title: ["n$a_name의 ", "b과거병력", "n을 입력해주세요."],
                      subTitle: "",
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      initValue: widget.animal.case_history.toString(),
                      hint: "병력을 입력하세요.",
                      tag: "case_history",
                      useSelect: false,
                      selKind: "",
                      onChanged: (String tag, String value, String attach) {
                        widget.animal.case_history = value;
                        bDirty = true;
                        if (kDebugMode) {
                          print(
                            "onSubmit():tag=$tag, value=$value");
                        }
                      }),
                  const SizedBox(height:50),
                  Visibility(
                    visible: isAddAction,
                    child: Center(
                      child:ElevatedButton(
                        child: const Text("신규등록",
                            style:TextStyle(fontSize:16.0, color:Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            fixedSize: const Size(300, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        onPressed: () async {
                          await _regist();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height:25),
                  Visibility(
                    visible: !isAddAction,
                    child: Center(
                      child:ElevatedButton(
                        child: const Text("수정하기",
                            style:TextStyle(fontSize:16.0, color:Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            fixedSize: const Size(300, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        onPressed: () async {
                          await _update();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height:25),
                  Visibility(
                    visible: (widget.canDelete),
                    child: Center(
                      child:ElevatedButton(
                        child: const Text("지우기",
                            style:TextStyle(fontSize:16.0, color:Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            fixedSize: const Size(300, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        onPressed: () async {
                          showDialogPop(
                              context:context,
                              title: "삭제 확인",
                              body:const Text("데이터를 삭제하시겠습니까?",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              content:const Text("데이터는 복구할 수 없습니다.",
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),),
                              choiceCount:2, yesText: "예", cancelText: "아니오",
                              onResult:(bool isOk) async {
                            if(isOk) {
                              await _delete();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height:50),
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _BuildHeader() {
    return Container(
      height:140,
      width:MediaQuery.of(context).size.width-10,
      padding: const EdgeInsets.fromLTRB(10,0,0,0),
      child: Stack(
        children: [
          Positioned(
            child: Align(alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, Transition(
                          child: PhotoViewer(path: URL_IMAGE+"${widget.animal.photo_url}"),
                          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
                      );
                    },
                    child: SizedBox(
                    width: 80, height:80,
                    child: Container(
                    child: (widget.animal.photo_url!.isNotEmpty)
                        ? CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage("$URL_IMAGE/${widget.animal.photo_url}"),
                            backgroundColor: Colors.transparent,
                          )
                        : const SizedBox(
                            width: 80,
                            height: 80,
                            //color: Colors.brown,
                            child: CircleAvatar(backgroundImage: AssetImage("assets/icon/icon_dog_empty.png"
                            ),
                      ),
                    ),
                  ),
                )
                )
            ),
          ),
          Positioned(
              top:25, left:90, right:0,
              child: Container(
                //width:300,
                  height: 100,
                  //color:Colors.white,
                  padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text((widget.animal.name!.isNotEmpty)?widget.animal.name.toString():"이름",
                            style: const TextStyle(fontSize: 20.0,
                            color: Colors.black, fontWeight: FontWeight.bold)),),
                      const SizedBox(height: 5,),
                      Expanded(child: Text((diffMessage.isNotEmpty)?diffMessage:"만난지 0일",
                          style: const TextStyle(fontSize: 15.0,
                          color: Colors.black)),),
                    ],
                  )
              )
          ),
          Positioned(
            top:15,
            right:15,
            child:
            SizedBox(width:50,height:50,
                child: RawMaterialButton(
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: const Icon(CupertinoIcons. camera, size: 18.0,),
                  shape: const CircleBorder(),
                  onPressed: () {
                    _takePicture();
                  },
                )
            ),
          ),
          Positioned(
            bottom:15,
            right:15,
            child:
            SizedBox(width:50,height:50,
                child: RawMaterialButton(
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: const Icon(CupertinoIcons.folder, size: 18.0,),
                  shape: const CircleBorder(),
                  onPressed: () {
                    _pickupPicture();
                  },
                )
            ),
          ),
        ],
      ),

      margin: const EdgeInsets.fromLTRB(5,10,5,5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color:Colors.black.withOpacity(0.3),
                blurRadius: 1,
                spreadRadius: 1
            )
          ]
      ),
    );
  }

  Widget BuildAnimalCard(bool isLoad, String photo_url, String title, String subTitle) {
    if(isLoad) {
      return Center(
        child: SizedBox(
            key: UniqueKey(),
            height: MediaQuery.of(context).size.width*0.8,
            child: Container(
              margin: const EdgeInsets.all(2),
              child: Stack(
                children: [
                  Positioned(
                    child:GestureDetector(
                      onTap: () {
                        //Navigator.push(context, Transition(
                        //    child: PhotoViewer(path: URL_IMAGE+"${widget.animal.photo_url}"),
                        //   transitionEffect: TransitionEffect.RIGHT_TO_LEFT),);
                      },
                      child: SizedBox(
                          width: 2400,
                          height: 2400,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(photo_url,
                              fit: BoxFit.fill,
                              //cache: true, shape: BoxShape.rectangle,
                            ),
                          )
                      ),
                    ),
                  ),
                  Positioned(
                    child: Column(),
                  ),
                ],
              ),
            )
        ),
      );
    }else {
      return Container();
    }
  }

  String checkValidate() {
    setState(() {

    });
    if(widget.animal.photo_url!.isEmpty) {
      return "사진을 입력해 주세요.";
    } else if(widget.animal.name!.isEmpty) {
      return "이름을 입력해 주세요.";
    } else if(widget.animal.birthday!.isEmpty) {
      return "출생일자를 입력해 주세요.";
    } else if(widget.animal.weight!.isEmpty) {
      return "체중를 입력해 주세요.";
    } else if(widget.animal.kind!.isEmpty) {
      return "반려동물의 종류를 선택해주세요.";
    } else if(widget.animal.spayed!.isEmpty) {
      return "중성화 여부를 선택해주세요.";
    } else if(widget.animal.breed!.isEmpty) {
      return "품종을 확인해 주세요.";
    } else if(widget.animal.body_mass!.isEmpty) {
      return "비만상태를 체크해주세요.";
    } else if(widget.animal.frequency_of_urination!.isEmpty) {
      return "배변횟수를 체크해주세요.";
    } else if(widget.animal.frequency_of_defecation!.isEmpty) {
      return "배뇨횟수를 체크해주세요.";
    } else if(widget.animal.basic_vaccination!.isEmpty) {
      return "예방접종 여부를 체크해주세요.";
    } else if(widget.animal.keyword!.isEmpty) {
      return "관심사항을 체크해주세요.";
    } else if(widget.animal.kind!.isEmpty) {
      return "심장사상충 예방접종을 체크해주세요.";
    } else if(widget.animal.sex!.isEmpty) {
      return "반려동물의 성을 구분해주세요.";
    } else if(widget.animal.walks_per_week!.isEmpty) {
      return "산책 횟수를 체크해주세요.";
    }
    return "OK";
  }

  Future<void> _regist() async {
    String message = checkValidate();
    if(message != "OK") {
      showPopupMessage(context,
        Text(message,
          style: const TextStyle(fontSize: 16, color: Colors.redAccent,
              fontWeight: FontWeight.bold),),);
      return;
    }

    await Remote.addAnimal(users_id:widget.users_id, animal: widget.animal,
        onResponse: (Animal info) async {
          bDirty = true;
          //print("Register::_regist():=>"+info.toString());
          Navigator.pop(context, bDirty);
        });
  }

  Future<void> _update() async {
    await Remote.updateAnimal(animal: widget.animal,
        onResponse: (bool result) {
          bDirty = true;
          //print("Register::_update():=>"+result.toString());
          Navigator.pop(context, bDirty);
      }
    );
  }

  Future<void> _delete() async {
    await Remote.deleteAnimal(animal: widget.animal,
        onResponse: (bool result) {
            bDirty = true;
            setState(() {
              gDeleteFlag = true;
            });
            //print("Register::_delete():=>"+result.toString());
            Navigator.of(context).popUntil((route) => route.isFirst);
        }
      );
  }

  Future <void> _takePicture() async {
      File? src = await takeImage();
      if(src != null) {
          dynamic crop = await cropImage(src);
          if(crop != null) {
              await Remote.reqFile(filePath:crop.path,
                  params: {"command":"ADD", "users_id": "2", "photo_type": "A",},
                  onUpload: (int status, Files result) {
                        if (kDebugMode) {
                          print(result);
                        }
                      setState(() {
                        widget.animal.photo_url = result.url!;
                        imageUrl = "$URL_IMAGE/${result.url!}";
                        bDirty = true;
                      });
                  }
              );
          }
      }
  }

  Future <void> _pickupPicture() async {
    File? src = await pickupImage();
    if(src != null) {
      dynamic crop = await cropImage(src);
      if(crop != null){
        await Remote.reqFile(filePath:crop.path,
            params: {"command":"ADD", "users_id": "2", "photo_type": "A",},
            onUpload: (int status, Files result) {
              if (kDebugMode) {
                print(result);
              }
              setState(() {
                widget.animal.photo_url = result.url!;
                imageUrl = "$URL_IMAGE/${result.url!}";
                bDirty = true;
              });
            });
      }
    }
  }

  Future<bool> _onBackPressed(BuildContext context) {
    _goBack();
    return Future(() => false);
  }

  void _goBack() {
    //print("_goBack():bDirty=$bDirty, widget.command=${widget.command}");
    if(bDirty && widget.command=="UPDATE") {
      showDialogPop(
          context:context,
          title: "확인",
          body:const Text("내용이 변경되었습니다.",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          content:const Text("변경된 내용을 저장하시겠습니까 ?",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),),
          choiceCount:2, yesText: "예", cancelText: "아니오",
          onResult:(bool isOK) async {
            if(isOK) {
              _update();
            }
            else{
              Navigator.pop(context, false);
            }
          }
      );
    }
    else
    {
      Navigator.pop(context, false);
    }
  }

}


