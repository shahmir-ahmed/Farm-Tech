import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/backend/services/review_services.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/profile/edit_profile_view.dart';
import 'package:farm_tech/presentation/views/seller/profile/image_view.dart';
import 'package:farm_tech/presentation/views/seller/profile/settings_view.dart';
import 'package:farm_tech/presentation/views/seller/profile/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/seller/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfileTabView extends StatefulWidget {
  ProfileTabView({required this.setOrderTabAsActive});
  ProfileTabView.forBuyer(
      {required this.setOrderTabAsActive, this.forBuyer = true});

  VoidCallback setOrderTabAsActive;
  bool? forBuyer;

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  String profileImageUrl = '';
  String name = '';
  String email = '';

  String docId = '';

  // get seller name (using doc id from shared pref)
  _getSellerName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      docId = pref.getString("uId") as String;
    });

    // now get profile image also
    _getSellerProfileImage();

    // get name
    final result =
        await SellerServices().getSellerName(SellerModel(docId: docId));

    // if no error
    if (result != null) {
      setState(() {
        name = result;
      });
    }
  }

  // get seller email (from shared pref)
  _getSellerEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      email = pref.getString("email") as String;
    });
  }

  // get seller profile image (using doc id from shared pref)
  _getSellerProfileImage() async {
    // get image url
    final result =
        await SellerServices().getProfileImage(SellerModel(docId: docId));

    if (result != null) {
      setState(() {
        profileImageUrl = result;
      });
    }
  }

  // get buyer name (using doc id from shared pref)
  _getBuyerName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      docId = pref.getString("uId") as String;
    });

    // now get profile image also
    _getBuyerProfileImage();

    // get name
    final result = await BuyerServices().getName(BuyerModel(docId: docId));

    // if no error
    if (result != null) {
      setState(() {
        name = result;
      });
    }
  }

  // get buyer email (from shared pref)
  _getBuyerEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      email = pref.getString("email") as String;
    });
  }

  // get buyer profile image (using doc id from shared pref)
  _getBuyerProfileImage() async {
    // get image url
    final result =
        await BuyerServices().getProfileImage(BuyerModel(docId: docId));

    if (result != null) {
      setState(() {
        profileImageUrl = result;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if not for buyer
    if (widget.forBuyer == null) {
      // get seller name
      _getSellerName();

      // get email
      _getSellerEmail();
    } else {
      // get buyer name
      _getBuyerName();

      // after 10 secs check if image is still empty then assign buyer dummy image to var
      Future.delayed(Duration(seconds: 10), () {
        print('checking profile image url');
        if (profileImageUrl.isEmpty) {
          print('profile image url still empty');
          setState(() {
            profileImageUrl = 'assets/images/buyer-icon.png';
          });
        }
      });

      // get buyer email
      _getBuyerEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getTabAppBar(
          'Profile',
          [
            // settings icon
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Utils.whiteColor),
                    elevation: WidgetStatePropertyAll(0),
                    overlayColor: WidgetStatePropertyAll(Utils.whiteColor)),
                onPressed: () {
                  if (widget.forBuyer == null) {
                    // show settings screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsView()));
                  } else {
                    // show settings screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsView.forBuyer()));
                  }
                },
                child:
                    Image.asset('assets/images/settings-icon.png', width: 25)),
            const SizedBox(
              width: 10,
            ),
          ],
          context),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  _getBody() {
    return Column(
      children: [
        // user image
        profileImageUrl.isEmpty
            ?
            // Shimmer.fromColors(
            //     baseColor: Colors.grey.shade300,
            //     highlightColor: Colors.grey.shade100,
            //     enabled: true,
            //     child: CircleSkeleton())
            const SizedBox(height: 100, child: Utils.circularProgressIndicator)
            : GestureDetector(
                onTap: profileImageUrl.isEmpty ||
                        profileImageUrl == 'assets/images/buyer-icon.png'
                    ? () {}
                    : () {
                        // show image view
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageView(
                                      assetName: profileImageUrl,
                                    )));
                      },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      profileImageUrl == 'assets/images/buyer-icon.png'
                          ? AssetImage(profileImageUrl)
                          : NetworkImage(
                              profileImageUrl,
                              // width: 120,
                            ),
                  backgroundColor: Utils.whiteColor,
                ),
              ),

        // space
        const SizedBox(
          height: 5,
        ),

        // username
        // name.isEmpty
        //     ?
        /*
        Shimmer.fromColors(
            period: Durations.extralong1,
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: const Skeleton(
              height: 40,
              width: 50,
              defaultPadding: 10,
            )),
            */
        // :
        Text(
          name,
          style: Utils.kAppBody1MediumStyle,
        ),

        // space
        const SizedBox(
          height: 5,
        ),

        // user email
        Text(
          email,
          style:
              Utils.kAppCaptionRegularStyle.copyWith(color: Utils.greenColor),
        ),

        // space
        const SizedBox(
          height: 15,
        ),

        // edit profile button
        CustomButton(
            buttonWidth: MediaQuery.of(context).size.width - 230,
            buttonHeight: 50,
            onButtonPressed: () {
              if (profileImageUrl.isEmpty || name.isEmpty || email.isEmpty) {
                // not show screen
              } else {
                // show edit profile screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.forBuyer == null
                            ? EditProfileView(
                                docId: docId,
                                name: name,
                                email: email,
                                profileImageUrl: profileImageUrl,
                                getProfileImage: _getSellerProfileImage,
                                getName: _getSellerName)
                            : EditProfileView.forBuyer(
                                docId: docId,
                                name: name,
                                email: email,
                                profileImageUrl: profileImageUrl,
                                getProfileImage: _getBuyerProfileImage,
                                getName: _getBuyerName,
                              )));
              }
            },
            icon: Image.asset('assets/images/edit-icon.png', width: 30),
            buttonText: 'Edit Profile',
            primaryButton: true,
            secondaryButton: false),

        // space
        const SizedBox(
          height: 35,
        ),

        // orders option
        OptionRow(
          text: 'Orders',
          onPressed: widget.setOrderTabAsActive,
        ),

        docId.isNotEmpty
            ?
            // seller reviews section with stream
            StreamProvider.value(
                value: ReviewServices()
                    .getAllSellerReviews(SellerModel(docId: docId)),
                initialData: null,
                child: RatingsReviewsSection.forSellerProfileTab(),
              )
            : SizedBox(),
      ],
    );
  }
}
