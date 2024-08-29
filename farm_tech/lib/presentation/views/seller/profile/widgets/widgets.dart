import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

// option row
class OptionRow extends StatelessWidget {
  OptionRow(
      {required this.text,
      required this.onPressed,
      this.textColor,
      this.noRightIcon,
      this.startIcon,
      this.noTopDivider,
      this.textStyle
      });

  String text;
  TextStyle? textStyle;
  Color? textColor;
  bool? noRightIcon;
  dynamic startIcon;
  bool? noTopDivider;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // divider
        noTopDivider != null
            ? const SizedBox()
            : const Divider(
                height: 0.5,
                thickness: 0.0,
                color: Utils.lightGreyColor3,
              ),

        // option row
        GestureDetector(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: startIcon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // starting icon
                      startIcon,

                      // space
                      const SizedBox(
                        width: 10,
                      ),

                      // text
                      Text(
                        text,
                        style: textStyle ?? Utils.kAppBody3MediumStyle
                            .copyWith(color: textColor ?? Utils.blackColor2),
                      ),

                      // arrow
                      noRightIcon != null
                          ? const SizedBox()
                          : const Icon(
                              Icons.chevron_right_rounded,
                              color: Utils.lightGreyColor3,
                              size: 26,
                            )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // text
                      Text(
                        text,
                        style: textStyle ?? Utils.kAppBody3MediumStyle
                            .copyWith(color: textColor ?? Utils.blackColor2),
                      ),

                      // arrow
                      noRightIcon != null
                          ? const SizedBox()
                          : const Icon(
                              Icons.chevron_right_rounded,
                              color: Utils.lightGreyColor3,
                              size: 26,
                            )
                    ],
                  ),
          ),
        ),

        // divider
        Utils.divider
      ],
    );
  }
}
