// all orders tab view
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/orders/order_details_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllOrdersTabView extends StatelessWidget {
  const AllOrdersTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // consume orders stream
    final sellerOrders = Provider.of<List<OrderModel>?>(context);

    // print('sellerOrders $sellerOrders');

    // if (sellerOrders != null) {
    //   for (var i = 0; i < sellerOrders.length; i++) {
    //     print('sellerOrders ${orderModelToJson(sellerOrders[i])}');
    //   }
    // }

    // widget tree
    return sellerOrders == null
        ? const SizedBox(
            height: 300,
            child: Utils.circularProgressIndicator,
          )
        : Column(
            children: [
              // divider
              Utils.divider,

              // row
              Column(
                  children: sellerOrders.map((orderModel) {
                // single order card
                return OrderCard(orderModel: orderModel);
              }).toList())
            ],
          );
  }
}

// in progress orders tab view
class InProgressOrdersTabView extends StatelessWidget {
  const InProgressOrdersTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // consume orders stream
    final sellerOrders = Provider.of<List<OrderModel>?>(context);

    // print('sellerOrders $sellerOrders');

    // widget tree
    return sellerOrders == null
        ? const SizedBox(
            height: 300,
            child: Utils.circularProgressIndicator,
          )
        : Column(
            children: [
              // divider
              Utils.divider,

              // row
              Column(
                  children: sellerOrders
                      .where(
                          (sellerOrder) => sellerOrder.status == "In Progress")
                      .map((orderModel) {
                // single order card
                return OrderCard(orderModel: orderModel);
              }).toList())
            ],
          );
  }
}

// completed orders tab view
class CompletedOrdersTabView extends StatelessWidget {
  const CompletedOrdersTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // consume orders stream
    final sellerOrders = Provider.of<List<OrderModel>?>(context);

    // widget tree
    return sellerOrders == null
        ? const SizedBox(
            height: 300,
            child: Utils.circularProgressIndicator,
          )
        : Column(
            children: [
              // divider
              Utils.divider,

              // row
              Column(
                  children: sellerOrders
                      .where((sellerOrder) => sellerOrder.status == "Completed")
                      .map((orderModel) {
                // single order card
                return OrderCard(orderModel: orderModel);
              }).toList())
            ],
          );
  }
}

// cancelled orders tab view
class CancelledOrdersTabView extends StatelessWidget {
  const CancelledOrdersTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // consume orders stream
    final sellerOrders = Provider.of<List<OrderModel>?>(context);

    // widget tree
    return sellerOrders == null
        ? const SizedBox(
            height: 300,
            child: Utils.circularProgressIndicator,
          )
        : Column(
            children: [
              // divider
              Utils.divider,

              // row
              Column(
                  children: sellerOrders
                      .where((sellerOrder) => sellerOrder.status == "Cancelled")
                      .map((orderModel) {
                // single order card
                return OrderCard(orderModel: orderModel);
              }).toList())
            ],
          );
  }
}

// single order card
class OrderCard extends StatefulWidget {
  OrderCard({required this.orderModel});

  OrderModel orderModel;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String productImageUrl = '';
  String productName = '';
  String productCategory = '';

  String convertStringToNumber(String input) {
    return input.codeUnits.map((unit) => unit.toString()).join();
  }

  String extractDateFromTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
    DateFormat dateFormat =
        DateFormat('dd MMMM yyyy'); // Specify the date format
    return dateFormat.format(dateTime); // Format and return the date part
  }

  Future? getProductName(String productId) async {
    final obj = await ProductServices().getProductName(productId);

    if (obj != null) {
      setState(() {
        productName = obj.title!;
      });
    } else {
      return null;
    }
  }

  Future? getProductCategory(String productId) async {
    final obj = await ProductServices().getProductCategory(productId);

    if (obj != null) {
      setState(() {
        productCategory = obj.category!;
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
            productImageUrl = imageUrl;
          });
        } else {
          return null;
        }
      } else {
        final imageUrl = await ProductServices().getProductImage(productId);

        if (imageUrl != null) {
          setState(() {
            productImageUrl = imageUrl;
          });
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get order product main image
    getProductMainImage(widget.orderModel.productId!);
    // get order product name
    getProductName(widget.orderModel.productId!);
    // get order product category
    getProductCategory(widget.orderModel.productId!);
  }

  @override
  Widget build(BuildContext context) {
    // widget tree
    return GestureDetector(
      onTap: () {
        if (productName.isEmpty ||
            productCategory.isEmpty ||
            productImageUrl.isEmpty) {
          // not show details screen
        } else {
          // show order details screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailsView(
                      orderModel: widget.orderModel,
                      orderId: convertStringToNumber(widget.orderModel.docId!)
                          .substring(0, 7),
                      orderDate: extractDateFromTimestamp(
                          widget.orderModel.createdAt!),
                      productModel: ProductModel(
                          title: productName,
                          category: productCategory,
                          mainImageUrl: productImageUrl))));
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
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
                          color: widget.orderModel.status == "In Progress"
                              ? Colors.orange
                              : widget.orderModel.status == "Completed"
                                  ? Utils.greenColor
                                  : widget.orderModel.status == "Cancelled"
                                      ? Colors.red
                                      : Colors.black),
                    ),
                  ],
                ),

                // space
                const SizedBox(
                  height: 10,
                ),

                // row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date placed',
                      style: Utils.kAppCaptionMediumStyle
                          .copyWith(color: Utils.greyColor2),
                    ),
                    Text(
                      extractDateFromTimestamp(widget.orderModel.createdAt!),
                      style: Utils.kAppCaptionMediumStyle
                          .copyWith(color: Utils.greyColor2),
                    ),
                  ],
                ),

                // space
                const SizedBox(
                  height: 20,
                ),

                // product details
                Row(
                  children: [
                    // image
                    productImageUrl.isEmpty
                        ? const SizedBox(
                            width: 90, child: Utils.circularProgressIndicator)
                        : Image.network(
                            productImageUrl,
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
                          Text(
                            productName.isEmpty ? "Product Name" : productName,
                            style: Utils.kAppBody3MediumStyle,
                          ),

                          // space
                          const SizedBox(
                            height: 5,
                          ),

                          // category
                          Text(
                            productCategory.isEmpty
                                ? 'Category'
                                : productCategory,
                            style: Utils.kAppCaptionMediumStyle
                                .copyWith(color: Utils.greyColor2),
                          ),

                          // space
                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // price
                              Text(
                                "PKR ${widget.orderModel.totalAmount!}",
                                style: Utils.kAppBody2MediumStyle
                                    .copyWith(color: Utils.greenColor),
                              ),

                              // quantity
                              Text(
                                'Qty: ${widget.orderModel.quantity} Kg',
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
          Utils.divider,
        ],
      ),
    );
  }
}
