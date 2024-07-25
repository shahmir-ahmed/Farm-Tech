import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Utils.whiteColor, body: _getBody());
  }

  _getBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Dashboard!',
              style: Utils.kAppHeading6BoldStyle,
            ),
            // texts row
            Row(
              children: [
                Text(
                  'Welcome to Dashboard, ',
                  style: Utils.kAppCaptionRegularStyle
                      .copyWith(color: Utils.lightGreyColor1),
                ),
                Text(
                  'Shahmir',
                  style: Utils.kAppCaptionRegularStyle
                      .copyWith(color: Utils.blackColor2),
                ),
              ],
            ),
            GridView.count(crossAxisCount: 2, children: [
              Container(
                child: Column(
                  children: [
                    // question mark icon
                    Row(
                      children: [

                      ],
                    )
                  ],
                ),
              )
            ],),
            // graph
            Center(
              child: Image.asset(
                'assets/images/dashboard-graph.png',
                width: MediaQuery.of(context).size.width,
                // height: 273,
              ),
            ),

            // orders section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orders in Queue',
                  style: Utils.kAppBody3MediumStyle,
                ),
                // text
                Text(
                  'See all',
                  style: Utils.kAppCaption2RegularStyle
                      .copyWith(color: Utils.greenColor),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
