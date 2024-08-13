import 'package:flutter/material.dart';

class BuyerOrderTabView extends StatefulWidget {
  const BuyerOrderTabView({super.key});

  @override
  State<BuyerOrderTabView> createState() => _BuyerOrderTabViewState();
}

class _BuyerOrderTabViewState extends State<BuyerOrderTabView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  _getBody() {
    return Center(
      child: Text('Order tab'),
    );
  }
}