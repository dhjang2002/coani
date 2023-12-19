import 'package:coani/Utils/utils.dart';
import 'package:flutter/material.dart';

class CardQButton extends StatelessWidget {
  final bool visible;
  final bool enable;
  final String btnText;
  final String validText;
  final Function() onClick;
  const CardQButton({
    required this.btnText,
    required this.onClick,
    this.visible = true,
    this.enable = true,
    this.validText="",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Center(
        child:ElevatedButton(
          child: Text(btnText,
              style: (enable)
                  ? TextStyle(
                      fontSize:16.0,
                      color:Colors.white)
                  : TextStyle(
                  fontSize:16.0,
                  color:Colors.grey),
          ),
          style: (enable)
              ? ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              fixedSize: const Size(300, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              )

          )
              : ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              fixedSize: const Size(300, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              )
          ),
          onPressed:() {
            if(enable) {
              onClick();
            } else {
              if(validText.isNotEmpty) {
                showToastMessage(validText);
              }
            }
          },
        ),
      ),
    );
  }
}
