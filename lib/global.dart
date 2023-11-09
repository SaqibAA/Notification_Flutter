import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Initialize Everything here
class Global {
  static CollectionReference devicesId =
      FirebaseFirestore.instance.collection('devicesId');
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDb09qTqpYkfwjk4Cp-2wv0UshYdXspvGI',
        appId: '1:169396261036:android:1b646e262d7bef7cc88f09',
        messagingSenderId: '169396261036',
        projectId: 'music-app-dddb5',
      ),
    );
    subscribeToNotification();
  }

  
  static getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      if (!await checkToken(token.toString())) {
        devicesId.doc().set({
          "token": token.toString(),
        });
      }
    });
  }

  void isTokenRefresh() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  static subscribeToNotification() {
    FirebaseMessaging.instance.subscribeToTopic('asa_developer').then((value) {
      // Successfully subscribed to Notification Service
      print('Successfully subscribed to Notification Service');
    }).catchError((error) {
      // Subscription to Notification Service failed
      print('Subscription to Notification Service failed: $error');
    });
  }

  static Future<bool> checkToken(String token) async {
    QuerySnapshot querySnapshot = await devicesId.get();
    for (var doc in querySnapshot.docs) {
      if (doc['token'] == token) {
        return true;
      }
    }
    return false;
  }

  static Future<List> tokenList() async {
    List tokenList = [];
    QuerySnapshot querySnapshot = await devicesId.get();
    for (var doc in querySnapshot.docs) {
      tokenList.add(doc['token']);
    }
    print(tokenList);
    return tokenList;
  }
}
