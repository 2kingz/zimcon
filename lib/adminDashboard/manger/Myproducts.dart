import 'package:flutter/material.dart';
import 'package:zimcon/company_view_products/models/network_image.dart';
import 'package:zimcon/core/assets.dart';

class MyProductList extends StatefulWidget {
  const MyProductList({Key? key}) : super(key: key);

  @override
  _MyProductListState createState() => _MyProductListState();
}

class _MyProductListState extends State<MyProductList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> sliderItems = [
    breakfast,
    burger1,
    meal,
    pancake,
  ];
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          // _buildAppBar(context),
          // _buildSlider(),
          // _buildListSectionHeader(
          //     context, "Popular " + productCategories + " Pages Available"),
          // _buildPopularRestaurant(),
          _buildListSectionHeader(context, "Your Product Listings"),
          _buildRecommendedList()
        ],
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
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
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
