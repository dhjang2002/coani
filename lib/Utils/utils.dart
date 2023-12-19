import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

Future <File?> pickupVideo() async {
  //var platform = ImagePicker();
  var pickedImage =
  await ImagePicker.platform.getVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60));
  File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
  return imageFile;
}

Future <File?> takeVideo() async {
  var pickedImage =
  await ImagePicker.platform.getVideo(source: ImageSource.camera, maxDuration: const Duration(seconds: 60));
  File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
  return imageFile;
}

Future <File?> pickupImage() async {
  var pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
  return imageFile;
}

Future <File?> takeImage() async {
  var pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.camera);
  File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
  return imageFile;
}

Future <CroppedFile?> cropImage(File imageFile) async {
  ImageCropper imageCropper = ImageCropper();
  CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        //CropAspectRatioPreset.ratio3x2,
        //CropAspectRatioPreset.original,
        //CropAspectRatioPreset.ratio4x3,
        //CropAspectRatioPreset.ratio16x9
      ]
          : [
        //CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        //CropAspectRatioPreset.ratio3x2,
        //CropAspectRatioPreset.ratio4x3,
        //CropAspectRatioPreset.ratio5x3,
        //CropAspectRatioPreset.ratio5x4,
        //CropAspectRatioPreset.ratio7x5,
        //CropAspectRatioPreset.ratio16x9
      ],
      compressQuality: 75,
      uiSettings:
      [
        AndroidUiSettings(
            toolbarTitle: '이미지 자르기',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            //lockAspectRatio: true,
            hideBottomControls: true
        ),
        IOSUiSettings(
          title: '이미지 자르기',
          doneButtonTitle: "자르기",
          cancelButtonTitle: "취소",
          //aspectRatioPickerButtonHidden:true,
          //hidesNavigationBar:true,
          //showActivitySheetOnDone:false,
          //showCancelConfirmationDialog:false,
          //rotateClockwiseButtonHidden:false,
          hidesNavigationBar:true,
          rotateButtonsHidden:true,
          resetButtonHidden:false,
          aspectRatioPickerButtonHidden:true,
          resetAspectRatioEnabled:false,
          aspectRatioLockDimensionSwapEnabled:true,
          aspectRatioLockEnabled:true,
        )
      ]
  );

  return croppedFile;
}
/*
Future<File?> cropImage(File imageFile) async {
  ImageCropper imageCropper = ImageCropper();
  CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid ? [
        CropAspectRatioPreset.square,
        //CropAspectRatioPreset.ratio3x2,
        //CropAspectRatioPreset.original,
        //CropAspectRatioPreset.ratio4x3,
        //CropAspectRatioPreset.ratio16x9
      ] : [
        //CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        //CropAspectRatioPreset.ratio3x2,
        //CropAspectRatioPreset.ratio4x3,
        //CropAspectRatioPreset.ratio5x3,
        //CropAspectRatioPreset.ratio5x4,
        //CropAspectRatioPreset.ratio7x5,
        //CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: '이미지 자르기',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls:true),
      iosUiSettings: const IOSUiSettings(title: '이미지 자르기',));

  return croppedFile;
}
*/

Future <String> getFilePath(uniqueFileName) async {
  String path = '';
  Directory dir = await getApplicationDocumentsDirectory();
  path = '${dir.path}/$uniqueFileName';
  return path;
}

String getNameFromPath(String path){
  if(path.length>3){
    File file = File(path);
    return file.path.split('/').last.toLowerCase();
  }
  return "";
}

String getExtFromPath(String path){
  if(path.length>3){
    File file = File(path);
    return file.path.split('.').last.toLowerCase();
  }
  return "";
}

String getDayCount(String dateString) {
  if(dateString.length>=10) {
    if(dateString.indexOf(".")>0) {
      dateString = dateString.replaceAll(".", "-");
    }
    DateTime birthday = DateFormat('yyyy-MM-dd').parse(dateString);
    DateTime today = DateTime.now();
    var diff = (today.difference(birthday).inDays)+1;
    return "만난지 $diff일 ";
  }
  return "";
}

void showDialog3Pop({required BuildContext context,
  required String title,
  required Text body,
  required Text content,
  String?  btn1Text="아니오",
  String?  btn2Text="저장후 종료",
  String?  btn3Text="종료",
  required Function(int btnIndex) onResult}) {
  showDialog(
    context: context,
    barrierDismissible:
    false, //다이얼로그 바깥을 터치 시에 닫히도록 하는지 여부 (true: 닫힘, false: 닫히지않음)
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,
          style: const TextStyle(color:Colors.black, fontWeight: FontWeight.normal, fontSize: 20),),

        content: SingleChildScrollView(
          //내용 정의
          child: ListBody(
            children: <Widget>[
              body,
              const SizedBox(height:5),
              content,
            ],
          ),
        ),
        actions: <Widget>[
          //버튼 정의
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onResult(0);// 현재 화면을 종료하고 이전 화면으로 돌아가기
            },
            child: Text(btn1Text!,
              style: const TextStyle(
                  color:Colors.redAccent,
                  fontWeight:
                  FontWeight.bold, fontSize: 16),),
          ),
          Visibility(
            visible: true,
            child:TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 현재 화면을 종료하고 이전 화면으로 돌아가기
                onResult(1);
              },
              child: Text(btn2Text!,style:
              const TextStyle(
                  color:Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),),
            ),),
          Visibility(
            visible: true,
            child:TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 현재 화면을 종료하고 이전 화면으로 돌아가기
                onResult(2);
              },
              child: Text(btn3Text!,style:
              const TextStyle(color:Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),
            ),),

        ],
      );
    },
  );
}

void showDialogPop({required BuildContext context,
  required String title,
  required Text body,
  required Text content,
  required int  choiceCount,
  String?  yesText="확인",
  String?  cancelText="취소",
  required Function(bool isOK) onResult}) {
  showDialog(
    context: context,
    barrierDismissible:
    false, //다이얼로그 바깥을 터치 시에 닫히도록 하는지 여부 (true: 닫힘, false: 닫히지않음)
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,
          style: const TextStyle(color:Colors.black, fontWeight: FontWeight.normal, fontSize: 20),),

        content: SingleChildScrollView(
          //내용 정의
          child: ListBody(
            children: <Widget>[
              body,
              const SizedBox(height:5),
              content,
            ],
          ),
        ),
        actions: <Widget>[
          //버튼 정의
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onResult(true);// 현재 화면을 종료하고 이전 화면으로 돌아가기
            },
            child: Text(yesText!,
              style: const TextStyle(color:Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),
          ),
          Visibility(
            visible: (choiceCount>1) ? true : false,
            child:TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 현재 화면을 종료하고 이전 화면으로 돌아가기
              onResult(false);
            },
            child: Text(cancelText!,style:
            const TextStyle(color:Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),
          ),),

        ],
      );
    },
  );
}

void showPopupMessage(BuildContext context, Text message) async {
  double height = (MediaQuery.of(context).size.height/3 > 150)
                  ? MediaQuery.of(context).size.height/3 : 150;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              message,
            ],
          ),
        ),
      );
    },
  );
}

void showSnackbar(BuildContext context, String message) {
  var snack = SnackBar(
    content: Text(message, style: const TextStyle(fontSize: 16),),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

void showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 18.0);
}
