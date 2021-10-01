import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zimcon/company_view_products/models/company.dart';
import 'package:zimcon/company_view_products/models/network_image.dart';
import 'package:zimcon/company_view_products/models/pageProduct.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:http/http.dart' as http;

class VendorPages extends StatefulWidget {
  final Companies pagesAvailable;
  VendorPages(this.pagesAvailable);

  @override
  _VendorPagesState createState() => _VendorPagesState();
}

class _VendorPagesState extends State<VendorPages> {
  List companyProducts = [];

  late String compstate, phone;

  @override
  void initState() {
    super.initState();
    checkNertworkAndProceed();
    getThisPageProducts();
    setState(() {
      compstate = widget.pagesAvailable.status;
      phone = widget.pagesAvailable.Tel;
    });
  }

  checkNertworkAndProceed() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  void getThisPageProducts() async {
    var pageId = widget.pagesAvailable.id;
    var url = Uri.parse(getPageProducts);
    var response = await http.post(url, body: {
      "poster": pageId,
      "category": productCategories,
    });
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        companyProducts = items;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.pagesAvailable.title,
                  style: TextStyle(fontSize: 15.3, color: Colors.black45),
                ),
                background: PNetworkImage(
                    server + widget.pagesAvailable.app_logo,
                    fit: BoxFit.cover),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.person),
                  tooltip: 'View Company Profile',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              content: aboutCompany(context),
                            ),
                        barrierDismissible: true);
                  },
                ),
              ]),
          SliverToBoxAdapter(
            child: Container(
                color: Colors.deepOrange,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              compstate.contains("Approved")
                                  ? "VERIFIED:  "
                                  : "",
                              style: TextStyle(
                                  fontSize: 17.5, fontWeight: FontWeight.w800),
                            ),
                            compstate.contains("Approved")
                                ? Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.close_outlined,
                                    color: Colors.white,
                                  )
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          launch("tel://+263$phone");
                        },
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0,
                  childAspectRatio: 1.0,
                  crossAxisCount: 2),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _buildItems(index, context);
                },
                childCount: companyProducts.length,
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Container(
          //       margin: EdgeInsets.only(top: 20.0),
          //       color: Colors.pink,
          //       child: Padding(
          //         padding: EdgeInsets.all(8.0),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             MaterialButton(
          //                 onPressed: () {},
          //                 child: Text("Featured".toUpperCase(),
          //                     style: TextStyle(
          //                         color: Colors.white,
          //                         fontWeight: FontWeight.bold))),
          //             MaterialButton(
          //                 onPressed: () {},
          //                 child: Text("See All".toUpperCase(),
          //                     style: TextStyle(
          //                         color: Colors.white,
          //                         fontWeight: FontWeight.w400))),
          //           ],
          //         ),
          //       )),
          // ),
          // SliverToBoxAdapter(
          //   child: _buildSlider(),
          // ),
          // SliverToBoxAdapter(
          //   child: Container(
          //       padding: EdgeInsets.all(20.0),
          //       color: Colors.pink,
          //       child: Text("Recommended for you".toUpperCase(),
          //           style: TextStyle(
          //               color: Colors.white, fontWeight: FontWeight.bold))),
          // ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return _buildListItem(index);
          //     },
          //     childCount: companyProducts.length,
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildItems(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 250,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProducView(companyProducts,
                      index))), //companyProducts_onTapItem(context, index),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Hero(
                      // transitionOnUserGestures: true,
                      tag: "item$index",
                      child: PNetworkImage(
                        server + companyProducts[index]['app_img'],
                        fit: BoxFit.contain,
                        height: 200,
                        width: double.infinity,
                      ))),
              SizedBox(
                height: 10.0,
              ),
              Text(
                companyProducts[index]['Name'],
                softWrap: true,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '\$' + companyProducts[index]["Price"],
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    return Container(
        height: 100,
        child: Card(
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage(companyProducts[index]['app_img']),
              ),
              title: Text(
                'Top Quality fashion item',
                softWrap: true,
              ),
              subtitle: Text(
                companyProducts[index]['Price'],
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ),
        ));
  }

  aboutCompany(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundImage:
              NetworkImage(server + widget.pagesAvailable.app_logo),
          backgroundColor: Colors.white,
        ),
        Divider(),
        Text(
          widget.pagesAvailable.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          widget.pagesAvailable.Branch,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.email, color: Colors.pink.shade500),
            GestureDetector(
                onTap: () => launch("mailto:" + widget.pagesAvailable.email),
                child: Text(
                  widget.pagesAvailable.email.substring(0, 20) + "...",
                  style: TextStyle(color: Colors.grey),
                )),
          ],
        ),
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.phone, color: Colors.pink.shade500),
            GestureDetector(
                onTap: () => launch("tel://" + widget.pagesAvailable.Tel),
                child: Text(
                  widget.pagesAvailable.Tel,
                  style: TextStyle(color: Colors.grey),
                )),
          ],
        ),
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home, color: Colors.pink.shade500),
            SizedBox(
              width: 100,
              height: 100,
              child: Text(
                widget.pagesAvailable.addresss,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
