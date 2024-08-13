import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/earnings/earnings_view.dart';
import 'package:farm_tech/presentation/views/seller/profile/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // show confirm alert dialog
  showConfirmAlertDialog(BuildContext context) {
    // set up the button
    // confirm button
    Widget confirmButton = Expanded(
      child: CustomButton(
        secondaryButton: false,
        primaryButton: true,
        buttonText: 'Logout',
        onButtonPressed: () async {
          // close alert dialog
          Navigator.pop(context);

          // show loading alert dialog
          Utils.showLoadingAlertDialog(context, 'logout');

          // logout user
          await UserAuthServices().signOut();

          // close loading alert dialog
          Navigator.pop(context);

          // close screen
          Navigator.pop(context);

          // clear shared pref
          await _logoutUser();

          // show message
          floatingSnackBar(
              message: 'Logged out successfully', context: context);

          // print('user logged out');
        },
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
          // close alert dialog
          Navigator.pop(context);
        },
        // buttonWidth: MediaQuery.of(context).size.width,
        buttonHeight: 60,
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 45.0),
      icon: const Icon(
        Icons.logout_outlined,
        size: 60,
        color: Utils.greenColor,
      ),
      // contentPadding:
      //     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      backgroundColor: Utils.whiteColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        textAlign: TextAlign.center,
        "Logout?",
        style: Utils.kAppHeading6BoldStyle,
      ),
      content: Text(
        textAlign: TextAlign.center,
        "Are you sure you want to logout?",
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

  // logout function
  Future<void> _logoutUser() async {
    // clear shared pref data for app
    SharedPreferences pref = await SharedPreferences.getInstance();
    final cleared = await pref.clear();

    print('cleared: $cleared');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar('Settings', [], context),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  _getBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          /*'Account',*/ 'Earnings',
          /*'Notifications', 'Cache',*/ 'Logout'
        ].map((text) {
          // single option widget
          return
              // text == "Earnings" ||
              //         // text == "Notifications" ||
              //         // text == "Cache" ||
              //         text == "Logout"
              //     ?
              text == "Logout"
                  ? OptionRow(
                      text: text,
                      textColor: Colors.red,
                      noRightIcon: true,
                      startIcon: Image.asset(
                        'assets/images/logout-icon.png',
                        width: 25,
                      ),
                      noTopDivider: true,
                      onPressed: () async {
                        // show confirm alert dialog
                        showConfirmAlertDialog(context);
                      },
                    )
                  // other than logout other options
                  : OptionRow(
                      text: text,
                      noTopDivider: true,
                      onPressed: () {
                        // show earnings screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EarningsView()));
                      },
                    );
          // account option having top divider
          // : OptionRow(
          //     text: text,
          //     onPressed: () {},
          //   );
        }).toList(),
      ),
    );
  }
}
