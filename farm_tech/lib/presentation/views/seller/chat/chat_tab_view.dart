import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class ChatTabView extends StatefulWidget {
  const ChatTabView({super.key});

  @override
  State<ChatTabView> createState() => _ChatTabViewState();
}

class _ChatTabViewState extends State<ChatTabView> {
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
