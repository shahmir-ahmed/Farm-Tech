import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  // colors
  static const Color whiteColor = Colors.white;
  static const Color greenColor = Color(0xff339D44);
  static const Color greyColor = Color(0xffB4B4B4);
  static const Color greyColor2 = Color(0xffC4C4C4);
  static const Color greyColor3 = Color(0xff7C7C7C);
  static const Color blackColor1 = Color(0xff292929);
  static const Color blackColor2 = Colors.black;
  static const Color lightGreyColor1 = Color(0xffB4B4B4);
  static const Color lightGreyColor2 = Color(0xffFBFBFB);
  static const Color lightGreyColor3 = Color(0xffD4D4D4);
  static const Color lightGreyColor4 = Color(0xffB3B3B3);
  static const Color lightGreenColor1 = Color(0xffb8ddbe);

  // text styles
  static final TextStyle kAppBody1RegularStyle =
      GoogleFonts.raleway(fontSize: 19.2);
  static final TextStyle kAppBody1MediumStyle =
      GoogleFonts.raleway(fontSize: 19.2, fontWeight: FontWeight.w500);
  static final TextStyle kAppBody1BoldStyle =
      GoogleFonts.raleway(fontSize: 19.2, fontWeight: FontWeight.bold);
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
  static final TextStyle kAppHeading3BoldStyle =
      GoogleFonts.raleway(fontSize: 39.8, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading4BoldStyle =
      GoogleFonts.raleway(fontSize: 33.2, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading5BoldStyle =
      GoogleFonts.raleway(fontSize: 27.6, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading6BoldStyle =
      GoogleFonts.raleway(fontSize: 23, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading6MediumStyle =
      GoogleFonts.raleway(fontSize: 23, fontWeight: FontWeight.w500);
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

  // divider
  static const divider = Divider(
    height: 0.5,
    thickness: 0.0,
    color: Utils.lightGreyColor3,
  );

  // dividerWith2Thickness
  static const dividerWith1Thickness = Divider(
    height: 0.5,
    thickness: 0.3,
    color: Utils.lightGreyColor3,
  );

  // circluar progress indicator for alert dialog with more width
  static const circularProgressIndicatorForAlertDialog =
      CircularProgressIndicator(
    color: greenColor,
    backgroundColor: lightGreenColor1,
    strokeWidth: 6,
  );

  // circluar progress indicator
  static const circularProgressIndicator = Center(
      child: CircularProgressIndicator(
    color: greenColor,
    backgroundColor: lightGreenColor1,
  ));

  // circluar progress indicator not centered
  static const circularProgressIndicatorNotCentered = CircularProgressIndicator(
    color: greenColor,
    backgroundColor: lightGreenColor1,
  );

  // opposite color circluar progress indicator
  static const circularProgressIndicatorLightGreen = Center(
      child: CircularProgressIndicator(
    color: lightGreenColor1,
    backgroundColor: greenColor,
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
            textAlign: TextAlign.center,
            forScreen == 'signup'
                ? "Creating"
                : forScreen == 'upload_product'
                    ? "Uploading"
                    : forScreen == 'login'
                        ? "Logging in"
                        : forScreen == 'edit_profile'
                            ? "Updating profile"
                            : forScreen == 'cancel_order'
                                ? "Cancelling order"
                                : forScreen == 'mark_as_delivered'
                                    ? "Updating order status"
                                    : forScreen == 'logout'
                                        ? "Logging out"
                                        : forScreen == 'update_address'
                                            ? "Updating address"
                                            : forScreen == 'remove_cart_item'
                                                ? "Removing item"
                                                : forScreen ==
                                                        'remove_cart_items'
                                                    ? "Removing items"
                                                    : forScreen ==
                                                            'add_item_to_cart'
                                                        ? "Adding item"
                                                        : forScreen ==
                                                                'proceed_to_checkout'
                                                            ? "Checking out"
                                                            : forScreen ==
                                                                    'placing_order'
                                                                ? "Placing order"
                                                                : forScreen ==
                                                                        'placing_orders'
                                                                    ? "Placing orders"
                                                                    : forScreen ==
                                                                            'payment_processing'
                                                                        ? "Processing payment"
                                                                        : forScreen ==
                                                                                'clear_recent_searches'
                                                                            ? "Deleting"
                                                                            : forScreen == 'post_feedback'
                                                                                ? "Posting feedback"
                                                                                : "",
            style: forScreen == 'payment_processing'
                ? kAppBody1BoldStyle
                : kAppHeading6BoldStyle,
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
                            : forScreen == 'cancel_order'
                                ? "Order is being cancelled"
                                : forScreen == 'mark_as_delivered'
                                    ? "Marking order as delivered"
                                    : forScreen == 'update_address'
                                        ? "Please be patient"
                                        : forScreen == 'remove_cart_item'
                                            ? "Removing item from cart"
                                            : forScreen == 'remove_cart_items'
                                                ? "Removing items from cart"
                                                : forScreen ==
                                                        'add_item_to_cart'
                                                    ? "Adding item to cart"
                                                    : forScreen ==
                                                            'proceed_to_checkout'
                                                        ? "Proceeding to checkout"
                                                        : forScreen ==
                                                                'placing_order'
                                                            ? "Please be patient we are placing your order"
                                                            : forScreen ==
                                                                    'placing_orders'
                                                                ? "Please be patient we are placing your orders"
                                                                : forScreen ==
                                                                        'payment_processing'
                                                                    ? "Payment is being processed"
                                                                    : forScreen ==
                                                                            'clear_recent_searches'
                                                                        ? "Deleting all recent searches"
                                                                        : forScreen ==
                                                                                'post_feedback'
                                                                            ? "Your feedback is being posted"
                                                                            : "",
            style: kAppBody3RegularStyle.copyWith(color: lightGreyColor1),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      barrierDismissible:
          false, // outside of alert dialog tap will not dismiss alert dialog
      context: context,
      builder: (BuildContext context) {
        // for back pressed
        return WillPopScope(
            onWillPop: () async =>
                false, // False will prevent and true will allow to dismiss
            child: alert);
      },
    );
  }

  // show account created alert dialog
  static showAccountCreatedAlertDialog(BuildContext context, String forUser) {
    // set up the button
    Widget okButton = CustomButton(
      secondaryButton: false,
      primaryButton: true,
      buttonText: 'OK',
      onButtonPressed: () {
        // close alert dialog
        Navigator.pop(context);
        if (forUser == 'seller') {
          // close shop register screen
          Navigator.pop(context);
        }
        // close sign up screen
        Navigator.pop(context);
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
      icon: Image.asset(
        'assets/images/done-icon.png',
        width: 48,
        height: 48,
      ),
      // contentPadding:
      //     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      backgroundColor: Utils.whiteColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        "Account Created",
        style: Utils.kAppHeading6BoldStyle,
      ),
      content: Text(
        textAlign: TextAlign.center,
        "You can now access your account",
        style:
            Utils.kAppBody3RegularStyle.copyWith(color: Utils.lightGreyColor1),
      ),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async =>
                false, // False will prevent and true will allow to dismiss
            child: alert);
        // return alert;
      },
    );
  }

  // show confirm alert dialog
  static showConfirmAlertDialog(
      BuildContext context, VoidCallback onConfirmPressed, String forScreen) {
    // set up the button
    // confirm button
    Widget confirmButton = Expanded(
      child: CustomButton(
        secondaryButton: false,
        primaryButton: true,
        buttonText: forScreen == 'logout'
            ? 'Logout'
            : forScreen == 'cart_single_item' || forScreen == 'cart'
                ? 'Yes'
                : 'Yes',
        onButtonPressed: onConfirmPressed,
        // buttonWidth: MediaQuery.of(context).size.width,
        buttonHeight: 60,
      ),
    );
    // cancel button
    Widget cancelButton = Expanded(
      child: CustomButton(
        secondaryButton: true,
        primaryButton: false,
        buttonText: 'No',
        onButtonPressed: () async {
          if (forScreen == 'exit_app') {
            // close alert dialog with false passed i.e. not allow back pressed
            Navigator.of(context).pop(true);
          } else {
            // close alert dialog
            Navigator.pop(context);
          }
        },
        // buttonWidth: MediaQuery.of(context).size.width,
        buttonHeight: 60,
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 50.0, vertical: 65.0),
      icon: forScreen == 'logout'
          ? Icon(
              Icons.logout_outlined,
              size: 60,
              color: Utils.greenColor,
            )
          : null,
      // contentPadding:
      //     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      backgroundColor: Utils.whiteColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        textAlign: TextAlign.center,
        forScreen == 'logout'
            ? 'Logout?'
            : forScreen == 'cart_single_item'
                ? 'Remove item?'
                : forScreen == 'cart'
                    ? 'Remove items?'
                    : forScreen == 'clear_recent_searches'
                        ? 'Clear recent searches?'
                        : forScreen == 'exit_app'
                            ? 'Exit App?'
                            : '',
        style: Utils.kAppHeading6BoldStyle,
      ),
      content: Text(
        textAlign: TextAlign.center,
        forScreen == 'logout'
            ? 'Are your sure you want to logout?'
            : forScreen == 'cart_single_item'
                ? 'Are your sure you want to remove item from cart?'
                : forScreen == 'cart'
                    ? 'Are your sure you want to remove items from cart?'
                    : forScreen == 'clear_recent_searches'
                        ? 'Are your sure you want to clear all your recent searches?'
                        : forScreen == 'exit_app'
                            ? 'Press yes to exit the app'
                            : '',
        style:
            Utils.kAppBody3RegularStyle.copyWith(color: Utils.lightGreyColor1),
      ),
      actions: [
        Row(
          children: [
            cancelButton,
            // space
            const SizedBox(
              width: 15,
            ),
            confirmButton
          ],
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // show confirm alert dialog
static Future<bool> showExitAppConfirmAlertDialog(
    BuildContext context) async {
  // set up the confirm button
  bool shouldExit = false;

  // confirm button
  Widget confirmButton = Expanded(
    child: CustomButton(
      secondaryButton: false,
      primaryButton: true,
      buttonText: 'Yes',
      onButtonPressed: () {
        shouldExit = true;  // Set true when confirmed
        Navigator.of(context).pop();  // Close the dialog
      },
      buttonHeight: 60,
    ),
  );

  // cancel button
  Widget cancelButton = Expanded(
    child: CustomButton(
      secondaryButton: true,
      primaryButton: false,
      buttonText: 'No',
      onButtonPressed: () {
        shouldExit = false;  // Set false when canceled
        Navigator.of(context).pop();  // Close the dialog
      },
      buttonHeight: 60,
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 65.0),
    backgroundColor: Utils.whiteColor,
    actionsAlignment: MainAxisAlignment.spaceBetween,
    title: Text(
      textAlign: TextAlign.center,
      'Exit App?',
      style: Utils.kAppHeading6BoldStyle,
    ),
    content: Text(
      textAlign: TextAlign.center,
      'Press yes to exit the app',
      style: Utils.kAppBody3RegularStyle.copyWith(color: Utils.lightGreyColor1),
    ),
    actions: [
      Row(
        children: [
          cancelButton,
          const SizedBox(width: 15),
          confirmButton,
        ],
      ),
    ],
  );

  // show the dialog and wait for result
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  print('Dialog result: $shouldExit');

  // return the result (true if confirmed, false if canceled)
  return shouldExit;
}

  // appbar for screen
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

  // appbar for login, sigup, forgot
  static getAuthAppBar(String title, context) {
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
        backgroundColor: whiteColor.withOpacity(0.0),
        title: Text(
          title,
          style: kAppHeading6BoldStyle,
        ));
  }

  // appbar for tab screen
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
