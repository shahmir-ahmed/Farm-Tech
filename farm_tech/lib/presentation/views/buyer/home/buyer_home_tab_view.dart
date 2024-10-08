import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/services/cart_services.dart';
import 'package:farm_tech/backend/services/notification_service.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/cart/cart_view.dart';
import 'package:farm_tech/presentation/views/buyer/categories/all_categories_view.dart';
import 'package:farm_tech/presentation/views/buyer/checkout/order_placed_view.dart';
import 'package:farm_tech/presentation/views/buyer/home/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/buyer/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerHomeTabView extends StatefulWidget {
  BuyerHomeTabView(
      {required this.buyerId,
      required this.buyerName,
      required this.setSearchTabAsActive,
      required this.setOrderTabAsActive});

  String buyerId;
  String buyerName;
  VoidCallback setSearchTabAsActive;
  VoidCallback setOrderTabAsActive;

  @override
  State<BuyerHomeTabView> createState() => _BuyerHomeTabViewState();
}

class _BuyerHomeTabViewState extends State<BuyerHomeTabView> {
  /*
  // logout function
  Future<void> _logoutUser() async {
    // clear shared pref data for app
    SharedPreferences pref = await SharedPreferences.getInstance();
    final cleared = await pref.clear();

    print('cleared: $cleared');
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Home!',
                        style: Utils.kAppHeading6BoldStyle,
                      ),
                      Row(
                        children: [
                          Text(
                            'Welcome ',
                            style: Utils.kAppCaptionRegularStyle
                                .copyWith(color: Utils.greyColor),
                          ),
                          Text(
                              widget.buyerName.contains(' ')
                                  ? widget.buyerName.substring(
                                      0, widget.buyerName.indexOf(' '))
                                  : widget.buyerName,
                              style: Utils.kAppCaptionRegularStyle),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      /*
                        NotificationService().sendNotificationUsingApi(token: "c6s6zeioQV25WdazY-Vc7E:APA91bE2G_bwkZxR3H9guyloVNqonbuFmmrIcbIgsYdi3rGN_DW8ZChbO7EFmU2i2lUgCmoUfKpbbBkoTM4ZHjx-kCCKxVQ6Ft15xOtUnoN7kv0J9ivwph6lY5lpupd68vD6pzs64kct", title: 'New order', body: 'Lets go', data: {});
                                  */
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StreamProvider.value(
                                  value: CartServices().getBuyerCartItemsStream(
                                      BuyerModel(docId: widget.buyerId)),
                                  initialData: null,
                                  child: CartView(
                                    setOrderTabAsActive:
                                        widget.setOrderTabAsActive,
                                  ))));

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => OrderPlacedView(
                      //               setOrderTabAsActive:
                      //                   widget.setOrderTabAsActive,
                      //             )));
                    },

                    /*
                    onTap: () async {
                      // logout user
                      await UserAuthServices().signOut();
                      await _logoutUser();
                      floatingSnackBar(
                          message: 'Logged out successfully', context: context);
                      print('user logged out');
                      floatingSnackBar(
                          message: 'Logged out successfully',
                          context: context);
                    },
                    */

                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Utils.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 235, 235, 235),
                              spreadRadius: 0.5,
                              blurRadius: 2,
                              // offset: Offset(0.5, 2)
                            )
                          ]),
                      child: StreamProvider.value(
                          initialData: null,
                          value: CartServices().getBuyerCartItemsCountStream(
                              BuyerModel(docId: widget.buyerId)),
                          child: CartIcon()),
                    ),
                  )
                  /*
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Utils.whiteColor),
                          elevation: WidgetStatePropertyAll(5)),
                      onPressed: () async {
                        /*
                        // logout user
                        await UserAuthServices().signOut();
                        await _logoutUser();
                        floatingSnackBar(
                            message: 'Logged out successfully', context: context);
                        print('user logged out');
                        // floatingSnackBar(
                        //     message: 'Logged out successfully',
                        //     context: context);
                        */
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
                        child: Image.asset(
                          'assets/images/cart-icon.png',
                          width: 25,
                        ),
                      )),
                      */
                ],
              ),
            ),

            // space
            const SizedBox(
              height: 40,
            ),

            // search field
            GestureDetector(
              onTap: widget.setSearchTabAsActive,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                child: TextField(
                  enabled: false,
                  // onTapOutside: (event){
                  //   new FocusNode().requestFocus();
                  // },
                  decoration: Utils.inputFieldDecoration.copyWith(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Image.asset(
                          'assets/images/icon@search.png',
                          width: 25,
                          height: 20,
                        ),
                      ),
                      hintText: 'Search'),
                ),
              ),
            ),

            // space
            const SizedBox(
              height: 30,
            ),

            // categories section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Utils.kAppBody3MediumStyle,
                  ),
                  // text
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllCategoriesView(
                                    setOrderTabAsActive:
                                        widget.setOrderTabAsActive,
                                  )));
                    },
                    child: Text(
                      'See all',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                  ),
                ],
              ),
            ),

            // space
            // const SizedBox(
            //   height: 20,
            // ),

            // categories
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: SizedBox(
                height: 180,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: [
                    'Crops',
                    'Livestock',
                    'Forestry',
                    'Dairy',
                    'Fish Farming',
                    'Dry Fruits',
                    'Miscellaneous'
                  ].map((title) {
                    return GestureDetector(
                      onTap: () {
                        // crops category products view screen
                        // if (title == 'Crops') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StreamProvider.value(
                                      value: ProductServices()
                                          .getCategoryProductsStream(title),
                                      initialData: null,
                                      child: ProductsView(
                                          title: '$title Category Items',
                                          setOrderTabAsActive:
                                              widget.setOrderTabAsActive),
                                    )));
                        // }
                      },
                      child: Container(
                        margin: title == 'Miscellaneous'
                            ? EdgeInsets.fromLTRB(10, 0, 18, 0)
                            : EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        width: 135,
                        height: 140,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Utils.whiteColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 235, 235, 235),
                                spreadRadius: 0.3,
                                blurRadius: 4,
                                // offset: Offset(0.5, 2)
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // category image
                            Image.asset(
                              title == 'Fish Farming' ||
                                      title == 'Miscellaneous' ||
                                      title == 'Dry Fruits'
                                  ? 'assets/images/${title.toLowerCase()}-category-image.jpg'
                                  : 'assets/images/${title.toLowerCase()}-category-image.png',
                              width: 80,
                              height: 80,
                            ),

                            // space
                            const SizedBox(
                              height: 10,
                            ),

                            // category title
                            Text(
                              title,
                              style: Utils.kAppCaptionRegularStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()),
                ),
              ),
            ),

            // space
            const SizedBox(
              height: 20,
            ),

            // featured section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured',
                    style: Utils.kAppBody3MediumStyle,
                  ),
                  // text
                  GestureDetector(
                    onTap: () {
                      // show all featured items in products view screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StreamProvider.value(
                                    value: ProductServices()
                                        .getAllProductsStream(),
                                    initialData: null,
                                    child: ProductsView(
                                      title: 'Featured Items',
                                      setOrderTabAsActive:
                                          widget.setOrderTabAsActive,
                                    ),
                                  )));
                    },
                    child: Text(
                      'See all',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                  ),
                ],
              ),
            ),

            // space
            const SizedBox(
              height: 10,
            ),

            // featured products list
            StreamProvider.value(
                value: ProductServices().getAllProductsStream(),
                initialData: null,
                child: FeaturedSection(
                  setOrderTabAsActive: widget.setOrderTabAsActive,
                )),

            // space
            const SizedBox(
              height: 40,
            ),

            /*
            // favourite section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favourites',
                    style: Utils.kAppBody3MediumStyle,
                  ),
                  // text
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavouriteItemsView()));
                    },
                    child: Text(
                      'See all',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                  ),
                ],
              ),
            ),

            // space
            const SizedBox(
              height: 10,
            ),

            // favourite products list
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: [1, 2, 3, 4, 5].map((number) {
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              fit: BoxFit.fitHeight,
                              number == 1
                                  ? 'assets/images/featured-product-image-$number.png'
                                  : 'assets/images/featured-product-image-$number.jpg',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'PKR 900',
                                      style: Utils.kAppCaptionBoldStyle,
                                    ),

                                    // rating row
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Utils.greenColor,
                                          size: 13,
                                        ),
                                        Text(
                                          ' 5.0',
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
                                  'Product Name Here',
                                  style: Utils.kAppCaption2MediumStyle
                                      .copyWith(color: Utils.lightGreyColor1),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                ),
              ),
            ),

            // space
            const SizedBox(
              height: 20,
            ),
            */
          ],
        ),
      ),
    );
  }
}

