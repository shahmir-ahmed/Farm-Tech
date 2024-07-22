import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/shared/on_boarding/on_boarding_view.dart';
import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  SplashScreenView({this.forBuyer, this.forSeller});

  // for seller after login
  bool? forSeller;
  // for buyer after login
  bool? forBuyer;

  // pop splash screen and push onboarding screen in future
  _futurePopAndPush(context) {
    // after 4 seconds pop this splash screen and push on boarding screen 1
    Future.delayed(const Duration(seconds: 3), () {
      // pop
      Navigator.pop(context);
      // push
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const OnBoardingView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // call method
    _futurePopAndPush(context);
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
                ? const Image(
                    image: AssetImage('assets/images/agri-hardware-logo.png'),
                    width: 127,
                    height: 132,
                  )
                :
                // for buyer splash screen
                forBuyer != null
                    ?
                    // agri user image
                    const Image(
                        image: AssetImage('assets/images/agri-user-logo.png'),
                        width: 107,
                        height: 149,
                      )
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
