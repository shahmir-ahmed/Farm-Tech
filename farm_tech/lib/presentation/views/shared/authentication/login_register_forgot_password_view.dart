import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/backend/services/notification_service.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/authentication/shop_register/shop_register_view.dart';
import 'package:farm_tech/presentation/views/seller/home/home_view.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sms_autofill/sms_autofill.dart';
import 'package:pinput/pinput.dart';

class LoginRegisterForgotResetPasswordView extends StatefulWidget {
  LoginRegisterForgotResetPasswordView({
    super.key,
    this.changeScreenMethod,
    this.forLoginView,
    this.forSignupView,
    this.forForgotPasswordView,
    // this.showUserTypeView
    required this.forSeller,
    required this.forBuyer,
  });

  // change screen method
  VoidCallback? changeScreenMethod;

  // for login view
  bool? forLoginView;

  // for register view
  bool? forSignupView;

  // for forgot password view
  bool? forForgotPasswordView;

  // on back pressed show select user type view
  // VoidCallback? showUserTypeView;

  bool forSeller;
  bool forBuyer;

  @override
  State<LoginRegisterForgotResetPasswordView> createState() =>
      _LoginRegisterForgotResetPasswordViewState();
}

class _LoginRegisterForgotResetPasswordViewState
    extends State<LoginRegisterForgotResetPasswordView> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  // form field values
  // common
  String email = '';
  String password = '';

  // for register view
  String name = '';
  String confirmPassword = '';
  String contactNo = '';
  final TextEditingController otpController = TextEditingController();
  // final TextEditingController intlPhoneFieldController =
  //     TextEditingController();

  // reg exp variable for name field
  static final RegExp nameRegExp = RegExp(r'^[A-Za-z ]+$');

  // user auth services instance
  final UserAuthServices _userAuthServices = UserAuthServices();

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // String verificationId = '';
  // String otpError = '';
  // bool otpSent = false;
  // bool isPhoneVerified = false;
  // bool isVerifyingOTP = false;

  // PhoneAuthCredential? phoneAuthCredential;

  String contactNumberError = '';
  String countryCode = '';

  @override
  void initState() {
    super.initState();
    // SmsAutoFill().listenForCode(); // Start listening for the OTP code.
  }

  @override
  void dispose() {
    // SmsAutoFill()
    //     .unregisterListener(); // Stop listening for OTP codes when done.
    super.dispose();
  }

  // dialog
  _showVerifyContactDialog() {
    // set up the button
    Widget verifyButton = CustomButton(
      secondaryButton: false,
      primaryButton: true,
      buttonText: 'Verify',
      onButtonPressed: () async {
        // _auth.signOut();

        // print('otpController.text: ${otpController.text}');

        if (otpController.text.isNotEmpty &&
            (!otpController.text.contains('-') &&
                !otpController.text.contains('.')) &&
            otpController.text == '000000') {
          /*
          // show verifying otp dialog
          Utils.showLoadingAlertDialog(context, 'verifying_otp');

          final result = await verifyOTP();

          // close verifying alert dialog
          Navigator.pop(context);

          if (result == 'success') {
          */
          // not having effect in bottom sheet
          setState(() {
            // clear otp field
            otpController.text == "";
          });

          // show verifying otp dialog
          Utils.showLoadingAlertDialog(context, 'verifying_otp');
          // not having effect in bottom sheet
          // setState(() {
          //   isVerifyingOTP = true;
          // });
          Future.delayed(Duration(seconds: 2), () async {
            // not having effect in bottom sheet
            // setState(() {
            //   isVerifyingOTP = false;
            // });

            // close verifying otp dialog
            Navigator.pop(context);

            // close contact verify alert dialog
            Navigator.pop(context);

            // show creating account alert dialog
            Utils.showLoadingAlertDialog(context, 'signup');

            if (widget.forSeller) {
              // get seller device token and pass it to the register view also
              String deviceToken = await NotificationService().getDeviceToken();

              // close creating account alert dialog
              Navigator.pop(context);

              // push shop register screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopRegisterView(
                            sellerName: name,
                            sellerContactNo: "$countryCode$contactNo",
                            email: email,
                            password: password,
                            deviceToken: deviceToken,
                          )));
            } else if (widget.forBuyer) {
              // signup for buyer

              // signup buyer account
              final result = await _userAuthServices
                  .signUpUser(UserModel(email: email, password: password));

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
                UserModel user = result; // logged in user object

                // save user uid, email in shared pref.
                SharedPreferences pref = await SharedPreferences.getInstance();
                final set =
                    await pref.setString('uId', result.uId); // set user uid
                final set2 =
                    await pref.setString('email', email); // set user email
                final set3 =
                    await pref.setString('userType', "buyer"); // set user uid

                print("pref set: $set $set2 $set3");

                // create user uid with buyer document which contains buyer details
                final result2 = await BuyerServices().createDoc(
                    BuyerModel(
                      name: name,
                      email: email,
                      contactNo: "$countryCode$contactNo",
                      address: "",
                    ),
                    user.uId!);

                // doc created
                if (result2 == 'success') {
                  // sets this device user type logged in as buyer and id as empty beacuse dont need buyer id for noti recieivng checking
                  NotificationService()
                      .updateDeviceLoggedInUserDetails('buyer', '');

                  // close creating account dialog
                  Navigator.pop(context);

                  Utils.showAccountCreatedAlertDialog(context, "buyer");
                } else {
                  // logout user
                  // await _userAuthServices.signOut(); // can log in again on same credential so no benfit of logging out

                  // clear shared pref.
                  // await pref.clear();

                  // close creating account dialog
                  Navigator.pop(context);

                  // show error
                  floatingSnackBar(
                      message:
                          'Error while creating account. Please try again later.',
                      context: context);
                }
              }
            }
            /*
          } else {
            // show error alert dialog
            Utils.showErrorAlertDialog(context,
                'Error verifying otp please make sure otp is correct.');
          }
          */
          });
        } else if (otpController.text.isEmpty) {
          // show error alert dialog
          Utils.showErrorAlertDialog(context, 'Please provide OTP');
          // floatingSnackBar(message: 'Please provide OTP', context: context); // showing below alert dialog
        } else if (otpController.text.length < 6) {
          // show error alert dialog
          Utils.showErrorAlertDialog(context, 'Please provide complete OTP');
        } else {
          // show error alert dialog
          Utils.showErrorAlertDialog(context, 'Please provide valid OTP');
          // floatingSnackBar(
          //     message: 'Please provide valid OTP', context: context);
        }
        // verifyOTP();
      },
      buttonWidth: MediaQuery.of(context).size.width,
      buttonHeight: 60,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      backgroundColor: Utils.whiteColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        "Verify Your Contact",
        textAlign: TextAlign.center,
        style: Utils.kAppHeading6BoldStyle,
      ),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              "Please enter the 6 digit OTP sent to $countryCode $contactNo below",
              style: Utils.kAppBody3RegularStyle
                  .copyWith(color: Utils.lightGreyColor1),
            ),
            // space
            SizedBox(
              height: 20,
            ),

            // otp input field
            Pinput(
              length: 6,
              controller: otpController,
              autofocus: true,
            ),

            // otp error
            // Text(
            //   otpError,
            //   style: TextStyle(color: Colors.red),
            // )
          ],
        ),
      ),
      actions: [verifyButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              // if alert closed then reset vars
              setState(() {
                // verificationId = '';
                // otpError = '';
                // otpSent = false;
                // isPhoneVerified = false;
                // isVerifyingOTP = false;
                // phoneAuthCredential = null;
                // otpController.clear();
                otpController.text == "";
              });
              return true;
            }, // False will prevent and true will allow to dismiss
            child: alert);
        // return alert;
      },
    );
  }

