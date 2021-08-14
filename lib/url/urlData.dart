const String server = "https://2kingzsoftwares.com/";

const String updateAdress = server + "ZimCon/UI/images/alias.jpg";
const String updatepass = server + "ZimCon/UI/images/alias.jpg";
const String generalInforUpdate = server + "ZimCon/UI/images/alias.jpg";

const String loginUrl = server + "API/zimcon/login.php";
String user = "";
const String register = server + "API/zimcon/sign_up.php";

String updatePass = server + "API/zimcon/password.php";
String updateGen = server + "API/zimcon/general_infor.php";
String uploadImg = server + "API/zimcon/upload_propic.php";
String updateAddress = server + "API/zimcon/address.php";
String updateVendor = server + "API/zimcon/vendor.php";

String productsList = server + "API/zimcon/products_list.php";
String likeItem = server + "API/zimcon/like_item.php";

String addToCart = server + "API/zimcon/cart/add_to_cart.php";
String getMyCartUri = server + "API/zimcon/cart/get_my_cart.php";
String uriEdit = server + "API/zimcon/cart/edit_my_cart.php";

String productCategories = "Food";
String checkProductLike = server + "API/zimcon/checkLike.php";
String checkProductCart = server + "API/zimcon/cart/checkCart.php";
String getProducturl = server + "API/zimcon/productQtyinCart.php";

String subbmitOrdeUri = server + "API/zimcon/cart/place_order.php";
String categoryUrl = server + "API/zimcon/vendor/get_categories.php";
String upbloadProduct = server + "API/zimcon/vendor/upload.php";

String getCateList = server + "API/zimcon/vendor/get_comapny_category.php";
String getPagesList = server + "API/zimcon/pages/getCompanies.php";
String getvendoracc = server + "API/zimcon/vendor/getVendorAcc.php";
String sendVendorBasic = server + "API/zimcon/vendor/upload_and_update.php";

String getPageProducts = server + "API/zimcon/pages/getProducts.php";

int cartItemnumber = 1;
int mySelectedIndex = 0;
List<String> categories = [
  "Top Trending",
  "Recently",
  "Low Price",
  "Local Products"
];
String cartTotal = "";
String posterId = ""; //This will only be used on the vendor side...
String vendorCate = "";// And this one also
