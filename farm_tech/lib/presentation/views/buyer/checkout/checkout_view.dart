import 'package:farm_tech/backend/model/cart_item.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/profile/change_address_view.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CheckoutView extends StatefulWidget {
  CheckoutView({required this.cartItems});

  List<CartItemModel> cartItems;

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
    // print('cartItems: ${widget.cartItems}');

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
                              builder: (context) => const ChangeAddressView()));
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

            // address
            
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
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Add Items',
                      style: Utils.kAppBody3RegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                  )
                ],
              ),
            ),
            // divider
            Utils.divider,

            // items view
            SizedBox(
              height: 100,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // remove item
                                  GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                      'assets/images/remove-icon.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),

                                  // space
                                  SizedBox(
                                    width: 20,
                                  ),

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
                    );
                  }),
            )
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
    return Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Libero, et sapien.',
              style:
                  Utils.kAppBody3RegularStyle.copyWith(color: Utils.greyColor),
            );
  }
}