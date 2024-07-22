// primary green button
import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {required this.onButtonPressed,
      required this.buttonText,
      this.buttonWidth,
      this.buttonHeight});

  VoidCallback onButtonPressed;
  String buttonText;
  double? buttonWidth;
  double? buttonHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Utils.greenColor,
                  offset: Offset(0.0, 3.0), //(x,y)
                  blurRadius: 2,
                  spreadRadius: -3),
            ],
            color: Utils.greenColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            buttonText,
            style:
                Utils.kAppBody2RegularStyle.copyWith(color: Utils.whiteColor),
          ),
        ),
      ),
    );
  }
}
