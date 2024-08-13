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
    );
  }

  _getBody() {
    return Center(
      child: Text('Chat tab'),
    );
  }
}