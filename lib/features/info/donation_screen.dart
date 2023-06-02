import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../profile/my_benefit_history.dart';

class DonationPage extends StatelessWidget {
  final String? product;

  const DonationPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showBenefitDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Congratulations!',
              style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Congratulations, you have contributed to nature with your activity. Click to find out your contribution.',
              style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Go to my benefits',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.asset('assets/images/leaf.png',
                          width: 20, height: 20),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BenefitHistoryPage(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _addBenefitToCurrentUser(
        String veggie, double weight, String action) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final donationData = {
          'veggie': veggie,
          'weight': weight,
          'action': action,
          'date': DateTime.now(),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'your_benefit': FieldValue.arrayUnion([donationData])
        });
      }
    }

    Future<double?> _inputWeight(BuildContext context) async {
      double? weight;
      return showDialog<double>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Weight in kilograms'),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                weight = double.tryParse(value);
              },
              decoration:
                  InputDecoration(hintText: "Enter weight in kilograms"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(weight);
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _handleWeightSubmission(
        BuildContext context, double weight) async {
      await _showBenefitDialog(context);
      await _addBenefitToCurrentUser(product!, weight, 'Donate');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Solution for $product',
            style: TextStyle(fontFamily: 'Lato', color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
          color: Theme.of(context).cardColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Food Banks to Donate Your Vegetables:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'The list of food banks is for when the vegetables are not needed:',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                            color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text('• iHH- insani yardim Vakfi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• Aip- Acil intiyas projesi Vakfi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• Insani insa dernegi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• Uluslararasi Insani Yardim Dernegi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• 1 Tek Lira Dernegi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• lyilikler Yardimlasma Dernegi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• Besir Dernegi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• Vuslat Dernegi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• Aziz Mahmud Hüdayi Vakfi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('• Endes Engellilere Destek ve Yardim Dernegi',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text(
                          '• TİDER (Basic Needs Association organization) (food bank umberlla org.)',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text(
                          '• Donate to soup kitchens that aim to serve food to the homeless such as:',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      InkWell(
                        child: Text(
                          '“Hayata Sarıl Lokantası” (Embrace Life Restaurant), a restaurant for homeless people in Istanbul',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          launchUrl(Uri.parse(
                              'https://borgenproject.org/homeless-people-in-istanbul/'));
                          launchUrl(Uri.parse(
                              'https://culinarybackstreets.com/cities-category/istanbul/2018/hayata-sarl-lokantas/'));
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Donations for Animal Feed:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'List of where you can donate food for animal feed:',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                            color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text('Animal Shelter',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text(
                          '1) Türkiye Hayvanları Koruma Derneği (Animal Shelter)',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('2) Haçiko (Animal Shelter)',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('3) Haytap (Animal Shelter)',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      Text('4) Yedikule Hayvan Barınağı (Animal Shelter)',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.black)),
                      InkWell(
                        child: Text(
                          '5) Special "bread dumpsters" located in Istanbul that recycle bread into animal feed',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          launchUrl(Uri.parse(
                              'https://www.dailysabah.com/turkey/istanbul/leftover-bread-turned-into-animal-feed-helps-recycling-in-istanbul'));
                          launchUrl(Uri.parse(
                              'https://www.oggusto.com/pets/sokak-hayvanlarina-yardim-etmenin-yollari'));
                        },
                      ),
                    ]),
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          double? weight = await _inputWeight(context);
          if (weight != null) {
            await _handleWeightSubmission(context, weight);
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Weight',
      ),
    );
  }
}
