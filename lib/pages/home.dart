import 'package:flutter/material.dart';
import 'package:hotels_1/services/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Sample hotel data
  final List<Map<String, dynamic>> hotels = [
    {
      'name': 'Hotel Fairmont',
      'price': 'Rp.250.000',
      'location': 'Near Main Market, Jakarta',
      'image': 'images/hotel1.jpg',
    },
    {
      'name': 'Hotel Bali',
      'price': 'Rp.850.000',
      'location': 'Near Beach, Kuta',
      'image': 'images/hotel2.jpg',
    },
    {
      'name': 'The Trans Luxury Hotel',
      'price': 'Rp.850.000',
      'location': 'Kota Bandung, Jawa Barat',
      'image': 'images/hotel3.jpg',
    },
  ];

  // Sample destination data
  final List<Map<String, dynamic>> destinations = [
    {
      'image': "images/mumbai.jpg",
      'name': "Jembatan Suramadu",
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
              // Header section with search (unchanged)
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
                          "Howdy, Idham! Tell us where want to go",
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

              // Hotels section (unchanged)
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "The most relevant",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 350,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = hotels[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 20.0 : 15.0,
                        right: index == hotels.length - 1 ? 20.0 : 0,
                        bottom: 5.0,
                      ),
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                child: Image.asset(
                                  hotel['image'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            hotel['name'],
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          hotel['price'],
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                          size: 20.0,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Expanded(
                                          child: Text(
                                            hotel['location'],
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          5,
                                          (index) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18.0,
                                          ),
                                        ),
                                        const SizedBox(width: 5.0),
                                        const Text(
                                          "4.8 (120 reviews)",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Destinations section (CLEANED UP)
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
