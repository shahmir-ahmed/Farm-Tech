import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';

class ShopTabView extends StatefulWidget {
  const ShopTabView({super.key});

  @override
  State<ShopTabView> createState() => _ShopTabViewState();
}

class _ShopTabViewState extends State<ShopTabView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      appBar: AppBar(
        backgroundColor: Utils.whiteColor,
        title: Text(
          'Store Profile',
          style: Utils.kAppHeading6BoldStyle,
        ),
        actions: const [
          // search icon
          Icon(
            Icons.search,
            color: Utils.greenColor,
          ),
          SizedBox(
            width: 15,
          ),
          // settings icon
          Icon(
            Icons.settings,
            color: Utils.greenColor,
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.network(profileImageUrl)
                // user profile pic
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/asad-ali.png'),
                  radius: 50,
                ),
                // space
                SizedBox(
                  height: 5,
                ),

                // name
                Text(
                  'Asad Ali',
                  style: Utils.kAppHeading6BoldStyle,
                ),

                // space
                SizedBox(
                  height: 5,
                ),

                // reviews row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Utils.greenColor,
                      size: 10,
                    ),
                    Text(
                      ' 5.0 ',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                    Text(
                      '(154 Reviews)',
                      style: Utils.kAppCaptionRegularStyle,
                    )
                  ],
                ),

                // space
                SizedBox(
                  height: 20,
                ),

                // store stats
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          // count
                          Text(
                            '1022',
                            style: Utils.kAppBody2BoldStyle,
                          ),
                          // space
                          SizedBox(
                            height: 3,
                          ),
                          // title
                          Text(
                            'Total Items',
                            style: Utils.kAppCaptionRegularStyle,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          // count
                          Text(
                            '200',
                            style: Utils.kAppBody2BoldStyle,
                          ),
                          // space
                          SizedBox(
                            height: 3,
                          ),
                          // title
                          Text(
                            'Sold Items',
                            style: Utils.kAppCaptionRegularStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // tabs
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
