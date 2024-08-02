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
  final List<Widget?> _widgetOptions = <Widget?>[
    Utils.circularProgressIndicator,
    Utils.circularProgressIndicator,
    const OrderTabView(),
    const ChatTabView(),
    const ProfileTabView(),
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

  // get seller uid
  _getUserUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // set state to let the widget tree know and refresh itself that something (data att.) has changed that it needs to reflect in its tree/view
    setState(() {
      uId = pref.getString("uId") as String;
    });

    // reinitialize shop tab
    _reInitializeShopTab();

    // get seller name now
    _getSellerName();
  }

  // for shop tab reinitialize
  _reInitializeShopTab() {
    // reinitialize widgets options 1 index
    setState(() {
      _widgetOptions[1] =
          // shop tab view with stream supplied (same as already)
          StreamProvider.value(
              initialData: null,
              value:
                  SellerServices().getSellerDataStream(SellerModel(docId: uId)),
              child: const ShopTabView());
    });
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
    // get seller uid
    _getUserUid();
  }

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
                      width: 24,
                      height: 24,
                    ),
                    backgroundColor: Colors.white,
                    icon: Image.asset(
                      'assets/images/icon@home.png',
                      width: 24,
                      height: 24,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset(
                      'assets/images/icon@shop-active.png',
                      width: 24,
                      height: 24,
                    ),
                    icon: Image.asset(
                      'assets/images/icon@shop.png',
                      width: 24,
                      height: 24,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset(
                      'assets/images/icon@orders-active.png',
                      width: 24,
                      height: 24,
                    ),
                    icon: Image.asset(
                      'assets/images/icon@orders.png',
                      width: 24,
                      height: 24,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset(
                      'assets/images/icon@chat-active.png',
                      width: 24,
                      height: 24,
                    ),
                    icon: Image.asset(
                      'assets/images/icon@chat.png',
                      width: 24,
                      height: 24,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset(
                      'assets/images/icon@profile-active.png',
                      width: 24,
                      height: 24,
                    ),
                    icon: Image.asset(
                      'assets/images/icon@profile.png',
                      width: 24,
                      height: 24,
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
