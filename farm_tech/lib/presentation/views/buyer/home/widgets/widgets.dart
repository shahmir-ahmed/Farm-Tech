import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/product_reviews_model.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// home featured section product card
class HomeFeaturedProductCard extends StatelessWidget {
  HomeFeaturedProductCard({required this.productModel});

  ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    // consume product reviews data stream
    final productReviewsData = Provider.of<ProductReviewsModel?>(context);

    return Container(
      margin:
          // number == 1
          //     ? EdgeInsets.fromLTRB(0, 0, 10, 0)
          //     :
          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      width: 185,
      height: 275,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Utils.whiteColor,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 235, 235, 235),
              spreadRadius: 0.3,
              blurRadius: 4,
              // offset: Offset(0.5, 2)
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // product image
          productModel.mainImageUrl!.isEmpty
              ? SizedBox(
                  height: 180,
                  child: Center(
                    child: Utils.circularProgressIndicator,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    fit: BoxFit.cover,
                    productModel.mainImageUrl!,
                    // number == 1
                    //     ? 'assets/images/featured-product-image-$number.png'
                    //     : 'assets/images/featured-product-image-$number.jpg',
                    width: 210,
                    height: 180,
                  ),
                ),

          // space
          const SizedBox(
            height: 10,
          ),

          // price and rating row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PKR ${productModel.price}',
                      style: Utils.kAppCaptionBoldStyle,
                    ),

                    // rating row
                    Row(
                      children: [
                        productReviewsData != null
                            ? productReviewsData.avgRating == "0"
                                ? SizedBox()
                                : const Icon(
                                    Icons.star,
                                    color: Utils.greenColor,
                                    size: 13,
                                  )
                            : SizedBox(),
                        Text(
                          " ${productReviewsData != null ? productReviewsData.avgRating == "0" ? "" : productReviewsData.avgRating! : 5.0}",
                          style: Utils.kAppCaption2MediumStyle,
                        )
                      ],
                    )
                  ],
                ),
                // space
                const SizedBox(
                  height: 10,
                ),

                // product name
                Text(
                  productModel.title!,
                  style: Utils.kAppCaption2MediumStyle
                      .copyWith(color: Utils.lightGreyColor1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
