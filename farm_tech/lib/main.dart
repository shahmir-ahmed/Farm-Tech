import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/order_services.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
// import 'package:farm_tech/presentation/views/seller/authentication/authentication_view.dart';
// import 'package:farm_tech/presentation/views/shared/splash_screen/splash_screen_view.dart';
import 'package:farm_tech/auth_wrapper.dart';
import 'package:farm_tech/consts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // stripe publishable key initialization
  Stripe.publishableKey = stripePublishableKey;
  // firebase initialzitaion
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(const MyApp());

  // creating dummy orders
  // OrderServices().createOrder(OrderModel(
  //     quantity: "1",
  //     totalAmount: "1000",
  //     status: "in progress",
  //     productId: "HGusmi3IPJ7eWjOdCdFj",
  //     customerId: "dummy",
  //     sellerId: "eT8NhARPTMTccAQZ4BaREc832m83"));
  // OrderServices().createOrder(OrderModel(
  //     quantity: "2",
  //     totalAmount: "1500",
  //     status: "completed",
  //     productId: "HGusmi3IPJ7eWjOdCdFj",
  //     customerId: "dummy",
  //     sellerId: "eT8NhARPTMTccAQZ4BaREc832m83"));
  // OrderServices().createOrder(OrderModel(
  //     quantity: "3",
  //     totalAmount: "2000",
  //     status: "completed",
  //     productId: "b6JvxqwDQSYv6KcfZoLs",
  //     customerId: "dummy",
  //     sellerId: "eT8NhARPTMTccAQZ4BaREc832m83"));
  // OrderServices().createOrder(OrderModel(
  //     quantity: "4",
  //     totalAmount: "4000",
  //     status: "cancelled",
  //     productId: "b6JvxqwDQSYv6KcfZoLs",
  //     customerId: "dummy",
  //     sellerId: "eT8NhARPTMTccAQZ4BaREc832m83"));

  /*
  // create updatedAt field in every order
  await FirebaseFirestore.instance.collection('orders').get().then((snapshot) async{
    List<DocumentSnapshot> allDocs = snapshot.docs;
        for (DocumentSnapshot ds in allDocs) {
          await ds.reference.update(
            {
              'updatedAt': null
            }
          );
        }
      
  });
  */
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
            child: const AuthWrapper()),
      ),
    );
  }
}
