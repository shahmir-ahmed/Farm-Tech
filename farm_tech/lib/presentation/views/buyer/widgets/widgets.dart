import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/shared/item_details/item_details_view.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// specific category products view
class ProductsView extends StatefulWidget {
  ProductsView({required this.title});

  String title;

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  // products list from stream
  List<ProductModel> productsList = [];

  // get and set product main image from storage
  _setProductImages() async {
    for (var i = 0; i < productsList.length; i++) {
      // based on image count get main image of product
      if (productsList[i].imagesCount == 1) {
        // print('productsList[$i].docId ${productsList[i].docId}');
        // get image
        final imageUrl = await ProductServices()
            .getProductImage(productsList[i].docId as String);

        // set image
        if (imageUrl != null) {
          setState(() {
            productsList[i].mainImageUrl = imageUrl;
          });
        }
      }
      // more than one image of product different image name
      else {
        // get image
        final imageUrl = await ProductServices()
            .getProductImage("${productsList[i].docId}_1");

        // set image
        if (imageUrl != null) {
          setState(() {
            productsList[i].mainImageUrl = imageUrl;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar(
          widget.title,
          [
            // search icon
            SizedBox(
              width: 25,
              child: Image.asset('assets/images/icon@search-active.png'),
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
    // consume category products stream here
    final categoryProducts = Provider.of<List<ProductModel>?>(context);

    // print('productsList: ${productsList.first.mainImageUrl}');

    // if products are supplied and products list is empty
    if (categoryProducts != null && productsList.isEmpty) {
      // print('first product doc id ${products.first.docId}');
      productsList = categoryProducts;
      // get product image/first image
      _setProductImages();
    }

    return categoryProducts == null
        ? SizedBox(
            height: 200,
            child: Utils.circularProgressIndicator,
          )
        : categoryProducts.isEmpty
            ? Center(
                child: Text(
                  'No products for this category yet.',
                  style: Utils.kAppBody2RegularStyle,
                ),
              )
            : ProductsGridView(
                children: productsList.map((productModel) {
                return StreamProvider.value(
                    initialData: null,
                    value: ProductServices()
                        .getProductReviewsDataStream(productModel),
                    child: ProductCard(
                      productModel: productModel,
                      forBuyer: true,
                    ));
              }).toList());
  }
}

// add to cart, buy now view
class AddToCartBuyNowView extends StatefulWidget {
  AddToCartBuyNowView(
      {required this.title,
      required this.avgRating,
      required this.productModel});

  String title;
  // avg rating
  String avgRating;
  // product model with single product image, description, price, minimum order
  ProductModel productModel;

  @override
  State<AddToCartBuyNowView> createState() => _AddToCartBuyNowViewState();
}

class _AddToCartBuyNowViewState extends State<AddToCartBuyNowView> {
  // counter field controller

  int counter = 0;

  final counterFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter = widget.productModel.minOrder!;

    counterFieldController.text = counter.toString();
    // print('counter $counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar(
          widget.title,
          [
            // share icon
            const Icon(
              Icons.share,
              color: Utils.greenColor,
            ),
            const SizedBox(
              width: 30,
            ),
          ],
          context),
      body: _getBody(context),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody(context) {
    return SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
                // product image
                image: DecorationImage(
                    fit: BoxFit.contain,
                    alignment: AlignmentDirectional.topCenter,
                    image: NetworkImage(widget.productModel.mainImageUrl!))),
            // container with border radius
            child: Container(
                margin: EdgeInsets.only(top: 220),
                decoration: const BoxDecoration(
                  color: Utils.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // product name
                    // price
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // space
                          const SizedBox(
                            height: 20,
                          ),

                          // name
                          Text(
                            widget.productModel.title as String,
                            style: Utils.kAppHeading6BoldStyle,
                          ),

                          // space
                          const SizedBox(
                            height: 10,
                          ),

                          // avg rating
                          widget.avgRating == "0"
                              ? Text(
                                  'No rating yet',
                                  style: Utils.kAppBody3MediumStyle
                                      .copyWith(fontStyle: FontStyle.italic),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // 5 stars

                                    Row(
                                        children: List.generate(
                                            double.parse(widget.avgRating)
                                                .floor(), (index) {
                                      return const Icon(
                                        Icons.star,
                                        color: Utils.greenColor,
                                        size: 19,
                                      );
                                    })),
                                    // rating
                                    Text(
                                      ' ${widget.avgRating}',
                                      style: Utils.kAppBody3MediumStyle,
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),

                    // divider
                    Utils.divider,

                    // description
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // description label
                          Text(
                            'Description',
                            style: Utils.kAppBody3MediumStyle,
                          ),

                          // space
                          const SizedBox(
                            height: 15,
                          ),

                          // decsription
                          Row(
                            children: [
                              Expanded(
                                child: widget.productModel.description!.length >
                                        30
                                    ? ExpandableText(
                                        text: widget.productModel.description
                                            as String
                                        // 'New Almonds lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget nulla scelerisque turpis non. Risus accumsan risus gravida ipsum mattis pretium sed egestas. Eget. New Almonds lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget nulla scelerisque turpis non. Risus accumsan risus gravida ipsum mattis pretium sed egestas. Eget.',
                                        )
                                    : Text(
                                        widget.productModel.description
                                            as String,
                                        style: Utils.kAppBody3RegularStyle,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // space
                    const SizedBox(
                      height: 20,
                    ),

                    // divider
                    Utils.divider,

                    // product counter, price row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // - icon
                                  GestureDetector(
                                    onTap: () {
                                      if (counter != 1 &&
                                          counter !=
                                              widget.productModel.minOrder!) {
                                        counter--;
                                        setState(() {
                                          counterFieldController.text =
                                              counter.toString();
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove_rounded,
                                      color: Utils.lightGreyColor4,
                                      size: 30,
                                    ),
                                  ),

                                  // space
                                  const SizedBox(
                                    width: 15,
                                  ),

                                  // counter field
                                  SizedBox(
                                    // width: 60,
                                    width:
                                        60, // Adjusted width to accommodate up to three digits
                                    height: 60,
                                    child: TextFormField(
                                      decoration:
                                          Utils.inputFieldDecoration.copyWith(
                                        // contentPadding: EdgeInsets.only(
                                        //     left: 23,
                                        //     top: 8,
                                        //     right: 10,
                                        //     bottom: 10),
                                        // contentPadding: EdgeInsets.all(20)
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                      ),
                                      // enabled: false,
                                      readOnly: true,
                                      // initialValue: counter.toString(),
                                      controller: counterFieldController,
                                      style: Utils.kAppHeading6MediumStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  // space
                                  const SizedBox(
                                    width: 15,
                                  ),

                                  // + icon
                                  GestureDetector(
                                    onTap: () {
                                      if (counter <
                                          widget.productModel.stockQuantity!) {
                                        counter++;
                                        setState(() {
                                          counterFieldController.text =
                                              counter.toString();
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: Utils.greenColor,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),

                              // price
                              Text(
                                'PKR ${widget.productModel.price.toString()}',
                                style: Utils.kAppBody1MediumStyle,
                              ),
                            ],
                          ),

                          // space
                          const SizedBox(
                            height: 30,
                          ),

                          // add button
                          CustomButton(
                              buttonHeight: 60,
                              onButtonPressed: () {},
                              buttonText: 'Add',
                              primaryButton: true,
                              secondaryButton: false)
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
