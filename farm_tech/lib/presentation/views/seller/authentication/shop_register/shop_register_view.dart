import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/authentication/authentication_view.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopRegisterView extends StatefulWidget {
  ShopRegisterView(
      {required this.sellerName,
      required this.sellerContactNo,
      required this.email,
      required this.password});

  // seller/owner name
  String sellerName;
  // seller/owner contact no
  String sellerContactNo;
  // email
  String email;
  // password
  String password;

  @override
  State<ShopRegisterView> createState() => _ShopRegisterViewState();
}

class _ShopRegisterViewState extends State<ShopRegisterView> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String shopName = '';
  String shopLocation = '';
  String ownerName = '';
  String ownerCNICNo = '';
  String ownerContactNo = '';
  String shopDescription = '';
  // profile image file object
  File? pickedImage;
  // image error text
  String fileError = '';

  // user auth services instance
  final UserAuthServices _userAuthServices = UserAuthServices();

  // select source to upload image i.e. gallery/camera
  void mediaPickerOptions(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Pic image from",
                    style: Utils.kAppHeading6BoldStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    primaryButton: true,
                    secondaryButton: false,
                    onButtonPressed: () {
                      // close this modal bottom sheet
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                    buttonText: "Camera",
                    buttonHeight: 50,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomButton(
                    primaryButton: true,
                    secondaryButton: false,
                    onButtonPressed: () {
                      // close this modal bottom sheet
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                    buttonText: "Gallery",
                    buttonHeight: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Pick image
  void pickImage(ImageSource imageType) async {
    try {
      // app crashes if heavy image is selected (so not more than 15mb image should be allowed to be uploaded)
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;

      const maxFileSize = 10 * 1024 * 1024; // 10 MB in bytes

      // if image size is more than 10mb show error
      if (File(photo.path).lengthSync() > maxFileSize) {
        // print('large image');
        floatingSnackBar(
            message:
                'The image you are trying to upload is too large. The maximum file size allowed is 10 MB. Please select a smaller image.',
            context: context,
            duration: Duration(seconds: 6));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     duration: Duration(seconds: 6),
        //     content: Text(
        //         'The image you are trying to upload is too large. The maximum file size allowed is 10 MB.  Please select a smaller image.')));
        // return; (not closes the modal sheet so snackbar not visible so commented this)
      } else {
        // print('photo.path: ${photo.path}'); // jpg file

        // if image is less than or equal to 10MB
        // compress photo using flutter image compress package
        File? tempImage = await compressFile(File(photo.path));

        // if error compressing
        if (tempImage == null) tempImage = File(photo.path);

        // print(photo.path); // jpg file

        // print('tempImage.path: ${tempImage.path}');

        // update the image and error variable and notify the widget to update its state using setState
        setState(() {
          pickedImage = tempImage;
          fileError = '';
        });
      }

      // Close the image picker screen (but it closes the modal bottom sheet)
      // Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // flutter_image_compress
  // The flutter_image_compress package is fairly simple to use and it appears to be much better at actually reducing the file size.
  Future<File?> compressFile(File file) async {
    try {
      final filePath = file.absolute.path;

      // Create output file path with .jpg extension
      final outPath =
          "${filePath.substring(0, filePath.lastIndexOf('.'))}_out.jpg";

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        format: CompressFormat.jpeg, // Ensure the format is set to JPEG
        quality: 25,
      );

      if (result == null) {
        print("Compression failed");
        return null;
      }

      print('Original file size: ${file.lengthSync()} bytes');
      result
          .length()
          .then((value) => print('Compressed file size: ${value} bytes'));

      return File(result.path);
    } catch (e) {
      print("Error in compressing image: $e");
      return null;
    }
  }

  // show account created alert dialog
  showAccountCreatedAlertDialog(BuildContext context) {
    // set up the button
    Widget loginButton = CustomButton(
      secondaryButton: false,
      primaryButton: true,
      buttonText: 'OK',
      onButtonPressed: () {
        // close alert dialog
        Navigator.pop(context);
        // close shop register screen
        Navigator.pop(context);
        // close sign up screen
        // Navigator.pop(context);
        // push authentication view with login true
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const AuthenticationView()));
      },
      buttonWidth: MediaQuery.of(context).size.width,
      buttonHeight: 60,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      icon: Image.asset(
        'assets/images/done-icon.png',
        width: 48,
        height: 48,
      ),
      // contentPadding:
      //     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      backgroundColor: Utils.whiteColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        "Account Created",
        style: Utils.kAppHeading6BoldStyle,
      ),
      content: Text(
        textAlign: TextAlign.center,
        "You can now access your account",
        style:
            Utils.kAppBody3RegularStyle.copyWith(color: Utils.lightGreyColor1),
      ),
      actions: [loginButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async =>
                false, // False will prevent and true will allow to dismiss
            child: alert);
        // return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ownerName = widget.sellerName;
    ownerContactNo = widget.sellerContactNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  _getBody() {
    return SafeArea(
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          // statusBarColor: Color(0xffffdabe),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                // text
                Text(
                  'Shop Details',
                  style: Utils.kAppHeading6BoldStyle,
                ),

                // space
                const SizedBox(
                  height: 10.0,
                ),

                // instructions
                // text
                Text(
                  'Enter your shop details below',
                  style: Utils.kAppBody3RegularStyle
                      .copyWith(color: Utils.lightGreyColor1),
                ),

                // space
                const SizedBox(
                  height: 30.0,
                ),

                // form
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // shop name field
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              shopName = value;
                            });
                          },
                          decoration: Utils.inputFieldDecoration
                              .copyWith(hintText: 'Shop Name'),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Shop name is required';
                            }
                            return null;
                          },
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        const SizedBox(
                          height: 30.0,
                        ),

                        // shop location/address field
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              shopLocation = value;
                            });
                          },
                          decoration: Utils.inputFieldDecoration
                              .copyWith(hintText: 'Shop Location/Address'),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Shop location/address is required';
                            }
                            return null;
                          },
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        const SizedBox(
                          height: 30.0,
                        ),

                        // seller name/owner name field (from previous screen)
                        TextFormField(
                          initialValue: ownerName,
                          readOnly: true,
                          decoration: Utils.inputFieldDecoration,
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        const SizedBox(
                          height: 30.0,
                        ),

                        // owner cnic field
                        TextFormField(
                          maxLength: 13,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              ownerCNICNo = value;
                            });
                          },
                          decoration: Utils.inputFieldDecoration
                              .copyWith(hintText: 'Owner CNIC'),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Owner CNIC number is required';
                            } else if (value.trim().length < 13) {
                              return 'Please enter complete CNIC number';
                            }
                            return null;
                          },
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        const SizedBox(
                          height: 30.0,
                        ),

                        // seller contact no/owner contact no field (from previous screen)
                        TextFormField(
                          initialValue: ownerContactNo,
                          readOnly: true,
                          decoration: Utils.inputFieldDecoration,
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        const SizedBox(
                          height: 30.0,
                        ),

                        // owner profile image container
                        DottedBorder(
                          // strokeWidth: 2,
                          color: fileError.isEmpty
                              ? Utils.greenColor
                              : Color.fromARGB(255, 180, 44, 44),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [7, 7],
                          child: GestureDetector(
                            onTap: () {
                              // remove focus from last text field filled
                              FocusScope.of(context)
                                  .unfocus();
                              mediaPickerOptions(context);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width - 70,
                                height: pickedImage != null ? 280 : 60,
                                child: pickedImage == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // text
                                          Text(
                                            'Owner Profile Image',
                                            style: Utils.kAppBody3RegularStyle,
                                          ),

                                          // upload icon
                                          Image.asset(
                                            'assets/images/upload-icon.png',
                                            width: 24,
                                            height: 24,
                                          )
                                        ],
                                      )
                                    : Image.file(
                                        pickedImage!,
                                        fit: BoxFit.contain,
                                      )),
                          ),
                        ),

                        fileError.isNotEmpty
                            ? const SizedBox(
                                height: 5.0,
                              )
                            : SizedBox(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // space
                            SizedBox(width: 25),
                            Text(
                              fileError,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 180, 44, 44),
                                  fontSize: 12),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 30.0,
                        ),

                        // shop description field
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 5,
                          maxLines: 6,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          onChanged: (value) {
                            setState(() {
                              shopDescription = value;
                            });
                          },
                          decoration: Utils.inputFieldDecoration
                              .copyWith(hintText: 'Shop Description'),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Shop description is required';
                            }
                            return null;
                          },
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        const SizedBox(
                          height: 30.0,
                        ),

                        // next button
                        CustomButton(
                          primaryButton: true,
                          secondaryButton: false,
                          onButtonPressed: () async {
                            // remove focus from last text field filled
                            FocusScope.of(context)
                                .unfocus();
                            // check image
                            if (pickedImage == null) {
                              setState(() {
                                fileError = 'Profile image is required';
                              });
                            }
                            // validate form
                            if (_formKey.currentState!.validate() &&
                                pickedImage != null) {
                              // if form is valid
                              // show creating account alert dialog
                              Utils.showLoadingAlertDialog(
                                  context, "signup");

                              // print('shopName $shopName');
                              // print('shopLocation $shopLocation');
                              // print('ownerName $ownerName');
                              // print('ownerCNICNo $ownerCNICNo');
                              // print('ownerContactNo $ownerContactNo');
                              // print('pickedImage!.path ${pickedImage!.path}');
                              // print('shopDescription $shopDescription');

                              // signup seller account shop details, add profile image in storage
                              final result = await _userAuthServices.signUpUser(
                                  UserModel(
                                      email: widget.email,
                                      password: widget.password));

                              if (result == null) {
                                // close creating account dialog
                                Navigator.pop(context);

                                // user with email already exists
                                floatingSnackBar(
                                    message:
                                        'User with email already exists. Please try different email.',
                                    context: context);
                              } else {
                                // valid user
                                UserModel user =
                                    result; // logged in user object

                                // create user uid with seller document which contains shop details and user details
                                final result2 = await SellerServices()
                                    .createSellerDoc(
                                        SellerModel(
                                            name: ownerName,
                                            contactNo: ownerContactNo,
                                            cnicNo: ownerCNICNo,
                                            shopName: shopName,
                                            shopLocation: shopLocation,
                                            shopDescription: shopDescription),
                                        user.uId as String);

                                // doc created
                                if (result2 == 'success') {
                                  // then
                                  // save profile image in fb storage
                                  final result3 = await SellerServices()
                                      .uploadProfileImage(SellerModel(
                                          docId: user.uId,
                                          profileImageUrl: pickedImage!.path));

                                  // close creating account dialog
                                  Navigator.pop(context);

                                  // profile image uploaded
                                  if (result3 == 'success') {
                                    // save user uid in shared pref.
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString('uId',
                                        user.uId as String); // set user uid
                                    // show account created alert dialog
                                    showAccountCreatedAlertDialog(context);
                                  } else {
                                    // show error
                                    floatingSnackBar(
                                        message:
                                            'Error while uploading profile image. Please try again later.',
                                        context: context);
                                  }
                                } else {
                                  // show error
                                  floatingSnackBar(
                                      message:
                                          'Error while creating account. Please try again later.',
                                      context: context);
                                }
                              }

                              // after 3 secs
                              // Future.delayed(const Duration(seconds: 3), () {
                              //   // close previous dialog
                              //   Navigator.pop(context);
                              //   // show next dialog
                              //   showAccountCreatedAlertDialog(context);
                              // });
                            }
                          },
                          buttonText: 'Next',
                          buttonWidth: MediaQuery.of(context).size.width,
                          buttonHeight: 60,
                        ),

                        // space
                        const SizedBox(
                          height: 30.0,
                        ),

                        // text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  // close screen
                                  Navigator.pop(context);
                                },
                                child: Text("Back",
                                    style: Utils.kAppBody3RegularStyle
                                        .copyWith(color: Utils.greenColor))),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
