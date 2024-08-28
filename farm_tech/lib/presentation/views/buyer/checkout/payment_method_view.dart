import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class PaymentMethodView extends StatefulWidget {
  const PaymentMethodView({super.key});

  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar('Payment method', [], context),
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // divider
        Utils.divider,

        // stripe payment option selected row
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stripe',
                style: Utils.kAppBody3RegularStyle,
              ),
              Icon(
                Icons.check,
                color: Utils.greenColor,
              )
            ],
          ),
        )
      ],
    );
  }
}