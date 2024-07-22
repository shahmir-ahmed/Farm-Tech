import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  RegisterView({required this.changeScreenMethod});

  // change screen method
  VoidCallback changeScreenMethod;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
