import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class OrderPlacedView extends StatelessWidget {
  const OrderPlacedView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      // video play screen
      Container(
        // color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        height: 250,
        // padding: EdgeInsets.all(20.0),
        child: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            // order placed image
            const Image(
              image: AssetImage('assets/images/order-placed-banner.png'),
              fit: BoxFit.cover,
            ),

            // space

            // app bar in stack to make content go behind it
            Align(
              alignment: AlignmentDirectional.topStart,
              child: SizedBox(
                  height: 50.0, child: Utils.getAppBar('title', [], context)),
            ),
          ],
        ),
      )
    ]));
  }
}
