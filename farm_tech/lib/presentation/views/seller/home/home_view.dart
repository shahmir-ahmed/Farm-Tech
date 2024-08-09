import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/chat/chat_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/home/home_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/orders/order_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/profile/profile_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/shop/shop_tab_view.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // bottom navigation bar att.
  // ignore: prefer_final_fields
  List<Widget?> _widgetOptions = <Widget?>[
    Utils.circularProgressIndicator,
    Utils.circularProgressIndicator,
    Utils.circularProgressIndicator,
    const ChatTabView(),
    Utils.circularProgressIndicator
  ];

  // current botom navbar index
  int _selectedIndex = 0;

  // seller uid
  String uId = '';

  // seller name
  String sellerName = '';

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

  // get seller uid
  _getUserUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // set state to let the widget tree know and refresh itself that something (data att.) has changed that it needs to reflect in its tree/view
    setState(() {
      uId = pref.getString("uId") as String;
    });

    // reinitialize shop tab
    _reInitializeShopTab();

    // reinitialize orders tab
    _reInitializeOrdersTab();

    // get seller name now
    _getSellerName();
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
      _widgetOptions[0] =
          // home tab with seller name
          HomeTabView(
        sellerName: sellerName,
      );
    });
  }

  // for shop tab reinitialize
  _reInitializeShopTab() {
    // reinitialize widgets options 1 index
    setState(() {
      _widgetOptions[1] =
          // shop tab view with seller id
          ShopTabView(sellerId: uId);
    });
  }

  // orders tab reintialize
  _reInitializeOrdersTab() {
    // reinitialize widgets options
    setState(() {
      _widgetOptions[2] =
          // orders tab with seller id
          OrderTabView(sellerId: uId);
    });
  }

  // profile tab reintialize
  _reInitializeProfileTab() {
    // reinitialize widgets options
    setState(() {
      // pass function to profile tab
      _widgetOptions[4] = ProfileTabView(
        setOrderTabAsActive: setOrderTabAsActive,
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

    // reinitialize profile tab
    _reInitializeProfileTab();

    // get seller uid
    _getUserUid();
  }

  // buil method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      body: _widgetOptions.elementAt(_selectedIndex),
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
                BottomNavigationBarItem(
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
