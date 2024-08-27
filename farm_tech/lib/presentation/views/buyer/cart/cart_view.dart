import 'package:farm_tech/backend/model/cart_item.dart';
import 'package:farm_tech/backend/services/cart_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/cart/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/buyer/checkout/checkout_view.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  // any product remove button clicked
  bool _removeClicked = false;

  // items marked as checked (contains doc id of the cart item)
  List<String> checkedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar(
          'Cart',
          [
            _removeClicked
                ? Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // show confirmation dialog
                          Utils.showConfirmAlertDialog(context, () async {
                            // set remove clicked as false
                            setState(() {
                              _removeClicked = false;
                            });

                            // close alert dialog
                            Navigator.pop(context);

                            // show loading alert dialog based on length of removing items
                            if (checkedItems.length == 1) {
                              Utils.showLoadingAlertDialog(
                                  context, 'remove_cart_item');
                            } else {
                              Utils.showLoadingAlertDialog(
                                  context, 'remove_cart_items');
                            }

                            // results list
                            List results = [];

                            // remove items from carts collection present in checked items list
                            for (var i = 0; i < checkedItems.length; i++) {
                              final result = await CartServices()
                                  .removeItemFromCart(
                                      CartItemModel(docId: checkedItems[i]));

                              // print('result $i: $result');

                              results.add(result);
                            }

                            // close loading alert dialog
                            Navigator.pop(context);

                            // if removing any item error occured
                            if (results.contains(null)) {
                              if (checkedItems.length == 1) {
                                floatingSnackBar(
                                    message:
                                        'Error removing item. Please try again later',
                                    context: context);
                              } else {
                                floatingSnackBar(
                                    message:
                                        'Error removing items. Please try again later',
                                    context: context);
                              }
                            } else {
                              if (checkedItems.length == 1) {
                                // show success message for single item removed
                                floatingSnackBar(
                                    message:
                                        'Item removed from cart successfully',
                                    context: context);
                              } else {
                                // show success message
                                floatingSnackBar(
                                    message:
                                        'Items removed from cart successfully',
                                    context: context);
                              }
                            }
                          },
                              checkedItems.length == 1
                                  ? 'cart_single_item'
                                  : 'cart');
                        },
                        child: Text(
                          'Remove',
                          style: Utils.kAppBody3MediumStyle
                              .copyWith(color: Utils.greenColor),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  )
                :
                // search icon
                Row(
                    children: [
                      SizedBox(
                        width: 25,
                        child:
                            Image.asset('assets/images/icon@search-active.png'),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
          ],
          context),
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    // consume cart items stream
    final cartItems = Provider.of<List<CartItemModel>?>(context);

    // print('cartItems $cartItems');

    if (cartItems != null) {
      // sort cart items based on createdAt timestamp
      cartItems.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    }

    return cartItems == null
        ? SizedBox(
            height: 200,
            child: Center(
              child: Utils.circularProgressIndicator,
            ),
          )
        : cartItems.isEmpty
            ? SizedBox(
                // height: MediaQuery.of(context).size.height,
                height: 200,
                child: Center(
                  child: Text(
                    'Your cart is empty.',
                    style: Utils.kAppBody2RegularStyle,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // cart items
                        Column(
                          children: cartItems.map((cartItemModel) {
                            return CartItemCard(
                                key: Key(cartItemModel.docId!),
                                cartItemModel: cartItemModel,
                                removeClicked: _removeClicked,
                                checkBoxValue:
                                    checkedItems.contains(cartItemModel.docId)
                                        ? true
                                        : false,
                                onCheckBoxClicked: () {
                                  // if not added then add other wise remove
                                  if (!checkedItems
                                      .contains(cartItemModel.docId)) {
                                    // add this cart item doc id in check items list
                                    setState(() {
                                      checkedItems.add(cartItemModel.docId!);
                                    });
                                  } else {
                                    // remove this cart item doc id from check items list
                                    setState(() {
                                      checkedItems.remove(cartItemModel.docId);
                                    });
                                  }
                                },
                                onRemoveClicked: () {
                                  setState(() {
                                    // set remove clicked as true
                                    _removeClicked = true;

                                    // add this item doc id in checked items list
                                    checkedItems.add(cartItemModel.docId!);
                                  });
                                });
                          }).toList(),
                        ),

                        // proceed to checkout button
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CustomButton(
                            onButtonPressed: () {
                              // print('cartItems $cartItems');
                              // show checkout view with cart items passed to view
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckoutView(
                                            cartItems: cartItems,
                                            showRemoveItemOption: true,
                                          )));
                            },
                            buttonText: 'Proceed To Checkout',
                            primaryButton: true,
                            secondaryButton: false,
                            buttonWidth: MediaQuery.of(context).size.width,
                            buttonHeight: 60,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
  }
}
