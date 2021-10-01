class Companies {
  final String title;
  String app_logo;
  final String Tel;
  final String id;
  final String Branch;
  final String email;
  String addresss, status;

  Companies(
      {required this.title,
      required this.app_logo,
      required this.Tel,
      required this.id,
      required this.Branch,
      required this.email,
      required this.addresss,
      required this.status});
}

List<Companies> pagesAvailable = [];
