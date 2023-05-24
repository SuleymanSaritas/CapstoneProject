import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            title: Text('Congratulations!'),
            content: Text(
                'Congratulations, you have contributed to nature with your activity. Click to find out your contribution.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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
        title: Text('Donate Solution for $product'),
        centerTitle: true,
        backgroundColor: Color(0xFF8A2BE2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ... Your previous widgets ...
            Text(
              'Food Banks to Donate Your Vegetables:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The list of food banks is for when the vegetables are not needed:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('• iHH- insani yardim Vakfi'),
            Text('• Aip- Acil intiyas projesi Vakfi'),
            Text('• Insani insa dernegi'),
            Text('• Uluslararasi Insani Yardim Dernegi'),
            Text('• 1 Tek Lira Dernegi'),
            Text('• lyilikler Yardimlasma Dernegi'),
            Text('• Besir Dernegi'),
            Text('• Vuslat Dernegi'),
            Text('• Aziz Mahmud Hüdayi Vakfi'),
            Text('• Endes Engellilere Destek ve Yardim Dernegi'),
            Text(
                '• TİDER (Basic Needs Association organization) (food bank umberlla org.)'),
            Text(
                '• Donate to soup kitchens that aim to serve food to the homeless such as:'),
            InkWell(
              onTap: () {
                // Handle the URL redirect here
              },
              child: Text(
                '“Hayata Sarıl Lokantası” (Embrace Life Restaurant), a restaurant for homeless people in Istanbul',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Donations for Animal Feed:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'List of where you can donate food for animal feed:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('Animal Shelter'),
            Text('1) Türkiye Hayvanları Koruma Derneği (Animal Shelter)'),
            Text('2) Haçiko (Animal Shelter)'),
            Text('3) Haytap (Animal Shelter)'),
            Text('4) Yedikule Hayvan Barınağı (Animal Shelter)'),
            InkWell(
              onTap: () {
                // Handle the URL redirect here
              },
              child: Text(
                '5) Special "bread dumpsters" located in Istanbul that recycle bread into animal feed',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ]),
        ),
      ),
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
