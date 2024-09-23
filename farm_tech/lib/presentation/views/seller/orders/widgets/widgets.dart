import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/review.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/backend/services/review_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/orders/feedback_view.dart';
import 'package:farm_tech/presentation/views/seller/orders/order_details_view.dart';
import 'package:farm_tech/presentation/views/seller/shop/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/seller/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// all orders tab view
class AllOrdersTabView extends StatelessWidget {
  AllOrdersTabView({super.key});
  AllOrdersTabView.forSellerSearch({super.key, required this.searchQuery});
  AllOrdersTabView.forBuyer({super.key, this.forBuyer = true});
  AllOrdersTabView.forBuyerSearch(
      {super.key, this.forBuyer = true, required this.searchQuery});

  bool? forBuyer;
  String? searchQuery;

  @override
  Widget build(BuildContext context) {
    // consume orders stream
    final orders = Provider.of<List<OrderModel>?>(context);

    // print('orders $orders');

    // if (orders != null) {
    //   for (var i = 0; i < orders.length; i++) {
    //     print('orders ${orderModelToJson(orders[i])}');
    //   }
    // }

    if (orders != null) {
      // Sort the orders first
      orders.sort((a, b) => b.createdAt!.compareTo(
          a.createdAt!)); // Sort in descending order (from latest to oldest)
    }

    // widget tree
    return orders == null
        ? const SizedBox(
            height: 300,
            child: Utils.circularProgressIndicator,
          )
        : Column(
            children: [
              // divider
              Utils.divider,

              orders.isEmpty
                  ? SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          'No orders',
                          style: Utils.kAppBody2MediumStyle,
                        ),
                      ),
                    )
                  // column of searched order cards
                  : searchQuery != null
                      ? Column(
                          children: orders.map((orderModel) {
                          // single order card
                          return forBuyer != null
                              ? searchQuery != null
                                  ? OrderCard.forBuyerSearch(
                                      orderModel: orderModel,
                                      searchQuery: searchQuery)
                                  : OrderCard.forBuyer(
                                      key: Key(orderModel.docId!),
                                      orderModel: orderModel)
                              : searchQuery != null
                                  ? OrderCard.forSellerSearch(
                                      orderModel: orderModel,
                                      searchQuery: searchQuery)
                                  : OrderCard(
                                      key: Key(orderModel.docId!),
                                      orderModel: orderModel);
                        }).toList())
                      :
                      // column of order cards
                      Column(
                          children: orders.map((orderModel) {
                          // single order card
                          return forBuyer != null
                              ? OrderCard.forBuyer(
                                  key: Key(orderModel.docId!),
                                  orderModel: orderModel)
                              : OrderCard(
                                  key: Key(orderModel.docId!),
                                  orderModel: orderModel);
                        }).toList())
            ],
          );
  }
}

// in progress orders tab view
class InProgressOrdersTabView extends StatelessWidget {
  InProgressOrdersTabView({super.key});
  InProgressOrdersTabView.forSellerSearch(
      {super.key, required this.searchQuery});
  InProgressOrdersTabView.forBuyer({super.key, this.forBuyer = true});
  InProgressOrdersTabView.forBuyerSearch(
      {super.key, this.forBuyer = true, required this.searchQuery});

  bool? forBuyer;
  String? searchQuery;

  @override
  Widget build(BuildContext context) {
    // consume orders stream
    final orders = Provider.of<List<OrderModel>?>(context);

    // print('orders $orders');

    if (orders != null) {
      // Sort the orders first
      orders.sort((a, b) => b.createdAt!.compareTo(
          a.createdAt!)); // Sort in descending order (from latest to oldest)
    }

    // widget tree
    return orders == null
        ? const SizedBox(
            height: 300,
            child: Utils.circularProgressIndicator,
          )
        : Column(
            children: [
              // divider
              Utils.divider,

              orders.where((order) => order.status == "In Progress").isEmpty
                  ? SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          'No in progress orders',
                          style: Utils.kAppBody2MediumStyle,
                        ),
                      ),
                    )
                  :
                  // column of order cards
                  Column(
                      children: orders
                          .where((order) => order.status == "In Progress")
                          .map((orderModel) {
                      // single order card
                      return forBuyer != null
                          ? searchQuery != null
                              ? OrderCard.forBuyerSearch(
                                  orderModel: orderModel,
                                  searchQuery: searchQuery)
                              : OrderCard.forBuyer(
                                  key: Key(orderModel.docId!),
                                  orderModel: orderModel)
                          : searchQuery != null
                              ? OrderCard.forSellerSearch(
                                  orderModel: orderModel,
                                  searchQuery: searchQuery)
                              : OrderCard(
                                  key: Key(orderModel.docId!),
                                  orderModel: orderModel);
                    }).toList())
            ],
          );
  }
}

