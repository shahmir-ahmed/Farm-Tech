import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView({required this.changeScreenMethod});

  // change screen method
  VoidCallback changeScreenMethod;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  // form field values
  String email = '';
  String password = '';

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
                image: const AssetImage('assets/images/login-banner.png'))),
        child: Container(
          margin: const EdgeInsets.only(top: 280),
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
                // Welcome text
                Text(
                  'Welcome Again!',
                  style: Utils.kAppHeading6BoldStyle,
                ),

                // space
                const SizedBox(
                  height: 10.0,
                ),

                // text
                Text(
                  'Login To Access Your Account',
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
                        // email form field
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              email = value.trim();
                            });
                          },
                          decoration: Utils.inputFieldDecoration
                              .copyWith(hintText: 'Email'),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Email is required';
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
                            }
                            return null;
                          },
                          style: Utils.kAppBody3MediumStyle,
                        ),
                      ],
                    )),

                // space
                const SizedBox(
                  height: 20.0,
                ),

                // forgot pass text
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // forgot password text button
                    GestureDetector(
                      onTap: () {
                        // show forgot password screen
                      },
                      child: Text('Forgot your password?',
                          style: Utils.kAppBody3MediumStyle
                              .copyWith(color: Utils.greenColor)),
                    ),
                  ],
                ),

                // space
                const SizedBox(
                  height: 20.0,
                ),

                // login button
                PrimaryButton(
                  onButtonPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // if form is valid
                    }
                  },
                  buttonText: 'Login',
                  buttonWidth: MediaQuery.of(context).size.width,
                  buttonHeight: 60,
                ),

                // space
                const SizedBox(
                  height: 20.0,
                ),

                // dont have an account text
                Text("Don't have an account?",
                    style: Utils.kAppBody3RegularStyle),

                // space
                const SizedBox(
                  height: 20.0,
                ),

                // signup text
                GestureDetector(
                  onTap: widget.changeScreenMethod,
                  child: Text('Sign Up',
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
