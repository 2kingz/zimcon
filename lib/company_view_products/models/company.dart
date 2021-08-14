class MyPage {
  final String title;
  String numOfItem;
  final String id;
  final String price;
  final String img;
  String totalPrice;

  MyPage(
      {required this.title,
      required this.numOfItem,
      required this.id,
      required this.price,
      required this.img,
      required this.totalPrice});
}

// Demo data for our MyPage

List<MyPage> cartItems = [];
