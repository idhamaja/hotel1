import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotels_1/pages/detail_page.dart';
import 'package:hotels_1/services/database.dart';
import 'package:hotels_1/services/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? hotelStream;

  getOnTheLoad() async {
    hotelStream = await DatabaseMethods().getAllHotels();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  // Sample destination data
  final List<Map<String, dynamic>> destinations = [
    {
      'image': "images/mumbai.jpg",
      'name': "C.Stone Hotel Suramadu",
      'hotelCount': "10 Hotels",
    },
    {
      'image': "images/newyork.jpg",
      'name': "Liberty Statue",
      'hotelCount': "10 Hotels",
    },
    {
      'image': "images/bali.jpg",
      'name': "Bali City",
      'hotelCount': "10 Hotels",
    },
    {
      'image': "images/dubai.jpg",
      'name': "Abu Dhabi City",
      'hotelCount': "10 Hotels",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 241, 241),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with search
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                    child: Image.asset(
                      "images/home.jpg",
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(97, 0, 0, 0),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white),
                            const SizedBox(width: 10.0),
                            Text(
                              "Jakarta Indonesia",
                              style: AppWidget.whiteTextStyle(20.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        Text(
                          "How are you, Idham! \nTell us where want to go",
                          style: AppWidget.whiteTextStyle(24.0),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                          margin: const EdgeInsets.only(right: 20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(103, 255, 255, 255),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              hintText: "Search Places",
                              hintStyle: AppWidget.whiteTextStyle(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Hotels section from Firestore
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "The most relevant",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),

              // Display hotels from Firestore
              _buildHotelsFromFirestore(),

              // Destinations section
              const SizedBox(height: 15.0),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Discover new places",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    return _buildDestinationCard(
                      destination: destinations[index],
                      isFirst: index == 0,
                    );
                  },
                ),
              ),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display hotels from Firestore
  Widget _buildHotelsFromFirestore() {
    return StreamBuilder(
      stream: hotelStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text('No hotels found'));
        }

        return Container(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

              String name = data['HotelName'] ?? 'No Name';
              String price = data['HotelCharges']?.toString() ?? '0';
              String location = data['HotelAddress'] ?? 'No Address';
              String image = data['Image'] ?? 'images/hotel.jpg';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        bathroom: data['Bathroom'] ?? "false",
                        description: data['HotelDescription'] ?? "",
                        hdtv: data['HDTV'] ?? "false",
                        kitchen: data['Kitchen'] ?? "false",
                        price: price,
                        wifi: data['WiFi'] ?? "false",
                        name: name,
                        image: image,
                        location: location,
                        hotelid: ds.id,
                      ),
                    ),
                  );
                },
                child: _buildHotelCard(
                  name: name,
                  price: price,
                  location: location,
                  image: image,
                  isFirst: index == 0,
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Hotel card widget - UPDATED TO MATCH THE IMAGE

  Widget _buildHotelCard({
    required String name,
    required String price,
    required String location,
    required String image,
    bool isFirst = false,
  }) {
    return Container(
      margin: EdgeInsets.only(left: isFirst ? 20.0 : 15.0, right: 15.0),
      width: 300,
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "images/hotel.jpg",
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

              // TEXT SECTION
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel name + price in one row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          "\Rp. $price",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    // Location row
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Destination card widget
  Widget _buildDestinationCard({
    required Map<String, dynamic> destination,
    bool isFirst = false,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: isFirst ? 20.0 : 15.0,
        right: destination == destinations.last ? 20.0 : 0,
        bottom: 5.0,
      ),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  destination['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  destination['name'],
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    const Icon(Icons.hotel, color: Colors.blue, size: 18),
                    const SizedBox(width: 6.0),
                    Text(
                      destination['hotelCount'],
                      style: const TextStyle(fontSize: 16.0),
                    ),
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
