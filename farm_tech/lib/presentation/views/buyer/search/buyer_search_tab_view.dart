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
    );
  }

  _getBody() {
    return Center(
      child: Text('Search tab'),
    );
  }
}