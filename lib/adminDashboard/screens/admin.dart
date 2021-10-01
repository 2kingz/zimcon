import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zimcon/adminDashboard/manger/Myproducts.dart';
import 'package:zimcon/adminDashboard/manger/addProduct.dart';
import 'package:zimcon/adminDashboard/manger/MyRequestorders.dart';
import 'package:zimcon/adminDashboard/manger/vendor.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:http/http.dart' as http;

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.pink;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();

  TextEditingController item = TextEditingController();

  String soldProductsNumber = "0";

  String ordersNumber = "0";

  String numberOfReturns = "0";

  String numberOfProducts = "0";

  String generatedRevenue = "0.00";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    getGeatecoriies();
  }

  getGeatecoriies() async {
    EasyLoading.show(status: 'Please hold a sec...');
    try {
      var uri = Uri.parse(categoryUrl);
      var request =
          await http.post(uri, body: {"vendor_cate": vendorCate.toString()});
      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data != null) {
          List items = data;
          listItem.clear();
          getSimpleSummery();
          setState(() {
            EasyLoading.showSuccess('Done');
            for (var i = 0; i < items.length; i++) {
              listItem.add(items[i]["Category_Name"]);
            }
          });
        }
      }
    } catch (e) {
      print(e);
      EasyLoading.showError("ERROR : Could not make contact with server");
    }
    EasyLoading.dismiss();
  }

  void getSimpleSummery() async {
    EasyLoading.show(status: 'Please wait loading...');
    try {
      var url = Uri.parse(getSummeryurl);
      var request = await http.post(url, body: {"user": posterId.toString()});
      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        EasyLoading.showSuccess('Great Success!');
        setState(() {
          ordersNumber = data['ordersCal'];
          numberOfProducts = data['ProductCal'];
          generatedRevenue = data['revenueCal'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Reload",
              onPressed: () => getSimpleSummery(),
            ),
            content: Text("Response :" + request.statusCode.toString())));
      }
    } catch (e) {
      EasyLoading.showError("ERROR : Could not make contact with server");
    }
    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.pink, size: 25),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: TextButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: TextButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: TextButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('$generatedRevenue',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(
                                Icons.track_changes,
                                size: 20.00,
                              ),
                              label: Text("Products")),
                          subtitle: Text(
                            numberOfProducts,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 35.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.tag_faces),
                              label: Text("Sold")),
                          subtitle: Text(
                            soldProductsNumber,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 35.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            ordersNumber,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 35.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            numberOfReturns,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 35.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("Manage Products"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyProductList()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.check_box),
              title: Text("New Orders"), //
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MeOrderRequest()));
              },
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.category),
            //   title: Text("Deliveries"),
            //   onTap: () {},
            // ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.add_circle_outline),
            //   title: Text("Like Products"),
            //   onTap: () {
            //     _brandAlert();
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.timer),
            //   title: Text("Bussiness Hours"),
            //   onTap: () {
            //   },
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text("Vendor Profile"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ManageVendorAcc()));
              }, //66+6+4:76
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "VERIFIED BUSINESS : ",
                  style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w800),
                ),
                Icon(
                  Icons.verified,
                  color: Colors.blue,
                )
              ],
            ),
            Divider(),
          ],
        );
      default:
        return Container();
    }
  }
}
