import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfferScreen extends StatefulWidget {
  final String productId;
  final String userEmail;

  OfferScreen({required this.productId})
      : userEmail = FirebaseAuth.instance.currentUser!.email!;

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _offerPrice;
  String? _offerQuantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bidding Page'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bid Price',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Bid Price (TL per kg)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter bid price';
                          }
                          return null;
                        },
                        onSaved: (value) => _offerPrice = value,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Quantity (kg)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Quantity';
                          }
                          return null;
                        },
                        onSaved: (value) => _offerQuantity = value,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  textStyle: TextStyle(color: Colors.white),
                ),
                onPressed: _submitForm,
                child: Text('Give Offer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Teklif verilerini Firestore'a kaydetme
      CollectionReference offers =
          FirebaseFirestore.instance.collection('offers');
      await offers.add({
        'product_id': widget.productId,
        'price': int.parse(_offerPrice as String),
        'quantity': int.parse(_offerQuantity as String),
        'user_email': widget.userEmail,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Offer sent successfully')),
      );
      Navigator.pop(context);
    }
  }
}
