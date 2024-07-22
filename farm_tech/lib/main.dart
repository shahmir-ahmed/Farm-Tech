import 'package:farm_tech/presentation/seller/authentication/authentication_view.dart';
import 'package:farm_tech/presentation/shared/splash_screen/splash_screen_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AuthenticationView()
        home: SplashScreenView(
            // forBuyer: true,
            )
        );
  }
}
