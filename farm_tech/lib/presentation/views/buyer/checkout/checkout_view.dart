import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/cart_item.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/backend/services/cart_services.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
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
        onTap: () {},
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
          onButtonPressed: () {},
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
