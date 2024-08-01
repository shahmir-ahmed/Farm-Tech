// primary green button
import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

// primary green app button
class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onButtonPressed,
    required this.buttonText,
    this.buttonWidth,
    this.buttonHeight,
    this.primaryButton,
    this.secondaryButton,
  });

  VoidCallback onButtonPressed;
  String buttonText;
  double? buttonWidth;
  double? buttonHeight;
  bool? primaryButton;
  bool? secondaryButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
            boxShadow: primaryButton != null
                ? primaryButton!
                    ? [
                        const BoxShadow(
                            color: Utils.greenColor,
                            offset: Offset(0.0, 3.0), //(x,y)
                            blurRadius: 2,
                            spreadRadius: -3),
                      ]
                    : []
                : [],
            color: primaryButton != null
                ? primaryButton!
                    ? Utils.greenColor
                    // primary button false
                    : secondaryButton != null
                        ? secondaryButton!
                            ? Utils.lightGreyColor2
                            // secondary button false
                            : Colors.red
                        // secondary button null
                        : Colors.red
                // primary button null
                : Colors.red,
            borderRadius: const BorderRadius.all(const Radius.circular(10))),
        child: Center(
          child: Text(
            buttonText,
            style: Utils.kAppBody2RegularStyle.copyWith(
                color: secondaryButton != null
                    ? secondaryButton!
                        ? Utils.greyColor
                        // secondary button false
                        : primaryButton != null
                            ? primaryButton!
                                ? Utils.whiteColor
                                // primary button false
                                : Utils.blackColor2
                            // primary button null
                            : Utils.blackColor2
                    // secondary button null
                    : Utils.blackColor2),
          ),
        ),
      ),
    );
  }
}
