import 'package:farm_tech/configs/utils.dart';
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
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    return Center(
      child: Text('Profile tab'),
    );
  }
}