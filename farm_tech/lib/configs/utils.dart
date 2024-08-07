import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  // colors
  static const Color whiteColor = Colors.white;
  static const Color greenColor = Color(0xff339D44);
  static const Color greyColor = Color(0xffB4B4B4);
  static const Color greyColor2 = Color(0xffC4C4C4);
  static const Color blackColor1 = Color(0xff292929);
  static const Color blackColor2 = Colors.black;
  static const Color lightGreyColor1 = Color(0xffB4B4B4);
  static const Color lightGreyColor2 = Color(0xffFBFBFB);
  static const Color lightGreyColor3 = Color(0xffD4D4D4);
  static const Color lightGreenColor1 = Color(0xffb8ddbe);

  // text styles
  static final TextStyle kAppBody1RegularStyle =
      GoogleFonts.raleway(fontSize: 19.2);
  static final TextStyle kAppBody1MediumStyle =
      GoogleFonts.raleway(fontSize: 19.2, fontWeight: FontWeight.w500);
  static final TextStyle kAppBody2RegularStyle =
      GoogleFonts.raleway(fontSize: 16);
  static final TextStyle kAppBody2MediumStyle =
      GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w500);
  static final TextStyle kAppBody2BoldStyle =
      GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold);
  static final TextStyle kAppBody3RegularStyle =
      GoogleFonts.raleway(fontSize: 13.33);
  static final TextStyle kAppBody3MediumStyle =
      GoogleFonts.raleway(fontSize: 13.3, fontWeight: FontWeight.w500);
  static final TextStyle kAppBody3BoldStyle =
      GoogleFonts.raleway(fontSize: 13.3, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading4BoldStyle =
      GoogleFonts.raleway(fontSize: 33.2, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading5BoldStyle =
      GoogleFonts.raleway(fontSize: 27.6, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading6BoldStyle =
      GoogleFonts.raleway(fontSize: 23, fontWeight: FontWeight.bold);
  static final TextStyle kAppCaptionRegularStyle = GoogleFonts.raleway(
    fontSize: 11.1,
  );
  static final TextStyle kAppCaptionMediumStyle =
      GoogleFonts.raleway(fontSize: 11.1, fontWeight: FontWeight.w500);
  static final TextStyle kAppCaptionBoldStyle =
      GoogleFonts.raleway(fontSize: 11.1, fontWeight: FontWeight.bold);
  static final TextStyle kAppCaption2RegularStyle = GoogleFonts.raleway(
    fontSize: 9.3,
  );
  static final TextStyle kAppCaption2MediumStyle =
      GoogleFonts.raleway(fontSize: 9.3, fontWeight: FontWeight.w500);

  // text form field decoration
  static final inputFieldDecoration = InputDecoration(
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: greenColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      hintText: '',
      hintStyle: kAppBody3RegularStyle.copyWith(color: lightGreyColor1),
      contentPadding: const EdgeInsets.all(26),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: lightGreyColor1,
            // color: Colors.pink
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))));

  static const divider = Divider(
    height: 0.5,
    thickness: 0.0,
    color: Utils.lightGreyColor3,
  );

  static const circularProgressIndicatorForAlertDialog =
      CircularProgressIndicator(
    color: greenColor,
    backgroundColor: lightGreenColor1,
    strokeWidth: 6,
  );

  static const circularProgressIndicator = Center(
      child: CircularProgressIndicator(
    color: greenColor,
    backgroundColor: lightGreenColor1,
  ));

  // show loading alert dialog
  static showLoadingAlertDialog(BuildContext context, String forScreen) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // icon: SizedBox(
      //   width: 48,
      //   height: 48,
      //   child: CircularProgressIndicator(
      //     color: greenColor,
      //     backgroundColor: lightGreenColor1,
      //     strokeWidth: 5,
      //   ),
      // ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 45.0, horizontal: 50),
      backgroundColor: whiteColor,
      // title: Text(
      //   "Creating",
      //   style: kAppHeading6BoldStyle,
      // ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
              width: 48,
              height: 48,
              child: circularProgressIndicatorForAlertDialog),
          // space
          const SizedBox(height: 30),
          Text(
            forScreen == 'signup'
                ? "Creating"
                : forScreen == 'upload_product'
                    ? "Uploading"
                    : forScreen == 'login'
                        ? "Logging in"
                        : forScreen == 'edit_profile'
                            ? "Updating profile"
                            : "",
            style: kAppHeading6BoldStyle,
          ),
          const SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center,
            forScreen == 'signup'
                ? "Please be patient we are creating your account"
                : forScreen == 'upload_product'
                    ? "Product is being uploaded"
                    : forScreen == 'login'
                        ? "Please be patient"
                        : forScreen == 'edit_profile'
                            ? "Profile is being updated"
                            : "",
            style: kAppBody3RegularStyle.copyWith(color: lightGreyColor1),
          ),
        ],
      ),
    );

    // show confirm alert dialog
    showConfirmAlertDialog(BuildContext context, String forOption) {
      // set up the button
      Widget confirmButton = CustomButton(
        secondaryButton: false,
        primaryButton: true,
        buttonText: 'Confirm',
        onButtonPressed: () {
          // close alert dialog
          Navigator.pop(context);
          // close shop register screen
          // Navigator.pop(context);
          // close sign up screen
          // Navigator.pop(context);
          // push authentication view with login true
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const AuthenticationView()));
        },
        buttonWidth: MediaQuery.of(context).size.width,
        buttonHeight: 60,
      );
      Widget cancelButton = CustomButton(
        secondaryButton: false,
        primaryButton: true,
        buttonText: 'OK',
        onButtonPressed: () {
          // close alert dialog
          Navigator.pop(context);
          // close shop register screen
          Navigator.pop(context);
          // close sign up screen
          // Navigator.pop(context);
          // push authentication view with login true
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const AuthenticationView()));
        },
        buttonWidth: MediaQuery.of(context).size.width,
        buttonHeight: 60,
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
        icon: const Icon(
          Icons.question_mark,
          size: 40,
          color: Utils.greenColor,
        ),
        // contentPadding:
        //     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
        backgroundColor: Utils.whiteColor,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        title: Text(
          forOption == "cancel"
              ? "Cancel Order?"
              : forOption == "complete"
                  ? "Mark as delivered?"
                  : "",
          style: Utils.kAppHeading6BoldStyle,
        ),
        content: Text(
          textAlign: TextAlign.center,
          forOption == "cancel"
              ? "Are you sure you want to cancel order?"
              : forOption == "complete"
                  ? "Are you sure you want to mark order as delivered?"
                  : "",
          style: Utils.kAppBody3RegularStyle
              .copyWith(color: Utils.lightGreyColor1),
        ),
        actions: [cancelButton, confirmButton],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
          // return alert;
        },
      );
    }

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async =>
                false, // False will prevent and true will allow to dismiss
            child: alert);
      },
    );
  }

  static getAppBar(String title, List<Widget> actions, context) {
    return AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: Image.asset(
              'assets/images/back-arrow.png',
            ),
          ),
        ),
        leadingWidth: 48,
        scrolledUnderElevation: 0,
        backgroundColor: whiteColor,
        title: Text(
          title,
          style: kAppHeading6BoldStyle,
        ),
        actions: actions.isEmpty ? [] : actions);
  }

  static getTabAppBar(String title, List<Widget> actions, context) {
    return AppBar(
        leadingWidth: 48,
        scrolledUnderElevation: 0,
        backgroundColor: whiteColor,
        title: Text(
          title,
          style: kAppHeading6BoldStyle,
        ),
        actions: actions.isEmpty ? [] : actions);
  }
}
