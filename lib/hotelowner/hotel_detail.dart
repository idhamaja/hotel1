import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotels_1/hotelowner/owner_home.dart';
import 'package:hotels_1/services/database.dart';
import 'package:hotels_1/services/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({super.key});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  bool isChecked = false,
      isChecked1 = false,
      isChecked2 = false,
      isChecked3 = false;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  TextEditingController hotelNamecontroller = new TextEditingController();
  TextEditingController hotelChargescontroller = new TextEditingController();
  TextEditingController hotelAddresscontroller = new TextEditingController();
  TextEditingController hotelDescriptioncontroller =
      new TextEditingController();

  Future getImage() async {
    ImagePicker imagePicker;
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hotel Details",
                  style: AppWidget.boldWhiteTextStyle(26.0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  // Added scroll view
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),

                      selectedImage != null
                          ? Container(
                              width: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                // Add your image picker logic here if needed

                                getImage();
                              },
                              child: Center(
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 2.0,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 35.0,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 20.0),
                      Text(
                        "Hotel Name",
                        style: AppWidget.normalTextStyle(20.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: hotelNamecontroller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Hotel Name",
                            hintStyle: AppWidget.normalTextStyle(20.0),
                          ),
                        ),
                      ),

                      //New Input Decoration
                      SizedBox(height: 20.0),
                      Text(
                        "Hotel Room Charges",
                        style: AppWidget.normalTextStyle(20.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: hotelChargescontroller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Room Charges",
                            hintStyle: AppWidget.normalTextStyle(20.0),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),
                      Text(
                        "Hotel Address",
                        style: AppWidget.normalTextStyle(20.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: hotelAddresscontroller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Hotel Address",
                            hintStyle: AppWidget.normalTextStyle(20.0),
                          ),
                        ),
                      ),

                      //
                      SizedBox(height: 20.0),
                      Text(
                        "What service you want to offer?",
                        style: AppWidget.normalTextStyle(20.0),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          Icon(
                            Icons.wifi,
                            color: const Color.fromARGB(255, 7, 102, 179),
                            size: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text("Wifi", style: AppWidget.normalTextStyle(23.0)),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      //
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isChecked1,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked1 = value!;
                              });
                            },
                          ),
                          Icon(
                            Icons.tv,
                            color: const Color.fromARGB(255, 7, 102, 179),
                            size: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text("HDTV", style: AppWidget.normalTextStyle(23.0)),
                        ],
                      ),

                      //
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isChecked2,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked2 = value!;
                              });
                            },
                          ),
                          Icon(
                            Icons.kitchen,
                            color: const Color.fromARGB(255, 7, 102, 179),
                            size: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "Kitchen",
                            style: AppWidget.normalTextStyle(23.0),
                          ),
                        ],
                      ),

                      //
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isChecked3,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked3 = value!;
                              });
                            },
                          ),
                          Icon(
                            Icons.bathroom,
                            color: const Color.fromARGB(255, 7, 102, 179),
                            size: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "Bathroom",
                            style: AppWidget.normalTextStyle(23.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0), // Added extra space at bottom

                      Text(
                        "Hotel Description",
                        style: AppWidget.normalTextStyle(20.0),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: hotelDescriptioncontroller,
                          maxLines: 6,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter About Hotel",
                            hintStyle: AppWidget.normalTextStyle(20.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () async {
                          // Add your submit logic here
                          String addId = randomAlphaNumeric(10);
                          // Reference firebaseStorageRef = FirebaseStorage
                          //     .instance
                          //     .ref()
                          //     .child("blogImage")
                          //     .child(addId);
                          // final UploadTask task = firebaseStorageRef.putFile(
                          //   selectedImage!,
                          // );
                          // var downloadUrl = await (await task).ref
                          //     .getDownloadURL();

                          Map<String, dynamic> addHotel = {
                            "Image": "",
                            "HotelName": hotelNamecontroller.text,
                            "HotelCharges": hotelChargescontroller.text,
                            "HotelAddress": hotelAddresscontroller.text,
                            "HotelDescription": hotelDescriptioncontroller.text,
                            "WiFi": isChecked ? "true" : "false",
                            "HDTV": isChecked ? "true" : "false",
                            "Kitchen": isChecked ? "true" : "false",
                            "Bathroom": isChecked ? "true" : "false",
                            "Id": addId,
                          };
                          await DatabaseMethods().addHotel(addHotel, addId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Hotel Details has been Uploaded Successfully",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OwnerHomePage(),
                            ),
                          );
                        },
                        child: Center(
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: AppWidget.boldWhiteTextStyle(26.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
