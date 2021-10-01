import 'package:flutter/material.dart';

class MyAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MyAppBarWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(color: Colors.deepOrangeAccent)),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 2,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.deepOrangeAccent),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
