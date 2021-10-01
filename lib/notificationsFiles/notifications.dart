import 'package:flutter/material.dart';
import 'package:zimcon/Utilities/appbar.dart';
import 'package:zimcon/notificationsFiles/notificationPage.dart';

class MyNotifications extends StatelessWidget {
  const MyNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(
        title: 'Notifications',
      ),
      body: ListView.separated(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 35,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "E-Commerce",
              style: TextStyle(color: Colors.black38),
            ),
            subtitle: Text(
              "Thank you for downloading ZimCon app",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }
}
