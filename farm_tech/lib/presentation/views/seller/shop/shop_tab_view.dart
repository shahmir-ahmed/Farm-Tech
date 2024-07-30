import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/product/upload_product_view.dart';
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

  String profileImageUrl = '';

  String uId = '';

  // get user uid
  _getUserUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      uId = pref.getString("uId") as String;
    });
  }

  _getSellerImage(String docId) async {
    final sellerModel =
        await SellerServices().getProfileImage(SellerModel(docId: docId));

    if (sellerModel != null) {
      setState(() {
        profileImageUrl = sellerModel.profileImageUrl as String;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserUid(); // get user uid to show products
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // show add product screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UploadProductView()));
        },
        foregroundColor: Utils.whiteColor,
        backgroundColor: Utils.greenColor,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      backgroundColor: Utils.whiteColor,
      appBar: AppBar(
        backgroundColor: Utils.whiteColor,
        title: Text(
          'Store Profile',
          style: Utils.kAppHeading6BoldStyle,
        ),
        actions: const [
          // search icon
          Icon(
            Icons.search,
            color: Utils.greenColor,
          ),
          SizedBox(
            width: 15,
          ),
          // settings icon
          Icon(
            Icons.settings,
            color: Utils.greenColor,
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    // consume seller data stream here
    final sellerData = Provider.of<SellerModel?>(context);

    print('sellerData $sellerData');

    if (sellerData != null && profileImageUrl.isEmpty) {
      // get seller image path
      _getSellerImage(sellerData.docId as String);
    }

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
                CircleAvatar(
                  backgroundImage: profileImageUrl.isEmpty
                      ? const AssetImage('assets/images/asad-ali.png')
                      : NetworkImage(profileImageUrl),
                  radius: 50,
                ),
                // space
                const SizedBox(
                  height: 5,
                ),

                // name
                Text(
                  sellerData != null ? sellerData.name as String : "",
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
                      ' 5.0 ',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                    Text(
                      '(154 Reviews)',
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
                            '1022',
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
                    ? uId.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Utils.greenColor,
                              backgroundColor: Utils.lightGreyColor1,
                            ),
                          )
                        : StreamProvider.value(
                            initialData: null,
                            value: ProductServices()
                                .getProductsStream(SellerModel(docId: uId)),
                            child: ProductTabView())
                    :
                    // info container
                    Container(
                        child: const Center(child: Text('Info')),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