class FeaturedSection extends StatefulWidget {
  FeaturedSection({super.key, required this.setOrderTabAsActive});

  VoidCallback setOrderTabAsActive;

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
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
    // consume all products stream
    final products = Provider.of<List<ProductModel>?>(context);

    // if products are supplied and products list is empty
    if (products != null && productsList.isEmpty) {
      // print('first product doc id ${products.first.docId}');
      productsList = products;
      // get product image/first image
      _setProductImages();
    }

    return products == null
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Center(
              child: Utils.circularProgressIndicator,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: productsList.map((productModel) {
                  return StreamProvider.value(
                      value: ProductServices()
                          .getProductAvgRatingStream(productModel),
                      initialData: null,
                      child: HomeFeaturedProductCard(
                        productModel: productModel,
                        setOrderTabAsActive: widget.setOrderTabAsActive,
                      ));
                }).toList()),
              ),
            ),
          );
  }
}

class CartIcon extends StatefulWidget {
  const CartIcon({super.key});

  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  @override
  Widget build(BuildContext context) {
    // cart items count
    final itemsCount = Provider.of<int?>(context);

    return itemsCount == null
        ? Image.asset(
            'assets/images/cart-icon.png',
            width: 25,
          )
        : itemsCount == 0
            ? Image.asset(
                'assets/images/cart-icon.png',
                width: 25,
              )
            : Badge(
                label: Text(
                  int.parse(itemsCount.toString()) > 99
                      ? '99+'
                      : itemsCount.toString(),
                  style: TextStyle(fontSize: 8),
                ),
                backgroundColor: Utils.greenColor,
                alignment: AlignmentDirectional.topEnd,
                child: Image.asset(
                  'assets/images/cart-icon.png',
                  width: 25,
                ),
              );
  }
}
