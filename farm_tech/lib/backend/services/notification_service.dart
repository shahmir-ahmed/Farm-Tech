//get token
// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/auth_wrapper.dart';
import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/backend/services/server_key_service.dart';
import 'package:farm_tech/backend/services/user_auth_services.dart';
import 'package:farm_tech/presentation/views/seller/home/home_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. notification is recieved when app is in background ore terminated when no user is logged in, means not checking shared pref.
// 2. notification in foreground is correctly displayed i.e. only when seller is logged in
class NotificationService {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //send notificartion request
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
        // save seller device token with seller id in firestore (at the time of registering done)
        // SellerServices().saveSellerDeviceToken(sellerId, deviceToken);
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

//Fetch FCM Token
  Future<String> getDeviceToken() async {
    // not request permission now
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    String? token = await messaging.getToken();
    print("token=> $token");
    return token!;
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      // handleMessage(context, message);
    });
  }

//
  void firebaseInit(BuildContext context) {
    // print('inside firebase init');
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        // print("notifications title:${notification!.title}");
        // print("notifications body:${notification.body}");
        // print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        // check from shared pref. if logged in user is seller then show notification otheriwse not beacuse on same device buyer can also be logged in when noti. recieved

        SharedPreferences.getInstance().then((value) {
          // print('value: $value');
          final userType = value.getString('userType');
          final userId = value.getString('uId');

          // print('userType: $userType'); // not printing

          // a user is logged in
          if (userType != null) {
            // seller is logged in
            if (userType == 'seller') {
              print('seller is logged in');

              // if for same seller who is logged in currently
              if (message.data['sellerId'] == userId) {
                // initLocalNotifications(context, message);
                initLocalNotifications(message);
                showNotification(message);
              }
            } else {
              print('buyer is logged in');
            }
          } else {
            print('no user is logged in');
          }
        });
        // Working fine now on foreground
        // before noti was recieved but nothing happens on clicking
        // same device token on when buyer side sending noti not recievied but on seller side recieved and clicking
        // issue in logging out beacuse of home screen shown when clicking on noti
        // initLocalNotifications(context, message);
        // showNotification(message);
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // // when app is terminated
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();

    // if (initialMessage != null) {
    //   handleMessage(context, initialMessage);
    // }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

    // Handle terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(context, message);
      }
    });
  }

  /*
   // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    try{
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      // message.notification!.android!.channelId.toString(),
      // message.notification!.android!.channelId.toString(),
      "id",
      "name",
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            // channel.id.toString(), channel.name.toString(),
            "id", "name",
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',
            sound: channel.sound
            //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
            //  icon: largeIconPath
            );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        // message.notification!.title.toString(),
        // message.notification!.body.toString(),
        message.data['title'].toString(),
        message.data['body'].toString(),
        notificationDetails,
        payload: 'my_data',
      );
    });
    }catch(e){
      print('Err in showNotification: $e');
    }
  }
  */

  Future<void> showNotification(RemoteMessage message) async {
    try {
      const String groupKey = 'com.example.notification.GROUP';
      const String groupChannelId = 'grouped_channel';

      // Create a notification channel for grouped notifications
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        groupChannelId,
        "Grouped Notifications",
        description: "Notifications grouped under a single app name",
        importance: Importance.max,
        showBadge: true,
        playSound: true,
      );

      // Individual notification details
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(groupChannelId, "Grouped Notifications",
              channelDescription: 'your channel description',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              ticker: 'ticker',
              groupKey: groupKey); // This will group notifications

      // Summary notification details with InboxStyle
      AndroidNotificationDetails summaryNotificationDetails =
          AndroidNotificationDetails(groupChannelId, "Grouped Notifications",
              channelDescription: 'your channel description',
              importance: Importance.high,
              priority: Priority.high,
              groupKey: groupKey,
              setAsGroupSummary: true,
              styleInformation: InboxStyleInformation(
                [], // Empty list for now
                contentTitle: 'You have new notifications',
                // summaryText: 'Total notifications: X', // Update dynamically
              ));

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: darwinNotificationDetails);

      // Generate a unique ID for each notification
      int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Show individual notifications
      _flutterLocalNotificationsPlugin.show(
        notificationId, // Use unique ID for each notification
        message.data['title'].toString(),
        message.data['body'].toString(),
        notificationDetails,
        payload: 'my_data',
      );

      // Delay showing the summary notification slightly to allow grouping to happen
      Future.delayed(const Duration(milliseconds: 500), () {
        _flutterLocalNotificationsPlugin.show(
          0, // Use constant ID for the summary notification
          'Grouped Notifications',
          'You have new notifications',
          NotificationDetails(
            android: summaryNotificationDetails,
            iOS: darwinNotificationDetails,
          ),
        );
      });
    } catch (e) {
      print('Error in showNotification: $e');
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> handleMessage(
    BuildContext context,
    RemoteMessage message,
  ) async {
    print(
        "Navigating to seller home screen's orders tab. Hit here to handle the message. Message data: ${message.data}");

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => HomeView(
    //       userType: 'seller',
    //       setOrderTabAsActive: true,
    //     ),
    //   ),
    // );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => AnnotatedRegion(
    //             value: const SystemUiOverlayStyle(
    //               statusBarIconBrightness: Brightness.dark,
    //             ),
    //             child: MaterialApp(
    //               home: StreamProvider<UserModel?>.value(
    //                   initialData: null,
    //                   value: UserAuthServices().authStream,
    //                   child: const AuthWrapper()),
    //             ),
    //           )),
    // );

    // if (message.data['screen'] == 'cart') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const CartScreen(),
    //     ),
    //   );
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NotificationScreen(message: message),
    //     ),
    //   );
    // }
  }

  // send notification to seller of new order
  Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required String? sellerId,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await ServerKeyService().getServerKeyToken();
    print("notification server key => ${serverKey}");
    String url =
        "https://fcm.googleapis.com/v1/projects/farm-tech-1a96c/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    //mesaage
    Map<String, dynamic> message = {
      "message": {
        "token": token,
        // "notification": {"body": body, "title": title},
        // "data": data,
        "data": {
          "body": body,
          "title": title,
          "token": token,
          "sellerId": sellerId
        }
      }
    };

    //hit api
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("Notification Sent Successfully!");
    } else {
      print("Notification not send!");
    }
  }

  // save device user logged in type and id with token as id (for background/terminated state app notitifcation showing)
  updateDeviceLoggedInUserDetails(String userType, String userId) async {
    try {
      String deviceToken = await getDeviceToken();

      final result = await FirebaseFirestore.instance
          .collection('deviceDetails')
          .doc(deviceToken)
          .set({'userTypeLoggedIn': userType, 'userIdLoggedIn': userId});

      print('device user type set as $userType');
      print('device user id set as $userId');
    } catch (e) {
      print('Err in updateDeviceLoggedInUserDetails: $e');
      return;
    }
  }
}
