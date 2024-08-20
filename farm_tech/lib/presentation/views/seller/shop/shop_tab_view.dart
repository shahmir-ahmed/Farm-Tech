import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/model/seller_reviews_model.dart';
import 'package:farm_tech/backend/services/order_services.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/upload_product_view.dart';
import 'package:farm_tech/presentation/views/seller/shop/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopTabView extends StatefulWidget {
  ShopTabView({required this.sellerId});

  String sellerId;

  @override
  State<ShopTabView> createState() => _ShopTabViewState();
}

class _ShopTabViewState extends State<ShopTabView> {
  // build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppbar(),
      floatingActionButton: _getFloatingActionButton(),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  // get app bar
  _getAppbar() {
    return Utils.getTabAppBar(
        'Store Profile',
        [
          // search icon
          const Icon(
            Icons.search,
            color: Utils.greenColor,
          ),
          const SizedBox(
            width: 15,
          ),
          // settings icon
          const Icon(
            Icons.settings,
            color: Utils.greenColor,
          ),
          const SizedBox(
            width: 30,
          ),
        ],
        context);
  }

  // get floating action button
  _getFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // show add product screen
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UploadProductView()));
      },
      foregroundColor: Utils.whiteColor,
      backgroundColor: Utils.greenColor,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }

  // return body
  _getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // dp, name column
                StreamProvider.value(
                    initialData: null,
                    value: SellerServices().getSellerDataStream(
                        SellerModel(docId: widget.sellerId)),
                    child: const SellerDetails()),

                // space
                const SizedBox(
                  height: 5,
                ),

                // seller avg. rating, reviews count row
                StreamProvider.value(
                    initialData: null,
                    value: SellerServices().getSellerReviewsDataStream(
                        SellerModel(docId: widget.sellerId)),
                    child: const SellerReviewsData()),

                // space
                const SizedBox(
                  height: 20,
                ),

                // store stats
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // seller products count column
                      SellerTotalItemsCount(sellerId: widget.sellerId),

                      // seller total sold items count
                      StreamProvider.value(
                        value: OrderServices().getSellerSoldItemsStream(
                            SellerModel(docId: widget.sellerId)),
                        initialData: null,
                        child: const SellerSoldItemsCount(),
                      )
                    ],
                  ),
                ),

                // space
                const SizedBox(
                  height: 40,
                ),

                // product, info tabs container
                ProductAndInfoTabsContainer(sellerId: widget.sellerId)
              ],
            ),
          )
        ],
      ),
    );
  }
}

// seller details column
class SellerDetails extends StatefulWidget {
  const SellerDetails({super.key});

  @override
  State<SellerDetails> createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {
  SellerModel? _sellerModel;

  // get seller image
  _getSellerImage(SellerModel sellerModel) async {
    final profileImageUrl = await SellerServices().getProfileImage(sellerModel);

    if (profileImageUrl != null) {
      setState(() {
        _sellerModel!.profileImageUrl = profileImageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // consume seller data stream here
    final sellerData = Provider.of<SellerModel?>(context);

    // print('sellerData $sellerData');

    if (sellerData != null) {
      // set seller model
      _sellerModel = sellerData;

      if (_sellerModel!.profileImageUrl!.isEmpty) {
        // get seller image path
        _getSellerImage(_sellerModel!);
      }
    }

    return Column(
      children: [
        // user profile pic
        _sellerModel == null
            ? const SizedBox(
                height: 100, child: Utils.circularProgressIndicator)
            : _sellerModel!.profileImageUrl!.isEmpty
                ? const SizedBox(
                    height: 100, child: Utils.circularProgressIndicator)
                : CircleAvatar(
                    backgroundImage:
                        NetworkImage(_sellerModel!.profileImageUrl!),
                    radius: 50,
                  ),
        // space
        const SizedBox(
          height: 5,
        ),

        // name
        Text(
          _sellerModel != null ? _sellerModel!.name as String : "",
          style: Utils.kAppHeading6BoldStyle,
        ),
      ],
    );
  }
}

// seller reviews data row
class SellerReviewsData extends StatefulWidget {
  const SellerReviewsData({super.key});

  @override
  State<SellerReviewsData> createState() => _SellerReviewsDataState();
}

class _SellerReviewsDataState extends State<SellerReviewsData> {
  @override
  Widget build(BuildContext context) {
    // consume seller reviews data stream here
    final sellerReviewsData = Provider.of<SellerReviewsModel?>(context);

    // reviews row
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.star,
          color: Utils.greenColor,
          size: 10,
        ),
        Text(
          sellerReviewsData != null
              ? sellerReviewsData.avgRating as String
              : ' 5.0 ',
          style:
              Utils.kAppCaptionRegularStyle.copyWith(color: Utils.greenColor),
        ),
        Text(
          ' (${sellerReviewsData != null ? sellerReviewsData.totalReviewsCount!.substring(0, 1) : 154} Reviews)',
          style: Utils.kAppCaptionRegularStyle,
        )
      ],
    );
  }
}

// seller total items count column
class SellerTotalItemsCount extends StatefulWidget {
  SellerTotalItemsCount({required this.sellerId});

