// primary green button
import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

// primary green app button
class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.onButtonPressed,
      required this.buttonText,
      required this.primaryButton,
      required this.secondaryButton,
      this.buttonWidth,
      this.buttonHeight,
      this.icon,
      this.textStyle
      });

  VoidCallback onButtonPressed;
  String buttonText;
  double? buttonWidth;
  double? buttonHeight;
  bool? primaryButton;
  bool? secondaryButton;
  dynamic icon;
  TextStyle? textStyle;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null ? icon! : const SizedBox(),
              icon != null
                  ? const SizedBox(
                      width: 10,
                    )
                  : const SizedBox(),
              Text(
                buttonText,
                style: textStyle ?? Utils.kAppBody2RegularStyle.copyWith(
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
            ],
          ),
        ),
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton(
      {Key? key,
      required this.height,
      required this.width,
      required this.defaultPadding})
      : super(key: key);

  final double height, width, defaultPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