// completed orders tab view
class CompletedOrdersTabView extends StatelessWidget {
  CompletedOrdersTabView({super.key});
  CompletedOrdersTabView.forSellerSearch(
      {super.key, required this.searchQuery});
  CompletedOrdersTabView.forBuyer({super.key, this.forBuyer = true});
  CompletedOrdersTabView.forBuyerSearch(
      {super.key, this.forBuyer = true, required this.searchQuery});

  bool? forBuyer;
  String? searchQuery;

  @override
  Widget build(BuildContext context) {
    // consume orders stream
    final orders = Provider.of<List<OrderModel>?>(context);

    if (orders != null) {
      // Sort the orders first
      orders.sort((a, b) => b.createdAt!.compareTo(
          a.createdAt!)); // Sort in descending order (from latest to oldest)
    }

    // widget tree
    return orders == null
        ? const SizedBox(
            height: 300,
            child: Utils.circularProgressIndicator,
          )
        : Column(
            children: [
              // divider
              Utils.divider,

              orders.where((order) => order.status == "Completed").isEmpty
                  ? SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          'No completed orders',
                          style: Utils.kAppBody2MediumStyle,
                        ),
                      ),
                    )
                  :
                  // column of order cards
                  Column(
                      children: orders
                          .where((order) => order.status == "Completed")
                          .map((orderModel) {
                      // single order card
                      return forBuyer != null
                          ? searchQuery != null
                              ? OrderCard.forBuyerSearch(
                                  orderModel: orderModel,
                                  searchQuery: searchQuery)
                              : OrderCard.forBuyer(
                                  key: Key(orderModel.docId!),
                                  orderModel: orderModel)
                          : searchQuery != null
                              ? OrderCard.forSellerSearch(
                                  orderModel: orderModel,
                                  searchQuery: searchQuery)
                              : OrderCard(
                                  key: Key(orderModel.docId!),
                                  orderModel: orderModel);
                    }).toList())
            ],
          );
  }
}

// cancelled orders tab view
class CancelledOrdersTabView extends StatelessWidget {
  CancelledOrdersTabView({super.key});
  CancelledOrdersTabView.forBuyer({super.key, this.forBuyer = true});
  CancelledOrdersTabView.forSellerSearch(
      {super.key, required this.searchQuery});
  CancelledOrdersTabView.forBuyerSearch(
      {super.key, this.forBuyer = true, required this.searchQuery});

  bool? forBuyer;
  String? searchQuery;

  @override
  Widget build(BuildContext context) {
    // consume orders stream
    final orders = Provider.of<List<OrderModel>?>(context);

    if (orders != null) {
      // Sort the orders first
      orders.sort((a, b) => b.createdAt!.compareTo(
          a.createdAt!)); // Sort in descending order (from latest to oldest)
    }

    // widget tree
    return orders == null
        ? const SizedBox(
            height: 300,
            child: Utils.circularProgressIndicator,
          )
        : Column(
            children: [
              // divider
              Utils.divider,

              orders.where((order) => order.status == "Cancelled").isEmpty
                  ? SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          'No cancelled orders',
                          style: Utils.kAppBody2MediumStyle,
                        ),
                      ),
                    )
                  :
                  // column of order cards
                  Column(
                      children: orders
                          .where((order) => order.status == "Cancelled")
                          .map((orderModel) {
                      // single order card
                      return forBuyer != null
                          ? searchQuery != null
                              ? OrderCard.forBuyerSearch(
                                  orderModel: orderModel,
                                  searchQuery: searchQuery)
                              : OrderCard.forBuyer(
                                  key: Key(orderModel.docId!),
                                  orderModel: orderModel)
                          : searchQuery != null
                              ? OrderCard.forSellerSearch(
                                  orderModel: orderModel,
                                  searchQuery: searchQuery)
                              : OrderCard(
                                  key: Key(orderModel.docId!),
                                  orderModel: orderModel);
                    }).toList())
            ],
          );
  }
}

