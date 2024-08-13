import 'package:flutter/material.dart';

class BuyerProfileTabView extends StatefulWidget {
  const BuyerProfileTabView({super.key});

  @override
  State<BuyerProfileTabView> createState() => _BuyerProfileTabViewState();
}

class _BuyerProfileTabViewState extends State<BuyerProfileTabView> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  _getBody() {
    return Center(
      child: Text('Profile tab'),
    );
  }
}