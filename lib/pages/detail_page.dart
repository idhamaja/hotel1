import 'package:flutter/material.dart';
import 'package:hotels_1/services/widget_support.dart';

class DetailPage extends StatefulWidget {
  final String bathroom;
  final String hdtv;
  final String kitchen;
  final String wifi;
  final String price;
  final String description;
  final String name;
  final String image;
  final String location;

  const DetailPage({
    super.key,
    required this.bathroom,
    required this.hdtv,
    required this.kitchen,
    required this.wifi,
    required this.price,
    required this.description,
    required this.name,
    required this.image,
    required this.location,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 241, 241),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      child: Image.asset(widget.image, fit: BoxFit.cover),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 50.0, left: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Text(widget.name, style: AppWidget.headlineTextStyle(27.0)),
                    Text(
                      "\Rp. " + widget.price,
                      style: AppWidget.normalTextStyle(27.0),
                    ),
                    Divider(thickness: 2.0),
                    SizedBox(height: 10.0),
                    Text(
                      "What this place offers",
                      style: AppWidget.headlineTextStyle(22.0),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        Icon(
                          Icons.wifi,
                          color: const Color.fromARGB(255, 7, 102, 179),
                        ),
                        SizedBox(width: 5.0),
                        Text("WiFi", style: AppWidget.normalTextStyle(23.0)),
                      ],
                    ),
                    SizedBox(height: 20.0),

                    //
                    Row(
                      children: [
                        Icon(
                          Icons.tv,
                          color: const Color.fromARGB(255, 7, 102, 179),
                          size: 30.0,
                        ),
                        SizedBox(width: 10.0),
                        Text("HDTV", style: AppWidget.normalTextStyle(23.0)),
                      ],
                    ),
                    SizedBox(height: 20.0),

                    Row(
                      children: [
                        Icon(
                          Icons.kitchen,
                          color: const Color.fromARGB(255, 7, 102, 179),
                        ),
                        SizedBox(width: 10.0),
                        Text("Kitchen", style: AppWidget.normalTextStyle(23.0)),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Icon(
                          Icons.bathroom,
                          color: const Color.fromARGB(255, 7, 102, 179),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Bathroom",
                          style: AppWidget.normalTextStyle(23.0),
                        ),
                      ],
                    ),
                    Divider(thickness: 2.0),
                    Text(
                      "About this place",
                      style: AppWidget.headlineTextStyle(22.0),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      widget.description,
                      style: AppWidget.normalTextStyle(16.0),
                    ),
                    SizedBox(height: 20.0), // Added extra space at the bottom
                    Material(
                      color: Colors.white,
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(10),

                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.0),
                            Text(
                              "\$1.450.000 for one night",
                              style: AppWidget.headlineTextStyle(20.0),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              "Check-in Date",
                              style: AppWidget.normalTextStyle(20.0),
                            ),
                            Divider(),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  "15 Apr 2025",
                                  style: AppWidget.normalTextStyle(20.0),
                                ),
                              ],
                            ),

                            //
                            SizedBox(height: 10.0),
                            Text(
                              "Check-out Date",
                              style: AppWidget.normalTextStyle(20.0),
                            ),
                            Divider(),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  "18 Apr 2025",
                                  style: AppWidget.normalTextStyle(20.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Number of Guests",
                              style: AppWidget.normalTextStyle(20.0),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFececf8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "1",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Book Now",
                                  style: AppWidget.whiteTextStyle(22.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
