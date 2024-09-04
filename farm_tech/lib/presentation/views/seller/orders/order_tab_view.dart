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
    return Utils.getTabAppBar(
        'Orders',
        [
          // search icon
          const Icon(
            Icons.search,
            color: Utils.greenColor,
            size: 30,
          ),
          const SizedBox(
            width: 25,
          ),
        ],
        context);
  }

  // body
  _getBody() {
    return SingleChildScrollView(
      child: Column(
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
                : OrderServices()
                    .getAllBuyerOrdersStream(BuyerModel(docId: widget.buyerId)),
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
