import 'package:carousel_slider/carousel_slider.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/product_reviews_model.dart';
import 'package:farm_tech/backend/model/review.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/item_details_view.dart';
import 'package:farm_tech/presentation/views/seller/shop/ratings_reviews_view.dart';
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
        ? Utils.circularProgressIndicator
        // grid view
        : SizedBox(
            height: 340,
            child: GridView.count(
                childAspectRatio: 0.74,
                crossAxisCount: 2,
                children: productsList.map((productModel) {
                  // product card with stream of product reviews data supplied
                  return StreamProvider.value(
                      initialData: null,
                      value: ProductServices()
                          .getProductReviewsDataStream(productModel),
                      child: ProductCard(productModel: productModel));
                }).toList()
                // ..sort((a, b) =>
                //     b.createdAt.compareTo(a.createdAt))
                ));
  }
}

// individual product container
class ProductCard extends StatelessWidget {
  ProductCard({required this.productModel});

  ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    // consume product reviews data stream
    final productReviewsData = Provider.of<ProductReviewsModel?>(context);

    // print('productReviewsData $productReviewsData');

    // if (productReviewsData != null) {
    //   print(
    //       'productReviewsData ${productReviewsModelToJson(productReviewsData)}');
    // }

    return GestureDetector(
      onTap: () {
        if (productReviewsData != null) {
          // show product details screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamProvider.value(
                      initialData: null,
                      value: ProductServices().getProductStream(productModel),
                      child: ItemDetailsView(
                          avgRating: productReviewsData.avgRating!))));
        }
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
                    child: Utils.circularProgressIndicator,
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    " ${productReviewsData != null ? productReviewsData.avgRating as String : 5.0}",
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
              style:
                  Utils.kAppCaptionMediumStyle.copyWith(color: Utils.greyColor),
            )
          ],
        )),
      ),
    );
    ;
  }
}

// info tab view
class InfoTabView extends StatelessWidget {
  InfoTabView({required this.sellerModel});

  SellerModel sellerModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      '${sellerModel.shopName}',
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
                      '${sellerModel.shopLocation}',
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
                      '${sellerModel.shopDescription}',
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
                      '${sellerModel.name}',
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
                  '${sellerModel.contactNo}',
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
                  '${sellerModel.cnicNo}',
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

// reviews view inside item details view
class ReviewsView extends StatefulWidget {
  const ReviewsView({super.key});

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  // time ago function to calculate and return how much time has passed since the review posted
  String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }

  @override
  Widget build(BuildContext context) {
    // consume reviews stream here
    final reviews = Provider.of<List<ReviewModel>?>(context);

    return reviews == null
        ? const SizedBox(height: 100, child: Utils.circularProgressIndicator)
        : reviews.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'No ratings & reviews for the product.',
                  style: Utils.kAppBody2MediumStyle,
                ),
              )
            // ratings and reviews
            : Column(
                children: [
                  // label
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ratings & Reviews',
                            style: Utils.kAppBody3MediumStyle,
                          ),

                          // see all
                          GestureDetector(
                              onTap: () {
                                // show all ratings and reviews of product screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RatingsReviewsView(
                                              reviews: reviews,
                                            )));
                              },
                              child: Text(
                                'See all',
                                style: Utils.kAppCaptionRegularStyle
                                    .copyWith(color: Utils.greenColor),
                              )),
                        ],
                      )),

                  // user reviews section
                  Column(
                    children: reviews.map((reviewModel) {
                      return SingleUserRatingCard(
                        reviewModel: reviewModel,
                        timeAgo: timeAgo(reviewModel.createdAt!.toDate()),
                      );
                    }).toList(),
                  ),
                ],
              );
  }
}

// single user rating card
class SingleUserRatingCard extends StatelessWidget {
  SingleUserRatingCard({required this.reviewModel, required this.timeAgo});

  ReviewModel reviewModel;
  String timeAgo;

  @override
  Widget build(BuildContext context) {
    // individual user rating column
    return Column(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // user name
                        Text(
                          'Fareeha Sadaqat',
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // stars
                        Row(
                          children: List.generate(
                              int.parse(reviewModel.starsCount!), (index) {
                            return const Icon(
                              Icons.star,
                              color: Utils.greenColor,
                              size: 19,
                            );
                          }),
                          // children: [1, 2, 3, 4, 5].map((index) {
                          //   return const Icon(
                          //     Icons.star,
                          //     color: Utils.greenColor,
                          //     size: 19,
                          //   );
                          // }).toList(),
                        ),
                      ],
                    ),

                    // time
                    Text(
                      '$timeAgo ago',
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
        Utils.divider
      ],
    );
  }
}
