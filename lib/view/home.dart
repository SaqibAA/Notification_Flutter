import 'package:flutter/material.dart';
import 'package:push_notification/utils/utils.dart';

import '../res/color.dart';
import '../service/notifications.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController title = TextEditingController();
    TextEditingController message = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Push Notification"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: title,
              cursorColor: AppColors.appColor,
              style: const TextStyle(
                color: AppColors.appColor,
                decoration: TextDecoration.none,
                decorationThickness: 0,
              ),
              decoration: const InputDecoration(
                hintText: "Notification Title",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: message,
              maxLines: null,
              cursorColor: AppColors.appColor,
              style: const TextStyle(
                color: AppColors.appColor,
                decoration: TextDecoration.none,
                decorationThickness: 0,
              ),
              decoration: const InputDecoration(
                hintText: "Notification Message",
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {
                  if (title.text.isEmpty) {
                    Utils.snackBarError("Please Enter Title", context);
                  } else if (message.text.isEmpty) {
                    Utils.snackBarError("Please Enter Message", context);
                  } else {
                    NotificationServices.sendNotification(
                        title.text, message.text);
                  }
                },
                child: const Text("Send Notification")),
          ],
        ),
      ),
    );
  }
}