  String sellerId;

  @override
  State<SellerTotalItemsCount> createState() => _SellerTotalItemsCountState();
}

class _SellerTotalItemsCountState extends State<SellerTotalItemsCount> {
  int? productsCount;

  // get seller products count
  _getSellerProductsCount() async {
    final count = await SellerServices()
        .getSellerProductsCount(SellerModel(docId: widget.sellerId));

    if (count != null) {
      setState(() {
        productsCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if product count not set then set
    if (productsCount == null) {
      // get seller total products count
      _getSellerProductsCount();
    }

    return Column(
      children: [
        // count
        Text(
          // '1022',
          productsCount == null ? "0" : productsCount.toString(),
          style: Utils.kAppBody2BoldStyle,
        ),
        // space
        const SizedBox(
          height: 3,
        ),
        // title
        Text(
          'Total Items',
          style: Utils.kAppCaptionRegularStyle,
        ),
      ],
    );
  }
}

// seller sold items count column
class SellerSoldItemsCount extends StatefulWidget {
  const SellerSoldItemsCount({super.key});

  @override
  State<SellerSoldItemsCount> createState() => _SellerSoldItemsCountState();
}

class _SellerSoldItemsCountState extends State<SellerSoldItemsCount> {
  @override
  Widget build(BuildContext context) {
    // consume seller reviews data stream here
    final sellerSoldItemsCount = Provider.of<String?>(context);

    return Column(
      children: [
        // count
        Text(
          sellerSoldItemsCount ?? '200',
          style: Utils.kAppBody2BoldStyle,
        ),
        // space
        const SizedBox(
          height: 3,
        ),
        // title
        Text(
          'Sold Items',
          style: Utils.kAppCaptionRegularStyle,
        ),
      ],
    );
  }
}

// product, info tabs container
class ProductAndInfoTabsContainer extends StatefulWidget {
  ProductAndInfoTabsContainer({required this.sellerId});

  String sellerId;

  @override
  State<ProductAndInfoTabsContainer> createState() =>
      _ProductAndInfoTabsContainerState();
}

class _ProductAndInfoTabsContainerState
    extends State<ProductAndInfoTabsContainer> {
  bool productTabActive = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // tabs
        // primary button and secondary button
        Row(
          children: [
            // space
            const SizedBox(
              width: 30,
            ),

            Expanded(
                child: CustomButton(
              primaryButton: productTabActive ? true : false,
              secondaryButton: productTabActive ? false : true,
              onButtonPressed: () {
                if (!productTabActive) {
                  setState(() {
                    productTabActive = true;
                  });
                }
              },
              buttonText: 'Products',
              buttonHeight: 50,
            )),

            // space
            const SizedBox(
              width: 20,
            ),

            Expanded(
                child: CustomButton(
              secondaryButton: productTabActive ? true : false,
              primaryButton: productTabActive ? false : true,
              onButtonPressed: () {
                if (productTabActive) {
                  setState(() {
                    productTabActive = false;
                  });
                }
              },
              buttonText: 'Info',
              buttonHeight: 50,
            )),

            // space
            const SizedBox(
              width: 30,
            ),
          ],
        ),

        // space
        const SizedBox(
          height: 30,
        ),

        // products container
        productTabActive
            ? StreamProvider.value(
                initialData: null,
                value: ProductServices()
                    .getSellerProductsStream(SellerModel(docId: widget.sellerId)),
                child: const ProductTabView())
            :
            // info container
            // Container(
            //     child: const Center(child: Text('Info')),
            //   )
            StreamProvider.value(
                initialData: null,
                value: SellerServices()
                    .getSellerDataStream(SellerModel(docId: widget.sellerId)),
                child: InfoTabView())
      ],
    );
  }
}
