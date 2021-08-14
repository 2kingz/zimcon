import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zimcon/company_view_products/models/network_image.dart';
import 'package:zimcon/url/urlData.dart';

class ManageVendorAcc extends StatefulWidget {
  ManageVendorAcc({Key? key}) : super(key: key);

  @override
  _ManageVendorAccState createState() => _ManageVendorAccState();
}

class _ManageVendorAccState extends State<ManageVendorAcc> {
  final ImagePicker picker = ImagePicker();
  File? imagePath;
  TextEditingController name = new TextEditingController();
  TextEditingController vaddress = new TextEditingController();
  bool isname = false, isvaddress = false;
  String imageLnk = "";
  var valueChoose;
  String valueChoose2 = '';
  List listItem = [];
  @override
  void initState() {
    super.initState();
    getVendorAccDetails();
    getGeatecoriies();
  }

  getGeatecoriies() async {
    var uri = Uri.parse(getCateList);
    var request = await http.post(uri);
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

  void getVendorAccDetails() async {
    var uri = Uri.parse(getvendoracc);
    var request = await http.post(uri, body: {"user": user.toString()});
    if (request.statusCode == 200) {
      var data = jsonDecode(request.body);
      if (data["success"] == "0") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'].toString())));
      } else {
        setState(() {
          name.text = data['result']['Name'];
          vaddress.text = data['result']['Address'];
          imageLnk = server + data['result']['app_logo'];
          vendorCate = data['result']['Category'];
          valueChoose2 = vendorCate;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          floating: true,
          expandedHeight: 200.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            // title: Text(name.text.isEmpty ? 'NO NAME YET' : name.text),
            background: PNetworkImage(imageLnk, fit: BoxFit.cover),
          ),
          actions: <Widget>[
            Container(
                child: InkWell(
              onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        content: bottomSheet(context),
                      ),
                  barrierDismissible: true),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 4, color: Colors.white),
                    color: Colors.pinkAccent),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
              margin: EdgeInsets.only(top: 20.0),
              color: Colors.pink,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                        onPressed: () {},
                        child: Text(
                            name.text.isEmpty
                                ? 'NO NAME YET'
                                : name.text.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                    MaterialButton(
                        onPressed: () {},
                        child: Text("Change Logo".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400))),
                  ],
                ),
              )),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 300,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: name,
                    enabled: true,
                    decoration: InputDecoration(
                        hintText: "Vendor Name", suffixIcon: Icon(Icons.edit)),
                  ),
                  DropdownButton(
                      hint: Text(valueChoose2.toString().isNotEmpty
                          ? valueChoose2
                          : "Select Bussiness Category"),
                      isDense: false,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      value: valueChoose,
                      onChanged: (newValue) {
                        setState(() {
                          valueChoose = newValue;
                          valueChoose2 = valueChoose;
                        });
                      },
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList()),
                  TextField(
                    controller: vaddress,
                    enabled: true,
                    maxLength: 150,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: "Address", suffixIcon: Icon(Icons.edit)),
                  ),
                  myBottons(),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget myBottons() {
    return Row(
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
                  fontSize: 15, letterSpacing: 2, color: Colors.grey)),
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 45),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
        ),
        ElevatedButton(
          onPressed: () {
            if (name.text == "" || vaddress.text == "") {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please fill the blank fields.")));
            } else {
              uploadInfor();
            }
          },
          child: Text(
            "Upload",
            style:
                TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.white),
          ),
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.pinkAccent.withOpacity(0.7),
              primary: Colors.pink,
              padding: EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
        ),
      ],
    );
  }

  Widget separator() => Divider(
        color: Colors.pinkAccent.withOpacity(0.3),
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
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Divider(
            height: 1,
            thickness: 1,
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
          upload();
        });
      }
    }
  }

  void upload() {
    String base64Image = base64Encode(imagePath!.readAsBytesSync());
    String fileName = imagePath!.path.split("/").last;
    final phpEndPoint = Uri.parse(sendVendorBasic);
    http.post(phpEndPoint, body: {
      "image": base64Image,
      "oldImage": imageLnk,
      "name": fileName,
      "command": "image",
      "user": user.toString(),
    }).then((res) async {
      if (res.statusCode == 200) {
        print(res.body);
        var response = jsonDecode(res.body);
        if (response['success'] == "1") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Image is uploaded thank you....".toString())));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'].toString())));
        }
        getVendorAccDetails();
        File mia = new File(imagePath!.path);
        mia.delete();
      }
    }).catchError((err) {
      print(err);
    });
  }

  void uploadInfor() {
    http.post(Uri.parse(sendVendorBasic), body: {
      "user": user.toString(),
      "name": name.text,
      "address": vaddress.text,
      "category": valueChoose2,
      "command": "notImage",
    }).then((res) {
      if (res.statusCode == 200) {
        print(res.body);
        var response = jsonDecode(res.body);
        if (response['success'] == "1") {
          setState(() {
            getVendorAccDetails();
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'].toString())));
      }
    }).catchError((err) {
      print(err);
    });
  }

  myImage() {
    if (imagePath != null) {
      return FileImage(imagePath!);
    }
    return AssetImage("images/groceries.png");
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
}
