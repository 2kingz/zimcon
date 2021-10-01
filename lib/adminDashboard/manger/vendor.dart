import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  TextEditingController phonenumber = new TextEditingController();
  bool isname = false, isvaddress = false;
  String imageLnk = "";
  var valueChoose, valueChooseBranch;
  String valueChoose2 = '', valueChooseBranch2 = '';
  List mYlistItem = [],
      myCompBranch = [
        "Chegutu",
        "Kadoma",
        "Harare",
        "Gweru",
        "Norton",
        "Kwekwe"
      ];

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    getVendorAccDetails();
    getGeatecoriies();
  }

  getGeatecoriies() async {
    EasyLoading.show(status: "Please wait...");
    try {
      var uri = Uri.parse(getCateList);
      var request = await http.post(uri);
      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data != null) {
          List items = data;
          mYlistItem.clear();
          setState(() {
            EasyLoading.showSuccess("Great Done!");
            for (var i = 0; i < items.length; i++) {
              mYlistItem.add(items[i]["Category_Name"]);
            }
          });
        }
      }
    } catch (e) {
      EasyLoading.showError("ERROR : Could not make contact with server");
    }
    EasyLoading.dismiss();
  }

  void getVendorAccDetails() async {
    EasyLoading.show(status: "Hold a sec!");
    try {
      var uri = Uri.parse(getvendoracc);
      var request = await http.post(uri,
          body: {"user": user.toString()}); //To get the vendor account
      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data["success"] == "0") {
          EasyLoading.show(status: data['message']);
        } else {
          setState(() {
            posterId = data['result']['Id'];
            name.text = data['result']['Name'];
            vaddress.text = data['result']['Address'];
            phonenumber.text = data['result']['Tel'];
            imageLnk = data['result']['app_logo'];
            vendorCate = data['result']['Category'];
            valueChoose2 = vendorCate;
            valueChooseBranch2 = data['result']['Branch'];
          });
        }
      }
    } catch (e) {
      EasyLoading.showError("ERROR : Could not make contact with server");
    }
    EasyLoading.dismiss();
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
            background: PNetworkImage(server + imageLnk, fit: BoxFit.cover),
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
            height: 400,
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
                  TextField(
                    controller: phonenumber,
                    keyboardType: TextInputType.phone,
                    enabled: true,
                    decoration: InputDecoration(
                        hintText: "Phone e.g. 0700000000",
                        suffixIcon: Icon(Icons.phone)),
                  ),
                  DropdownButton(
                      hint: Text(valueChooseBranch2.toString().isNotEmpty
                          ? valueChooseBranch2
                          : "Select Company Branch"),
                      isDense: false,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      value: valueChooseBranch,
                      onChanged: (newValue) {
                        setState(() {
                          valueChooseBranch = newValue;
                          valueChooseBranch2 = valueChooseBranch;
                        });
                      },
                      items: myCompBranch.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList()),
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
                      items: mYlistItem.map((valueItem) {
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
          child: Text("Discard".toUpperCase(),
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
            }
            uploadInfor();
          },
          child: Text(
            "SAVE",
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
          maxHeight: 720,
          maxWidth: 720,
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

  void upload() async {
    try {
      EasyLoading.show(status: "Please wait...");
      String base64Image = base64Encode(imagePath!.readAsBytesSync());
      String fileName = imagePath!.path.split("/").last;
      final phpEndPoint = Uri.parse(sendVendorBasic);
      final res = await http.post(phpEndPoint, body: {
        "image": base64Image,
        "oldImage": imageLnk,
        "name": fileName,
        "command": "image",
        "user": posterId.toString(),
      });
      if (res.statusCode == 200) {
        print(res.body);
        var response = jsonDecode(res.body);
        if (response['success'] == "1") {
          EasyLoading.showToast("File uploaded");
        } else {
          EasyLoading.show(status: response['message'].toString());
        }
        getVendorAccDetails();
        File mia = new File(imagePath!.path);
        mia.delete();
      }
      EasyLoading.dismiss();
    } catch (e) {}
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

  Future<void> uploadInfor() async {
    try {
      EasyLoading.show(status: "Please wait...");
      var url = Uri.parse(sendVendorBasic);
      final response = await http.post(url, body: {
        "user": posterId.toString(),
        "name": name.text,
        "phone": phonenumber.text,
        "address": vaddress.text,
        "category": valueChoose2,
        "branck": valueChooseBranch2,
        "command": "notImage"
      });
      if (response.statusCode == 200) {
        print(response.body.toString());
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Response : " + data['message'].toString())));
        if (data['success'].toString() == "1") {
          setState(() {
            getVendorAccDetails();
          });
        }
        EasyLoading.showSuccess(data['message'].toString());
      }
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }
}
