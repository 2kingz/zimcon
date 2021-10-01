class House {
  String name;
  String address;
  String imageUrl;

  House(this.name, this.address, this.imageUrl);
}

final categoryList = ['Top Recommended', 'Near you', 'Agency Recommended'];

final recommendedList = [
  House(
      'The Moon House', 'P455, Chhatak, Sylhet', 'assets/images/house01.jpeg'),
  House('The Moon House', 'P455, Chhatak, Sylhet', 'assets/images/house02.jpeg')
];