/*
  // Send OTP to user's phone number
  Future<String> sendOTP() async {
    try {
      await _auth.verifyPhoneNumber(
        // phoneNumber: contactNo,
        // phoneNumber: "$countryCode$contactNo", // using testing number b/c for real numbers billing needs to be enabled (i.e. choose blaze plan in firebase (first 10 sms of the day are free but in cased exceeeded then charged according to country))
        // phoneNumber: "+923452129816", // testing number but still no otp sent on this number (real phone numbers cannot be used source: https://firebase.google.com/docs/auth/android/phone-auth?hl=en&authuser=0&_gl=1*9awbvy*_ga*MTAwOTA2MzUzMS4xNzIzODA3OTQ1*_ga_CW55HF8NVT*MTcyNzM0MDQzNy42My4xLjE3MjczNDA5MTQuNjAuMC4w#java)
        phoneNumber:
            "+923451234567", // testing number but still no otp sent on this number
        verificationCompleted: (PhoneAuthCredential credential) async {
          print(
              'Verification completed: ${credential.toString()}'); // on testing number not printed
          /*

          // // close verifying alert dialog
          // Navigator.pop(context);

          // setState(() {
          // isPhoneVerified = true;
          //   isVerifyingOTP = false;
          // });

          // close contact verify alert dialog
          Navigator.pop(context);

          // show creating account alert dialog
          Utils.showLoadingAlertDialog(context, 'signup');

          if (widget.forSeller) {
            // get seller device token and pass it to the register view also
            String deviceToken = await NotificationService().getDeviceToken();

            // close creating account alert dialog
            Navigator.pop(context);

            // push shop register screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShopRegisterView(
                        sellerName: name,
                        sellerContactNo: contactNo,
                        email: email,
                        password: password,
                        deviceToken: deviceToken,
                        phoneAuthCredential: phoneAuthCredential!)));
          } else if (widget.forBuyer) {
            // signup for buyer

            // signup buyer account
            final result = await _userAuthServices.signUpUser(
                UserModel(email: email, password: password),
                phoneAuthCredential!);

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
              UserModel user = result; // logged in user object

              // save user uid, email in shared pref.
              SharedPreferences pref = await SharedPreferences.getInstance();
              final set =
                  await pref.setString('uId', result.uId); // set user uid
              final set2 =
                  await pref.setString('email', email); // set user email
              final set3 =
                  await pref.setString('userType', "buyer"); // set user uid

              print("pref set: $set $set2 $set3");

              // create user uid with buyer document which contains buyer details
              final result2 = await BuyerServices().createDoc(
                  BuyerModel(
                    name: name,
                    contactNo: contactNo,
                  ),
                  user.uId!);

              // doc created
              if (result2 == 'success') {
                // sets this device user type logged in as buyer and id as empty beacuse dont need buyer id for noti recieivng checking
                NotificationService()
                    .updateDeviceLoggedInUserDetails('buyer', '');

                // close creating account dialog
                Navigator.pop(context);

                Utils.showAccountCreatedAlertDialog(context, "buyer");
              } else {
                // logout user
                await _userAuthServices.signOut();

                // clear shared pref.
                await pref.clear();

                // close creating account dialog
                Navigator.pop(context);

                // show error
                floatingSnackBar(
                    message:
                        'Error while creating account. Please try again later.',
                    context: context);
              }
            }
          }
          */
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
          setState(() {
            otpError = e.message!;
            // isVerifyingOTP = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          print('otpSent: $verificationId'); // recieved
          setState(() {
            this.verificationId = verificationId;
            // otpSent = true;
          });
          // close sending otp alert dialog
          Navigator.pop(context);

          // show verify contact alert dialog
          _showVerifyContactDialog();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          /*
          // [SmsRetrieverHelper] Timed out waiting for SMS.
          // Cannot recieve otp
          */
          print('codeAutoRetrievalTimeout: $verificationId');
          this.verificationId = verificationId;
        },
      );
      return 'success';
    } catch (e) {
      print('Err sending otp: $e');
      return 'error';
    }
  }
  */
