import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/widgets/widgets.dart';
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
                    child: ProductCard(productModel: productModel));
              }).toList());
  }
}
