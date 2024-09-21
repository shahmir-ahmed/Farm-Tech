import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/notification_service.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // when just this line of code is written and data is send only from api then noti is not shown and if noti params are present in api then noti is shown
  /*
  SharedPreferences or any other local storage won't work in the _firebaseMessagingBackgroundHandler. source: https://stackoverflow.com/questions/64961326/flutter-strange-behavior-of-shared-preferences
  // check from shared pref. if logged in user is seller then show notification otheriwse not beacuse on same device buyer can also be logged in when noti. recieved
  SharedPreferences.getInstance().then((value) {
    value.reload().then((_) {
      final userType = value.getString('userType');

      print('userType: $userType');

      // a user is logged in
      if (userType != null) {
        // seller is logged in
        if (userType == 'seller') {
          print('seller is logged in');

          NotificationService().initLocalNotifications(message);
          NotificationService().showNotification(message);
        } else {
          print('buyer is logged in');
        }
      } else {
        print('no user is logged in');
      }
    });
  });
  */

  // when app in background/terminated code is working (when a user auth is present)
  // adding data to check if this code is running when noti is recieved (not running when no user is logged in b/c firestore request cannot be made when no user is logged in)
  // await FirebaseFirestore.instance
  //     .collection('deviceUserTypes')
  //     .add({'dummy_field': "dummy"});
  // Fetch user type from a remote source
  String? userType = await fetchUserTypeFromServer(message.data['token']);

  if (userType == 'seller') {
    // Show the notification
    // NotificationService().initLocalNotifications(message);
    NotificationService().showNotification(message);
  }
}

Future<String?> fetchUserTypeFromServer(String deviceToken) async {
  // Implement a network call or use Firestore to fetch the user type
  // This example assumes you fetch data from an API
  return await FirebaseFirestore.instance
      .collection('deviceUserTypes')
      .doc(deviceToken)
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      // return logged in user type on this device
      return snapshot.get('userType');
    } else {
      // no doc with id exists
      return null;
    }
  });
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
