import 'package:farm_tech/presentation/seller/authentication/login_view.dart';
import 'package:farm_tech/presentation/seller/authentication/register_view.dart';
import 'package:flutter/material.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  bool _showSigninScreen = true;

  changeScreen(){
    setState(() {
      _showSigninScreen = !_showSigninScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSigninScreen ? LoginView(changeScreenMethod: changeScreen) : RegisterView(changeScreenMethod: changeScreen);
  }
}
