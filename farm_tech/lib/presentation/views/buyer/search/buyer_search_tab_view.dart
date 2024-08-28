import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/profile/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'What products/services are you looking for?',
            style: Utils.kAppHeading6BoldStyle,
          ),
        ),

        // space
        SizedBox(
          height: 20,
        ),

        // search field
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            decoration: Utils.inputFieldDecoration.copyWith(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Image.asset(
                    'assets/images/icon@search.png',
                    width: 25,
                    height: 20,
                  ),
                ),
                hintText: 'Search'),
          ),
        ),

        // space
        SizedBox(
          height: 15,
        ),

        // recent searches text row
        Row(
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
                  style: Utils.kAppCaptionRegularStyle,
                ))
          ],
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
                OptionRow(text: recentSearchText, onPressed: () {})
              ],
            );
          }).toList(),
        )
      ],
    );
  }
}
