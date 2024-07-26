import 'package:farm_tech/backend/model/user.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        threeSecondsPassed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // consume stream of auth here if user is present then seller splash screen otherwise show auth view
    final user = Provider.of<UserModel?>(context);

    print('user: $user');

    if (user == null) {
      print('user not logged in: $user');
      // normal splash screen
      return threeSecondsPassed ? AuthenticationView() : SplashScreenView();
    } else {
      print('user logged in: ${user.uId}');
      // seller splash screen
      return threeSecondsPassed ? HomeView() : SplashScreenView(
        forSeller: true,
      );
    }
  }
}
