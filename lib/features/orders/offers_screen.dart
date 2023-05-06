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
  String? _offerDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teklif Verme Sayfası'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Teklif Fiyatı',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen teklif fiyatını girin';
                  }
                  return null;
                },
                onSaved: (value) => _offerPrice = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Teklif Açıklaması',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen teklif açıklaması girin';
                  }
                  return null;
                },
                onSaved: (value) => _offerDescription = value,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Teklif Ver'),
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
        'description': _offerDescription,
        'user_email': widget.userEmail, // Kullanıcının e-posta adresini ekleyin
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teklif başarıyla gönderildi')),
      );
      Navigator.pop(context);
    }
  }
}