/*
  // Verify the OTP entered by the user
  Future<String> verifyOTP() async {
    try {
      phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text,
      );

      print('phoneAuthCredential created');

      // final result = await _auth.signInWithCredential(AuthCredential(providerId: phoneAuthCredential!.providerId, signInMethod: phoneAuthCredential!.signInMethod));
      final result = await _auth.signInWithCredential(phoneAuthCredential!);

      print('user temporarily signed in signInWithCredential: $result');

      await _auth.signOut();

      print('user signed out');

      // setState(() {
      //   isVerifyingOTP = false;
      // });

      // setState(() {
      //   isPhoneVerified = true;
      // });

      return 'success';
    } catch (e) {
      print("Error verifying OTP: $e");
      return 'error';
      // setState(() {
      //   isVerifyingOTP = false;
      // });
    }
  }
  */

  // login user function
  _loginUser() async {
    if (widget.forSeller) {
      // if for seller login view
      // print
      // print('email $email');
      // print('password $password');

      // show loading alert dialog
      Utils.showLoadingAlertDialog(context, 'login');

      // first check email with seller doc exists because email used to registered at the time of buyer can also be used to login into seller side
      final sellerExists =
          await SellerServices().checkEmailExists(SellerModel(email: email));

      print('sellerExists: $sellerExists');

      if (sellerExists != null) {
        if (sellerExists) {
          // authenticate user (either seller/buyer)
          final result = await _userAuthServices
              .authenticateUser(UserModel(email: email, password: password));

          // print('result: $result');

          // null result is returned means error occured when invalid email/password
          if (result == null) {
            // close alert
            Navigator.pop(context);

            // show snackbar
            // invalid username/password
            floatingSnackBar(
                message: 'Invalid email or password', context: context);
          } else {
            // valid user
            // print('user uid: ${result.uId}');

            // close alert
            Navigator.pop(context);

            // close login screen
            Navigator.pop(context);

            // save user uid, email in shared pref.
            SharedPreferences pref = await SharedPreferences.getInstance();
            final set = await pref.setString('uId', result.uId); // set user uid
            final set2 = await pref.setString('email', email); // set user email
            final set3 =
                await pref.setString('userType', "seller"); // set user type

            print("pref set: $set $set2 $set3");

            // sets this device user type logged in as seller and id as seller id (id needed beacuse on same device token maybe two seller logged in so check from fs that noti is for same seller using id from noti and fs in background/terminated)
            NotificationService()
                .updateDeviceLoggedInUserDetails('seller', result.uId);

            // check if seller device token in firestore is same as this device
            // if not same then update token to this device token
            // get seller device token from fs
            final sellerDeviceToken =
                await SellerServices().getSellerDeviceToken(result.uId);

            // get this device token
            final deviceToken = await NotificationService().getDeviceToken();

            // if not same
            if (sellerDeviceToken != deviceToken) {
              print('device token is not same');
              // update device token in fs
              SellerServices().updateDeviceToken(
                  SellerModel(docId: result.uId, deviceToken: deviceToken));
            } else {
              print('device token is same');
            }

            // // after 3 secs show welcome message
            // Future.delayed(Duration(seconds: 3), () {
            //   // show snackbar
            //   floatingSnackBar(
            //       message: 'Welcome back!', context: context);
            // });

            // close auth screen
            // Navigator.pop(context);
            // // close choose user type screen
            // Navigator.pop(context);
            // // then show seller home screen (if for seller login screen)
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => HomeView()));
          }
        } else {
          // close alert
          Navigator.pop(context);
          // show snackbar
          // invalid username/password
          floatingSnackBar(
              message: 'Invalid email or password', context: context);
        }
      }
    } else if (widget.forBuyer) {
      // login for buyer

      // show loading alert dialog
      Utils.showLoadingAlertDialog(context, 'login');

      // first check email with buyer doc exists because email used to registered at the time of seller can also be used to login into buyer side
      final buyerExists =
          await BuyerServices().checkEmailExists(BuyerModel(email: email));

      print('buyerExists: $buyerExists');

      if (buyerExists != null) {
        if (buyerExists) {
          // authenticate user (either seller/buyer)
          final result = await _userAuthServices
              .authenticateUser(UserModel(email: email, password: password));

          // print('result: $result');

          // null result is returned means error occured when invalid email/password
          if (result == null) {
            // close alert
            Navigator.pop(context);

            // show snackbar
            // invalid username/password
            floatingSnackBar(
                message: 'Invalid email or password', context: context);
          } else {
            // valid user
            // print('user uid: ${result.uId}');

            // check the user exists in buyers collection or not

            // close alert
            Navigator.pop(context);

            // close login screen
            Navigator.pop(context);

            // save user uid, email in shared pref.
            SharedPreferences pref = await SharedPreferences.getInstance();
            final set = await pref.setString('uId', result.uId); // set user uid
            final set2 = await pref.setString('email', email); // set user email
            final set3 =
                await pref.setString('userType', "buyer"); // set user type

            print("pref set: $set $set2 $set3");

            // sets this device user type logged in as buyer and id as empty beacuse dont need buyer id for noti recieivng checking
            NotificationService().updateDeviceLoggedInUserDetails('buyer', '');
          }
        } else {
          // close alert
          Navigator.pop(context);
          // show snackbar
          // invalid username/password
          floatingSnackBar(
              message: 'Invalid email or password', context: context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: Utils.getAuthAppBar('', context),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  // on back pressed
  // onLoginSignupBackPressed() {
  //   Navigator.pop(context);
  //   widget.showUserTypeView!();
  // }

  // on forgot password screen back pressed
  // onForgotBackPressed() {
  //   Navigator.pop(context);
  // }

  _getBody() {
    return
        // WillPopScope(
        //   onWillPop: () =>
        //       widget.forLoginView != null || widget.forSignupView != null
        //           ? onLoginSignupBackPressed()
        //           : onForgotBackPressed(),
        //   child:
        SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain,
                alignment: AlignmentDirectional.topCenter,
                image: AssetImage(widget.forSignupView != null
                    ? 'assets/images/signup-banner.png'
                    : 'assets/images/login-banner.png'))),
        child: Container(
          margin:
              EdgeInsets.only(top: widget.forSignupView != null ? 100 : 280),
          decoration: const BoxDecoration(
            color: Utils.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50.0, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // text
                Text(
                  widget.forLoginView != null
                      ? widget.forSeller
                          ? 'Welcome Again Seller!'
                          : widget.forBuyer
                              ? "Welcome Again Buyer!"
                              : ""
                      : widget.forSignupView != null
                          ? widget.forSeller
                              ? 'Create Account as Seller'
                              : widget.forBuyer
                                  ? 'Create Account as Buyer'
                                  : ""
                          : 'Forgot Password',
                  style: Utils.kAppHeading6BoldStyle,
                ),

                // space
                const SizedBox(
                  height: 10.0,
                ),

                // text
                Text(
                  widget.forLoginView != null
                      ? 'Login To Access Your Account'
                      : widget.forSignupView != null
                          ? 'Sign Up to Create Your Account'
                          : 'Enter your registered email below we\'ll send you a reset link',
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
                        // name form field
                        widget.forLoginView != null
                            ? const SizedBox()
                            : widget.forSignupView != null
                                ? TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value) {
                                      setState(() {
                                        name = value.trim();
                                      });
                                    },
                                    decoration: Utils.inputFieldDecoration
                                        .copyWith(hintText: 'Name'),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return 'Name is required';
                                      }
                                      // contains characters other than alphabets
                                      else if (!nameRegExp.hasMatch(value)) {
                                        return 'Please enter valid name';
                                      }
                                      return null;
                                    },
                                    style: Utils.kAppBody3MediumStyle,
                                  )
                                : const SizedBox(),

                        // space
                        widget.forLoginView != null
                            ? const SizedBox()
                            : widget.forSignupView != null
                                ? const SizedBox(
                                    height: 30.0,
                                  )
                                : const SizedBox(),

                        // email form field
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              email = value.trim();
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: Utils.inputFieldDecoration
                              .copyWith(hintText: 'Email'),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Email is required';
                            } else if (!value.contains('@') ||
                                !value.contains('.')) {
                              // return 'Email must contain @ and .';
                              return 'Please enter valid email';
                            }
                            return null;
                          },
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        widget.forLoginView != null ||
                                widget.forSignupView != null
                            ? const SizedBox(
                                height: 30.0,
                              )
                            : const SizedBox(),

                        // password form field
                        widget.forLoginView != null ||
                                widget.forSignupView != null
                            ? TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    password = value.trim();
                                  });
                                },
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                obscureText:
                                    !_passwordVisible, //This will obscure text dynamically
                                decoration: Utils.inputFieldDecoration.copyWith(
                                  hintText: 'Password',
                                  // Here is key idea
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Utils.lightGreyColor1,
                                        size: 25.0,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (widget.forLoginView != null) {
                                    if (value!.trim().isEmpty) {
                                      return 'Password is required';
                                    } else if (value.trim().length < 6) {
                                      return 'Password should be at least 6 characters';
                                    }
                                  } else {
                                    if (value!.trim().isEmpty) {
                                      return 'Password is required';
                                    } else if (value.trim().length < 6) {
                                      return 'Password should be at least 6 characters';
                                    } else if (confirmPassword != password) {
                                      return 'Both passwords must be same';
                                    }
                                  }

                                  return null;
                                },
                                style: Utils.kAppBody3MediumStyle,
                              )
                            : const SizedBox(),

                        // space
                        widget.forLoginView != null
                            ? const SizedBox()
                            : widget.forSignupView != null
                                ? const SizedBox(
                                    height: 30.0,
                                  )
                                : const SizedBox(),

                        // confirm password form field
                        widget.forLoginView != null
                            ? const SizedBox()
                            : widget.forSignupView != null
                                ? TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        confirmPassword = value.trim();
                                      });
                                    },
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    obscureText:
                                        !_confirmPasswordVisible, //This will obscure text dynamically
                                    decoration:
                                        Utils.inputFieldDecoration.copyWith(
                                      hintText: 'Confirm Password',
                                      suffixIcon: // Here is key idea
                                          Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _confirmPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Utils.lightGreyColor1,
                                            size: 25.0,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            setState(() {
                                              _confirmPasswordVisible =
                                                  !_confirmPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return 'Please enter password again';
                                      } else if (value.trim().length < 6) {
                                        return 'Password should be at least 6 characters';
                                      } else if (confirmPassword != password) {
                                        return 'Both passwords must be same';
                                      }
                                      return null;
                                    },
                                    style: Utils.kAppBody3MediumStyle,
                                  )
                                : const SizedBox(),

                        // space
                        widget.forLoginView != null
                            ? const SizedBox()
                            : widget.forSignupView != null
                                ? const SizedBox(
                                    height: 30.0,
                                  )
                                : const SizedBox(),

                        // contact no form field
                        widget.forLoginView != null
                            ? const SizedBox()
                            : widget.forSignupView != null
                                ?
                                // TextFormField(
                                //     maxLength: 11,
                                //     keyboardType: TextInputType.phone,
                                //     textInputAction: TextInputAction.done,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         contactNo = value.trim();
                                //       });
                                //     },
                                //     decoration: Utils.inputFieldDecoration
                                //         .copyWith(hintText: 'Contact No'),
                                //     validator: (value) {
                                //       if (value!.trim().isEmpty) {
                                //         return 'Contact number is required';
                                //       } else if (value.trim().length < 11) {
                                //         return 'Please enter complete number';
                                //       }
                                //       return null;
                                //     },
                                //     style: Utils.kAppBody3RegularStyle,
                                //   )
                                IntlPhoneField(
                                    style: Utils.kAppBody3RegularStyle,
                                    dropdownIconPosition: IconPosition.trailing,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    decoration: contactNumberError.isNotEmpty
                                        ? Utils.inputFieldDecoration.copyWith(
                                            counterText: '',
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 180, 44, 44),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 180, 44, 44),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                          )
                                        : Utils.inputFieldDecoration.copyWith(
                                            counterText: '',
                                          ),
                                    initialCountryCode: 'PK',
                                    onChanged: (phone) {
                                      print('countryCode: $countryCode');
                                      if (countryCode.isEmpty) {
                                        setState(() {
                                          countryCode = phone.countryCode;
                                        });
                                      }
                                      print('phone.number: ${phone.number}');
                                      setState(() {
                                        contactNo = phone.number;
                                      });
                                    },
                                    // validator: (phone) {
                                    //   print(
                                    //       'Validator called with: ${phone?.number}');
                                    //   if (phone!.number.isEmpty) {
                                    //     return 'Please provide phone number';
                                    //   }
                                    //   return null;
                                    // },
                                  )
                                : const SizedBox(),

                        contactNumberError.isNotEmpty
                            ? const SizedBox(
                                height: 5.0,
                              )
                            : const SizedBox(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // space
                            const SizedBox(width: 25),
                            Text(
                              contactNumberError,
                              style: const TextStyle(
                                  color: const Color.fromARGB(255, 180, 44, 44),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    )),

                // space
                widget.forLoginView != null
                    ? const SizedBox(
                        height: 30.0,
                      )
                    : const SizedBox(),

                // forgot pass text
                widget.forLoginView != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // forgot password text button
                          GestureDetector(
                            onTap: () {
                              // show forgot password screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginRegisterForgotResetPasswordView(
                                            forForgotPasswordView: true,
                                            forSeller: widget.forSeller,
                                            forBuyer: widget.forBuyer,
                                          )));
                            },
                            child: Text('Forgot your password?',
                                style: Utils.kAppBody3MediumStyle
                                    .copyWith(color: Utils.greenColor)),
                          ),
                        ],
                      )
                    : const SizedBox(),

                // space
                widget.forLoginView != null || widget.forSignupView != null
                    ? const SizedBox(
                        height: 30.0,
                      )
                    : const SizedBox(
                        height: 230.0,
                      ),

                // next button
                CustomButton(
                  primaryButton: true,
                  secondaryButton: false,
                  onButtonPressed: () async {
                    // remove focus from last text field filled
                    FocusScope.of(context).unfocus();

                    if (widget.forSignupView != null) {
                      // show contact number error
                      if (contactNo.isEmpty) {
                        setState(() {
                          contactNumberError = 'Contact number is required';
                        });
                      } else {
                        setState(() {
                          contactNumberError = '';
                        });
                      }
                    }

                    // if form is valid for login view
                    if (widget.forLoginView != null) {
                      if (_formKey.currentState!.validate()) {
                        _loginUser();
                      }
                      // for signup view
                    } else {
                      // if (_formKey.currentState!.validate()) {
                      if (_formKey.currentState!.validate() &&
                          contactNo.isNotEmpty) {
                        // show dummy sending otp alert
                        Utils.showLoadingAlertDialog(context, 'sending_otp');

                        // afetr 3 secs
                        Future.delayed(Duration(seconds: 3), () {
                          // close sending otp alert
                          Navigator.pop(context);

                          // show verify dialog
                          _showVerifyContactDialog();
                        });

                        /*

                        final result = await sendOTP();

                        if (result == 'error') {
                          // close sending otp alert
                          Navigator.pop(context);

                          // show error
                          floatingSnackBar(
                              message:
                                  'Error sending OTP. Please try again later',
                              context: context);
                        }
                        // if verification failed error
                        else if (otpError.isNotEmpty) {
                          // close sending otp alert
                          Navigator.pop(context);

                          // show error
                          floatingSnackBar(
                              message: 'Error sending OTP: $otpError',
                              context: context);
                        }
                        */
                        /*
                      // for login view
                      if (widget.forLoginView != null) {
                        if (widget.forSeller) {
                          // if for seller login view
                          // print
                          // print('email $email');
                          // print('password $password');

                          // show loading alert dialog
                          Utils.showLoadingAlertDialog(context, 'login');

                          // authenticate user (either seller/buyer)
                          final result =
                              await _userAuthServices.authenticateUser(
                                  UserModel(email: email, password: password));

                          // print('result: $result');

                          // null result is returned means error occured when invalid email/password
                          if (result == null) {
                            // close alert
                            Navigator.pop(context);

                            // show snackbar
                            // invalid username/password
                            floatingSnackBar(
                                message: 'Invalid email or password',
                                context: context);
                          } else {
                            // valid user
                            // print('user uid: ${result.uId}');

                            // close alert
                            Navigator.pop(context);

                            // close login screen
                            Navigator.pop(context);

                            // save user uid, email in shared pref.
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            final set = await pref.setString(
                                'uId', result.uId); // set user uid
                            final set2 = await pref.setString(
                                'email', email); // set user email
                            final set3 = await pref.setString(
                                'userType', "seller"); // set user type

                            print("pref set: $set $set2 $set3");

                            // sets this device user type logged in as seller and id as seller id (id needed beacuse on same device token maybe two seller logged in so check from fs that noti is for same seller using id from noti and fs in background/terminated)
                            NotificationService()
                                .updateDeviceLoggedInUserDetails(
                                    'seller', result.uId);

                            // check if seller device token in firestore is same as this device
                            // if not same then update token to this device token
                            // get seller device token from fs
                            final sellerDeviceToken = await SellerServices()
                                .getSellerDeviceToken(result.uId);

                            // get this device token
                            final deviceToken =
                                await NotificationService().getDeviceToken();

                            // if not same
                            if (sellerDeviceToken != deviceToken) {
                              print('device token is not same');
                              // update device token in fs
                              SellerServices().updateDeviceToken(SellerModel(
                                  docId: result.uId, deviceToken: deviceToken));
                            } else {
                              print('device token is same');
                            }

                            // // after 3 secs show welcome message
                            // Future.delayed(Duration(seconds: 3), () {
                            //   // show snackbar
                            //   floatingSnackBar(
                            //       message: 'Welcome back!', context: context);
                            // });

                            // close auth screen
                            // Navigator.pop(context);
                            // // close choose user type screen
                            // Navigator.pop(context);
                            // // then show seller home screen (if for seller login screen)
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => HomeView()));
                          }
                        } else if (widget.forBuyer) {
                          // login for buyer

                          // show loading alert dialog
                          Utils.showLoadingAlertDialog(context, 'login');

                          // authenticate user (either seller/buyer)
                          final result =
                              await _userAuthServices.authenticateUser(
                                  UserModel(email: email, password: password));

                          // print('result: $result');

                          // null result is returned means error occured when invalid email/password
                          if (result == null) {
                            // close alert
                            Navigator.pop(context);

                            // show snackbar
                            // invalid username/password
                            floatingSnackBar(
                                message: 'Invalid email or password',
                                context: context);
                          } else {
                            // valid user
                            // print('user uid: ${result.uId}');

                            // check the user exists in buyers collection or not

                            // close alert
                            Navigator.pop(context);

                            // close login screen
                            Navigator.pop(context);

                            // save user uid, email in shared pref.
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            final set = await pref.setString(
                                'uId', result.uId); // set user uid
                            final set2 = await pref.setString(
                                'email', email); // set user email
                            final set3 = await pref.setString(
                                'userType', "buyer"); // set user type

                            print("pref set: $set $set2 $set3");

                            // sets this device user type logged in as buyer and id as empty beacuse dont need buyer id for noti recieivng checking
                            NotificationService()
                                .updateDeviceLoggedInUserDetails('buyer', '');
                          }
                        }
                      }
                      // for signup screen
                      else if (widget.forSignupView != null) {
                        Utils.showLoadingAlertDialog(context, 'sending_otp');

                        final result = await sendOTP();

                        if (result == 'error') {
                          // close seinding otp alert
                          Navigator.pop(context);

                          // show error
                          floatingSnackBar(
                              message:
                                  'Error sending OTP. Please try again later',
                              context: context);
                        }
                        // if verification failed error
                        else if (otpError.isNotEmpty) {
                          // close seinding otp alert
                          Navigator.pop(context);

                          // show error
                          floatingSnackBar(
                              message: 'Error sending OTP: $otpError',
                              context: context);
                        }

                        /*
                        if (widget.forSeller) {
                          // signup for seller
                          // print('name $name');
                          // print('email $email');
                          // print('password $password');
                          // print('contactNo $contactNo');

                          /*
                          // check user account with email already exists or not (returning false/empty list everytime maybe because function is deperecated)
                          final result = await UserAuthServices()
                              .accountEmailAlreadyExists(UserModel(email: email));
      
                          print('result: $result');
      
                          if (result || result == null) {
                            // user with email already exists
                            floatingSnackBar(
                                message:
                                    'User with email already exists. Please try different email.',
                                context: context);
                          } else {
                            // valid user
                            */
                          // show loading alert dialog
                          // Utils.showLoadingAlertDialog(context, 'signup');

                          // show sending otp alert dialog
                          Utils.showLoadingAlertDialog(context, 'sending_otp');

                          // get seller device token and pass it to the register view also
                          String deviceToken =
                              await NotificationService().getDeviceToken();

                          // close loading alert dialog
                          // Navigator.pop(context);

                          // close contact verify alert dialog
                          Navigator.pop(context);

                          // push shop register screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopRegisterView(
                                      sellerName: name,
                                      sellerContactNo: contactNo,
                                      email: email,
                                      password: password,
                                      deviceToken: deviceToken,
                                      phoneAuthCredential:
                                          phoneAuthCredential!)));
                          // }
                        } else if (widget.forBuyer) {
                          // signup for buyer

                          // show creating account alert dialog
                          Utils.showLoadingAlertDialog(context, "signup");

                          // signup buyer account
                          final result = await _userAuthServices.signUpUser(
                              UserModel(email: email, password: password),
                              phoneAuthCredential!);

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
                            UserModel user = result; // logged in user object

                            // save user uid, email in shared pref.
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            final set = await pref.setString(
                                'uId', result.uId); // set user uid
                            final set2 = await pref.setString(
                                'email', email); // set user email
                            final set3 = await pref.setString(
                                'userType', "buyer"); // set user uid

                            print("pref set: $set $set2 $set3");

                            // create user uid with buyer document which contains buyer details
                            final result2 = await BuyerServices().createDoc(
                                BuyerModel(
                                  name: name,
                                  contactNo: contactNo,
                                ),
                                user.uId!);

                            // doc created
                            if (result2 == 'success') {
                              // sets this device user type logged in as buyer and id as empty beacuse dont need buyer id for noti recieivng checking
                              NotificationService()
                                  .updateDeviceLoggedInUserDetails(
                                      'buyer', '');

                              // close creating account dialog
                              Navigator.pop(context);

                              Utils.showAccountCreatedAlertDialog(
                                  context, "buyer");
                            } else {
                              // show error
                              floatingSnackBar(
                                  message:
                                      'Error while creating account. Please try again later.',
                                  context: context);
                            }
                          }
                        }
                        */
                      }
                        */
                      }
                    }
                  },
                  buttonText: widget.forLoginView != null
                      ? 'Login'
                      : widget.forSignupView != null
                          ? 'Next'
                          : 'Get Link',
                  buttonWidth: MediaQuery.of(context).size.width,
                  buttonHeight: 60,
                ),

                // space
                widget.forLoginView != null || widget.forSignupView != null
                    ? const SizedBox(
                        height: 30.0,
                      )
                    : const SizedBox(),

                // text
                widget.forLoginView != null || widget.forSignupView != null
                    ? Text(
                        widget.forLoginView != null
                            ? "Don't have an account?"
                            : "Already have an account?",
                        style: Utils.kAppBody3RegularStyle)
                    : const SizedBox(),

                // space
                widget.forLoginView != null || widget.forSignupView != null
                    ? const SizedBox(
                        height: 20.0,
                      )
                    : const SizedBox(),

                // signup text
                widget.forLoginView != null || widget.forSignupView != null
                    ? GestureDetector(
                        onTap: widget.changeScreenMethod,
                        child: Text(
                            widget.forLoginView != null ? "Sign Up" : 'Login',
                            style: Utils.kAppHeading5BoldStyle
                                .copyWith(color: Utils.greenColor)),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
