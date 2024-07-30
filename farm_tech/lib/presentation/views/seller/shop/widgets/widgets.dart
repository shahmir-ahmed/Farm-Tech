import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTabView extends StatefulWidget {
  const ProductTabView({super.key});

  @override
  State<ProductTabView> createState() => _ProductTabViewState();
}

class _ProductTabViewState extends State<ProductTabView> {
  @override
  Widget build(BuildContext context) {
    // consume stream
    final products = Provider.of<List<ProductModel>?>(context);

    print('products $products');

    return Container(
        height: 340,
        child: GridView.count(
            childAspectRatio: 0.74,
            crossAxisCount: 2,
            children: products != null
                ? products.map((productModel) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Utils.greyColor, width: 0.1),
                      ),
                      child: Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // product image
                          Image.asset(
                            'assets/images/carousel-image-1.png',
                            height: 160,
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
                                Container(
                                  child: Row(
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
                                  ),
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
                    );
                  }).toList()
                // ..sort((a, b) =>
                //     b.createdAt.compareTo(a.createdAt))

                : []));
  }
}
