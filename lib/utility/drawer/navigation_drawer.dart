import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zimcon/aboutApp.dart';
import 'package:zimcon/cart/cart_screen.dart';
import 'package:zimcon/login_screen.dart';
import 'package:zimcon/products/groceries.dart';
import 'package:zimcon/user_account/account_setting.dart';
import 'package:zimcon/utility/drawer/data.dart';
import 'package:zimcon/utility/drawer/model/drawer_item.dart';
import 'package:zimcon/utility/drawer/provider/navigation_provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  //this padding controls the icon alinments
  final padding = EdgeInsets.symmetric(horizontal: 20);

  bool userLogOut = false;

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;
    return Container(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          color: Colors.pinkAccent,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                  width: double.infinity,
                  color: Colors.white12,
                  child: buildHeader(isCollapsed)),
              const SizedBox(height: 24),
              buidList(items: itemsFirst, isCollapsed: isCollapsed),
              const SizedBox(height: 5),
              Divider(
                color: Colors.white70,
              ),
              const SizedBox(height: 5),
              buidList(
                  indexOffset: itemsFirst.length,
                  items: itemsSecond,
                  isCollapsed: isCollapsed),
              Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 5)
            ],
          ),
        ),
      ),
    );
  }

  Widget buidList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return builMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectedItem(context, indexOffset + index),
          );
        },
      );
  Widget builMenuItem(
      {required bool isCollapsed,
      required String text,
      required IconData icon,
      required VoidCallback? onClicked}) {
    final color = Colors.white;
    final leading = Icon(icon, color: color);
    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              leading: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(text, style: TextStyle(color: color, fontSize: 15)),
              onTap: onClicked,
            ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? Image.asset(
          "images/zimcon.ico",
          width: 48,
          height: 48,
        )
      : Row(
          children: [
            const SizedBox(width: 24),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 5,
                      blurRadius: 15,
                      color: Colors.white,
                    )
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('images/zimcon.ico'),
                      fit: BoxFit.scaleDown)),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              'Zim',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.pink,
                  fontWeight: FontWeight.w900),
            ),
            Text(
              'Con',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w900),
            )
          ],
        );

  buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward : Icons.arrow_back;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);
            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    final navigateTo = (page) =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    switch (index) {
      case 0:
        navigateTo(AccountSettingPage());
        break;
      case 1:
        navigateTo(CartScreen());
        break;
      case 2:
        navigateTo(Groceries());
        break;
      case 3:
        navigateTo(AboutApp());
        break;
      case 4:
        logoutUser(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
      default:
    }
  }

  logoutUser(BuildContext context) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.clear();
    userLogOut = true;
  }
}
