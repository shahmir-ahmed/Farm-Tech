import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({super.key});

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text(
        'Profile Tab',
        style: Utils.kAppBody2BoldStyle,
      ),
    );
  }
}