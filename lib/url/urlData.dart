const String server = "https://zimcon.store/";

const String updateAdress = server + "images/alias.jpg";
const String updatepass = server + "images/alias.jpg";
const String generalInforUpdate = server + "images/alias.jpg";

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
String updateProduct = server + "API/zimcon/vendor/update__product_image.php";
String updateProductInfo = server + "API/zimcon/vendor/UpdateProduct.php";
String deleteVendorItem = server + "API/zimcon/vendor/deleteProduct.php";

String getCateList = server + "API/zimcon/vendor/get_comapny_category.php";
String getPagesList = server + "API/zimcon/pages/getCompanies.php";
String getvendoracc = server + "API/zimcon/vendor/getVendorAcc.php";
String sendVendorBasic = server + "API/zimcon/vendor/upload_and_update.php";

String getSummeryurl = server + "API/zimcon/vendor/getSummeryurl.php";
String getVendorProducts = server + "API/zimcon/vendor/products.php";

String getPageProducts = server + "API/zimcon/pages/getProducts.php";

int cartItemnumber = 1;
int mySelectedIndex = 0;
List<String> listItem = [];
List<String> categories = [
  "Top Trending",
  "Recently",
  "Low Price",
  "Local Products"
];
String cartTotal = "";
String posterId = ""; //This will only be used on the vendor side...
String vendorCate = ""; // And this one also

String aboutApp =
    "Our company is a start-up electronic marketing platform in Kadoma, Zimbabwe, providing ease of access to accommodation such as lodges, residential and commercial sector, available food and restaurant outlets, hardware and fashion outlets in and around Kadoma. The main agenda of ZimCon is to provide a convenience shopping experience and delivery service for both individuals and companies at any time of the day in the comfort of their homes and offices. Also during this time of the pandemic ZimCon will play an essential service in reducing people’s movements hence helping enforcing lockdown regulations and the spread of the virus.";

String getMyOrdrURL = server + "API/zimcon/order_user/get_my_orders.php"; //.php
String getMyOrdrMyOrderURL = server +
    "API/zimcon/order_user/getVendorRequestOrders.php"; //getVendorRequestOrders.php
String getMyOrdrListURL =
    server + "API/zimcon/order_user/get_myOders_details.php";

String getVendorOrderDetails =
    server + "API/zimcon/order_user/getVendorOrderDetails.php";

///Vendor accepting order from a stupid user
String acceptUserOrder = server + "API/zimcon/order_user/acceptUserOrder.php";

String checkVersionURL =
    server + "API/zimcon/updateChecker.php"; //Appversion checker link
String getNotifiedURL = server +
    "API/zimcon/notifications/get_notification.php"; //Getting the notifications from online services
String updateNotificationOnRead =
    server + "API/zimcon/notifications/update_notifications.php";
