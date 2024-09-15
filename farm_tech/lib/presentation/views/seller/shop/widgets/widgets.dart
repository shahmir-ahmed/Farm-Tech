import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/product_reviews.dart';
import 'package:farm_tech/backend/model/review.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/shared/item_details/item_details_view.dart';
import 'package:farm_tech/presentation/views/seller/widgets/ratings_reviews_view.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// product tab view
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
    // consume stream
    final products = Provider.of<List<ProductModel>?>(context);

    // if products are supplied and products list is empty
    if (products != null && productsList.isEmpty) {
      // print('first product doc id ${products.first.docId}');
      productsList = products;
      // get product image/first image
      _setProductImages();
    }

    // print('products $products');
    // print('productsList $productsList');

    return products == null
        ? Utils.circularProgressIndicator
        // grid view
        : SizedBox(
            height: 340,
            child: ProductsGridView(
                children: productsList.map((productModel) {
              // product card with stream of product reviews data supplied
              return StreamProvider.value(
                  initialData: null,
                  value:
                      ProductServices().getProductAvgRatingStream(productModel),
                  child: ProductCard(
                    productModel: productModel,
                    setOrderTabAsActive: () {},
                  ));
            }).toList()
                // ..sort((a, b) =>
                //     b.createdAt.compareTo(a.createdAt))
                ));
  }
}

// individual product container/card in grid view
class ProductCard extends StatelessWidget {
  ProductCard(
      {required this.productModel,
      this.forBuyer,
      required this.setOrderTabAsActive});

  // for buyer
  bool? forBuyer;

  ProductModel productModel;

  VoidCallback setOrderTabAsActive;

