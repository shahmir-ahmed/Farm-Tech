import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class BuyerChatTabView extends StatefulWidget {
  const BuyerChatTabView({super.key});

  @override
  State<BuyerChatTabView> createState() => _BuyerChatTabViewState();
}

class _BuyerChatTabViewState extends State<BuyerChatTabView> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    return Center(
      child: Text('Chat tab'),
    );
  }
}