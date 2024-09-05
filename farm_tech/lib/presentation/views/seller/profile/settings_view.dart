import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/earnings/earnings_view.dart';
import 'package:farm_tech/presentation/views/seller/profile/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key});
  SettingsView.forBuyer({super.key, this.forBuyer = true});

  bool? forBuyer;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List optionsList = [];
  // logout function
  Future<void> _logoutUser() async {
    // clear shared pref data for app
    SharedPreferences pref = await SharedPreferences.getInstance();
    final cleared = await pref.clear();

    print('cleared: $cleared');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.forBuyer == null) {
      optionsList = [
        /*'Account',*/
        'Earnings',
        /*'Notifications', 'Cache',*/
        'Logout'
      ];
    } else {
      optionsList = ['Logout'];
    }
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
        children: optionsList.map((text) {
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
                      // noTopDivider: true,
                      onPressed: () async {
                        // show confirm alert dialog
                        // showConfirmAlertDialog(context);
                        Utils.showConfirmAlertDialog(context, () async {
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
                              message: 'Logged out successfully',
                              context: context);

                          // print('user logged out');
                        }, 'logout');
                      },
                    )
                  // other than logout other options
                  : OptionRow(
                      text: text,
                      // noTopDivider: true,
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
