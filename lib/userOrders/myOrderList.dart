import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:http/http.dart' as http;
import 'package:zimcon/userOrders/oderDetails.dart';
import 'package:zimcon/userOrders/orders.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List orders = [];

  @override
  void initState() {
    super.initState();
    getMyOrders();
  }

  getMyOrders() async {
    EasyLoading.show(status: "Please wait loading");
    try {
      var url = Uri.parse(getMyOrdrURL);
      var request = await http.post(url, body: {"user": user});
      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        orders = data;
        myOrdersArray.clear();
        setState(() {
          for (var i = 0; i < orders.length; i++) {
            var item = orders[i];
            myOrdersArray.add(CheckOutData(
                Id: item['Id'],
                buyer_id: item['Buyer_id'],
                Order_Total: item['Order_Total'],
                Shipping_Fee: item['Shipping_Fee'],
                Selected_Billing_Information:
                    item['Selected_Billing_Information'],
                Time_Placed: item['Time_Placed'],
                Billing_address: item['Billing_address'],
                batch_code: item['batch_code'],
                state: item['State']));
          }
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
    EasyLoading.showSuccess("Great Done!");
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'.toUpperCase()),
        ),
        body: ListTileTheme(
          contentPadding: EdgeInsets.all(15),
          iconColor: Colors.pink,
          textColor: Colors.black54,
          tileColor: Colors.grey[100],
          style: ListTileStyle.list,
          dense: true,
          child: ListView.builder(
            itemCount: myOrdersArray.length,
            itemBuilder: (_, index) => Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text("Order # " + myOrdersArray[index].batch_code),
                subtitle: Text("Status: " + myOrdersArray[index].state,
                    softWrap: true,
                    style: TextStyle(
                        color: myOrdersArray[index].state.contains("Not")
                            ? Colors.red
                            : Colors.green)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Total: \$" + myOrdersArray[index].Order_Total),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetails(
                                      myOrdersArray: myOrdersArray[index])));
                        },
                        icon: Icon(Icons.remove_red_eye)),
                    // IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    // IconButton(onPressed: () {}, icon: Icon(Icons.add_box)),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
