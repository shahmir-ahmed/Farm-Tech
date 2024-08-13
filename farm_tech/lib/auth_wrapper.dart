import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/presentation/views/select_user_type/select_user_type_view.dart';
import 'package:farm_tech/presentation/views/seller/authentication/authentication_view.dart';
import 'package:farm_tech/presentation/views/seller/home/home_view.dart';
import 'package:farm_tech/presentation/views/shared/on_boarding/on_boarding_view.dart';
import 'package:farm_tech/presentation/views/shared/splash_screen/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool threeSecondsPassed = false;

  bool sellerAuth = false;
  bool buyerAuth = false;

  showSellerAuth() {
    setState(() {
      sellerAuth = true;
    });
  }

  showBuyerAuth() {
    setState(() {
      buyerAuth = true;
    });
  }

  // show user type view (by setting both seller and buyer auth false)
  showUserTypeView() {
    setState(() {
      sellerAuth = false;
      buyerAuth = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        threeSecondsPassed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // consume stream of auth here if user is present then seller splash screen otherwise show auth view
    final user = Provider.of<UserModel?>(context);

    // print('user: $user');

    if (user == null) {
      // print('user not logged in: $user');
      // normal splash screen
      return threeSecondsPassed
          ? /* if for seller auth true now from select user type screen */
          sellerAuth
              ? AuthenticationView(
                  forSeller: true,
                )
              : buyerAuth
                  ? AuthenticationView(
                      forBuyer: true,
                    )
                  // if both seller and buyer auth are false (initially and when back is pressedn on login/signup)
                  : SelectUserTypeView(
                      showSellerAuth: showSellerAuth,
                      showBuyerAuth: showBuyerAuth,
                    )
          : SplashScreenView();
    } else {
      // print('user logged in: ${user.uId}');
      // seller splash screen
      return threeSecondsPassed
          ? const HomeView()
          : SplashScreenView(
              forSeller: true,
            );
    }
  }
}
