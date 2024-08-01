import 'package:carousel_slider/carousel_slider.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/review.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/item_details_view.dart';
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

    // if products are supplied and first product main image path is not set
    if (products != null && productsList.isEmpty) {
      // print('first product doc id ${products.first.docId}');
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StreamProvider.value(
                                  initialData: null,
                                  value: ProductServices()
                                      .getProductStream(productModel),
                                  child: ItemDetailsView())));
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

  CarouselController controller;
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
      CarouselSlider(
        carouselController: controller,
        options: CarouselOptions(
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
                            fit: BoxFit.cover,
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

// reviews
class ReviewsView extends StatefulWidget {
  const ReviewsView({super.key});

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  @override
  Widget build(BuildContext context) {
    // consume reviews stream here
    final reviews = Provider.of<List<ReviewModel>?>(context);

    return reviews == null
        ? Center(
            child: CircularProgressIndicator(
              color: Utils.greenColor,
              backgroundColor: Utils.lightGreyColor1,
            ),
          )
        : Column(
            children: reviews.map((reviewModel) {
              return
                  // individual user rating row
                  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // user image
                        Image.asset(
                          'assets/images/user-image.png',
                          width: 35,
                        ),

                        // space
                        const SizedBox(
                          width: 8,
                        ),

                        // column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // user name
                                  Text(
                                    'Fareeha Sadaqat',
                                    style: Utils.kAppBody3MediumStyle,
                                  ),

                                  // 5 stars
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [1, 2, 3, 4, 5].map((index) {
                                      return const Icon(
                                        Icons.star,
                                        color: Utils.greenColor,
                                        size: 19,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),

                              // time
                              Text(
                                reviewModel.createdAt.toString(),
                                style: Utils.kAppCaptionRegularStyle
                                    .copyWith(color: Utils.greyColor),
                              ),

                              // space
                              const SizedBox(
                                height: 10,
                              ),

                              // review
                              Text(
                                reviewModel.review as String,
                                style: Utils.kAppBody3RegularStyle,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // divider
                  // not show divider for last review
                  // index == 4
                  //     ? const SizedBox()
                  //     : 
                      const Divider(
                          height: 0.5,
                          thickness: 0.0,
                          color: Utils.lightGreyColor3,
                        ),
                ],
              );
            }).toList(),
          );
  }
}
