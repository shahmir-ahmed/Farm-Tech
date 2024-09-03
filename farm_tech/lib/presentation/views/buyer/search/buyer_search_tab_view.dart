import 'package:farm_tech/backend/model/recent_search.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/backend/services/recent_search_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/seller/profile/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyerSearchTabView extends StatefulWidget {
  BuyerSearchTabView(
      {super.key, required this.setOrderTabAsActive, required this.buyerId});

  VoidCallback setOrderTabAsActive;
  String buyerId;

  @override
  State<BuyerSearchTabView> createState() => _BuyerSearchTabViewState();
}

class _BuyerSearchTabViewState extends State<BuyerSearchTabView> {
  // add text in recent searches for buyer
  _addTextInRecentSearches(String text) async {
    final result = await RecentSearchServices().addRecentSearch(
        RecentSearchModel(searchText: text, buyerId: widget.buyerId));

    if (result == 'success') {
      print('Text added in recent searches');
    } else {
      print('Error adding text in recent searches');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // space
      SizedBox(
        height: 30,
      ),

      // heading text
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: Text(
          'What products are you looking for?',
          style: Utils.kAppHeading6BoldStyle,
        ),
      ),

      // search field
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
        child: TextFormField(
          textInputAction: TextInputAction.search,
          onTapOutside: (event) {
            // new FocusNode().requestFocus();
            FocusScope.of(context)
                .unfocus(); // remove focus from search field on tapping outside
          },
          onFieldSubmitted: (value) async {
            // if value is not provided then not search
            if (value.trim().isNotEmpty) {
              // add text in recent searches for this buyer
              _addTextInRecentSearches(value.trim().toLowerCase());

              // search the product name in products collection and show the product(s) in products view
              // push products view with products found for search list
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StreamProvider.value(
                            value: ProductServices().getSearchedProductsStream(
                                value.trim().toLowerCase()),
                            initialData: null,
                            child: ProductsView(
                              title: 'Search "${value.trim()}"',
                              setOrderTabAsActive: widget.setOrderTabAsActive,
                              noSearchIcon: true,
                            ),
                          )));
            }
          },
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
          style: Utils.kAppBody3MediumStyle,
        ),
      ),

      // space
      SizedBox(
        height: 10,
      ),

      // recent searches section
      StreamProvider.value(
        value: RecentSearchServices().getBuyerRecentSearches(widget.buyerId),
        initialData: null,
        child: RecentSearchesSection(
            buyerId: widget.buyerId,
            setOrderTabAsActive: widget.setOrderTabAsActive),
      )
    ]));
  }
}

// recent searches widget
class RecentSearchesSection extends StatefulWidget {
  RecentSearchesSection(
      {super.key, required this.buyerId, required this.setOrderTabAsActive});

  String buyerId;
  VoidCallback setOrderTabAsActive;

  @override
  State<RecentSearchesSection> createState() => _RecentSearchesSectionState();
}

class _RecentSearchesSectionState extends State<RecentSearchesSection> {
  @override
  Widget build(BuildContext context) {
    // consume stream
    final recentSearches = Provider.of<List<RecentSearchModel>?>(context);

    if (recentSearches != null) {
      // sort recent searches based on createdAt timestamp
      recentSearches.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    }

    return Column(
      children: [
        // recent searches text row
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // text
                  Text(
                    'Recent Searches',
                    style: Utils.kAppBody3MediumStyle,
                  ),

                  // clear text option
                  // if recenet searches are not passed or recent searches are empty then not show this option
                  recentSearches == null || recentSearches.isEmpty
                      ? SizedBox()
                      : GestureDetector(
                          onTap: () {
                            // show confirm dialog
                            Utils.showConfirmAlertDialog(context, () async {
                              // close confirm dialog
                              Navigator.pop(context);

                              // show loading dialog
                              Utils.showLoadingAlertDialog(
                                  context, 'clear_recent_searches');

                              // clear all recent searches of buyer
                              final result = await RecentSearchServices()
                                  .clearRecentSearches(widget.buyerId);

                              // close loading dialog
                              Navigator.pop(context);

                              if (result == 'success') {
                                floatingSnackBar(
                                    message: 'Recent search history cleared',
                                    context: context);
                              } else {
                                floatingSnackBar(
                                    message:
                                        'Error clearing recent search history. Please try again later.',
                                    context: context);
                              }
                            }, 'clear_recent_searches');
                          },
                          child: Text(
                            'Clear',
                            style: Utils.kAppCaptionRegularStyle
                                .copyWith(color: Utils.greenColor),
                          ))
                ],
              ),
            ),

            // dvider
            Utils.divider,
          ],
        ),
        // if receent searches are not passed yet then show loading
        recentSearches == null
            ? SizedBox(
                height: 100,
                child: Center(
                  child: Utils.circularProgressIndicator,
                ),
              )
            :
            // list
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recentSearches.isEmpty
                    // if recent searches are empty
                    ? [
                        // space
                        SizedBox(
                          height: 15,
                        ),

                        // text
                        Center(
                          child: Text(
                            'No recent searches.',
                            style: Utils.kAppBody2RegularStyle,
                          ),
                        ),
                      ]
                    :
                    // [
                    //   'Farming Vehicles',
                    //   'Wheat',
                    //   'Wheat Market Rates',
                    //   'Tractor',
                    //   'Farmers'
                    // ]
                    recentSearches.map((model) {
                        return Column(
                          children: [
                            // recent search row
                            OptionRow(
                              text: model.searchText!,
                              onPressed: () {
                                // remove focus from search text field
                                FocusScope.of(context).unfocus();
                                // when clicking on a recent searched text the text will be searched again
                                // push products view with products found for search list
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StreamProvider.value(
                                              value: ProductServices()
                                                  .getSearchedProductsStream(
                                                      model.searchText!),
                                              initialData: null,
                                              child: ProductsView(
                                                title:
                                                    'Search "${model.searchText}"',
                                                setOrderTabAsActive:
                                                    widget.setOrderTabAsActive,
                                                noSearchIcon: true,
                                              ),
                                            )));
                              },
                              noTopDivider: true,
                              textStyle: Utils.kAppBody3RegularStyle,
                            )
                          ],
                        );
                      }).toList(),
              ),
      ],
    );
  }
}
