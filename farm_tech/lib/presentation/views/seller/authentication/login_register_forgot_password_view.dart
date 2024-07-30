import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/authentication/shop_register/shop_register_view.dart';
import 'package:farm_tech/presentation/views/seller/home/home_view.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRegisterForgotResetPasswordView extends StatefulWidget {
  LoginRegisterForgotResetPasswordView(
      {super.key,
      this.changeScreenMethod,
      this.forLoginView,
      this.forSignupView,
      this.forForgotPasswordView,
      this.showUserTypeView});

  // change screen method
  VoidCallback? changeScreenMethod;

  // for login view
  bool? forLoginView;

  // for register view
  bool? forSignupView;

  // for forgot password view
  bool? forForgotPasswordView;

  // on back pressed show select user type view
  VoidCallback? showUserTypeView;

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

  // reg exp variable for name field
  static final RegExp nameRegExp = RegExp(r'^[A-Za-z ]+$');

  // user auth services instance
  final UserAuthServices _userAuthServices = UserAuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  // on back pressed
  onLoginSignupBackPressed() {
    Navigator.pop(context);
    widget.showUserTypeView!();
  }

  // on forgot password screen back pressed
  onForgotBackPressed() {
    Navigator.pop(context);
  }

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
                      ? 'Welcome Again!'
                      : widget.forSignupView != null
                          ? 'Create Account'
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
                                ? TextFormField(
                                    maxLength: 11,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    onChanged: (value) {
                                      setState(() {
                                        contactNo = value.trim();
                                      });
                                    },
                                    decoration: Utils.inputFieldDecoration
                                        .copyWith(hintText: 'Contact No'),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return 'Contact number is required';
                                      } else if (value.trim().length < 11) {
                                        return 'Please enter complete number';
                                      }
                                      return null;
                                    },
                                    style: Utils.kAppBody3RegularStyle,
                                  )
                                : const SizedBox(),
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
                  onButtonPressed: () async {
                    // remove focus from last text field filled
                    FocusScope.of(context).requestFocus(new FocusNode());

                    // if form is valid
                    if (_formKey.currentState!.validate()) {
                      // for login view
                      if (widget.forLoginView != null) {
                        // print
                        print('email $email');
                        print('password $password');

                        // show loading alert dialog
                        Utils.showCreatingAccountAlertDialog(context, 'login');

                        // authenticate user (either seller/buyer)
                        final result = await _userAuthServices.authenticateUser(
                            UserModel(email: email, password: password));

                        print('result: $result');

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
                          print('user uid: ${result.uId}');

                          // close alert
                          Navigator.pop(context);

                          // save user uid in shared pref.
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          final set = await pref.setString(
                              'uId', result.uId); // set user uid

                          print("pref set: $set");

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
                      }
                      // for signup screen
                      else if (widget.forSignupView != null) {
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
                        // push shop register screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopRegisterView(
                                      sellerName: name,
                                      sellerContactNo: contactNo,
                                      email: email,
                                      password: password,
                                    )));
                        // }
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
