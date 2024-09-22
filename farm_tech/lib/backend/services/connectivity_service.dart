import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isDialogShown = false;
  BuildContext? _context;
  // bool isChecking = false;
  late Timer _internetCheckTimer;

  // Constructor to initialize connectivity monitoring
  ConnectivityService(BuildContext context) {
    _context = context;
    _startMonitoring();
  }

  void _startMonitoring() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // Received changes in available connectivity types!
      _checkConnection();
    });
    // _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   _checkConnection();
    // });
    // Check for internet access every 5 seconds
    // _internetCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
    //   _checkConnection();
    // });
  }

  Future<void> _checkConnection() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;

    print('isConnected in _checkConnection: $isConnected');

    if (!isConnected && !_isDialogShown) {
      _showNoInternetAlertDialog();
    }
  }

  // Show alert dialog when there's no connection
  // show no internet alert dialog
  _showNoInternetAlertDialog() {
    _isDialogShown = true;
    // print('isChecking $isChecking');
    // set up the button
    Widget okButton = CustomButton(
      secondaryButton: false,
      primaryButton: true,
      // widget: isChecking ? Utils.circularProgressIndicatorLightGreen : null,
      buttonText: 'Try again',
      onButtonPressed: () async {
        // closing here so that user knows that trying again
        _isDialogShown = false;
        Navigator.of(_context!).pop(); // Close the dialog
        
        // isChecking = true; // after checking instant no internet screen showing which causes blinking
        // Navigator.of(_context!).pop(); // Close the try again dialog
        // _showNoInternetAlertDialog(); // show loading dialog
        bool isConnected = await InternetConnectionChecker().hasConnection;
        print('isConnected inside onButtonPressed: $isConnected');
        // isChecking = false;
        // Navigator.of(_context!).pop(); // Close the loading dialog
        if (isConnected) {
          // _isDialogShown = false;
          // Navigator.of(_context!).pop(); // Close the dialog
        } else {
          // Navigator.of(_context!).pop(); // Close the dialog
          // if dialog is not shown until now means if between connection status from connectivity plus changed then it has already shown dialog so check here before showing
          // if(!_isDialogShown){
          // Keep showing the dialog until there's internet access
          _showNoInternetAlertDialog();
          // }
        }
      },
      buttonWidth: MediaQuery.of(_context!).size.width,
      buttonHeight: 60,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
      icon: Icon(
        Icons.signal_wifi_off_rounded,
        size: 60,
        color: Colors.black,
      ),
      backgroundColor: Utils.whiteColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        "No Internet Connection",
        style: Utils.kAppHeading6BoldStyle,
      ),
      content: Text(
        textAlign: TextAlign.center,
        "You are not connected to the internet. Please check your connection.",
        style:
            Utils.kAppBody3RegularStyle.copyWith(color: Utils.lightGreyColor1),
      ),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: _context!,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async =>
                false, // False will prevent and true will allow to dismiss
            child: alert);
        // return alert;
      },
    );
  }

  /*
  // Show alert dialog when there's no connection
  void _showNoConnectionDialog() {
    _isDialogShown = true;
    showDialog(
      context: _context!,
      barrierDismissible: false, // Prevent dialog from being dismissed
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button press
          child: AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text(
              'You are not connected to the internet. Please check your connection.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog

                  bool isConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (isConnected) {
                    _isDialogShown = false;
                  } else {
                    // Keep showing the dialog until there's internet access
                    _showNoConnectionDialog();
                  }
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      },
    );
  }
  */

  // Stop monitoring when no longer needed (usually on dispose)
  void dispose() {
    _subscription.cancel();
    _internetCheckTimer.cancel();
  }
}
