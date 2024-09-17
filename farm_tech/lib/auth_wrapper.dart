import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/select_user_type/select_user_type_view.dart';
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
  bool twoSecondsPassed1 = false; // for no user logged in splash timer

  bool twoSecondsPassed2 = false;

  bool isChecking = true;

  String userType = '';

  SharedPreferences? pref;

  // String? loggedInUserType;

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

  // check and set the user type var value from shared pref based on the value in shared pref
  _checkLoggedInUserTypeInPref() {
    final type = pref!.getString("userType");

    // print('user type in shared pref: $type');

    if (type == 'seller') {
      setState(() {
        isChecking = false;
        userType = 'seller';
        // print('user type set as seller');
      });
    } else if (type == 'buyer') {
      setState(() {
        isChecking = false;
        userType = 'buyer';
        // print('user type set as buyer');
      });
    }
    // if null
    else {
      // print('user type is null in shared pref');
      // set as empty because previous user's type is saved here in userType value and when different user logs in again shared pref take time to save and if not saved yet then the same previous user type screen will be displayed
      setState(() {
        userType == '';
      });
      // if not present yet then check again b/c user is logged in then after sometime userType value in shared pref is set when registering
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
          // print('second two seconds passed');
        });
      });
    }
  }

  // return current user logged in type i.e. buyer/seller
  String? _getLoggedInUserTypeFromPref() {
    // print('returning user type');

    final type = pref!.getString("userType");

    // print('user type in shared pref: $type');

    return type;
  }

  // initial splash timer for general splash screen to stay
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
        // print('first two seconds passed');
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startInitialSplashTimer(); // runs when firrt time app starts

    // initialize shared pref instance for the app
    SharedPreferences.getInstance().then((instance) {
      setState(() {
        pref = instance;
        // print('pref instance set');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // consume stream of auth here if user is present then seller splash screen otherwise show auth view
    final user = Provider.of<UserModel?>(context);

    // print('user: $user');

    // user not logged in
    if (user == null) {
      // print('user is not logged in');
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
    }
    // user logged in
    else {
      // print('user is logged in');
      // print('user logged in: ${user.uId}');

      // set user type var as empty b/c when user loggs out and then different type user logs in again then this value will not be changed so current saved user type value based home screen will be shown i.e. if seller logs out and buyer logs in again then type is not changed so seller with new uis does not exist in collection so error in showing data in seller home screen, because already it is set so set again. (need to renintizlize somewhere)

      // check user type in shared pref
      if (pref != null) {
        // if empty then fetch
        if (userType.isEmpty) {
          _checkLoggedInUserTypeInPref();
          // print('checking user type');
        }
        // check and get the current value in shared pref that which type user is logged in if it is same as current type then not change userType value and if not same then change the type value
        else {
          // print('checking user type again');

          String? loggedInUserType = _getLoggedInUserTypeFromPref();

          // same user type of current logged in and previous logged in user
          if (loggedInUserType == userType) {
            // do nothing
            // print('same user type');
          } else if (loggedInUserType == null) {
            // print('user type not present');

            // set user type state var as empty again
            setState(() {
              userType = '';
            });

            // if not set yet then null here then get and set again after 2 secs
            Future.delayed(const Duration(seconds: 2), () {
              _checkLoggedInUserTypeInPref();
            });
          } else if (loggedInUserType != userType) {
            // print('different user type');

            // if not same then set the user type value again
            _checkLoggedInUserTypeInPref();
          }
        }
      }

      // print('userType state var: $userType');

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
                  // still not know which user type
                  : SplashScreenView()
              // if logged in user type is not set yet then means a new user has logged in just now so wait and then verify the user type and then show relevant splash screen
              // : loggedInUserType == null
              //     ? SplashScreenView()
              // if 2 seconds are not passed and user type is not set yet then both value below will be false and general splash will be displayed
              : SplashScreenView(
                  forSeller: userType == "seller" ? true : false,
                  forBuyer: userType == "buyer" ? true : false,
                );
    }
  }
}
