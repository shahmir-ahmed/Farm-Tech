import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  late List<Map<String, String>> statsList;
  String uId = '';
  String sellerName = '';

  // logout function
  Future<void> _logoutUser() async {
    // clear shared pref data for app
    SharedPreferences pref = await SharedPreferences.getInstance();
    final cleared = await pref.clear();

    print('cleared: $cleared');
  }

  // get user uid
  _getUserUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    uId = pref.getString("uId") as String;

    // get seller name
    _getSellerName();
  }

  // get seller name and set
  _getSellerName() async {
    final name =
        await SellerServices().getSellerName(SellerModel(docId: uId)) as String;
    print('sellerName $name');
    // set state to let the widget tree know and refresh itself that something (data att.) has changed that it needs to reflect in its tree/view
    setState(() {
      sellerName = name;
    });
  }

  @override
  void initState() {
    _getUserUid();
    // TODO: implement initState
    super.initState();
    statsList = [
      {
        "icon": "assets/images/icon-question-mark.png",
        "count": "224",
        "title": "Total Products"
      },
      {
        "icon": "assets/images/icon-done-all.png",
        "count": "154",
        "title": "Total Orders"
      },
      {
        "icon": "assets/images/icon-earned.png",
        "count": "Rs 12661",
        "title": "Total Earned"
      },
      {
        "icon": "assets/images/icon-review.png",
        "count": "12",
        "title": "Total Reviews"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }

  _getBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 25, 25, 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard!',
                              style: Utils.kAppHeading6BoldStyle,
                            ),
                            // texts row
                            Row(
                              children: [
                                Text(
                                  'Welcome to Dashboard, ',
                                  style: Utils.kAppCaptionRegularStyle
                                      .copyWith(color: Utils.lightGreyColor1),
                                ),
                                // user name
                                Text(
                                  sellerName.isEmpty
                                      ? ""
                                      : sellerName.substring(
                                          0, sellerName.indexOf(' ')),
                                  style: Utils.kAppCaptionRegularStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Utils.whiteColor)),
                          onPressed: () async {
                            // logout user
                            await UserAuthServices().signOut();
                            await _logoutUser();
                            floatingSnackBar(
                                message: 'Logged out successfully',
                                context: context);
                            print('user logged out');
                            // floatingSnackBar(
                            //     message: 'Logged out successfully',
                            //     context: context);
                          },
                          child: Icon(
                            Icons.logout,
                            color: Utils.blackColor2,
                          ),
                        ),
                      ],
                    ),
                    // space
                    const SizedBox(
                      height: 20,
                    ),
                    // grid view
                    SizedBox(
                      height: 277,
                      child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: statsList.map((statMap) {
                            // single mini card for stat
                            return Container(
                              decoration: const BoxDecoration(
                                color: Utils.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 243, 243, 243),
                                      blurRadius: 2,
                                      spreadRadius: 2)
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // icon
                                  Image.asset(
                                    statMap['icon'] as String,
                                    width: 50,
                                    height: 50,
                                  ),

                                  // count and title column
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // count
                                      Text(
                                        statMap['count'] as String,
                                        style: Utils.kAppBody2BoldStyle,
                                      ),

                                      // title
                                      Text(
                                        statMap['title'] as String,
                                        style: Utils.kAppCaption2RegularStyle,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }).toList()),
                    ),

                    // space
                    const SizedBox(
                      height: 20,
                    ),

                    // graph
                    Center(
                      child: Image.asset(
                        'assets/images/dashboard-graph.png',
                        width: MediaQuery.of(context).size.width,
                        height: 350,
                      ),
                    ),

                    // space
                    const SizedBox(
                      height: 20,
                    ),

                    // orders section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Orders in Queue',
                          style: Utils.kAppBody3MediumStyle,
                        ),
                        // text
                        Text(
                          'See all',
                          style: Utils.kAppCaption2RegularStyle
                              .copyWith(color: Utils.greenColor),
                        ),
                      ],
                    ),
                  ]),
            ),

            // divider
            const Divider(
              height: 0.5,
              thickness: 0.0,
              color: Utils.lightGreyColor1,
            ),

            const Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  // orders
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
