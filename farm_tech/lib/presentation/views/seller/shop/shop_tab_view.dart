import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/model/seller_reviews_model.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/upload_product_view.dart';
import 'package:farm_tech/presentation/views/seller/shop/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopTabView extends StatefulWidget {
  const ShopTabView({super.key});

  @override
  State<ShopTabView> createState() => _ShopTabViewState();
}

class _ShopTabViewState extends State<ShopTabView> {
  bool productTabActive = true;

  SellerModel? _sellerModel;

  int? productsCount;

  // String uId = '';

  // // get user uid
  // _getUserUid() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     uId = pref.getString("uId") as String;
  //   });
  // }

  // get seller image
  _getSellerImage(SellerModel sellerModel) async {
    final profileImageUrl = await SellerServices().getProfileImage(sellerModel);

    if (profileImageUrl != null) {
      setState(() {
        _sellerModel!.profileImageUrl = profileImageUrl;
      });
    }
  }

  // get seller products count
  _getSellerProductsCount(SellerModel sellerModel) async {
    final count = await SellerServices().getSellerProductsCount(sellerModel);

    if (count != null) {
      setState(() {
        productsCount = count;
      });
    }
  }

  // initstate method
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getUserUid(); // get user uid to show products using seller id
  }

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

      if (productsCount == null) {
        // get seller total products count
        _getSellerProductsCount(_sellerModel!);
      }
    }

    // consume seller reviews data stream here
    final sellerReviewsData = Provider.of<SellerReviewsModel?>(context);

    // print('sellerReviewsData $sellerReviewsData');

    // if (sellerReviewsData != null) {
    //   print('sellerReviewsData ${sellerReviewsModelToJson(sellerReviewsData)}');
    // }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.network(profileImageUrl)
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

                // space
                const SizedBox(
                  height: 5,
                ),

                // reviews row
                Row(
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
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                    Text(
                      ' (${sellerReviewsData != null ? sellerReviewsData.totalReviewsCount!.substring(0, 1) : 154} Reviews)',
                      style: Utils.kAppCaptionRegularStyle,
                    )
                  ],
                ),

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
                      Column(
                        children: [
                          // count
                          Text(
                            // '1022',
                            productsCount == null
                                ? "0"
                                : productsCount.toString(),
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
                      ),
                      Column(
                        children: [
                          // count
                          Text(
                            '200',
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
                      ),
                    ],
                  ),
                ),

                // space
                const SizedBox(
                  height: 40,
                ),

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
                    ? _sellerModel == null
                        ? const SizedBox()
                        : StreamProvider.value(
                            initialData: null,
                            value: ProductServices()
                                .getProductsStream(_sellerModel!),
                            child: const ProductTabView())
                    :
                    // info container
                    // Container(
                    //     child: const Center(child: Text('Info')),
                    //   )
                    _sellerModel == null
                        ? const SizedBox(
                            height: 200,
                            child: Utils.circularProgressIndicator,
                          )
                        : InfoTabView(sellerModel: _sellerModel!)
              ],
            ),
          )
        ],
      ),
    );
  }
}
