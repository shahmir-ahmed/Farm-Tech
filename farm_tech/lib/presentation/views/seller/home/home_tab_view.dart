import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/order_services.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/orders/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTabView extends StatefulWidget {
  HomeTabView({required this.sellerName, required this.setOrderTabAsActive});

  // seller name from home view
  String sellerName;

  VoidCallback setOrderTabAsActive;

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  // stats list
  late List<Map<String, dynamic>> statsList;

  String sellerId = '';

  // get seller uid
  _getUserUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // set state to let the widget tree know and refresh itself that something (data att.) has changed that it needs to reflect in its tree/view
    setState(() {
      sellerId = pref.getString("uId") as String;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialize stats list
    statsList = [
      {
        "icon": "assets/images/icon-question-mark.png",
        "title": "Total Products",
      },
      {
        "icon":
            "assets/images/icon-done-all.png", // "assets/images/icon@orders.png"
        "title": "Total Orders"
      },
      {
        "icon": "assets/images/icon-earned.png", // Icons.paid_outlined
        "title": "Total Earned"
      },
      {
        "icon": Icons.star, // "assets/images/icon-review.png",
        "title": "Total Reviews"
      },
    ];

    // get user uid
    _getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }

  _getBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                // user name
                                sellerId.isEmpty
                                    ? Text(
                                        "...",
                                        style: Utils.kAppCaptionRegularStyle,
                                      )
                                    : StreamProvider.value(
                                        initialData: null,
                                        value: SellerServices()
                                            .getSellerNameStream(
                                                SellerModel(docId: sellerId)),
                                        child: SellerNameText()),
                              ],
                            ),
                          ],
                        ),
                        /*
                        ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Utils.whiteColor)),
                          onPressed: () async {
                            // logout user
                            await UserAuthServices().signOut();
                            await _logoutUser();
                            floatingSnackBar(
                                message: 'Logged out successfully',
                                context: context);
                            print('user logged out');
                            // floatingSnackBar(
                            //     message: 'Logged out successfully',
                            //     context: context);
                          },
                          child: const Icon(
                            Icons.logout,
                            color: Utils.blackColor2,
                          ),
                        ),
                        */
                      ],
                    ),
                    // space
                    const SizedBox(
                      height: 20,
                    ),
                    // grid view
                    SizedBox(
                      height: 277,
                      child: sellerId.isEmpty
                          ? Utils.circularProgressIndicator
                          : GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 1.4,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: statsList.map((statMap) {
                                return StatMiniCard(
                                  sellerId: sellerId,
                                  title: statMap['title'],
                                  icon: statMap['icon'],
                                );
                              }).toList()),
                    ),
                    /*

                    // space
                    const SizedBox(
                      height: 20,
                    ),

                    // graph
                    Center(
                      child: Image.asset(
                        'assets/images/dashboard-graph.png',
                        width: MediaQuery.of(context).size.width,
                        height: 350,
                      ),
                    ),
                    */

                    // space
                    const SizedBox(
                      height: 20,
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
                        GestureDetector(
                          onTap: () {
                            widget.setOrderTabAsActive();
                          },
                          child: Text(
                            'See all',
                            style: Utils.kAppCaption2RegularStyle
                                .copyWith(color: Utils.greenColor),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),

            // divider
            Utils.divider,

            sellerId.isEmpty
                ? Utils.circularProgressIndicator
                : StreamProvider.value(
                    initialData: null,
                    value: OrderServices().getInProgressOrdersStream(
                        SellerModel(docId: sellerId)),
                    child: OrdersInQueue(),
                  )
          ],
        ),
      ),
    );
  }
}

// seller name text widget
class SellerNameText extends StatefulWidget {
  const SellerNameText({super.key});

  @override
  State<SellerNameText> createState() => _SellerNameTextState();
}

class _SellerNameTextState extends State<SellerNameText> {
  @override
  Widget build(BuildContext context) {
    final sellerName = Provider.of<String?>(context);

    return Text(
      sellerName == null
          ? "..."
          : !sellerName.contains(' ')
              ? sellerName
              : sellerName.substring(0, sellerName.indexOf(' ')),
      style: Utils.kAppCaptionRegularStyle,
    );
  }
}

// mini card
class StatMiniCard extends StatelessWidget {
  StatMiniCard({
    required this.sellerId,
    required this.title,
    required this.icon,
  });

  String sellerId;
  String title;
  dynamic icon;

