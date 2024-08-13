import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class EarningsView extends StatefulWidget {
  const EarningsView({super.key});

  @override
  State<EarningsView> createState() => _EarningsViewState();
}

class _EarningsViewState extends State<EarningsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      appBar: _getAppBar(),
      body: _getBody(),
    );
  }

  _getAppBar() {
    return Utils.getAppBar('Earnings', [], context);
  }

  _getBody() {
    return Column(
      children: [
        // space
        const SizedBox(
          height: 30,
        ),

        // row
        Container(
          color: Utils.lightGreyColor2,
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // previous button
              Image.asset(
                'assets/images/cil_arrow-circle-right.png',
                width: 25,
                height: 25,
              ),
              // dates
              Row(
                children: [
                  Text(
                    '01-07th Feb, 2021',
                    style: Utils.kAppBody2MediumStyle,
                  )
                ],
              ),
              // previous button
              Image.asset(
                'assets/images/cil_arrow-circle-right.png',
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),

        // space
        const SizedBox(
          height: 30,
        ),

        // text
        Text(
          'Your earnings this week',
          style:
              Utils.kAppBody3MediumStyle.copyWith(color: Utils.lightGreyColor1),
        ),

        // space
        const SizedBox(
          height: 10,
        ),

        // earnings
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '7200',
              style: Utils.kAppHeading3BoldStyle,
            ),
            Text(
              'PKR',
              style:
                  Utils.kAppBody3RegularStyle.copyWith(color: Utils.greenColor),
            ),
          ],
        ),

        // space
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
