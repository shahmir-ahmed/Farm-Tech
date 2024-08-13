import 'package:farm_tech/presentation/views/seller/authentication/login_register_forgot_password_view.dart';
import 'package:flutter/material.dart';

class AuthenticationView extends StatefulWidget {
  AuthenticationView({required this.forSeller, required this.forBuyer});
  // AuthenticationView({this.forSeller, this.forBuyer, this.showUserTypeView});

  bool forSeller;
  bool forBuyer;
  // on back pressed show select user type view
  // VoidCallback? showUserTypeView;

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  bool _showSigninScreen = true;

  changeScreen() {
    setState(() {
      _showSigninScreen = !_showSigninScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSigninScreen
        ? LoginRegisterForgotResetPasswordView(
            changeScreenMethod: changeScreen,
            forLoginView: true,
            forBuyer: widget.forBuyer,
            forSeller: widget.forSeller,
          )
        : LoginRegisterForgotResetPasswordView(
            changeScreenMethod: changeScreen,
            forSignupView: true,
            forBuyer: widget.forBuyer,
            forSeller: widget.forSeller,
          );
  }
}
