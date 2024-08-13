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
    return SingleChildScrollView(
      child: Column(
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
                  'assets/images/cil_arrow-circle-left.png',
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
            style: Utils.kAppBody3MediumStyle
                .copyWith(color: Utils.lightGreyColor1),
          ),

          // space
          const SizedBox(
            height: 5,
          ),

          // earnings
          SizedBox(
            height: 54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '7200',
                  style: Utils.kAppHeading3BoldStyle,
                ),
                Text(
                  'PKR',
                  style: Utils.kAppBody3RegularStyle
                      .copyWith(color: Utils.greenColor),
                ),
              ],
            ),
          ),

          // space
          const SizedBox(
            height: 30,
          ),

          // divider
          Utils.dividerWith1Thickness,

          // stats container
          Container(
            color: Utils.lightGreyColor2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // orders
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Orders',
                      style: Utils.kAppBody3MediumStyle,
                    ),
                    Text(
                      '248',
                      style: Utils.kAppBody3MediumStyle
                          .copyWith(color: Utils.greenColor),
                    )
                  ],
                ),

                // space
                const SizedBox(
                  height: 40,
                ),

                // earnings stats image
                Image.asset(
                  'assets/images/earnings-stats.png',
                  width: MediaQuery.of(context).size.width,
                )
              ],
            ),
          ),

          // divider
          Utils.dividerWith1Thickness,

          // single credit record
          Column(
            children: [
              // single credited tile
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                // main row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // credited, dummy text column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Credited ',
                              style: Utils.kAppBody2RegularStyle,
                            ),
                            Text(
                              '1500',
                              style: Utils.kAppBody2RegularStyle
                                  .copyWith(color: Utils.greenColor),
                            ),
                          ],
                        ),

                        // dummy text
                        Text(
                          'Lorem ipsum dolor sit amet',
                          style: Utils.kAppBody3RegularStyle
                              .copyWith(color: Utils.lightGreyColor1),
                        )
                      ],
                    ),

                    // date column
                    Row(
                      children: [
                        Text(
                          '07/02/21',
                          style: Utils.kAppCaptionRegularStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // divider
              Utils.divider,
              // single credited tile
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                // main row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // credited, dummy text column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Credited ',
                              style: Utils.kAppBody2RegularStyle,
                            ),
                            Text(
                              '500',
                              style: Utils.kAppBody2RegularStyle
                                  .copyWith(color: Utils.greenColor),
                            ),
                          ],
                        ),

                        // dummy text
                        Text(
                          'Lorem ipsum dolor sit amet',
                          style: Utils.kAppBody3RegularStyle
                              .copyWith(color: Utils.lightGreyColor1),
                        )
                      ],
                    ),

                    // date column
                    Row(
                      children: [
                        Text(
                          '07/02/21',
                          style: Utils.kAppCaptionRegularStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // divider
              Utils.divider,

              // single credited tile
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                // main row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // credited, dummy text column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Credited ',
                              style: Utils.kAppBody2RegularStyle,
                            ),
                            Text(
                              '150',
                              style: Utils.kAppBody2RegularStyle
                                  .copyWith(color: Utils.greenColor),
                            ),
                          ],
                        ),

                        // dummy text
                        Text(
                          'Lorem ipsum dolor sit amet',
                          style: Utils.kAppBody3RegularStyle
                              .copyWith(color: Utils.lightGreyColor1),
                        )
                      ],
                    ),

                    // date column
                    Row(
                      children: [
                        Text(
                          '06/02/21',
                          style: Utils.kAppCaptionRegularStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // divider
              Utils.divider,

              // single credited tile
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                // main row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // credited, dummy text column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Credited ',
                              style: Utils.kAppBody2RegularStyle,
                            ),
                            Text(
                              '150',
                              style: Utils.kAppBody2RegularStyle
                                  .copyWith(color: Utils.greenColor),
                            ),
                          ],
                        ),

                        // dummy text
                        Text(
                          'Lorem ipsum dolor sit amet',
                          style: Utils.kAppBody3RegularStyle
                              .copyWith(color: Utils.lightGreyColor1),
                        )
                      ],
                    ),

                    // date column
                    Row(
                      children: [
                        Text(
                          '06/02/21',
                          style: Utils.kAppCaptionRegularStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // divider
              Utils.divider,

              // single credited tile
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                // main row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // credited, dummy text column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Credited ',
                              style: Utils.kAppBody2RegularStyle,
                            ),
                            Text(
                              '150',
                              style: Utils.kAppBody2RegularStyle
                                  .copyWith(color: Utils.greenColor),
                            ),
                          ],
                        ),

                        // dummy text
                        Text(
                          'Lorem ipsum dolor sit amet',
                          style: Utils.kAppBody3RegularStyle
                              .copyWith(color: Utils.lightGreyColor1),
                        )
                      ],
                    ),

                    // date column
                    Row(
                      children: [
                        Text(
                          '06/02/21',
                          style: Utils.kAppCaptionRegularStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // divider
              Utils.divider
            ],
          )
        ],
      ),
    );
  }
}
