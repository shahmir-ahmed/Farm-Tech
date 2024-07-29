import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
// import 'package:farm_tech/presentation/views/seller/authentication/authentication_view.dart';
// import 'package:farm_tech/presentation/views/shared/splash_screen/splash_screen_view.dart';
import 'package:farm_tech/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          // statusBarColor: Color(0xffffdabe),
          statusBarIconBrightness: Brightness.dark,
        ),
      child: MaterialApp(
        // home: AuthenticationView()
        // home: SplashScreenView(
        //       // forBuyer: true,
        //       ),
        home: StreamProvider<UserModel?>.value(
          initialData: null,
          value: UserAuthServices().authStream,
          child: AuthWrapper()
        ),
      ),
    );
  }
}
