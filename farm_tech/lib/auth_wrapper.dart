import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/presentation/views/select_user_type/select_user_type_view.dart';
import 'package:farm_tech/presentation/views/seller/authentication/authentication_view.dart';
import 'package:farm_tech/presentation/views/seller/home/home_view.dart';
import 'package:farm_tech/presentation/views/shared/on_boarding/on_boarding_view.dart';
import 'package:farm_tech/presentation/views/shared/splash_screen/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool twoSecondsPassed1 = false;

  bool twoSecondsPassed2 = false;

  bool isChecking = true;

  String userType = '';

/*
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
  */

/*
  _checkUserDocIdInSellersAndBuyers(String docId) {
    // check in sellers
    final result =
        SellerServices().checkSellerWithDocId(SellerModel(docId: docId));

    if (result == 'success') {
      setState(() {
        isLoading = false;
        userType = 'seller';
      });
    } else {
      // check in buyers
      final result =
          BuyerServices().checkBuyerWithDocId(BuyerModel(docId: docId));

      if (result == 'success') {
        setState(() {
          isLoading = false;
          userType = 'buyer';
        });
      }
    }

    // start 2 seconds now for seller/buyer splash screen
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        twoSecondsPassed2 = true;
      });
    });
  }
  */

  _checkLoggedInUserTypeInPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final type = pref.getString("userType");

    print('user type in shared pref: $type');

    if (type == 'seller') {
      setState(() {
        isChecking = false;
        userType = 'seller';
        print('user type set as seller');
      });
    } else if (type == 'buyer') {
      setState(() {
        isChecking = false;
        userType = 'buyer';
        print('user type set as buyer');
      });
    } else {
      // if not present yet then check again b/c user logged in then after then userType value in shared pref is set when registering
      // after 2 secs interval check again
      Future.delayed(const Duration(seconds: 2), () {
        _checkLoggedInUserTypeInPref();
      });
    }

    // if user type is set now then pass the time otherwise keep showing
    if (userType.isNotEmpty) {
      // start 2 seconds now for seller/buyer splash screen
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          twoSecondsPassed2 = true;
        });
      });
    }
  }

  _startInitialSplashTimer() {
    // for general splash screen if no user is logged in (first time)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        /*
        // if after three seconds still not found user type then keep showing splash screen
        if (userType.isNotEmpty) {
          twoSecondsPassed1 = true;
        } else {
          // start again
          _startInitialSplashTimer();
        }
        */
        twoSecondsPassed1 = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startInitialSplashTimer(); // runs when firrt time app starts
  }

  @override
  Widget build(BuildContext context) {
    // consume stream of auth here if user is present then seller splash screen otherwise show auth view
    final user = Provider.of<UserModel?>(context);

    // print('user: $user');

    if (user == null) {
      // print('user not logged in: $user');
      // normal splash screen
      return twoSecondsPassed1
          ?
          /*
          /* if for seller auth true now from select user type screen */
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
                    */
          SelectUserTypeView()
          : SplashScreenView();
    } else {
      // print('user logged in: ${user.uId}');

      // set user type var as empty b/c when user loggs out and then different type user logs in again then this value will not be changed because already it is set so set again. (need to renintizlize somewhere)

      // check user user type in shared pref
      // if still empty then fetch
      if (userType.isEmpty) {
        _checkLoggedInUserTypeInPref();
        print('checking user type');
      }

      print('userType: $userType');

      // seller//buyer splash screen
      return isChecking
          // not know user type till now b/c checking
          ? SplashScreenView()
          : twoSecondsPassed2
              // now know user type
              ? userType.isNotEmpty
                  ? HomeView(
                      userType: userType,
                    )
                  // still empty (cannot come here because twoseondspassed 2 is not passed until the type value is non empty (see check function)) (so for else value sake written)
                  : Placeholder()
                  // if 2 seconds are not passed and user type is not set yet then both value below will be false and general splash will be displayed
              : SplashScreenView(
                  forSeller: userType == "seller" ? true : false,
                  forBuyer: userType == "buyer" ? true : false,
                );
    }
  }
}