  @override
  Widget build(BuildContext context) {
    // single mini card for stat
    return Container(
      decoration: const BoxDecoration(
        color: Utils.whiteColor,
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 243, 243, 243),
              blurRadius: 2,
              spreadRadius: 1)
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // icon
          title == "Total Reviews"
              ? Icon(
                  icon,
                  size: 55,
                  color: Utils.lightGreyColor3,
                )
              : Image.asset(
                  icon,
                  width: 50,
                  height: 50,
                ),

          // count and title column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // count
              title == "Total Products"
                  ? TotalProductsCount(
                      sellerId: sellerId,
                    )
                  : title == "Total Orders"
                      ? StreamProvider.value(
                          initialData: null,
                          value: OrderServices().getSellerSoldItemsStream(
                              SellerModel(docId: sellerId)),
                          child: const TotalOrdersCount())
                      : title == "Total Earned"
                          ? StreamProvider.value(
                              initialData: null,
                              value: OrderServices().getSellerTotalEarnedStream(
                                  SellerModel(docId: sellerId)),
                              child: const TotalEarnedCount())
                          : title == "Total Reviews"
                              ? StreamProvider.value(
                                  initialData: null,
                                  value: SellerServices()
                                      .getTotalReviewsCountStream(
                                          SellerModel(docId: sellerId)),
                                  child: const TotalReviewsCount())
                              : const SizedBox(),

              // title
              Text(
                title,
                style: Utils.kAppCaption2RegularStyle,
              )
            ],
          )
        ],
      ),
    );
  }
}

// total products count number widget
class TotalProductsCount extends StatefulWidget {
  TotalProductsCount({required this.sellerId});

  String sellerId;

  @override
  State<TotalProductsCount> createState() => _TotalProductsCountState();
}

class _TotalProductsCountState extends State<TotalProductsCount> {
  int? productsCount;

  // get seller products count
  _getSellerProductsCount() async {
    final count = await SellerServices()
        .getSellerProductsCount(SellerModel(docId: widget.sellerId));

    if (count != null) {
      setState(() {
        productsCount = count;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSellerProductsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      productsCount != null ? productsCount.toString() : "...",
      style: Utils.kAppBody2BoldStyle,
    );
  }
}

// total orders count
class TotalOrdersCount extends StatefulWidget {
  const TotalOrdersCount({super.key});

  @override
  State<TotalOrdersCount> createState() => _TotalOrdersCountState();
}

class _TotalOrdersCountState extends State<TotalOrdersCount> {
  @override
  Widget build(BuildContext context) {
    final ordersCount = Provider.of<String?>(context);

    return Text(
      ordersCount ?? "...",
      style: Utils.kAppBody2BoldStyle,
    );
  }
}

// total earned count
class TotalEarnedCount extends StatefulWidget {
  const TotalEarnedCount({super.key});

  @override
  State<TotalEarnedCount> createState() => _TotalEarnedCountState();
}

class _TotalEarnedCountState extends State<TotalEarnedCount> {
  @override
  Widget build(BuildContext context) {
    final totalEarnedCount = Provider.of<String?>(context);

    return Text(
      totalEarnedCount ?? "...",
      style: Utils.kAppBody2BoldStyle,
    );
  }
}

// total reviews count
class TotalReviewsCount extends StatefulWidget {
  const TotalReviewsCount({super.key});

  @override
  State<TotalReviewsCount> createState() => _TotalReviewsCountState();
}

class _TotalReviewsCountState extends State<TotalReviewsCount> {
  @override
  Widget build(BuildContext context) {
    final totalReviewsCount = Provider.of<String?>(context);

    return Text(
      totalReviewsCount ?? "...",
      style: Utils.kAppBody2BoldStyle,
    );
  }
}

// orders in queue widget
class OrdersInQueue extends StatefulWidget {
  const OrdersInQueue({super.key});

  @override
  State<OrdersInQueue> createState() => _OrdersInQueueState();
}

class _OrdersInQueueState extends State<OrdersInQueue> {
  @override
  Widget build(BuildContext context) {
    final inProgressOrders = Provider.of<List<OrderModel>?>(context);

    return inProgressOrders == null
        ? Utils.circularProgressIndicator
        : Column(
            children: inProgressOrders
                .map((inProgressOrder) =>
                    OrderCard.forHomeTab(orderModel: inProgressOrder))
                .toList(),
          );
  }
}
