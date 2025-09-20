import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hotels_1/services/constant.dart';
import 'package:hotels_1/services/database.dart';
import 'package:hotels_1/services/shared_preferences.dart';
import 'package:hotels_1/services/widget_support.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:random_string/random_string.dart';

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
  final String hotelid;

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
    required this.hotelid,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _guestController = TextEditingController(
    text: "1",
  );
  DateTime? _startDate;
  DateTime? _endDate;
  int _daysDifference = 1;
  int _guestCount = 1;
  int _finalAmount = 0;
  Map<String, dynamic>? _paymentIntent;
  String? username, userid, userimage;

  getOnTheLoad() async {
    username = await SharedPreferencesHelper().getUserName();
    userid = await SharedPreferencesHelper().getUserId();
    userimage = await SharedPreferencesHelper().getUserImage();
  }

  @override
  void initState() {
    super.initState();
    _finalAmount = _parsePrice(widget.price);
    getOnTheLoad();
  }

  // Parse price string to integer
  int _parsePrice(String priceString) {
    final cleaned = priceString.replaceAll(RegExp(r'[^\d.]'), '');

    if (cleaned.contains('.') && cleaned.indexOf('.') < cleaned.length - 3) {
      return double.parse(cleaned.replaceAll('.', '')).round();
    }

    return double.parse(cleaned).round();
  }

  // Format currency for display
  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }

  // Format date for display
  String _formatDate(DateTime? date) {
    return date != null
        ? DateFormat("dd MMM yyyy").format(date)
        : "Select date";
  }

  // Select start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
        _calculateDifference();
      });
    }
  }

  // Select end date
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _endDate ??
          (_startDate ?? DateTime.now()).add(const Duration(days: 1)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _calculateDifference();
      });
    }
  }

  // Calculate days difference
  void _calculateDifference() {
    if (_startDate != null && _endDate != null) {
      _daysDifference = _endDate!.difference(_startDate!).inDays;
      if (_daysDifference < 1) _daysDifference = 1;
      _updateFinalAmount();
    }
  }

  // Update final amount
  void _updateFinalAmount() {
    setState(() {
      _finalAmount = _parsePrice(widget.price) * _daysDifference * _guestCount;
    });
  }

  // Build amenity row
  Widget _buildAmenityRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 12),
          Text(text, style: AppWidget.normalTextStyle(18.0)),
        ],
      ),
    );
  }

  // Handle book now button press
  void _handleBookNow() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in and check-out dates'),
        ),
      );
      return;
    }

    makePayment(_finalAmount.toString());
  }

  // Payment methods
  Future<void> makePayment(String amount) async {
    try {
      _paymentIntent = await _createPaymentIntent(amount, "IDR");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: _paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Hotels',
        ),
      );

      await displayPaymentSheet(amount);
    } catch (e, s) {
      print('Payment exception: $e $s');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    }
  }

  Future<void> displayPaymentSheet(String amount) async {
    String addId = randomAlphaNumeric(10);
    try {
      await Stripe.instance.presentPaymentSheet();

      Map<String, dynamic> userBookingHotel = {
        "Username": username,
        "UserImage": userimage,
        "CheckIn": _formatDate(_startDate),
        "CheckOut": _formatDate(_endDate),
        "Total": _finalAmount.toString(),
        "HotelName": widget.name,
      };

      await DatabaseMethods().addUserBooking(userBookingHotel, userid!, addId);
      await DatabaseMethods().addHotelOwnerBooking(
        userBookingHotel,
        widget.hotelid,
        addId,
      );

      // Payment successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Payment successful!',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      );

      setState(() {
        _paymentIntent = null;
      });
    } on StripeException catch (e) {
      print("Stripe Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment cancelled: ${e.error.localizedMessage}'),
        ),
      );
    } catch (e) {
      print('Payment Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment error: ${e.toString()}')));
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': _calculateAmount(amount),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating payment intent: ${err.toString()}');
      rethrow;
    }
  }

  String _calculateAmount(String amount) {
    return (int.parse(amount) * 100).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 241, 241),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image with back button
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: AssetImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: AppWidget.headlineTextStyle(27.0)),
                  const SizedBox(height: 8),
                  Text(
                    "${_formatCurrency(_parsePrice(widget.price))}/night",
                    style: AppWidget.normalTextStyle(20.0),
                  ),
                  const SizedBox(height: 15),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 15),

                  // Amenities section
                  Text(
                    "What this place offers",
                    style: AppWidget.headlineTextStyle(22.0),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      if (widget.wifi == "true")
                        _buildAmenityRow(Icons.wifi, "WiFi"),
                      if (widget.hdtv == "true")
                        _buildAmenityRow(Icons.tv, "HDTV"),
                      if (widget.kitchen == "true")
                        _buildAmenityRow(Icons.kitchen, "Kitchen"),
                      if (widget.bathroom == "true")
                        _buildAmenityRow(Icons.bathroom, "Bathroom"),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 15),

                  // Description section
                  Text(
                    "About this place",
                    style: AppWidget.headlineTextStyle(22.0),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: AppWidget.normalTextStyle(16.0),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25),

                  // Booking section
                  _buildBookingSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSection() {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${_formatCurrency(_finalAmount)} for $_daysDifference night${_daysDifference > 1 ? 's' : ''}",
              style: AppWidget.headlineTextStyle(20.0),
            ),
            const SizedBox(height: 15),

            // Check-in date
            _buildDateSelector(
              title: "Check-in Date",
              date: _startDate,
              onTap: () => _selectStartDate(context),
            ),
            const SizedBox(height: 15),

            // Check-out date
            _buildDateSelector(
              title: "Check-out Date",
              date: _endDate,
              onTap: () => _selectEndDate(context),
            ),
            const SizedBox(height: 15),

            // Number of guests
            Text("Number of Guests", style: AppWidget.normalTextStyle(18.0)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _guestController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final count = int.tryParse(value) ?? 0;
                  setState(() {
                    _guestCount = count > 0 ? count : 0;
                    _guestController.text = _guestCount.toString();
                    _guestController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _guestController.text.length),
                    );
                    _updateFinalAmount();
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter number of guests",
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Book Now button
            GestureDetector(
              onTap: () {
                makePayment(_finalAmount.toString());
              },
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    makePayment(_finalAmount.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Book Now",
                    style: AppWidget.whiteTextStyle(20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String title,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppWidget.normalTextStyle(18.0)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFececf8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 16,
                    color: date == null ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
