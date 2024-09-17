import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/shared/authentication/authentication_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectUserTypeView extends StatelessWidget {
  // SelectUserTypeView({required this.showSellerAuth, required this.showBuyerAuth});
  SelectUserTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        // print('didPop: $didPop');
        if (!didPop) {
          final shouldExit = await Utils.showExitAppConfirmAlertDialog(context);

          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Farm Tech',
            style:
                Utils.kAppBody1RegularStyle.copyWith(color: Utils.whiteColor),
          ),
          centerTitle: true,
          backgroundColor: Utils.greenColor,
        ),
        backgroundColor: Utils.whiteColor,
        body: _getBody(context),
      ),
    );
  }

  _getBody(context) {
    return Container(
      // padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // main column
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // container for row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // first column for buyer options
              GestureDetector(
                onTap: () {
                  // show buyer Auth
                  // push buyer login screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticationView(
                                forSeller: false,
                                forBuyer: true,
                              )));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // buyer image avatar
                    // const CircleAvatar(
                    //     backgroundImage:
                    //         AssetImage("assets/images/buyer-icon.png"),
                    //     radius: 50.0,
                    //     foregroundColor: Utils.whiteColor),

                    Image.asset(
                      'assets/images/buyer-icon.png',
                      width: 100,
                    ),

                    // space
                    const SizedBox(
                      height: 20.0,
                    ),

                    // text
                    Text(
                      'Buyer',
                      style: Utils.kAppBody2BoldStyle,
                    ),
                  ],
                ),
              ),

              // // gap
              // SizedBox(
              //   width: 10.0,
              // ),

              // divider
              const SizedBox(
                height: 200,
                child: VerticalDivider(
                  thickness: 1.0,
                  color: Utils.lightGreyColor1,
                ),
              ),

              // // gap
              // SizedBox(
              //   width: 10.0,
              // ),

              // second column for seller options
              GestureDetector(
                onTap: () {
                  // push seller login screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticationView(
                                forSeller: true,
                                forBuyer: false,
                              )));
                },
                // onTap: showSellerAuth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // seller image avatar
                    Image.asset(
                      'assets/images/seller-icon.png',
                      width: 100,
                    ),

                    // space
                    const SizedBox(
                      height: 20.0,
                    ),

                    // text
                    Text(
                      'Seller',
                      style: Utils.kAppBody2BoldStyle,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
