import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/order_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/orders/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderTabView extends StatefulWidget {
  OrderTabView({required this.sellerId});
  OrderTabView.forBuyer({required this.buyerId});

  String? sellerId;
  String? buyerId;

  @override
  State<OrderTabView> createState() => _OrderTabViewState();
}

class _OrderTabViewState extends State<OrderTabView> {
  bool allTabActive = true;
  bool inProgressTabActive = false;
  bool completedTabActive = false;
  bool cancelledTabActive = false;

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear(); // Clear the search input
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppbar(),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  // app bar
  _getAppbar() {
    return _isSearching
        ? AppBar(
            scrolledUnderElevation: 0,
            toolbarHeight: 80,
            backgroundColor: Utils.whiteColor,
            title: TextField(
              style: Utils.kAppBody3MediumStyle,
              controller: _searchController,
              keyboardType: TextInputType.name,
              autofocus: true,
              decoration: Utils.inputFieldDecoration.copyWith(
                // contentPadding: EdgeInsets.all(15),
                hintText:
                    'Search in ${allTabActive ? "all" : inProgressTabActive ? "in progress" : completedTabActive ? "completed" : cancelledTabActive ? "cancelled" : ""} orders...',
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Utils.greenColor,
                    size: 28,
                  ),
                  onPressed: _stopSearch, // Clear search and go back
                ),
              ),
              onChanged: (query) => setState(() {
                searchQuery = query.trim();
              }), // Filter as user types
            ),
          )
        : Utils.getTabAppBar(
            'Orders',
            [
              // search icon
              GestureDetector(
                onTap: () {
                  _startSearch();
                },
                child: const Icon(
                  Icons.search,
                  color: Utils.greenColor,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 25,
              ),
            ],
            context);
  }

  // body
  _getBody() {
    // print('searchQuery: $searchQuery');
    // print("check ${'name'.contains('')}"); // true
    return SingleChildScrollView(
      child: _isSearching
          ? Column(
              children: [
                // space
                SizedBox(
                  height: 10,
                ),

                StreamProvider.value(
                  initialData: null,
                  value: widget.sellerId != null
                      ? OrderServices().getAllSellerOrdersStream(
                          SellerModel(docId: widget.sellerId))
                      : OrderServices().getAllBuyerOrdersStream(
                          BuyerModel(docId: widget.buyerId)),
                  child: SingleChildScrollView(
                      child: allTabActive
                          ? widget.sellerId != null
                              ? AllOrdersTabView.forSellerSearch(
                                  searchQuery: searchQuery,
                                )
                              : AllOrdersTabView.forBuyerSearch(
                                  searchQuery: searchQuery)
                          : inProgressTabActive
                              ? widget.sellerId != null
                                  ? InProgressOrdersTabView.forSellerSearch(
                                      searchQuery: searchQuery,
                                    )
                                  : InProgressOrdersTabView.forBuyerSearch(
                                      searchQuery: searchQuery)
                              : completedTabActive
                                  ? widget.sellerId != null
                                      ? CompletedOrdersTabView.forSellerSearch(
                                          searchQuery: searchQuery,
                                        )
                                      : CompletedOrdersTabView.forBuyerSearch(
                                          searchQuery: searchQuery)
                                  : cancelledTabActive
                                      ? widget.sellerId != null
                                          ? CancelledOrdersTabView
                                              .forSellerSearch(
                                              searchQuery: searchQuery,
                                            )
                                          : CancelledOrdersTabView
                                              .forBuyerSearch(
                                                  searchQuery: searchQuery)
                                      : const SizedBox()),
                ),
              ],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 530,
                          child: Row(
                            children: [
                              // space
                              const SizedBox(
                                width: 20,
                              ),

                              // all tab
                              Expanded(
                                  child: CustomButton(
                                      primaryButton: allTabActive,
                                      secondaryButton: !allTabActive,
                                      onButtonPressed: () {
                                        if (!allTabActive) {
                                          setState(() {
                                            allTabActive = true;
                                            inProgressTabActive = false;
                                            completedTabActive = false;
                                            cancelledTabActive = false;
                                          });
                                        }
                                      },
                                      buttonText: 'All',
                                      buttonHeight: 50,
                                      textStyle: Utils.kAppCaptionRegularStyle
                                          .copyWith(
                                              color: allTabActive
                                                  ? Utils.whiteColor
                                                  : Utils.greyColor))),

                              // space
                              const SizedBox(
                                width: 10,
                              ),

                              // in progress tab
                              Expanded(
                                  child: CustomButton(
                                      primaryButton: inProgressTabActive,
                                      secondaryButton: !inProgressTabActive,
                                      onButtonPressed: () {
                                        if (!inProgressTabActive) {
                                          setState(() {
                                            inProgressTabActive = true;
                                            allTabActive = false;
                                            completedTabActive = false;
                                            cancelledTabActive = false;
                                          });
                                        }
                                      },
                                      buttonText: 'In Progress',
                                      buttonHeight: 50,
                                      textStyle: Utils.kAppCaptionRegularStyle
                                          .copyWith(
                                              color: inProgressTabActive
                                                  ? Utils.whiteColor
                                                  : Utils.greyColor))),

                              // space
                              const SizedBox(
                                width: 10,
                              ),

                              // completed tab
                              Expanded(
                                  child: CustomButton(
                                      primaryButton: completedTabActive,
                                      secondaryButton: !completedTabActive,
                                      onButtonPressed: () {
                                        if (!completedTabActive) {
                                          setState(() {
                                            completedTabActive = true;
                                            allTabActive = false;
                                            inProgressTabActive = false;
                                            cancelledTabActive = false;
                                          });
                                        }
                                      },
                                      buttonText: 'Completed',
                                      buttonHeight: 50,
                                      textStyle: Utils.kAppCaptionRegularStyle
                                          .copyWith(
                                              color: completedTabActive
                                                  ? Utils.whiteColor
                                                  : Utils.greyColor))),

                              // space
                              const SizedBox(
                                width: 10,
                              ),

                              // cancelled tab
                              Expanded(
                                  child: CustomButton(
                                      primaryButton: cancelledTabActive,
                                      secondaryButton: !cancelledTabActive,
                                      onButtonPressed: () {
                                        if (!cancelledTabActive) {
                                          setState(() {
                                            cancelledTabActive = true;
                                            allTabActive = false;
                                            inProgressTabActive = false;
                                            completedTabActive = false;
                                          });
                                        }
                                      },
                                      buttonText: 'Cancelled',
                                      buttonHeight: 50,
                                      textStyle: Utils.kAppCaptionRegularStyle
                                          .copyWith(
                                              color: cancelledTabActive
                                                  ? Utils.whiteColor
                                                  : Utils.greyColor))),

                              // space
                              const SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // space
                const SizedBox(
                  height: 10,
                ),

                // divider
                Utils.divider,

                // active tab column
                StreamProvider.value(
                  initialData: null,
                  value: widget.sellerId != null
                      ? OrderServices().getAllSellerOrdersStream(
                          SellerModel(docId: widget.sellerId))
                      : OrderServices().getAllBuyerOrdersStream(
                          BuyerModel(docId: widget.buyerId)),
                  child: SingleChildScrollView(
                      child: allTabActive
                          ? widget.sellerId != null
                              ? AllOrdersTabView()
                              : AllOrdersTabView.forBuyer()
                          : inProgressTabActive
                              ? widget.sellerId != null
                                  ? InProgressOrdersTabView()
                                  : InProgressOrdersTabView.forBuyer()
                              : completedTabActive
                                  ? widget.sellerId != null
                                      ? CompletedOrdersTabView()
                                      : CompletedOrdersTabView.forBuyer()
                                  : cancelledTabActive
                                      ? widget.sellerId != null
                                          ? CancelledOrdersTabView()
                                          : CancelledOrdersTabView.forBuyer()
                                      : const SizedBox()),
                ),
              ],
            ),
    );
  }
}
