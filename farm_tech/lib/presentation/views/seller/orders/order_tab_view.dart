import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class OrderTabView extends StatefulWidget {
  const OrderTabView({super.key});

  @override
  State<OrderTabView> createState() => _OrderTabViewState();
}

class _OrderTabViewState extends State<OrderTabView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text(
        'Order Tab',
        style: Utils.kAppBody2BoldStyle,
      ),
    );
  }
}