// single order card
class OrderCard extends StatefulWidget {
  OrderCard({super.key, required this.orderModel});
  OrderCard.forHomeTab(
      {super.key, required this.orderModel, this.forHomeTab = true});
  OrderCard.forBuyer(
      {super.key, required this.orderModel, this.forBuyer = true});
  OrderCard.forBuyerSearch(
      {super.key,
      required this.orderModel,
      this.forBuyer = true,
      required this.searchQuery});
  OrderCard.forSellerSearch(
      {super.key, required this.orderModel, required this.searchQuery});
  OrderCard.forBuyerBottomSheet(
      {super.key,
      required this.orderModel,
      this.forBuyer = true,
      this.forOrderDetailsBottomSheet = true,
      required this.productModel});

  OrderModel orderModel;
  bool? forHomeTab;
  bool? forBuyer;
  bool? forOrderDetailsBottomSheet;
  ProductModel?
      productModel; // for order details bottom sheet because need name, image, category of product already in bottom sheet

  // searched text of product name
  String? searchQuery;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  // String productImageUrl = '';
  // String productName = '';
  // String productCategory = '';
  ProductModel _productModel = ProductModel(
      title: "", category: "", mainImageUrl: ""); // order product model

  bool?
      orderReviewExists; // for buyer order card to check that order review exists or not then on tap show post feedback option in bottom sheet

  // order review model for buyer order details bottom sheet if order review exists
  ReviewModel? orderReviewModel;

  String convertStringToNumber(String input) {
    return input.codeUnits.map((unit) => unit.toString()).join();
  }

  String extractDateFromTimestampForSeller(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
    DateFormat dateFormat =
        DateFormat('dd MMMM yyyy'); // Specify the date format
    return dateFormat.format(dateTime); // Format and return the date part
  }

  String extractDateFromTimestampForBuyer(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    DateFormat dateFormat = DateFormat('EEEE, d');
    // String formattedDate = dateFormat.format(dateTime);
    // String day = formattedDate.split(', ')[1];
    String suffix = daySuffix(dateTime.day);

    DateFormat monthYearFormat = DateFormat('MMM yyyy');
    String monthYear = monthYearFormat.format(dateTime);

    return '${dateFormat.format(dateTime)}$suffix $monthYear';
  }

  // format date, time for order placed, payment approved time
  String formatDateTimeForOrderPlacedPaymentApproved(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

    DateFormat dateFormat = DateFormat('d MMM yyyy, h:mm a');
    return dateFormat.format(dateTime);
  }

  // get product name
  Future? getProductName(String productId) async {
    final obj = await ProductServices().getProductName(productId);

    if (obj != null) {
      setState(() {
        _productModel.title = obj.title!;
      });
    } else {
      return null;
    }
  }

  Future? getProductCategory(String productId) async {
    final obj = await ProductServices().getProductCategory(productId);

    if (obj != null) {
      setState(() {
        _productModel.category = obj.category!;
      });
    } else {
      return null;
    }
  }

