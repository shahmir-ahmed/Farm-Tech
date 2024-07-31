import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTabView extends StatefulWidget {
  const ProductTabView({super.key});

  @override
  State<ProductTabView> createState() => _ProductTabViewState();
}

class _ProductTabViewState extends State<ProductTabView> {
  // products list from stream
  List<ProductModel> productsList = [];

  // get and set product main image from storage
  _setProductImages() async {
    for (var i = 0; i < productsList.length; i++) {
      // based on image count get main image of product
      if (productsList[i].imagesCount == 1) {
        // get image
        final imageUrl = await ProductServices()
            .getProductMainImage(productsList[i].docId as String);

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
            .getProductMainImage("${productsList[i].docId}_1");

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
    // consume stream
    final products = Provider.of<List<ProductModel>?>(context);

    // if products are supplied and first product main image path is not set
    if (products != null && productsList.isEmpty) {
      productsList = products;
      // get product image/first image
      _setProductImages();
    }

    // print('products $products');
    // print('productsList $productsList');

    return products == null
        ? const Center(
            child: CircularProgressIndicator(
              color: Utils.greenColor,
              backgroundColor: Utils.lightGreyColor1,
            ),
          )
        // grid view
        : SizedBox(
            height: 340,
            child: GridView.count(
                childAspectRatio: 0.74,
                crossAxisCount: 2,
                children: productsList.map((productModel) {
                  // individual product container
                  return GestureDetector(
                    onTap: () {
                      // show product details screen
                    },
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Utils.greyColor, width: 0.1),
                      ),
                      child: Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // product image
                          productModel.mainImageUrl!.isEmpty
                              ?
                              // Image.asset(
                              //     'assets/images/carousel-image-1.png',
                              //     height: 160,
                              //   )
                              const SizedBox(
                                  height: 160,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Utils.greenColor,
                                      backgroundColor: Utils.lightGreyColor1,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.network(
                                    productModel.mainImageUrl!,
                                    height: 160,
                                  ),
                                ),

                          // space
                          const SizedBox(
                            height: 10,
                          ),

                          // product price and rating row
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  productModel.price.toString(),
                                  style: Utils.kAppCaptionBoldStyle,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Utils.greenColor,
                                      size: 11,
                                    ),
                                    Text(
                                      ' 5.0',
                                      style: Utils.kAppCaption2MediumStyle,
                                    )
                                  ],
                                )
                              ]),

                          // space
                          const SizedBox(
                            height: 10,
                          ),

                          // product name
                          Text(
                            productModel.title as String,
                            style: Utils.kAppCaptionMediumStyle
                                .copyWith(color: Utils.greyColor),
                          )
                        ],
                      )),
                    ),
                  );
                }).toList()
                // ..sort((a, b) =>
                //     b.createdAt.compareTo(a.createdAt))
                ));
  }
}
