import 'package:flutter/material.dart';

class NeOrders extends StatefulWidget {
  const NeOrders({Key? key}) : super(key: key);

  @override
  _NeOrdersState createState() => _NeOrdersState();
}

class _NeOrdersState extends State<NeOrders>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List orders = [];

  @override
  void initState() {
    getOrders();
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  getOrders() {}

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildListItem(index);
              },
              childCount: orders.length,
            ),
          )
        ],
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
                backgroundImage: NetworkImage(orders[index]['app_img']),
              ),
              title: Text(
                'Top Quality fashion item',
                softWrap: true,
              ),
              subtitle: Text(
                orders[index]['Price'],
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ),
        ));
  }
}
