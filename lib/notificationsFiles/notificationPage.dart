import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification",
            style: TextStyle(color: Colors.deepOrangeAccent)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.deepOrangeAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.difference,
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.5),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)]),
        child: Column(
          children: [
            Text("Notification Title",
                style: TextStyle(
                    fontSize: 20.5,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Divider(),
            Text("Notification Body lorem text what so ever what what hello",
                style: TextStyle(
                    fontSize: 15.5,
                    color: Colors.black,
                    fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
