import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/cart_item.dart';
import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/backend/services/cart_services.dart';
import 'package:farm_tech/backend/services/order_services.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/backend/services/stripe_service.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/checkout/order_placed_view.dart';
import 'package:farm_tech/presentation/views/buyer/checkout/payment_method_view.dart';
import 'package:farm_tech/presentation/views/buyer/profile/change_address_view.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutView extends StatefulWidget {
  CheckoutView({required this.cartItems, required this.showRemoveItemOption});

  List<CartItemModel> cartItems;
  bool showRemoveItemOption;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  List<String> cartItemProductNames = [];

  _getItemProductNames() async {
    // for every item get product name and add in the list
    for (var i = 0; i < widget.cartItems.length; i++) {
      final productModel = await ProductServices()
          .getProductName(widget.cartItems[i].productId!);
      if (productModel != null) {
        setState(() {
          cartItemProductNames.add(productModel.title!);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // get cart items products name
    _getItemProductNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar(
          'Checkout',
          [
            // three dot icon
            const Icon(
              Icons.more_vert,
              color: Utils.greenColor,
            ),
            const SizedBox(
              width: 30,
            ),
          ],
          context),
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    // print('widget.cartItems ${widget.cartItems}');

    return SingleChildScrollView(
        // main body column
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Utils.divider,

      Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // address heading text and change row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Address',
                  style: Utils.kAppBody3MediumStyle,
                ),

                // change text
                GestureDetector(
                    onTap: () {
                      // push change address view
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StreamProvider.value(
                                  value: BuyerServices().getAddressStream(
                                      BuyerModel(
                                          docId: widget.cartItems[0].buyerId)),
                                  initialData: null,
                                  child: ChangeAddressView(
                                    buyerModel: BuyerModel(
                                        docId: widget.cartItems[0].buyerId),
                                  ))));
                    },
                    child: Text(
                      'Change',
                      style: Utils.kAppBody3RegularStyle
                          .copyWith(color: Utils.greenColor),
                    ))
              ],
            ),

            // space
            SizedBox(
              height: 10,
            ),

            // address widget with stream
            StreamProvider.value(
                value: BuyerServices().getAddressStream(
                    BuyerModel(docId: widget.cartItems[0].buyerId)),
                initialData: null,
                child: AddressTextWidget()),
          ],
        ),
      ),

      // divider
      Utils.divider,

      // payment
      GestureDetector(
        onTap: () {
          // show payment method options screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaymentMethodView()));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                'Payment',
                style: Utils.kAppBody3MediumStyle,
              )),
              Row(
                children: [
                  Image.asset(
                    'assets/images/card.png',
                    width: 30,
                    height: 30,
                  ),

                  // space
                  SizedBox(
                    width: 5,
                  ),

                  // arrow
                  Image.asset(
                    'assets/images/akar-icons_chevron-right.png',
                    width: 25,
                    height: 25,
                  )
                ],
              )
            ],
          ),
        ),
      ),

      // divider
      Utils.divider,

      Container(
        color: Utils.lightGreyColor2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Order Details ',
                        style: Utils.kAppBody3MediumStyle,
                      ),
                      Text(
                        widget.cartItems.length == 1
                            ? '(1 Item)'
                            : '(${widget.cartItems.length} Items)',
                        style: Utils.kAppBody3MediumStyle
                            .copyWith(color: Utils.greenColor),
                      )
                    ],
                  ),
                  // add items text
                  // not show add item text if not showing remove button i.e. when from buy now view
                  widget.showRemoveItemOption
                      ? GestureDetector(
                          onTap: () {
                            // close checkout view
                            Navigator.pop(context);
                            // close cart view
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Add Items',
                            style: Utils.kAppBody3RegularStyle
                                .copyWith(color: Utils.greenColor),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
            // divider
            Utils.divider,

            // items view
            Column(children: [
              // if (widget.cartItems.length>=1)
              // need for loop for cart product names list (otheriwise map would have been enough for cart items list)
              // based on cart product names list count becuase it is loaded dynamically
              for (int index = 0; index < cartItemProductNames.length; index++)
                // single item
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // remove item
                              widget.showRemoveItemOption
                                  ? GestureDetector(
                                      onTap: () {
                                        // show confirm dialog to remove item from cart
                                        Utils.showConfirmAlertDialog(context,
                                            () async {
                                          // close alert dialog
                                          Navigator.pop(context);

                                          // show loading alert dialog
                                          Utils.showLoadingAlertDialog(
                                              context, 'remove_cart_item');

                                          // remove item from user cart in db
                                          final result = await CartServices()
                                              .removeItemFromCart(CartItemModel(
                                                  docId: widget
                                                      .cartItems[index].docId));

                                          if (result == 'success') {
                                            // reomve item from widget cart items list and cart product names list
                                            setState(() {
                                              cartItemProductNames
                                                  .removeAt(index);
                                            });
                                            widget.cartItems.removeAt(index);

                                            print(
                                                'cartItemProductNames $cartItemProductNames');

                                            print(
                                                'widget.cartItems ${widget.cartItems}');

                                            // if removing cart items cart becomes empty then close checkout screen
                                            if (widget.cartItems.isEmpty) {
                                              Navigator.pop(context);
                                            }

                                            // show success message
                                            floatingSnackBar(
                                                message:
                                                    'Item removed from cart successfully',
                                                context: context);
                                          } else {
                                            // show error message
                                            floatingSnackBar(
                                                message:
                                                    'Error removing item. Please try again later',
                                                context: context);
                                          }

                                          // close loading alert dialog
                                          Navigator.pop(context);
                                        }, 'cart_single_item');
                                      },
                                      child: Image.asset(
                                        'assets/images/remove-icon.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : SizedBox(),

                              // space
                              widget.showRemoveItemOption
                                  ? SizedBox(
                                      width: 20,
                                    )
                                  : SizedBox(),

                              // item product name
                              Text(
                                '${cartItemProductNames[index].isEmpty ? "" : cartItemProductNames[index]}',
                                style: Utils.kAppBody3RegularStyle,
                              ),

                              // space
                              SizedBox(
                                width: 10,
                              ),

                              // quantity
                              Text(
                                'x${widget.cartItems[index].quantity}',
                                style: Utils.kAppBody3RegularStyle
                                    .copyWith(color: Utils.greenColor),
                              ),
                            ],
                          ),

                          // price
                          Text(
                            'PKR ${widget.cartItems[index].total}',
                            style: Utils.kAppBody3RegularStyle,
                          )
                        ],
                      ),
                    ),

                    // divider
                    Utils.divider
                  ],
                )
            ])
          ],
        ),
      ),

      // space
      SizedBox(
        height: 80,
      ),

      // divider
      Utils.divider,

      // subtotal row
      Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: Utils.kAppBody3RegularStyle,
                ),
                Text(
                  'PKR ${widget.cartItems.fold(0, (previousValue, cartItemModel) => previousValue + int.parse(cartItemModel.total!))}',
                  style: Utils.kAppBody3MediumStyle,
                ),
              ],
            ),
          ),
          // divider
          Utils.divider
        ],
      ),

      // shipping fee row
      Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping fee',
                  style: Utils.kAppBody3RegularStyle,
                ),
                Text(
                  'PKR 100',
                  style: Utils.kAppBody3MediumStyle,
                ),
              ],
            ),
          ),
          // divider
          Utils.divider
        ],
      ),

      // total row
      Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Utils.kAppBody3RegularStyle,
                ),
                Text(
                  'PKR ${widget.cartItems.fold(0, (previousValue, cartItemModel) => previousValue + int.parse(cartItemModel.total!)) + 100}',
                  style: Utils.kAppBody2BoldStyle,
                ),
              ],
            ),
          ),
        ],
      ),

      // pay now button
      Padding(
        padding: EdgeInsets.all(20),
        child: CustomButton(
          onButtonPressed: () async {
            // calculate total
            final total = widget.cartItems.fold(
                    0,
                    (previousValue, cartItemModel) =>
                        previousValue + int.parse(cartItemModel.total!)) +
                100;

            // convert total in pkr to usd
            final totalInUSD = total / 278;

            // make payment using stripe
            final result =
                await StripeService.instance.makePayment(totalInUSD.floor());

            if (result == null) {
              // show error message
              floatingSnackBar(
                  message: 'Error processing payment. Please try again later',
                  context: context);
            } else {
              if(widget.cartItems.length==1){
                // show loading alert
              Utils.showLoadingAlertDialog(context, 'placing_order');
              }else{

              // show loading alert
              Utils.showLoadingAlertDialog(context, 'placing_orders');
              }

              // results list of orders docs creation
              List results = [];

              // not placed orders list due to error feteching product seller id
              List notPlacedOrderNames = [];

              // payment success so
              // create order doc for each cart item
              for (var i = 0; i < widget.cartItems.length; i++) {
                // get product seller id
                final productModel = await ProductServices().getProductSellerId(
                    ProductModel(docId: widget.cartItems[i].productId));

                // if error fetching seller id
                if (productModel != null) {
                  final result = await OrderServices().createOrder(OrderModel(
                      quantity: widget.cartItems[i].quantity,
                      totalAmount: widget.cartItems[i].total,
                      status: "In Progress",
                      productId: widget.cartItems[i].productId,
                      customerId: widget.cartItems[0].buyerId,
                      sellerId: productModel.sellerId));

                  /*
                  // If above doc is not created then how will this be created?
                  // if error creating order doc
                  if (result == null) {
                    final result = await OrderServices().createOrder(OrderModel(
                        quantity: widget.cartItems[i].quantity,
                        totalAmount: widget.cartItems[i].total,
                        status: "Not placed",
                        productId: widget.cartItems[i].productId,
                        customerId: widget.cartItems[0].buyerId,
                        sellerId: productModel
                            .sellerId)); // create order doc with status as not placed

                    // cannot do anything if err in creating doc here
                  }
                  */

                  // add result in list
                  results.add(result);
                } else {
                  // order not placed due to error fetching seller id
                  // add cart item name in not placed orders list to show to user at end that this product name order cannot be placed
                  final result = await OrderServices().createOrder(OrderModel(
                      quantity: widget.cartItems[i].quantity,
                      totalAmount: widget.cartItems[i].total,
                      status: "Not placed",
                      productId: widget.cartItems[i].productId,
                      customerId: widget.cartItems[0].buyerId,
                      sellerId:
                          "")); // create order doc with empty seller id and status as not placed

                  // cannot do anything if err in creating order doc here

                  // add result in list
                  results.add(result);

                  // add cart item product name in list
                  notPlacedOrderNames.add(cartItemProductNames[i]);
                }
              }

              // cart items removing results list
              List results2 = [];

              // remove all items from cart
              for (var i = 0; i < widget.cartItems.length; i++) {
                // not remove item from cart for which order doc creation error occured
                if (results[i] != null) {
                  // remove item from cart
                  final result = await CartServices()
                      .removeItemFromCart(widget.cartItems[i]);

                  // add result in list
                  results2.add(result);
                }
              }

              // close loading alert dialog
              Navigator.pop(context);

              // close checkout screen
              Navigator.pop(context);

              // no error in creating order doc/docs & no orders marked as not placed
              if (!results.contains(null) && notPlacedOrderNames.isEmpty) {
                print('All orders placed');

                // close cart screen
                Navigator.pop(context);

                // show order placed screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderPlacedView()));

                // floatingSnackBar(
                //     message: 'Orders placed successfully', context: context);
              }

              // orders not placed due to error in creating order doc
              if (results.contains(null)) {
                // product names
                String errPlacingOrderNames = "";

                // create product names string
                for (var i = 0; i < results.length; i++) {
                  // err result cart item index
                  if (results[i] == null) {
                    errPlacingOrderNames += "$i. ${cartItemProductNames[i]}\n";
                  }
                }

                // show error
                // if null result count is 1
                if (results.where((result) => result == null).length == 1) {
                  floatingSnackBar(
                      message:
                          'Error placing order for product: $errPlacingOrderNames.Please request a refund.',
                      context: context,
                      duration: Duration(seconds: 4));
                } else {
                  floatingSnackBar(
                      message:
                          'Error placing order for products: $errPlacingOrderNames.Please request a refund.',
                      context: context,
                      duration: Duration(seconds: 4));
                }
              }

              // orders not placed due to error getting seller id
              if (notPlacedOrderNames.isNotEmpty) {
                // product names concatenated string
                String notPlacedOrderNames = "";

                // concatenate product names
                for (var i = 0; i < notPlacedOrderNames.length; i++) {
                  notPlacedOrderNames += i < notPlacedOrderNames.length - 1
                      ? "${notPlacedOrderNames[i]}, "
                      : notPlacedOrderNames[i];
                }

                // show error
                if (notPlacedOrderNames.length == 1) {
                  floatingSnackBar(
                      message:
                          'Error placing order for product: $notPlacedOrderNames.\nPlease request a refund.',
                      context: context,
                      duration: Duration(seconds: 4));
                } else {
                  floatingSnackBar(
                      message:
                          'Error placing order for products: $notPlacedOrderNames.\nPlease request a refund.',
                      context: context,
                      duration: Duration(seconds: 4));
                }
              }

              // if error in removing cart items
              if (results2.where((result) => result == null).length == 1) {
                floatingSnackBar(
                    message: 'Error removing item from cart', context: context);
              } else if (results2.where((result) => result == null).length >
                  1) {
                floatingSnackBar(
                    message: 'Error removing items from cart',
                    context: context);
              } else {
                // items removed from cart
                print('All items removed from cart');
              }
            }
          },
          buttonText: 'Pay Now',
          primaryButton: true,
          secondaryButton: false,
          buttonWidth: MediaQuery.of(context).size.width,
          buttonHeight: 60,
        ),
      ),
    ]));
  }
}

class AddressTextWidget extends StatefulWidget {
  const AddressTextWidget({super.key});

  @override
  State<AddressTextWidget> createState() => _AddressTextWidgetState();
}

class _AddressTextWidgetState extends State<AddressTextWidget> {
  @override
  Widget build(BuildContext context) {
    // consume buyer address stream
    final buyerModel = Provider.of<BuyerModel?>(context);

    return buyerModel == null
        ? Container(
            margin: EdgeInsets.only(left: 8),
            child: SizedBox(
              height: 20,
              width: 20,
              child: Center(
                child: Utils.circularProgressIndicator,
              ),
            ),
          )
        : Text(
            buyerModel.address!.isEmpty
                ? "No address provided."
                : buyerModel.address!,
            style: Utils.kAppBody3RegularStyle.copyWith(color: Utils.greyColor),
          );
  }
}
