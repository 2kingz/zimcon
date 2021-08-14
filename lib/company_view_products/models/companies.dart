import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:zimcon/company_view_products/models/network_image.dart';
import 'package:zimcon/company_view_products/page.dart';
import 'package:zimcon/core/assets.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:http/http.dart' as http;

class CompaiesProfiles extends StatefulWidget {
  @override
  _CompaiesProfilesState createState() => _CompaiesProfilesState();
}

class _CompaiesProfilesState extends State<CompaiesProfiles> {
  final List<String> sliderItems = [
    breakfast,
    burger1,
    meal,
    pancake,
  ];

  List pagesAvailable = [];
  @override
  void initState() {
    super.initState();
    getPages();
  }

  void getPages() async {
    var url = Uri.parse(getPagesList);
    var request =
        await http.post(url, body: {"category": productCategories.toString()});
    if (request.statusCode == 200) {
      var data = jsonDecode(request.body);
      setState(() {
        pagesAvailable = data;
        print(pagesAvailable);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(context),
          // _buildSlider(),
          _buildListSectionHeader(
              context, "Popular " + productCategories + " Pages Available"),
          _buildPopularRestaurant(),
          // _buildListSectionHeader(context, "Food recommendations for you"),
          // _buildRecommendedList()
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildSlider() {
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            child: Swiper(
              itemCount: sliderItems.length,
              autoplay: true,
              curve: Curves.easeIn,
              itemBuilder: (BuildContext context, int index) {
                return PNetworkImage(sliderItems[index], fit: BoxFit.cover);
              },
            ),
          ),
          Container(
            height: 200,
            color: Colors.black.withOpacity(0.5),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text("Heavy discount on meals today only.",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      textTheme: TextTheme(
          title: Theme.of(context)
              .textTheme
              .bodyText2!
              .merge(TextStyle(color: Colors.black))),
      iconTheme: IconThemeData(color: Colors.lightGreen),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      expandedHeight: 130,
      floating: true,
      flexibleSpace: Container(
        height: 160,
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text("Deliver to")),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {},
                  )
                ],
              ),
              SizedBox(
                height: 5.5,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    hintText: "Search for company or page",
                    suffixIcon: Icon(Icons.search)),
              )
            ],
          ),
        ),
      ),
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

  SliverGrid _buildPopularRestaurant() {
    return SliverGrid(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VendorPages(pagesAvailable[index])));
                  },
                  child: Container(
                      height: 110.0,
                      width: double.infinity,
                      child: PNetworkImage(
                          server + pagesAvailable[index]["app_logo"],
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(pagesAvailable[index]["Name"],
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .merge(TextStyle(fontSize: 12.0))),
                SizedBox(
                  height: 5.0,
                ),
                Text(pagesAvailable[index]["Branch"],
                    style: Theme.of(context)
                        .textTheme
                        .subhead!
                        .merge(TextStyle(fontSize: 12.0)))
              ],
            ),
          ),
        );
      }, childCount: pagesAvailable.length),
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
                  child: PNetworkImage(sliderItems[index], fit: BoxFit.cover)),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nepali breakfast",
                            style: Theme.of(context)
                                .textTheme
                                .title!
                                .merge(TextStyle(fontSize: 14.0))),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text("Vegetarian, Nepali",
                            style: Theme.of(context)
                                .textTheme
                                .subhead!
                                .merge(TextStyle(fontSize: 12.0))),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                  Text("ZWL. 180.21",
                      style: Theme.of(context)
                          .textTheme
                          .title!
                          .merge(TextStyle(fontSize: 16.0, color: Colors.red))),
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {},
                  )
                ],
              ),
            ],
          ),
        );
      }, childCount: sliderItems.length),
    );
  }
}
