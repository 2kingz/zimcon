import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:zimcon/userOrders/orders.dart';
import 'package:http/http.dart' as http;

class OrderDetails extends StatefulWidget {
  final CheckOutData myOrdersArray;
  const OrderDetails({Key? key, required this.myOrdersArray}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List orderDetail = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    EasyLoading.show(status: "Retriving Infor");
    var url = Uri.parse(getMyOrdrListURL);
    try {
      var request = await http
          .post(url, body: {"batch_code": widget.myOrdersArray.batch_code});
      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        setState(() {
          orderDetail = data;
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Order Details ".toUpperCase(),
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
          height: double.infinity,
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.color,
              color: Color(0xEEDAD3BB),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.5),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
              ]),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("ZIM".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 15.5,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold)),
                            Text("CON".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 15.5,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(
                            "Order #: ".toUpperCase() +
                                widget.myOrdersArray.batch_code,
                            style: TextStyle(
                                fontSize: 15.5,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ]),
                  Divider(),
                  Text("Order Details",
                      style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                ],
              ),
              Divider(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        height: 255,
                        width: double.infinity,
                        child: myListView())
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Grand Total: \$" + oderTotal(),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.ubuntu(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.myOrdersArray.Billing_address,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.ubuntu(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.myOrdersArray
                                      .Selected_Billing_Information +
                                  "\n" +
                                  "Ship Fee \$" +
                                  widget.myOrdersArray.Shipping_Fee,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.ubuntu(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              widget.myOrdersArray.state,
                              style: TextStyle(
                                  color:
                                      widget.myOrdersArray.state.contains("Not")
                                          ? Colors.red
                                          : Colors.green),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      children: [
                        Text(
                          "Date Placed: " + widget.myOrdersArray.Time_Placed,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.ubuntu(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  oderTotal() {
    double sum = 0.00;
    for (var i = 0; i < orderDetail.length; i++) {
      sum += double.parse(orderDetail[i]['TPrice']);
    }
    return sum.toStringAsFixed(2);
  }

  Widget myListView() {
    return ListView.separated(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: orderDetail.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            orderDetail[index]['Name'],
            style: TextStyle(color: Colors.black38),
          ),
          subtitle: Text(
            "Price : \$" +
                orderDetail[index]['price'] +
                ", Qty x" +
                orderDetail[index]['Qty'] +
                " Total \$" +
                orderDetail[index]['TPrice'],
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
