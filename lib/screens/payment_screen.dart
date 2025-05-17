import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shop_uz/screens/nfc/nfc_listener_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentCode = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    generateAndSaveCode();
  }

  Future<void> generateAndSaveCode() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final int totalPrice = cart.totalPrice.toInt();

    // 6 xonali tasodifiy kod generatsiyasi
    final random = Random();
    paymentCode = (random.nextInt(900000) + 100000).toString();

    // Firebase Firestore ga yozish
    await FirebaseFirestore.instance
        .collection('pendingPayments')
        .doc(paymentCode)
        .set({
          'amount': totalPrice,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending',
        });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toʻlov'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code, size: 80, color: Colors.blue[800]),
                    SizedBox(height: 24),
                    Text('To‘lov kodi:', style: TextStyle(fontSize: 22)),
                    SizedBox(height: 16),
                    Text(
                      paymentCode,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Iltimos, bu kodni to‘lov terminaliga kiriting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NfcListenerScreen()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "To'lash",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
