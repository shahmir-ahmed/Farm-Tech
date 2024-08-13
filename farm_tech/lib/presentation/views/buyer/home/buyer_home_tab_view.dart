import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerHomeTabView extends StatefulWidget {
  const BuyerHomeTabView({super.key});

  @override
  State<BuyerHomeTabView> createState() => _BuyerHomeTabViewState();
}

class _BuyerHomeTabViewState extends State<BuyerHomeTabView> {
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
      body: _getBody(),
    );
  }

  _getBody() {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Text('Home tab'),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Utils.whiteColor)),
                onPressed: () async {
                  // logout user
                  await UserAuthServices().signOut();
                  await _logoutUser();
                  floatingSnackBar(
                      message: 'Logged out successfully', context: context);
                  print('user logged out');
                  // floatingSnackBar(
                  //     message: 'Logged out successfully',
                  //     context: context);
                },
                child: const Icon(
                  Icons.logout,
                  color: Utils.blackColor2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