  Future? getProductMainImage(String productId) async {
    // get images count
    final obj = await ProductServices().getProductImagesCount(productId);

    if (obj != null) {
      // based on images count get main image
      if (obj.imagesCount! > 1) {
        final imageUrl =
            await ProductServices().getProductImage("${productId}_1");

        if (imageUrl != null) {
          setState(() {
            _productModel.mainImageUrl = imageUrl;
          });
        } else {
          return null;
        }
      } else {
        final imageUrl = await ProductServices().getProductImage(productId);

        if (imageUrl != null) {
          setState(() {
            _productModel.mainImageUrl = imageUrl;
          });
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
  }

  // buyer order details bottom sheet
  _showBuyerOrderDetailsBottomSheet() {
    // print('orderReviewExists in bottom sheet: $orderReviewExists');
    showModalBottomSheet<void>(
      // isScrollControlled: true,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            // height: 500,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // space
                  SizedBox(
                    height: 20,
                  ),

                  // text and cross icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Details',
                        style: Utils.kAppHeading6BoldStyle,
                      ),

                      // cross icon
                      GestureDetector(
                        onTap: () {
                          // close bottom sheet
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Utils.greenColor,
                          size: 30,
                        ),
                      )
                    ],
                  ),

                  // space
                  SizedBox(
                    height: 25,
                  ),

                  // order card (with main image, name, category passed)
                  OrderCard.forBuyerBottomSheet(
                    orderModel: widget.orderModel,
                    productModel: _productModel,
                  ),

                  // space
                  SizedBox(
                    height: 25,
                  ),

                  // history
                  Text(
                    'History',
                    style: Utils.kAppHeading6BoldStyle,
                  ),

                  // space
                  SizedBox(
                    height: 20,
                  ),

                  // two columns inside one row for status
                  Row(
                    children: [
                      // tick column
                      Column(
                        children: [
                          // space
                          // SizedBox(
                          //   height: 10,
                          // ),

                          // order placed and payment approved tick image
                          Image.asset(
                            'assets/images/completed-order-milestones-image.png',
                            width: 35,
                          ),

                          // if status is in progress then show incompleted icon in front of order delivered status, if completed then show completed, if cancelled then show cancelled
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Image.asset(
                              widget.orderModel.status == 'In Progress'
                                  ? 'assets/images/incompleted-icon.png'
                                  : widget.orderModel.status == 'Completed'
                                      ? 'assets/images/completed-icon.png'
                                      : 'assets/images/cancelled-icon.png',
                              width: 28,
                            ),
                          )
                        ],
                      ),

                      // space
                      SizedBox(
                        width: 20,
                      ),

                      // status texts column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // space
                          // SizedBox(
                          //   height: 5,
                          // ),

                          // order placed
                          Text(
                            'Order Placed',
                            style: Utils.kAppBody3MediumStyle,
                          ),
                          Text(
                            formatDateTimeForOrderPlacedPaymentApproved(
                                widget.orderModel.createdAt!),
                            style: Utils.kAppCaptionMediumStyle
                                .copyWith(color: Utils.greyColor2),
                          ),

                          // space
                          SizedBox(
                            height: 52,
                          ),

                          // payment approved
                          Text(
                            'Payment Approved',
                            style: Utils.kAppBody3MediumStyle,
                          ),
                          Text(
                            formatDateTimeForOrderPlacedPaymentApproved(
                                widget.orderModel.createdAt!),
                            style: Utils.kAppCaptionMediumStyle
                                .copyWith(color: Utils.greyColor2),
                          ),

                          // space
                          SizedBox(
                            height: 53,
                          ),

                          // order delivered
                          Text(
                            widget.orderModel.status == 'Cancelled'
                                ? 'Order Not Delivered'
                                : widget.orderModel.status == 'In Progress'
                                    ? 'Order Delivery Pending'
                                    : 'Order Delivered',
                            style: Utils.kAppBody3MediumStyle,
                          ),
                          // dont show time if in progress
                          widget.orderModel.status == 'In Progress'
                              ? Text('')
                              : Text(
                                  formatDateTimeForOrderPlacedPaymentApproved(
                                      widget.orderModel.updatedAt!),
                                  style: Utils.kAppCaptionMediumStyle
                                      .copyWith(color: Utils.greyColor2),
                                ),
                        ],
                      )
                    ],
                  ),

                  // space for button
                  widget.orderModel.status == 'Completed'
                      ? SizedBox(
                          height: 40,
                        )
                      : SizedBox(),

                  // show give feedback button if order is completed and order review does not exists
                  widget.orderModel.status == 'Completed' && !orderReviewExists!
                      ? CustomButton(
                          onButtonPressed: () {
                            // show feedback screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeedbackView(
                                        // review order model having buyer, product, seller id and order id
                                        reviewModel: ReviewModel(
                                          buyerId: widget.orderModel.customerId,
                                          productId:
                                              widget.orderModel.productId,
                                          sellerId: widget.orderModel.sellerId,
                                          orderId: widget.orderModel.docId,
                                        ),
                                        checkOrderReviewExists:
                                            _checkOrderReviewExists)));
                          },
                          buttonText: 'Give feedback',
                          primaryButton: true,
                          secondaryButton: false,
                          buttonHeight: 60,
                          buttonWidth: MediaQuery.of(context).size.width,
                        )
                      // if order review exists then
                      // show customer review card
                      : widget.orderModel.status == 'Completed' &&
                              orderReviewExists!
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // text
                                Text(
                                  'Your Review',
                                  style: Utils.kAppBody1BoldStyle,
                                ),

                                // space
                                SizedBox(
                                  height: 10,
                                ),

                                // single user rating/review card
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SingleUserRatingCard(
                                    reviewModel: orderReviewModel!,
                                    timeAgo:
                                        timeAgo(orderReviewModel!.createdAt!),
                                    noPadding: true,
                                    noBottomDivider: true,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox() // for cancelled/ in progress orders
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // time ago function to calculate and return how much time has passed since the review posted
  String timeAgo(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }

  _checkOrderReviewExists() async {
    final result = await ReviewServices()
        .checkOrderReviewExists(ReviewModel(orderId: widget.orderModel.docId));

    // print('result from checkOrderReviewExists: $result');

    if (result != null) {
      // if order review exists then review data in model is recieved
      if (result != false) {
        setState(() {
          orderReviewExists = true;
          orderReviewModel = result;
        });
      } else {
        setState(() {
          orderReviewExists = false;
        });
      }
    }

    // print('orderReviewExists updated to: $orderReviewExists');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // product model details are already present
    if (widget.forOrderDetailsBottomSheet == null) {
      // get order product main image
      getProductMainImage(widget.orderModel.productId!);
      // get order product name
      getProductName(widget.orderModel.productId!);
      // get order product category
      getProductCategory(widget.orderModel.productId!);
    }

    // if order card for buyer
    if (widget.forBuyer != null) {
      // not check for static card inside bottom sheet
      if (widget.forOrderDetailsBottomSheet == null) {
        // if order card is for buyer then for order details bottom sheet check product review already exists or not
        _checkOrderReviewExists();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('widget.orderModel: ${widget.orderModel.toJson()}, id: ${widget.orderModel.docId}');

    // widget tree
    return widget.searchQuery != null && _productModel.title!.isNotEmpty
        ? _productModel.title!
                .toLowerCase()
                .contains(widget.searchQuery!.toLowerCase())
            ? GestureDetector(
                onTap: widget.forHomeTab != null
                    ? () {}
                    : widget.forOrderDetailsBottomSheet != null
                        ? () {}
                        : () {
                            if (_productModel.title!.isEmpty ||
                                _productModel.category!.isEmpty ||
                                _productModel.mainImageUrl!.isEmpty) {
                              // not show details screen / details bottom sheet
                            } else {
                              //  if for buyer order card
                              if (widget.forBuyer != null) {
                                // print('orderReviewExists: $orderReviewExists');
                                // order review exists variable is not null then show details bottom sheet
                                if (orderReviewExists != null) {
                                  _showBuyerOrderDetailsBottomSheet();
                                }
                              } else {
                                // show order details screen for seller
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDetailsView(
                                            orderModel: widget.orderModel,
                                            orderId: convertStringToNumber(
                                                    widget.orderModel.docId!)
                                                .substring(0, 7),
                                            orderDate:
                                                extractDateFromTimestampForSeller(
                                                    widget
                                                        .orderModel.createdAt!),
                                            productModel: _productModel)));
                              }
                            }
                          },
                // main body column
                child: Column(
                  children: [
                    Padding(
                      padding: widget.forOrderDetailsBottomSheet != null
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // if order card if or home tab
                          widget.forHomeTab != null
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "#${convertStringToNumber(widget.orderModel.docId!).substring(0, 7)}",
                                      style: Utils.kAppBody3MediumStyle,
                                    ),
                                    // status
                                    Text(
                                      widget.orderModel.status!,
                                      style: Utils.kAppBody3MediumStyle
                                          .copyWith(
                                              color: widget.orderModel.status ==
                                                      "In Progress"
                                                  ? Colors.orange
                                                  : widget.orderModel.status ==
                                                          "Completed"
                                                      ? Utils.greenColor
                                                      : widget.orderModel
                                                                  .status ==
                                                              "Cancelled"
                                                          ? Colors.red
                                                          : Colors.black),
                                    ),
                                  ],
                                ),

                          // space
                          widget.forHomeTab != null
                              ? const SizedBox()
                              : const SizedBox(
                                  height: 10,
                                ),

                          // row
                          widget.forHomeTab != null
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date placed',
                                      style: Utils.kAppCaptionMediumStyle
                                          .copyWith(color: Utils.greyColor2),
                                    ),
                                    Text(
                                      widget.forBuyer != null
                                          ? extractDateFromTimestampForBuyer(
                                              widget.orderModel.createdAt!)
                                          : extractDateFromTimestampForSeller(
                                              widget.orderModel.createdAt!),
                                      style: Utils.kAppCaptionMediumStyle
                                          .copyWith(color: Utils.greyColor2),
                                    ),
                                  ],
                                ),

                          // space
                          widget.forHomeTab != null
                              ? const SizedBox()
                              : const SizedBox(
                                  height: 20,
                                ),

                          // product details
                          Row(
                            children: [
                              // image
                              // use widget's product model for order details bottom sheet (means not use state vars but already got data in widget product model)
                              widget.forOrderDetailsBottomSheet != null
                                  ? Image.network(
                                      widget.productModel!.mainImageUrl!,
                                      width: 90,
                                      height: 80,
                                    )
                                  : _productModel.mainImageUrl!.isEmpty
                                      ? const SizedBox(
                                          width: 90,
                                          child:
                                              Utils.circularProgressIndicator)
                                      : Image.network(
                                          _productModel.mainImageUrl!,
                                          width: 90,
                                          height: 80,
                                        ),

                              // space
                              const SizedBox(
                                width: 20,
                              ),

                              // column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // name
                                    Row(
                                      children: [
                                        Text(
                                          widget.forOrderDetailsBottomSheet !=
                                                  null
                                              ? widget.productModel!.title!
                                              : _productModel.title!.isEmpty
                                                  ? "Product Name"
                                                  : _productModel.title!,
                                          style: Utils.kAppBody3MediumStyle,
                                        ),
                                        widget.forHomeTab == null
                                            ? const SizedBox()
                                            : Text(
                                                " #${convertStringToNumber(widget.orderModel.docId!).substring(0, 7)}",
                                                style: Utils
                                                    .kAppBody3MediumStyle
                                                    .copyWith(
                                                        color:
                                                            Utils.greenColor),
                                              ),
                                      ],
                                    ),

                                    // space
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    // category
                                    Text(
                                      widget.forOrderDetailsBottomSheet != null
                                          ? widget.productModel!.category!
                                          : _productModel.category!.isEmpty
                                              ? 'Category'
                                              : _productModel.category!,
                                      style: Utils.kAppCaptionMediumStyle
                                          .copyWith(color: Utils.greyColor2),
                                    ),

                                    // space
                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // price
                                        Text(
                                          "PKR ${widget.orderModel.totalAmount!}",
                                          style: Utils.kAppBody2MediumStyle
                                              .copyWith(
                                                  color: Utils.greenColor),
                                        ),

                                        // quantity
                                        Text(
                                          'Qty: ${widget.orderModel.quantity}',
                                          style: Utils.kAppCaptionMediumStyle
                                              .copyWith(
                                                  color: Utils.greyColor2),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // divider
                    // no divider for order card in buyer order details bottom sheet
                    widget.forOrderDetailsBottomSheet != null
                        ? SizedBox()
                        : Utils.divider,
                  ],
                ))
            // if product name does not contain search query then not shown card
            : SizedBox()
        // normal order tab card
        : GestureDetector(
            onTap: widget.forHomeTab != null
                ? () {}
                : widget.forOrderDetailsBottomSheet != null
                    ? () {}
                    : () {
                        if (_productModel.title!.isEmpty ||
                            _productModel.category!.isEmpty ||
                            _productModel.mainImageUrl!.isEmpty) {
                          // not show details screen / details bottom sheet
                        } else {
                          //  if for buyer order card
                          if (widget.forBuyer != null) {
                            // print('orderReviewExists: $orderReviewExists');
                            // order review exists variable is not null then show details bottom sheet
                            if (orderReviewExists != null) {
                              _showBuyerOrderDetailsBottomSheet();
                            }
                          } else {
                            // show order details screen for seller
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDetailsView(
                                        orderModel: widget.orderModel,
                                        orderId: convertStringToNumber(
                                                widget.orderModel.docId!)
                                            .substring(0, 7),
                                        orderDate:
                                            extractDateFromTimestampForSeller(
                                                widget.orderModel.createdAt!),
                                        productModel: _productModel)));
                          }
                        }
                      },
            // main body column
            child: Column(
              children: [
                Padding(
                  padding: widget.forOrderDetailsBottomSheet != null
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // if order card if or home tab
                      widget.forHomeTab != null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "#${convertStringToNumber(widget.orderModel.docId!).substring(0, 7)}",
                                  style: Utils.kAppBody3MediumStyle,
                                ),
                                // status
                                Text(
                                  widget.orderModel.status!,
                                  style: Utils.kAppBody3MediumStyle.copyWith(
                                      color: widget.orderModel.status ==
                                              "In Progress"
                                          ? Colors.orange
                                          : widget.orderModel.status ==
                                                  "Completed"
                                              ? Utils.greenColor
                                              : widget.orderModel.status ==
                                                      "Cancelled"
                                                  ? Colors.red
                                                  : Colors.black),
                                ),
                              ],
                            ),

                      // space
                      widget.forHomeTab != null
                          ? const SizedBox()
                          : const SizedBox(
                              height: 10,
                            ),

                      // row
                      widget.forHomeTab != null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date placed',
                                  style: Utils.kAppCaptionMediumStyle
                                      .copyWith(color: Utils.greyColor2),
                                ),
                                Text(
                                  widget.forBuyer != null
                                      ? extractDateFromTimestampForBuyer(
                                          widget.orderModel.createdAt!)
                                      : extractDateFromTimestampForSeller(
                                          widget.orderModel.createdAt!),
                                  style: Utils.kAppCaptionMediumStyle
                                      .copyWith(color: Utils.greyColor2),
                                ),
                              ],
                            ),

                      // space
                      widget.forHomeTab != null
                          ? const SizedBox()
                          : const SizedBox(
                              height: 20,
                            ),

                      // product details
                      Row(
                        children: [
                          // image
                          // use widget's product model for order details bottom sheet (means not use state vars but already got data in widget product model)
                          widget.forOrderDetailsBottomSheet != null
                              ? Image.network(
                                  widget.productModel!.mainImageUrl!,
                                  width: 90,
                                  height: 80,
                                )
                              : _productModel.mainImageUrl!.isEmpty
                                  ? const SizedBox(
                                      width: 90,
                                      child: Utils.circularProgressIndicator)
                                  : Image.network(
                                      _productModel.mainImageUrl!,
                                      width: 90,
                                      height: 80,
                                    ),

                          // space
                          const SizedBox(
                            width: 20,
                          ),

                          // column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // name
                                Row(
                                  children: [
                                    Text(
                                      widget.forOrderDetailsBottomSheet != null
                                          ? widget.productModel!.title!
                                          : _productModel.title!.isEmpty
                                              ? "Product Name"
                                              : _productModel.title!,
                                      style: Utils.kAppBody3MediumStyle,
                                    ),
                                    widget.forHomeTab == null
                                        ? const SizedBox()
                                        : Text(
                                            " #${convertStringToNumber(widget.orderModel.docId!).substring(0, 7)}",
                                            style: Utils.kAppBody3MediumStyle
                                                .copyWith(
                                                    color: Utils.greenColor),
                                          ),
                                  ],
                                ),

                                // space
                                const SizedBox(
                                  height: 5,
                                ),

                                // category
                                Text(
                                  widget.forOrderDetailsBottomSheet != null
                                      ? widget.productModel!.category!
                                      : _productModel.category!.isEmpty
                                          ? 'Category'
                                          : _productModel.category!,
                                  style: Utils.kAppCaptionMediumStyle
                                      .copyWith(color: Utils.greyColor2),
                                ),

                                // space
                                const SizedBox(
                                  height: 10,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // price
                                    Text(
                                      "PKR ${widget.orderModel.totalAmount!}",
                                      style: Utils.kAppBody2MediumStyle
                                          .copyWith(color: Utils.greenColor),
                                    ),

                                    // quantity
                                    Text(
                                      'Qty: ${widget.orderModel.quantity}',
                                      style: Utils.kAppCaptionMediumStyle
                                          .copyWith(color: Utils.greyColor2),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // divider
                // no divider for order card in buyer order details bottom sheet
                widget.forOrderDetailsBottomSheet != null
                    ? SizedBox()
                    : Utils.divider,
              ],
            ));
  }
}
