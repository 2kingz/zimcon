class CheckOutData {
  final String Id;
  final String buyer_id;
  String Order_Total;
  final String Shipping_Fee;
  final String Selected_Billing_Information;
  final String Time_Placed;
  final String Billing_address;
  String batch_code;
  String state;

  CheckOutData(
      {required this.Id,
      required this.buyer_id,
      required this.Order_Total,
      required this.Shipping_Fee,
      required this.Selected_Billing_Information,
      required this.Time_Placed,
      required this.Billing_address,
      required this.batch_code,
      required this.state});
}

List<CheckOutData> myOrdersArray = [];
