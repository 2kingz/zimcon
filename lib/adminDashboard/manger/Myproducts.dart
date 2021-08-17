import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zimcon/adminDashboard/db/MyProductsData.dart';
import 'package:zimcon/adminDashboard/manger/editProduct.dart';
import 'package:zimcon/company_view_products/models/network_image.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:http/http.dart' as http;

class MyProductList extends StatefulWidget {
  const MyProductList({Key? key}) : super(key: key);

  @override
  _MyProductListState createState() => _MyProductListState();
}

class _MyProductListState extends State<MyProductList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  late double _progress;
  List sliderItems = [];
  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    getMyProducts();
    _controller = AnimationController(vsync: this);
  }

  getMyProducts() async {
    EasyLoading.show(status: "Please wait.");
    try {
      var url = Uri.parse(getVendorProducts);
      var response =
          await http.post(url, body: {"poster": posterId.toString()});
      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        setState(() {
          EasyLoading.showSuccess("Great Done!");
          sliderItems = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Reload",
              onPressed: () => getMyProducts()(),
            ),
            content: Text("Response :" + response.statusCode.toString())));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: "Reload",
            onPressed: () => getMyProducts()(),
          ),
          content: Text("ERROR :" + e.toString())));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Products"),
          elevation: 0,
          backgroundColor: Colors.pink,
        ),
        backgroundColor: Colors.white,
        body: getBody());
  }

  Widget getBody() {
    if (sliderItems.contains(null) && sliderItems.length < 0) {
      return Center(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nothing to display yet".toUpperCase(),
                  style: TextStyle(color: Colors.pink, fontSize: 15.0),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      myProducts.clear();
    }
    for (var i = 0; i < sliderItems.length; i++) {
      var item = sliderItems[i];
      myProducts.add(MyProducts(
          id: item["Id"],
          image: item['app_img'],
          cateGory: item['Category'],
          qty: item['Qty'],
          title: item['Name'],
          price: item['Price'],
          description: item['description']));
    }
    return CustomScrollView(
      slivers: <Widget>[
        // _buildAppBar(context),
        _buildListSectionHeader(context, "Your Product Listings"),
        _buildRecommendedList()
      ],
    );
  }

  SliverToBoxAdapter _buildListSectionHeader(
      BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 20.0, top: 20.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  SliverList _buildRecommendedList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: 150.0,
                  width: double.infinity,
                  child: PNetworkImage(server + myProducts[index].image,
                      fit: BoxFit.cover)),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(myProducts[index].title!,
                            style: Theme.of(context).textTheme.headline6!.merge(
                                TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(myProducts[index].cateGory,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .merge(TextStyle(fontSize: 12.0))),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                  Text("\$" + myProducts[index].price!,
                      style: Theme.of(context).textTheme.headline6!.merge(
                          TextStyle(
                              fontSize: 16.0,
                              color: Colors.red,
                              fontWeight: FontWeight.w700))),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProduct(myProduct: myProducts[index])));
                    },
                  )
                ],
              ),
            ],
          ),
        );
      }, childCount: myProducts.length),
    );
  }
}
