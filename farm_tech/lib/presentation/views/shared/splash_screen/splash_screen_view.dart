import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/home/home_view.dart';
import 'package:farm_tech/presentation/views/shared/on_boarding/on_boarding_view.dart';
import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  SplashScreenView({this.forBuyer, this.forSeller});

  // for seller after login
  bool? forSeller;
  // for buyer after login
  bool? forBuyer;

  // pop splash screen and push onboarding screen in future
  // _futurePopAndPush(context) {
  //   // after 4 seconds pop this splash screen and push on boarding screen 1
  //   Future.delayed(const Duration(seconds: 3), () {
  //     // pop
  //     Navigator.pop(context);
  //     // push
  //     Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => const OnBoardingView()));
  //   });
  // }

  // // pop seller splash screen and push seller home screen in future
  // _futurePopAndPushForSeller(context) {
  //   // after 4 seconds pop this splash screen and push
  //   Future.delayed(const Duration(seconds: 3), () {
  //     // pop
  //     Navigator.pop(context);
  //     // push
  //     Navigator.of(context)
  //         .push(MaterialPageRoute(builder: (context) => const HomeView()));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // call method
    // _futurePopAndPush(context);

    // if splash screen is for seller
    // if (forSeller != null) {
    //   _futurePopAndPushForSeller(context);
    // }else{
    //   _futurePopAndPush(context);
    // }
    // widget tree
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      body: _getBody(context),
    );
  }

  _getBody(context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: forSeller == null && forBuyer == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // space
            // if not for buyer or seller
            forSeller == null && forBuyer == null
                ? const SizedBox()
                : const SizedBox(
                    height: 30.0,
                  ),

            // for seller splash screen
            // agri hardware image
            forSeller != null
                ? forSeller!
                    // seller splash
                    ? const Image(
                        image:
                            AssetImage('assets/images/agri-hardware-logo.png'),
                        width: 127,
                        height: 132,
                      )
                    :
                    // seller false
                    // check for buyer is present
                    forBuyer != null
                        ? forBuyer!
                            ?
                            // agri user image
                            const Image(
                                image: AssetImage(
                                    'assets/images/agri-user-logo.png'),
                                width: 107,
                                height: 149,
                              )
                            // buyer false (so both cannot be false means not provide any value if not show seller/buyer splash)
                            : SizedBox()
                        // both are null (means value not provided)
                        : const Image(
                            image: AssetImage(
                                'assets/images/farm-tech-logo-with-text.png'),
                            width: 230,
                            height: 80,
                          )
                // seller is null
                : forBuyer != null
                    ? forBuyer!
                        ?
                        // agri user image
                        const Image(
                            image:
                                AssetImage('assets/images/agri-user-logo.png'),
                            width: 107,
                            height: 149,
                          )
                        // buyer false (so both cannot be false means not provide any value if not show seller/buyer splash)
                        : SizedBox()
                    // both are null (means value not provided)
                    : const Image(
                        image: AssetImage(
                            'assets/images/farm-tech-logo-with-text.png'),
                        width: 230,
                        height: 80,
                      ),

            // powered by farm tech image
            // if not for buyer or seller
            forSeller == null && forBuyer == null
                ? const SizedBox()
                : const Image(
                    image: AssetImage('assets/images/powered-by-farm-tech.png'),
                    width: 134,
                    height: 54,
                  ),
          ],
        ),
      ),
    ));
  }
}
