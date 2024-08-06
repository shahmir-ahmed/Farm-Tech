import 'package:carousel_slider/carousel_controller.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/backend/services/review_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDetailsView extends StatefulWidget {
  ItemDetailsView({required this.avgRating});

  String avgRating;

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  int _current = 0;

  final CarouselController _controller = CarouselController();

  // product images file objects
  // List productImages = [
  //   "https://images.unsplash.com/photo-1722399442178-dd5a0faa2d58?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMHx8fGVufDB8fHx8fA%3D%3D",
  //   "https://plus.unsplash.com/premium_photo-1721980274417-8d3d99e69ba0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyfHx8ZW58MHx8fHx8",
  //   "https://images.unsplash.com/photo-1722343879466-7dcda68a48cc?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw1fHx8ZW58MHx8fHx8",
  // ];

  ProductModel? productModel;

  // for carousel
  onPageChanged(index) {
    setState(() {
      _current = index;
    });
  }

  _fetchProductImages() async {
    // fetch product image based on images count
    if (productModel!.imagesCount == 1) {
      final imageUrl = await ProductServices()
          .getProductImage(productModel!.docId as String);
      setState(() {
        productModel!.imageUrls!.add(imageUrl);
      });
    } else {
      // get more than one images

      int imagesCount = productModel!.imagesCount as int;

      for (var i = 0; i < imagesCount; i++) {
        final imageUrl = await ProductServices()
            .getProductImage('${productModel!.docId}_${i + 1}');
        setState(() {
          productModel!.imageUrls!.add(imageUrl);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar(
          'Item Details',
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
    // consume stream here
    final productModelFromStream = Provider.of<ProductModel?>(context);

    if (productModelFromStream != null && productModel == null) {
      productModel = productModelFromStream;
      // fetch images
      _fetchProductImages();
    }

    return productModel == null
        ? const SizedBox(height: 200, child: Utils.circularProgressIndicator)
        : SingleChildScrollView(
            // main body column
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product images carousel
                productModel!.imageUrls!.isEmpty
                    ? const SizedBox(
                        height: 200, child: Utils.circularProgressIndicator)
                    : ProductImagesCarousel(
                        controller: _controller,
                        onPageChanged: onPageChanged,
                        productImages: productModel!.imageUrls as List<dynamic>,
                        current: _current,
                        carouselHeight: 430),

                // price
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // price
                      Text(
                        'Rs ${productModel!.price.toString()}',
                        style: Utils.kAppHeading5BoldStyle,
                      ),

                      // space
                      const SizedBox(
                        height: 10,
                      ),

                      // rating
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
                                        double.parse(widget.avgRating).floor(),
                                        (index) {
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

                      // space
                      const SizedBox(
                        height: 10,
                      ),

                      // name
                      Text(
                        productModel!.title as String,
                        style: Utils.kAppBody2MediumStyle,
                      ),

                      // space
                      const SizedBox(
                        height: 30,
                      ),

                      // description label
                      Text(
                        'Description',
                        style: Utils.kAppBody3MediumStyle,
                      ),

                      // space
                      const SizedBox(
                        height: 15,
                      ),

                      // description
                      Row(
                        children: [
                          Expanded(
                            child: productModel!.description!.length > 30
                                ? ExpandableText(
                                    text: productModel!.description as String
                                    // 'New Almonds lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget nulla scelerisque turpis non. Risus accumsan risus gravida ipsum mattis pretium sed egestas. Eget. New Almonds lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget nulla scelerisque turpis non. Risus accumsan risus gravida ipsum mattis pretium sed egestas. Eget.',
                                    )
                                : Text(
                                    productModel!.description as String,
                                    style: Utils.kAppBody3RegularStyle,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // divider
                Utils.divider,

                // product reviews section with stream
                StreamProvider.value(
                  value: ReviewServices().getAllProductReviews(productModel!),
                  initialData: null,
                  child: const ReviewsView(),
                )
              ],
            ),
          );
  }
}

// expandable text widget
class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  ExpandableText({required this.text, this.maxLines = 3});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final span = TextSpan(
        text: widget.text, style: const TextStyle(color: Colors.black));
    final tp = TextPainter(
      text: span,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.text,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: Utils.kAppBody3RegularStyle,
        ),
        GestureDetector(
          onTap: toggleExpansion,
          child: Text(
            isExpanded ? 'See less' : 'See more',
            style: const TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
