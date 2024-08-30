import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderPlacedView extends StatelessWidget {
  OrderPlacedView(
      {super.key, required this.setOrderTabAsActive, this.fromBuyNowView});

  VoidCallback setOrderTabAsActive;
  bool? fromBuyNowView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(context),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody(context) {
    return Container(
      color: Utils.whiteColor,
      child: Column(children: [
        // video play screen
        Container(
          // color: Colors.amber,
          width: MediaQuery.of(context).size.width,
          height: 450,
          // padding: EdgeInsets.all(20.0),
          child: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: [
              // order placed image
              const Image(
                image: AssetImage('assets/images/order-placed-banner.png'),
                fit: BoxFit.cover,
              ),

              // app bar in stack to make content go behind it
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: SizedBox(
                      height: 65.0, child: Utils.getAuthAppBar('', context)),
                ),
              ),
            ],
          ),
        ),

        // order placed text
        Text(
          'Your Order Has Been Placed',
          style: Utils.kAppHeading5BoldStyle,
          textAlign: TextAlign.center,
        ),

        // instructions text
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
          child: Text(
            'Your items has been placed and is on it\'s way to being processed',
            style: Utils.kAppBody2MediumStyle.copyWith(color: Utils.greyColor3),
            textAlign: TextAlign.center,
          ),
        ),

        // space
        SizedBox(
          height: 50,
        ),

        // track order button
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              CustomButton(
                onButtonPressed: () {
                  // close screen
                  Navigator.pop(context);

                  // if from buy now view checked out
                  if (fromBuyNowView != null) {
                    // close buy now view
                    Navigator.pop(context);

                    // close item details view
                    Navigator.pop(context);
                  }

                  // set orders tab as active in home screen
                  setOrderTabAsActive();
                },
                buttonText: 'Track Order',
                primaryButton: true,
                secondaryButton: false,
                buttonHeight: 60,
                buttonWidth: MediaQuery.of(context).size.width,
              ),

              // space
              SizedBox(
                height: 28,
              ),

              // back to home button
              GestureDetector(
                  onTap: () {
                    // close screen
                    Navigator.pop(context);

                    // if from buy now view checked out
                    if (fromBuyNowView != null) {
                      // close buy now view
                      Navigator.pop(context);

                      // close item details view
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Back to home',
                    style: Utils.kAppBody2MediumStyle,
                  )),
            ],
          ),
        )
      ]),
    );
  }
}
