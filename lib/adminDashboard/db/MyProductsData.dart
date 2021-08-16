class MyProducts {
  final String? id, title, description, price;
  String image, cateGory, qty;
  MyProducts({
    required this.id,
    required this.image,
    required this.cateGory,
    required this.qty,
    required this.title,
    required this.price,
    required this.description,
  });
}

List<MyProducts> myProducts = [];
