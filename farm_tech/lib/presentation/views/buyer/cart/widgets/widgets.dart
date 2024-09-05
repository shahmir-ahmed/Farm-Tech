import 'package:farm_tech/backend/model/cart_item.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/product_reviews.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/shared/item_details/item_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// single cart item card
class CartItemCard extends StatefulWidget {
  CartItemCard(
      {super.key,
      required this.cartItemModel,
      required this.removeClicked,
      required this.checkBoxValue,
      required this.onCheckBoxClicked,
      required this.onRemoveClicked,
      required this.setOrderTabAsActive});

  CartItemModel cartItemModel;
  bool removeClicked;
  bool checkBoxValue;
  VoidCallback onCheckBoxClicked;
  VoidCallback onRemoveClicked;
  VoidCallback setOrderTabAsActive;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  String productImageUrl = '';
  String productName = '';
  String productCategory = '';

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
    // get cart item main image
    getProductMainImage(widget.cartItemModel.productId!);
    // get cart item name
    getProductName(widget.cartItemModel.productId!);
    // get cart item category
    getProductCategory(widget.cartItemModel.productId!);
  }

  @override
  Widget build(BuildContext context) {
    // widget tree
    return Column(
      children: [
        // divider
        Utils.divider,

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // product details
              Row(
                children: [
                  widget.removeClicked
                      ?
                      // show checkbox
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomCheckbox(
                                value: widget.checkBoxValue,
                                onChanged: widget.onCheckBoxClicked),
                          ],
                        )
                      : SizedBox(),

                  widget.removeClicked
                      ?
                      // space
                      const SizedBox(
                          width: 20,
                        )
                      : SizedBox(),

                  // image
                  productImageUrl.isEmpty
                      ? const SizedBox(
                          width: 90, child: Utils.circularProgressIndicator)
                      : GestureDetector(
                          onTap: () {
                            // show product details screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StreamProvider.value(
                                        value: ProductServices()
                                            .getProductAvgRatingStream(
                                                ProductModel(
                                                    docId: widget.cartItemModel
                                                        .productId)),
                                        initialData: null,
                                        child: CartItemDetailsViewBridge(
                                          productModel: ProductModel(
                                              docId: widget
                                                  .cartItemModel.productId),
                                          setOrderTabAsActive:
                                              widget.setOrderTabAsActive,
                                        ))));
                          },
                          child: Image.network(
                            productImageUrl,
                            width: 90,
                            height: 80,
                          ),
                        ),

                  // Image.asset(
                  //   'assets/images/featured-product-image-4.jpg',
                  //   width: 90,
                  //   height: 80,
                  // ),

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (productName.isNotEmpty) {
                                  // show product details screen
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StreamProvider.value(
                                                  value: ProductServices()
                                                      .getProductAvgRatingStream(
                                                          ProductModel(
                                                              docId: widget
                                                                  .cartItemModel
                                                                  .productId)),
                                                  initialData: null,
                                                  child:
                                                      CartItemDetailsViewBridge(
                                                    productModel: ProductModel(
                                                        docId: widget
                                                            .cartItemModel
                                                            .productId),
                                                    setOrderTabAsActive: widget
                                                        .setOrderTabAsActive,
                                                  ))));
                                }
                              },
                              child: Text(
                                productName.isEmpty
                                    ? "Product Name"
                                    : productName,
                                style: Utils.kAppBody3MediumStyle,
                              ),
                            ),
                            widget.removeClicked
                                ? SizedBox()
                                :
                                // remove text
                                GestureDetector(
                                    onTap: widget.onRemoveClicked,
                                    child: Text(
                                      'Remove',
                                      style: Utils.kAppBody3MediumStyle
                                          .copyWith(color: Utils.greenColor),
                                    ),
                                  ),
                          ],
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
                              "PKR ${widget.cartItemModel.total!}",
                              // "PKR 900",
                              style: Utils.kAppBody2MediumStyle
                                  .copyWith(color: Utils.greenColor),
                            ),

                            // quantity
                            Text(
                              'Qty: ${widget.cartItemModel.quantity}',
                              // "Qty: 1",
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
        // Utils.divider,
      ],
    );
  }
}

// cart item and item details view bridge widget for product reviews i.e. avg rating data consumer
class CartItemDetailsViewBridge extends StatefulWidget {
  CartItemDetailsViewBridge(
      {required this.productModel, required this.setOrderTabAsActive});

  ProductModel productModel;
  VoidCallback setOrderTabAsActive;

  @override
  State<CartItemDetailsViewBridge> createState() =>
      _CartItemDetailsViewBridgeState();
}

class _CartItemDetailsViewBridgeState extends State<CartItemDetailsViewBridge> {
  @override
  Widget build(BuildContext context) {
    // consume product reviews data stream
    final productAvgRating = Provider.of<String?>(context);

    print('productAvgRating: $productAvgRating');

    return StreamProvider.value(
      value: ProductServices().getProductStream(widget.productModel),
      initialData: null,
      child: ItemDetailsView(
        forBuyer: true,
        avgRating: productAvgRating == null ? "0" : productAvgRating,
        setOrderTabAsActive: widget.setOrderTabAsActive,
      ),
    );
  }
}

// custom checkbox
class CustomCheckbox extends StatefulWidget {
  CustomCheckbox({
    Key? key,
    this.width = 28.0,
    this.height = 28.0,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final double width;
  final double height;
  // Now you can set the checkmark size of your own
  final bool value;
  VoidCallback onChanged;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      // setState(() => isChecked = !isChecked);
      // widget.onChanged?.call(isChecked);

      // },
      onTap: () => widget.onChanged(),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.value ? Utils.greenColor : Utils.lightGreyColor3,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: widget.value ? Utils.greenColor : Utils.whiteColor,
        ),
        child: widget.value
            ? Icon(
                Icons.check,
                size: 18,
                color: Utils.whiteColor,
              )
            : null,
      ),
    );
  }
}
