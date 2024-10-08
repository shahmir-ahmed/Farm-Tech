import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/product_reviews.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/shared/item_details/item_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// home featured section product card
class HomeFeaturedProductCard extends StatelessWidget {
  HomeFeaturedProductCard(
      {required this.productModel, required this.setOrderTabAsActive});

  ProductModel productModel;
  VoidCallback setOrderTabAsActive;

  @override
  Widget build(BuildContext context) {
    // consume product avg rating
    final productAvgRating = Provider.of<String?>(context);

    return GestureDetector(
      onTap: () {
        if (productAvgRating != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamProvider.value(
                      initialData: null,
                      value: ProductServices().getProductStream(productModel),
                      child: ItemDetailsView(
                        setOrderTabAsActive: setOrderTabAsActive,
                        avgRating: productAvgRating,
                        forBuyer: true,
                      ))));
        }
      },
      child: Container(
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
                          productAvgRating != null
                              ? productAvgRating == "0"
                                  ? SizedBox()
                                  : const Icon(
                                      Icons.star,
                                      color: Utils.greenColor,
                                      size: 13,
                                    )
                              : SizedBox(),
                          Text(
                            " ${productAvgRating != null ? productAvgRating == "0" ? "" : productAvgRating : 5.0}",
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
      ),
    );
  }
}
