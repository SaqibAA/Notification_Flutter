// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  static String serverKey = '';

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //initialising firebase message plugin
  static void firebaseMessageInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  static void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      handleMessage(context, message);
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  // Swith Screen

  static void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msj') {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MessageScreen(
      //               id: message.data['id'],
      //             )));
    }
  }

  static Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

// Android 13 Notification Permission
  static void requestNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
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

  // Send Notification Funtion

  static Future<http.Response> sendNotification(
      String title, String message) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "key=$serverKey"
      },
      body: jsonEncode({
        "to": "/topics/asa_developer", //jsonEncode(await Global.tokenList()),
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "type": "100",
          "title": title,
          "message": message,
          "time": DateTime.now().millisecondsSinceEpoch,
          "sound": "default",
          "vibrate": "300",
        },
        "notification": {
          "vibrate": "300",
          "priority": "high",
          "body": message,
          "title": title,
          "sound": "default",
          "android_channel_id": "1"
        }
      }),
    );
    return response;
  }

  // function to show visible notification when app is active
  static Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.max,
        showBadge: true,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('alarm_clock'));

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',
            sound: channel.sound);

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }
}
