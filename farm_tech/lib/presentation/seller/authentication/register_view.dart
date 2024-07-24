import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  RegisterView({required this.changeScreenMethod});

  // change screen method
  VoidCallback changeScreenMethod;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  // form field values
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String contactNo = '';

  // reg exp variable for name field
  static final RegExp nameRegExp = RegExp(r'^[A-Za-z ]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  _getBody() {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain,
                alignment: AlignmentDirectional.topCenter,
                image: const AssetImage('assets/images/signup-banner.png'))),
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          decoration: const BoxDecoration(
            color: Utils.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50.0, 30, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // text
                Text(
                  'Create Account',
                  style: Utils.kAppHeading6BoldStyle,
                ),

                // space
                const SizedBox(
                  height: 10.0,
                ),

                // text
                Text(
                  'Sign Up to Create Your Account',
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
                        TextFormField(
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              name = value;
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
                        ),

                        // space
                        const SizedBox(
                          height: 45.0,
                        ),

                        // email form field
                        TextFormField(
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
                        const SizedBox(
                          height: 45.0,
                        ),

                        // password form field
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              password = value.trim();
                            });
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          obscureText:
                              !_passwordVisible, //This will obscure text dynamically
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Utils.greenColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: 'Password',
                            contentPadding: const EdgeInsets.all(26),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Utils.lightGreyColor1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // Here is key idea
                            suffixIcon: IconButton(
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
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Password is required';
                            } else if (confirmPassword != password) {
                              return 'Both passwords must be same';
                            }
                            return null;
                          },
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        const SizedBox(
                          height: 45.0,
                        ),

                        // confirm password form field
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              confirmPassword = value.trim();
                            });
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          obscureText:
                              !_confirmPasswordVisible, //This will obscure text dynamically
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Utils.greenColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: 'Confirm Password',
                            contentPadding: const EdgeInsets.all(26),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Utils.lightGreyColor1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // Here is key idea
                            suffixIcon: IconButton(
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
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please enter password again';
                            } else if (confirmPassword != password) {
                              return 'Both passwords must be same';
                            }
                            return null;
                          },
                          style: Utils.kAppBody3MediumStyle,
                        ),

                        // space
                        const SizedBox(
                          height: 45.0,
                        ),

                        // contact no form field
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          decoration: Utils.inputFieldDecoration
                              .copyWith(hintText: 'Contact No'),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Contact number is required';
                            }
                            return null;
                          },
                          style: Utils.kAppBody3RegularStyle,
                        ),
                      ],
                    )),

                // space
                const SizedBox(
                  height: 20.0,
                ),

                // next button
                PrimaryButton(
                  onButtonPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // if form is valid
                    }
                  },
                  buttonText: 'Next',
                  buttonWidth: MediaQuery.of(context).size.width,
                  buttonHeight: 60,
                ),

                // space
                const SizedBox(
                  height: 40.0,
                ),

                // Already have an account text
                Text("Already have an account?",
                    style: Utils.kAppBody3RegularStyle),

                // space
                const SizedBox(
                  height: 20.0,
                ),

                // signup text
                GestureDetector(
                  onTap: widget.changeScreenMethod,
                  child: Text('Login',
                      style: Utils.kAppHeading5BoldStyle
                          .copyWith(color: Utils.greenColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
