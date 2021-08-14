import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zimcon/url/urlData.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker picker = ImagePicker();
  File? imagePath;
  TextEditingController item = new TextEditingController();
  var valueChoose;
  List listItem = [];

  TextEditingController description = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  bool isItem = false, isPrice = false, isQuantity = false;

  var descriptionm;

  @override
  void initState() {
    super.initState();
    getGeatecoriies();
  }

  getGeatecoriies() async {
    var uri = Uri.parse(categoryUrl);
    var request =
        await http.post(uri, body: {"vendor_cate": vendorCate.toString()});
    print(request.body);
    if (request.statusCode == 200) {
      var data = jsonDecode(request.body);
      if (data != null) {
        List items = data;
        listItem.clear();
        setState(() {
          for (var i = 0; i < items.length; i++) {
            listItem.add(items[i]["Category_Name"]);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 3,
                              blurRadius: 5,
                              color: Colors.pink.withOpacity(0.3),
                            )
                          ],
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: myImage()),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: bottomSheet(context),
                                    ),
                                barrierDismissible: true),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  color: Colors.pinkAccent),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                headerText("Product Information"),
                separator(),
                SizedBox(
                  height: 35,
                ),
                buildTextField("Item", "Item name", item, isItem),
                buildTextField("Price", "Item price", price, isPrice),
                buildTextField("Quantity", "Item qty", quantity, isQuantity),
                DropdownButton(
                    hint: Text("Select Item Category"),
                    isDense: false,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    value: valueChoose,
                    onChanged: (newValue) {
                      setState(() {
                        valueChoose = newValue;
                      });
                    },
                    items: listItem.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList()),
                Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 20),
                  child: TextField(
                    maxLines: 5,
                    enableSuggestions: true,
                    maxLength: 200,
                    buildCounter: descriptionm,
                    controller: description,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        labelText: "Description",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Item Description not more than 200 words",
                        hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        File mia = new File(imagePath!.path);
                        mia.delete();
                        Navigator.pop(context);
                      },
                      child: Text("Discard",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.grey)),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (imagePath != null) {
                            item.text.isEmpty ? isItem = true : isItem = false;
                            price.text.isEmpty
                                ? isPrice = true
                                : isPrice = false;
                            quantity.text.isEmpty
                                ? isQuantity = true
                                : isQuantity = false;
                            if (isItem == true ||
                                isPrice == true ||
                                isQuantity == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Please fill the blank fields.")));
                            } else {
                              uploadProduct();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Product image is requred.")));
                          }
                        });
                      },
                      child: Text(
                        "Upload",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent.withOpacity(0.7),
                          primary: Colors.pink,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void uploadProduct() {
    print(description.text.toString());
    String base64Image = base64Encode(imagePath!.readAsBytesSync());
    String fileName = imagePath!.path.split("/").last;
    final phpEndPoint = Uri.parse(upbloadProduct);
    http.post(phpEndPoint, body: {
      "image": base64Image,
      "name": fileName,
      "user": posterId.toString(),
      "item": item.text,
      "price": price.text,
      "qty": quantity.text,
      "description": description.text,
      "category": valueChoose,
    }).then((res) {
      if (res.statusCode == 200) {
        print(res.body);
        var response = jsonDecode(res.body);
        if (response['success'] == "1") {
          setState(() {
            imagePath = null;
            fileName = "";
            item.text = "";
            price.text = "";
            quantity.text = "";
            description.text = "";
          });
          getGeatecoriies();
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'].toString())));
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget separator() => Divider(
        color: Colors.pinkAccent.withOpacity(0.2),
        thickness: 0.5,
      );

  Widget headerText(String data) => Text(
        data,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent.withOpacity(0.5)),
      );

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Image Source".toUpperCase(),
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    galleryImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Camera")),
              TextButton.icon(
                  onPressed: () {
                    galleryImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery"))
            ],
          )
        ],
      ),
    );
  }

  galleryImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 4160,
          maxWidth: 4160,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.pinkAccent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Cropper',
          ));
      if (croppedFile != null) {
        setState(() {
          imagePath = croppedFile;
        });
      }
    }
  }

  Widget buildTextField(
      String label, String hint, TextEditingController cont, bool error) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            errorText: error ? "This field is required" : null,
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }

  myImage() {
    if (imagePath != null) {
      return FileImage(imagePath!);
    }
    return AssetImage("images/groceries.png");
  }
}
