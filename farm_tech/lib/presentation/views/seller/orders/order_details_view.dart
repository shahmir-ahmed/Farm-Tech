import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/services/order_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  OrderDetailsView({
    required this.orderModel,
    required this.orderId,
    required this.orderDate,
    required this.productModel,
  });

  OrderModel orderModel;
  String orderId;
  String orderDate;
  ProductModel productModel;

  // show confirm alert dialog
  showConfirmAlertDialog(BuildContext context, String forOption) {
    // set up the button
    // confirm button
    Widget confirmButton = Expanded(
      child: CustomButton(
        secondaryButton: false,
        primaryButton: true,
        buttonText: 'Yes',
        onButtonPressed: () async {
          // close alert dialog
          Navigator.pop(context);

          // if for cancel order option
          if (forOption == 'cancel_order') {
            // show loading alert dialog
            Utils.showLoadingAlertDialog(context, 'cancel_order');

            // set this order status as cancelled
            final result = await OrderServices().updateOrderStatus(
                OrderModel(docId: orderModel.docId, status: "Cancelled"));

            if (result == 'success') {
              // close loading alert dialog
              Navigator.pop(context);

              // close screen
              Navigator.pop(context);

              // floating snackbar
              floatingSnackBar(message: 'Order cancelled', context: context);
            } else {
              // close loading alert dialog
              Navigator.pop(context);

              // floating snackbar
              floatingSnackBar(
                  message: 'Error cancelling order.', context: context);
            }
          } else if (forOption == 'mark_as_delivered') {
            // show loading alert dialog
            Utils.showLoadingAlertDialog(context, 'mark_as_delivered');

            // set this order status as completed
            final result = await OrderServices().updateOrderStatus(
                OrderModel(docId: orderModel.docId, status: "Completed"));

            if (result == 'success') {
              // close loading alert dialog
              Navigator.pop(context);

              // close screen
              Navigator.pop(context);

              // floating snackbar
              floatingSnackBar(
                  message: 'Order marked as delivered', context: context);
            } else {
              // close loading alert dialog
              Navigator.pop(context);

              // floating snackbar
              floatingSnackBar(
                  message: 'Error changing order status.', context: context);
            }
          }
        },
        // buttonWidth: MediaQuery.of(context).size.width,
        buttonHeight: 60,
      ),
    );
    // cancel button
    Widget cancelButton = Expanded(
      child: CustomButton(
        secondaryButton: true,
        primaryButton: false,
        buttonText: 'No',
        onButtonPressed: () async {
          // close alert dialog
          Navigator.pop(context);
        },
        // buttonWidth: MediaQuery.of(context).size.width,
        buttonHeight: 60,
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      // icon: const Icon(
      //   Icons.question_mark,
      //   size: 40,
      //   color: Utils.greenColor,
      // ),
      // contentPadding:
      //     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      backgroundColor: Utils.whiteColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          textAlign: TextAlign.center,
          forOption == "cancel_order"
              ? "Cancel Order?"
              : forOption == "mark_as_delivered"
                  ? "Mark as delivered?"
                  : "",
          style: Utils.kAppHeading6BoldStyle,
        ),
      ),
      content: Text(
        textAlign: TextAlign.center,
        forOption == "cancel_order"
            ? "Are you sure you want to cancel order?"
            : forOption == "mark_as_delivered"
                ? "Are you sure you want to mark order as delivered?"
                : "",
        style:
            Utils.kAppBody3RegularStyle.copyWith(color: Utils.lightGreyColor1),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              cancelButton,
              // space
              const SizedBox(
                width: 15,
              ),
              confirmButton
            ],
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: _getBody(context),
      backgroundColor: Utils.whiteColor,
    );
  }

  // appbar
  _getAppBar(context) {
    return Utils.getAppBar(
        'Order Details',
        [
          // three dot icon
          const Icon(
            Icons.more_vert_outlined,
            size: 30,
            color: Utils.greenColor,
          ),
          // space
          const SizedBox(
            width: 20,
          ),
        ],
        context);
  }

  // body
  _getBody(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // status row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Details',
                      style: Utils.kAppBody3MediumStyle,
                    ),
                    Text(
                      orderModel.status!,
                      style: Utils.kAppBody3MediumStyle.copyWith(
                          color: orderModel.status == "In Progress"
                              ? Colors.orange
                              : orderModel.status == "Completed"
                                  ? Utils.greenColor
                                  : orderModel.status == "Cancelled"
                                      ? Colors.red
                                      : Colors.black),
                    )
                  ],
                ),

                // space
                const SizedBox(
                  height: 20,
                ),

                // id row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID',
                      style: Utils.kAppBody3MediumStyle
                          .copyWith(color: Utils.greyColor2),
                    ),
                    Text(
                      "#$orderId",
                      style: Utils.kAppBody3MediumStyle,
                    )
                  ],
                ),

                // space
                const SizedBox(
                  height: 10,
                ),

                // order placed date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date placed',
                      style: Utils.kAppBody3MediumStyle
                          .copyWith(color: Utils.greyColor2),
                    ),
                    Text(
                      orderDate,
                      style: Utils.kAppBody3MediumStyle,
                    )
                  ],
                ),

                // space
                const SizedBox(
                  height: 10,
                ),

                // quantity row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity',
                      style: Utils.kAppBody3MediumStyle
                          .copyWith(color: Utils.greyColor2),
                    ),
                    Text(
                      "${orderModel.quantity!} Kg",
                      style: Utils.kAppBody3MediumStyle,
                    )
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
                    Image.network(
                      productModel.mainImageUrl!,
                      width: 70,
                      height: 70,
                    ),

                    // space
                    const SizedBox(
                      width: 20,
                    ),

                    // name, category
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productModel.title!,
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        const SizedBox(
                          height: 5,
                        ),

                        Text(
                          productModel.category!,
                          style: Utils.kAppBody3MediumStyle
                              .copyWith(color: Utils.greyColor2),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),

          // divider
          Utils.divider,

          // customer details
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Details',
                  style: Utils.kAppBody2MediumStyle,
                ),

                // space
                const SizedBox(
                  height: 20,
                ),

                // name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name',
                      style: Utils.kAppBody3MediumStyle
                          .copyWith(color: Utils.greyColor2),
                    ),
                    Text(
                      'Mr John Doe',
                      style: Utils.kAppBody3MediumStyle,
                    )
                  ],
                ),

                // space
                const SizedBox(
                  height: 10,
                ),

                // contact
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contact',
                      style: Utils.kAppBody3MediumStyle
                          .copyWith(color: Utils.greyColor2),
                    ),
                    Text(
                      '0333 0000000',
                      style: Utils.kAppBody3MediumStyle,
                    )
                  ],
                ),

                // space
                const SizedBox(
                  height: 10,
                ),

                // email
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Email',
                      style: Utils.kAppBody3MediumStyle
                          .copyWith(color: Utils.greyColor2),
                    ),
                    Text(
                      'johndoe@gmail.com',
                      style: Utils.kAppBody3MediumStyle,
                    )
                  ],
                ),
              ],
            ),
          ),

          // divider
          Utils.divider,

          // shipment details
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipment Details',
                  style: Utils.kAppBody2MediumStyle,
                ),

                // space
                const SizedBox(
                  height: 20,
                ),

                Text(
                  'Address',
                  style: Utils.kAppBody3MediumStyle
                      .copyWith(color: Utils.greyColor2),
                ),

                // space
                const SizedBox(
                  height: 10,
                ),

                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Libero, et sapien.',
                  style: Utils.kAppBody3MediumStyle,
                ),
              ],
            ),
          ),

          // space
          const SizedBox(
            height: 50,
          ),

          // divider
          Utils.divider,

          // subtotal
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: Utils.kAppBody2RegularStyle,
                ),
                Text(
                  "PKR ${(int.parse(orderModel.totalAmount!) - 100).toString()}",
                  style: Utils.kAppBody2MediumStyle,
                )
              ],
            ),
          ),

          // divider
          Utils.divider,

          // shipping fee
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping Fee',
                  style: Utils.kAppBody2RegularStyle,
                ),
                Text(
                  "PKR 100",
                  style: Utils.kAppBody2MediumStyle,
                )
              ],
            ),
          ),

          // divider
          Utils.divider,

          // total
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Utils.kAppBody2RegularStyle,
                ),
                Text(
                  "PKR ${orderModel.totalAmount!}",
                  style: Utils.kAppBody2BoldStyle,
                )
              ],
            ),
          ),

          // space
          const SizedBox(
            height: 20,
          ),

          // buttons
          orderModel.status == "In Progress"
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // cancel order button
                      Expanded(
                        child: CustomButton(
                            buttonHeight: 65,
                            onButtonPressed: () async {
                              // show confirm alert dialog
                              showConfirmAlertDialog(context, 'cancel_order');
                            },
                            buttonText: 'Cancel Order',
                            primaryButton: false,
                            secondaryButton: true,
                            textStyle: Utils.kAppBody3MediumStyle
                                .copyWith(color: Colors.red)),
                      ),

                      // space
                      const SizedBox(
                        width: 10,
                      ),

                      // mark as delivered button
                      Expanded(
                        child: CustomButton(
                            buttonHeight: 65,
                            onButtonPressed: () async {
                              // show confirm alert dialog
                              showConfirmAlertDialog(
                                  context, 'mark_as_delivered');
                            },
                            buttonText: 'Mark As Delivered',
                            primaryButton: true,
                            secondaryButton: false,
                            textStyle: Utils.kAppBody3BoldStyle
                                .copyWith(color: Utils.whiteColor)),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),

          // space
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
