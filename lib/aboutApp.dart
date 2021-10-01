import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: appBody());
  }

  Widget appBody() {
    return Column(children: <Widget>[
      Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          Image(
              width: double.infinity,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 3,
              image: AssetImage("images/burner.png")),
          Positioned(
              height: 100,
              width: 100,
              bottom: -70.0,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("images/zimcon.ico"),
              )),
        ],
      ),
      SizedBox(height: 55),
      ListTile(
        title: Center(
            child: Text(
          'ZimCon',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        )),
        subtitle:
            Center(child: Text("#1 Buying and Marketing Online Platform")),
      ),
      TextButton.icon(
          onPressed: () {
            launch("mailto:balladsamu@2kingzsoftwares.com");
          },
          icon: Icon(Icons.email),
          label: Text("Feedback")),
      ListTile(
        title: Text("About",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        subtitle: Text(
          'ZimCon is to provide a convenience shopping experience and delivery service for both individuals and companies at any time of the day in the comfort of their homes and offices. Also during this time of the pandemic ZimCon will play an essential service in reducing people’s movements hence helping enforcing lockdown regulations and the spread of the virus.',
          maxLines: 500,
        ),
      ),
      Divider(),
      TextButton(
          onPressed: () => showAboutDialog(
              context: context,
              applicationIcon: Image.asset(
                "images/zimcon.ico",
                fit: BoxFit.contain,
              ),
              applicationName: "ZimCon",
              applicationVersion: "1.0.0"),
          child: Text("About App & Licenses"))
    ]);
  }
}
