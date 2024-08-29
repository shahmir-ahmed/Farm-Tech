import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/profile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuyerSearchTabView extends StatefulWidget {
  const BuyerSearchTabView({super.key});

  @override
  State<BuyerSearchTabView> createState() => _BuyerSearchTabViewState();
}

class _BuyerSearchTabViewState extends State<BuyerSearchTabView> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // space
          SizedBox(
            height: 30,
          ),
      
          // heading text
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              'What products/services are you looking for?',
              style: Utils.kAppHeading6BoldStyle,
            ),
          ),
      
          // search field
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: Utils.inputFieldDecoration.copyWith(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Image.asset(
                      'assets/images/icon@search.png',
                      width: 25,
                      height: 20,
                    ),
                  ),
                  hintText: 'Search'
                  ),
                  style: Utils.kAppBody3MediumStyle,
            ),
          ),
      
          // space
          SizedBox(
            height: 10,
          ),
      
          // recent searches text row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // text
                Text(
                  'Recent Searches',
                  style: Utils.kAppBody3MediumStyle,
                ),
            
                // clear text
                GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Clear',
                      style: Utils.kAppCaptionRegularStyle.copyWith(color: Utils.greenColor),
                    ))
              ],
            ),
          ),
      
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              'Farming Vehicles',
              'Wheat',
              'Wheat Market Rates',
              'Tractor',
              'Farmers'
            ].map((recentSearchText) {
              return Column(
                children: [
                  // dvider
                  Utils.divider,
      
                  // recent search row
                  OptionRow(text: recentSearchText, onPressed: () {}, noTopDivider: true, textStyle: Utils.kAppBody3RegularStyle,)
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
