import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/chat/buyer_chat_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/chat/chat_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/home/home_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/orders/order_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/profile/profile_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/shop/shop_tab_view.dart';
import 'package:farm_tech/presentation/views/buyer/home/buyer_home_tab_view.dart';
import 'package:farm_tech/presentation/views/buyer/orders/buyer_order_tab_view.dart';
import 'package:farm_tech/presentation/views/buyer/profile/buyer_profile_tab_view.dart';
import 'package:farm_tech/presentation/views/buyer/search/buyer_search_tab_view.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  HomeView({required this.userType});

  String userType;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // bottom navigation bar widget options seller
  // ignore: prefer_final_fields
  List<Widget?> _widgetOptionsSeller = <Widget?>[
    Utils.circularProgressIndicator,
    Utils.circularProgressIndicator,
    Utils.circularProgressIndicator,
    const ChatTabView(),
    Utils.circularProgressIndicator
  ];

  // bottom navigation bar widget options buyer
  List<Widget?> _widgetOptionsBuyer = <Widget?>[
    Utils.circularProgressIndicator,
    Utils.circularProgressIndicator,
    Utils.circularProgressIndicator,
    const BuyerChatTabView(),
    const BuyerProfileTabView(),
  ];

  // current botom navbar index
  int _selectedIndex = 0;

  // seller uid
  String uId = '';

  // seller name
  String sellerName = '';

  // buyer name
  String buyerName = '';

  // on bottom option tab clicked
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // set order tab as active
  void setOrderTabAsActive() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  // set buyer search tab as active
  void setBuyerSearchTabAsActive() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  // set buyer order tab as active
  void setBuyerOrderTabAsActive() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  // get seller uid
  _getUserUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // set state to let the widget tree know and refresh itself that something (data att.) has changed that it needs to reflect in its tree/view
    final id = pref.getString("uId");

    // print('id: $id'); // recieving null here when user logs in so null check below

    if (id == null) {
      // get user id again
      _getUserUid();
    } else {
      setState(() {
        uId = id;
      });
    }

    if (widget.userType == 'seller') {
      // reinitialize shop tab
      _reInitializeShopTab();

      // reinitialize orders tab
      _reInitializeOrdersTab();

      // get seller name now
      _getSellerName();
    } else {
      // get buyer name now
      _getBuyerName();

      // reinitialize buyer search tab
      _reInitializeBuyerSearchTab();

      // reinitialize buyer order tab
      _reInitializeBuyerOrderTab();
    }
  }

  // get seller name and set
  _getSellerName() async {
    final name =
        await SellerServices().getSellerName(SellerModel(docId: uId)) as String;
    // print('sellerName $name');
    // set state to let the widget tree know and refresh itself that something (data att.) has changed that it needs to reflect in its tree/view
    setState(() {
      sellerName = name;
    });

    // reinitailize home tab
    _reInitializeHomeTab();
  }

  // reinitailize home tab
  _reInitializeHomeTab() {
    // reinitialize widgets options
    setState(() {
      _widgetOptionsSeller[0] =
          // home tab with seller name
          HomeTabView(
        sellerName: sellerName,
        setOrderTabAsActive: setOrderTabAsActive,
      );
    });
  }

  // get buyer name and set
  _getBuyerName() async {
    final name =
        await BuyerServices().getName(BuyerModel(docId: uId)) as String;

    // print('buyerName $name');
    setState(() {
      buyerName = name;
    });

    // reinitailize home tab
    _reInitializeBuyerHomeTab();
  }

  // reinitailize home tab
  _reInitializeBuyerHomeTab() {
    // reinitialize widgets options
    setState(() {
      _widgetOptionsBuyer[0] =
          // home tab with buyer name and set search tab as active function
          BuyerHomeTabView(
        buyerId: uId,
        buyerName: buyerName,
        setSearchTabAsActive: setBuyerSearchTabAsActive,
        setOrderTabAsActive: setOrderTabAsActive,
      );
    });
  }

  // for shop tab reinitialize
  _reInitializeShopTab() {
    // reinitialize widgets options 1 index
    setState(() {
      _widgetOptionsSeller[1] =
          // shop tab view with seller id
          ShopTabView(sellerId: uId);
    });
  }

  // orders tab reintialize
  _reInitializeOrdersTab() {
    // reinitialize widgets options
    setState(() {
      _widgetOptionsSeller[2] =
          // orders tab with seller id
          OrderTabView(sellerId: uId);
    });
  }

  // profile tab reintialize
  _reInitializeProfileTab() {
    // reinitialize widgets options
    setState(() {
      // pass function to profile tab
      _widgetOptionsSeller[4] = ProfileTabView(
        setOrderTabAsActive: setOrderTabAsActive,
      );
    });
  }

  // buyer search tab reintialize
  _reInitializeBuyerSearchTab() {
    // reinitialize buyer widgets options
    setState(() {
      // pass function and buyer id to buyer search tab
      _widgetOptionsBuyer[1] = BuyerSearchTabView(
        setOrderTabAsActive: setOrderTabAsActive,
        buyerId: uId,
      );
    });
  }

  // buyer order tab reintialize
  _reInitializeBuyerOrderTab() {
    // reinitialize buyer widgets options
    setState(() {
      // pass buyer id to buyer order tab
      _widgetOptionsBuyer[2] = OrderTabView.forBuyer(
        buyerId: uId,
      );
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // SchedulerBinding.add
    // welcome message
    // show snackbar
    // floatingSnackBar(message: 'Welcome back!', context: context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print('user type: ${widget.userType}'); -/

    if (widget.userType == 'seller') {
      // reinitialize profile tab
      _reInitializeProfileTab();
    }
    // get seller/buyer uid
    _getUserUid();
  }

  // buil method
  @override
  Widget build(BuildContext context) {
    // print('user type: ${widget.userType}'); -/
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      body: widget.userType == 'seller'
          ? _widgetOptionsSeller.elementAt(_selectedIndex)
          : _widgetOptionsBuyer.elementAt(_selectedIndex),
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  // get bottom navigation bar
  _getBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color.fromARGB(255, 243, 243, 243),
            spreadRadius: 2,
            blurRadius: 4)
      ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
        child: SizedBox(
          height: 80,
          child: Theme(
            data: ThemeData(splashColor: Colors.white.withOpacity(0.0)),
            child: BottomNavigationBar(
              backgroundColor: Utils.whiteColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    activeIcon:
                        // active icon
                        Image.asset(
                      'assets/images/icon@home-active.png',
                      width: 27,
                      height: 27,
                    ),
                    backgroundColor: Colors.white,
                    icon: Image.asset(
                      'assets/images/icon@home.png',
                      width: 27,
                      height: 27,
                    ),
                    label: ''),
                widget.userType == 'buyer'
                    ? BottomNavigationBarItem(
                        backgroundColor: Colors.white,
                        activeIcon: Image.asset(
                          'assets/images/icon@search-active.png',
                          width: 32,
                          height: 32,
                        ),
                        icon: Image.asset(
                          'assets/images/icon@search.png',
                          width: 32,
                          height: 32,
                        ),
                        label: '')
                    : BottomNavigationBarItem(
                        backgroundColor: Colors.white,
                        activeIcon: Image.asset(
                          'assets/images/icon@shop-active.png',
                          width: 27,
                          height: 27,
                        ),
                        icon: Image.asset(
                          'assets/images/icon@shop.png',
                          width: 27,
                          height: 27,
                        ),
                        label: ''),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset(
                      'assets/images/icon@orders-active.png',
                      width: 27,
                      height: 27,
                    ),
                    icon: Image.asset(
                      'assets/images/icon@orders.png',
                      width: 27,
                      height: 27,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset(
                      'assets/images/icon@chat-active.png',
                      width: 27,
                      height: 27,
                    ),
                    icon: Image.asset(
                      'assets/images/icon@chat.png',
                      width: 27,
                      height: 27,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset(
                      'assets/images/icon@profile-active.png',
                      width: 27,
                      height: 27,
                    ),
                    icon: Image.asset(
                      'assets/images/icon@profile.png',
                      width: 27,
                      height: 27,
                    ),
                    label: ''),
              ],
              // type: BottomNavigationBarType.shifting,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              elevation: 10.0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        ),
      ),
    );
  }
}
