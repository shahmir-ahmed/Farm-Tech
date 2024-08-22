import 'package:farm_tech/backend/model/cart_item.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/cart/widgets/widgets.dart';
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

  // products marked as checked (contains id of the cart product)
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
                          Utils.showConfirmAlertDialog(context, () {
                            // remove items from cart present in checked products list
                          }, 'cart');
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
    // consume cart products stream
    final cartItems = Provider.of<List<CartItemModel>?>(context);

    print('cartItems $cartItems');

    return cartItems == null
        ? SizedBox(
            height: 200,
            child: Center(
              child: Utils.circularProgressIndicator,
            ),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // divider
                Utils.divider,

                // cart products
                Column(
                  children: cartItems.map((cartItemModel) {
                    return CartItemCard(
                      cartItemModel: cartItemModel,
                        removeClicked: _removeClicked,
                        checkBoxValue:
                            checkedItems.contains(cartItemModel.docId) ? true : false,
                        onCheckBoxClicked: () {
                          // if not added then add other wise remove
                          if (!checkedItems.contains(cartItemModel.docId)) {
                            // add this cart item doc id in check products list
                            setState(() {
                              checkedItems.add(cartItemModel.docId!);
                            });
                          } else {
                            // remove this cart item doc id from check products list
                            setState(() {
                              checkedItems.remove(cartItemModel.docId);
                            });
                          }
                        },
                        onRemoveClicked: () {
                          setState(() {
                            _removeClicked = true;
                          });
                        });
                  }).toList(),
                )
              ],
            ),
          );
  }
}
