import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class BuyerSearchTabView extends StatefulWidget {
  const BuyerSearchTabView({super.key});

  @override
  State<BuyerSearchTabView> createState() => _BuyerSearchTabViewState();
}

class _BuyerSearchTabViewState extends State<BuyerSearchTabView> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    return Center(
      child: Text('Search tab'),
    );
  }
}