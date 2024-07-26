import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class ChatTabView extends StatefulWidget {
  const ChatTabView({super.key});

  @override
  State<ChatTabView> createState() => _ChatTabViewState();
}

class _ChatTabViewState extends State<ChatTabView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text(
        'Chat Tab',
        style: Utils.kAppBody2BoldStyle,
      ),
    );
  }
}
