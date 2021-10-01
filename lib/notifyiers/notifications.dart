import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:zimcon/url/urlData.dart';

class Notifiyiers {
  late FlutterLocalNotificationsPlugin localNotification;
  void initMySate() {
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var iOSInitilize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitilize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
    getNotifications();
  }

  getNotifications() async {
    try {
      var response =
          await http.post(Uri.parse(getNotifiedURL), body: {"user": user});
      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        List resp = data;
        if (resp.length > 0 || resp.contains(null)) {
          print(data);
        } else {
          showNotification(
              title: data['Name'], body: data['Details'], id: data['Id']);
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  updateNotification(id) async {
    try {
      var url = Uri.parse(updateNotificationOnRead);
      var response = await http.post(url, body: {"Id": id});
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

//
  Future showNotification(
      {required String title, required String body, id}) async {
    var androidDetails = new AndroidNotificationDetails(
        "com.sbtcc.ZimCon", "ZimCon", "This is the notification description",
        visibility: NotificationVisibility.public,
        playSound: true,
        enableVibration: true,
        importance: Importance.max);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification.show(1, title, body, generalNotificationDetails,
        payload: updateNotification(id));
  }
}
