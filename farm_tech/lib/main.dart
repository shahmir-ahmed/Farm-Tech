import 'package:farm_tech/presentation/seller/authentication/authentication_view.dart';
import 'package:farm_tech/presentation/shared/splash_screen/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            ));
  }
}
