class Cart {
  final String title;
  String numOfItem;
  final String id;
  final String price;
  final String img;
  String totalPrice;

  Cart(
      {required this.title,
      required this.numOfItem,
      required this.id,
      required this.price,
      required this.img,
      required this.totalPrice});
}

// Demo data for our cart

List<Cart> cartItems = [];
