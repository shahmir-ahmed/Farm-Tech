import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerHomeTabView extends StatefulWidget {
  const BuyerHomeTabView({super.key});

  @override
  State<BuyerHomeTabView> createState() => _BuyerHomeTabViewState();
}

class _BuyerHomeTabViewState extends State<BuyerHomeTabView> {
  // logout function
  Future<void> _logoutUser() async {
    // clear shared pref data for app
    SharedPreferences pref = await SharedPreferences.getInstance();
    final cleared = await pref.clear();

    print('cleared: $cleared');
  }

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
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Row(
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
                            style: Utils.kAppCaption2RegularStyle
                                .copyWith(color: Utils.greyColor),
                          ),
                          Text('Muhammad Wajahat',
                              style: Utils.kAppCaption2RegularStyle),
                        ],
                      ),
                    ],
                  ),
                  Container(
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
                    child: Image.asset(
                      'assets/images/cart-icon.png',
                      width: 25,
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

              // space
              const SizedBox(
                height: 40,
              ),

              // search field
              TextField(
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

              // space
              const SizedBox(
                height: 40,
              ),

              // categories section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Utils.kAppBody3MediumStyle,
                  ),
                  // text
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See all',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                  ),
                ],
              ),

              // space
              const SizedBox(
                height: 20,
              ),

              // categories
              SizedBox(
                height: 180,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: ['Crops', 'Livestock', 'Forestry'].map((title) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                            'assets/images/${title.toLowerCase()}-category-image.png',
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
                    );
                  }).toList()),
                ),
              ),

              // space
              const SizedBox(
                height: 40,
              ),

              // featured section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured',
                    style: Utils.kAppBody3MediumStyle,
                  ),
                  // text
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See all',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                  ),
                ],
              ),

              // space
              const SizedBox(
                height: 40,
              ),

              // categories section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favourites',
                    style: Utils.kAppBody3MediumStyle,
                  ),
                  // text
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See all',
                      style: Utils.kAppCaptionRegularStyle
                          .copyWith(color: Utils.greenColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
