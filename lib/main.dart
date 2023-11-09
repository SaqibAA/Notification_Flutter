import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:push_notification/res/color.dart';
import 'package:push_notification/service/notifications.dart';
import 'package:push_notification/view/home.dart';

import 'global.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDb09qTqpYkfwjk4Cp-2wv0UshYdXspvGI',
      appId: '1:169396261036:android:1b646e262d7bef7cc88f09',
      messagingSenderId: '169396261036',
      projectId: 'music-app-dddb5',
    ),
  );
}

Future<void> main() async {
  await Global.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    NotificationServices.requestNotificationPermission();
    NotificationServices.firebaseMessageInit(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appColor),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
            surfaceTintColor: AppColors.transparent,
            backgroundColor: AppColors.appColor,
            foregroundColor: AppColors.whiteColor,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
                statusBarColor: AppColors.appColor,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarDividerColor: Colors.grey.shade200)),
      ),
      home: const Home(),
    );
  }
}
