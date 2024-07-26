import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/chat/chat_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/home/home_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/orders/order_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/profile/profile_tab_view.dart';
import 'package:farm_tech/presentation/views/seller/shop/shop_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // bottom navigation bar att.
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTabView(),
    const ShopTabView(),
    const OrderTabView(),
    const ChatTabView(),
    const ProfileTabView(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color.fromARGB(255, 243, 243, 243),
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