  @override
  Widget build(BuildContext context) {
    // consume product avg rating stream
    final productAvgRating = Provider.of<String?>(context);

    // print('productsList: ${productModel.mainImageUrl}');

    // print('productReviewsData $productReviewsData');

    // if (productReviewsData != null) {
    //   print(
    //       'productReviewsData ${productReviewsModelToJson(productReviewsData)}');
    // }

    return GestureDetector(
      onTap: () {
        if (productAvgRating != null) {
          // show product details screen for buyer
          if (forBuyer != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StreamProvider.value(
                        initialData: null,
                        value: ProductServices().getProductStream(productModel),
                        child: ItemDetailsView(
                          avgRating: productAvgRating,
                          forBuyer: true,
                          setOrderTabAsActive: setOrderTabAsActive,
                        ))));
          } else {
            // show product details screen for seller
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StreamProvider.value(
                        initialData: null,
                        value: ProductServices().getProductStream(productModel),
                        child: ItemDetailsView(
                          avgRating: productAvgRating,
                          setOrderTabAsActive: () {},
                        ))));
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          border: Border.all(color: Utils.greyColor, width: 0.1),
        ),
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
                    child: Utils.circularProgressIndicator,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SizedBox(
                      width: 165,
                      height: 160,
                      child: Image.network(
                        fit: BoxFit.fill,
                        productModel.mainImageUrl!,
                        // height: 160,
                      ),
                    ),
                  ),

            // space
            const SizedBox(
              height: 10,
            ),

            // product price and rating row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "PKR ${productModel.price.toString()}",
                          style: Utils.kAppCaptionBoldStyle,
                        ),
                        Row(
                          children: [
                            productAvgRating != null
                                ? productAvgRating == "0"
                                    ? SizedBox()
                                    : const Icon(
                                        Icons.star,
                                        color: Utils.greenColor,
                                        size: 11,
                                      )
                                : SizedBox(),
                            Text(
                              " ${productAvgRating != null ? productAvgRating == "0" ? "" : productAvgRating : 5.0}",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// info tab view
class InfoTabView extends StatelessWidget {
  InfoTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // consume seller data stream here
    final sellerData = Provider.of<SellerModel?>(context);

    return sellerData == null
        ? const SizedBox(
            height: 200,
            child: Utils.circularProgressIndicator,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // shop name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shop name:  ',
                        style: Utils.kAppBody2MediumStyle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.5),
                          child: Text(
                            '${sellerData.shopName}',
                            style: Utils.kAppBody3RegularStyle,
                          ),
                        ),
                      )
                    ],
                  ),

                  // space
                  const SizedBox(
                    height: 20,
                  ),

                  // shop location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shop location:  ',
                        style: Utils.kAppBody2MediumStyle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.5),
                          child: Text(
                            '${sellerData.shopLocation}',
                            style: Utils.kAppBody3RegularStyle,
                          ),
                        ),
                      )
                    ],
                  ),

                  // space
                  const SizedBox(
                    height: 20,
                  ),

                  // shop description
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shop description:  ',
                        style: Utils.kAppBody2MediumStyle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.5),
                          child: Text(
                            '${sellerData.shopDescription}',
                            style: Utils.kAppBody3RegularStyle,
                          ),
                        ),
                      )
                    ],
                  ),

                  // space
                  const SizedBox(
                    height: 35,
                  ),

                  // seller name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name:  ',
                        style: Utils.kAppBody2MediumStyle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.5),
                          child: Text(
                            '${sellerData.name}',
                            style: Utils.kAppBody3RegularStyle,
                          ),
                        ),
                      )
                    ],
                  ),

                  // space
                  const SizedBox(
                    height: 20,
                  ),

                  // contact
                  Row(
                    children: [
                      Text(
                        'Contact number:  ',
                        style: Utils.kAppBody2MediumStyle,
                      ),
                      Text(
                        '${sellerData.contactNo}',
                        style: Utils.kAppBody3RegularStyle,
                      )
                    ],
                  ),

                  // space
                  const SizedBox(
                    height: 20,
                  ),

                  // cnic
                  Row(
                    children: [
                      Text(
                        'CNIC number:  ',
                        style: Utils.kAppBody2MediumStyle,
                      ),
                      Text(
                        '${sellerData.cnicNo}',
                        style: Utils.kAppBody3RegularStyle,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

// carousel slider for upload product and view item details screen
class ProductImagesCarousel extends StatelessWidget {
  ProductImagesCarousel(
      {required this.controller,
      required this.onPageChanged,
      required this.productImages,
      required this.current,
      required this.carouselHeight,
      this.forUploadProductScreen,
      this.forItemDetailsScreen});

  carousel.CarouselSliderController controller;
  void Function(int) onPageChanged;
  List productImages;
  int current;
  double carouselHeight;
  bool? forUploadProductScreen;
  bool? forItemDetailsScreen;

  @override
  Widget build(BuildContext context) {
    // images slider
    return Stack(children: [
      // carousel
      carousel.CarouselSlider(
        carouselController: controller,
        options: carousel.CarouselOptions(
            viewportFraction: 1.0,
            height: carouselHeight,
            // height: MediaQuery.of(context).size.height - 100,
            onPageChanged: (index, reason) => onPageChanged(index)),
        items: productImages.asMap().entries.map((entry) {
          return Builder(
            builder: (BuildContext context) {
              // single slider widget
              return SizedBox(
                // height: 200.0,
                // width: 340.0,
                width: MediaQuery.of(context).size.width,
                child: productImages.length >= entry.key + 1
                    ? forUploadProductScreen != null
                        ? Image.file(
                            productImages[entry.key]!,
                            // fit: BoxFit.cover,
                          )
                        : Image.network(
                            productImages[entry.key]!,
                            fit: BoxFit.cover,
                          )
                    : Container(
                        color: Utils.lightGreyColor1,
                      ),
              );
            },
          );
        }).toList(),
      ),
      // indicator row
      SizedBox(
        height: carouselHeight,
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: productImages.asMap().entries.map((entry) {
                return GestureDetector(
                    onTap: () => controller.animateToPage(entry.key),
                    child: Container(
                        width: 7.0,
                        // width: 7.0,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: current == entry.key
                                ? Utils.whiteColor
                                : Utils.lightGreyColor1)));
              }).toList(),
            ),
          ),
        ),
      ),
    ]);
  }
}


