import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BenefitHistoryPage extends StatefulWidget {
  const BenefitHistoryPage({Key? key}) : super(key: key);

  @override
  _BenefitHistoryPageState createState() => _BenefitHistoryPageState();
}

class _BenefitHistoryPageState extends State<BenefitHistoryPage> {
  late Future<DocumentSnapshot> benefits;

  @override
  void initState() {
    super.initState();
    benefits = getUserBenefits();
  }

  Future<DocumentSnapshot> getUserBenefits() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Benefit History'),
      // ),
      body: FutureBuilder<DocumentSnapshot>(
        future: benefits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<dynamic, dynamic>? data =
                snapshot.data!.data() as Map<dynamic, dynamic>?;
            List<dynamic>? yourBenefits =
                data!['your_benefit'] as List<dynamic>?;

            // Create a map to store multipliers for each veggie
            Map<String, double> carbonmultipliers = {
              'onion': 0.2,
              'apple': 0.5,
              'bread': 1.0,
            };
            Map<String, double> watermultipliers = {
              'onion': 100,
              'apple': 500,
              'bread': 1000,
            };

            // Sort by date
            yourBenefits!.sort((a, b) =>
                (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Veggie'),
                  ),
                  DataColumn(
                    label: Text('Weight'),
                  ),
                  DataColumn(
                    label: Text('Date'),
                  ),
                  DataColumn(
                    label: Text('Carbon Emission (kg)'),
                  ),
                  DataColumn(
                    label: Text('Water Saved (liters)'),
                  ),
                ],
                rows: yourBenefits.map<DataRow>((benefit) {
                  String veggie = benefit['veggie'];
                  double weight =
                      (benefit['weight'] as num).toDouble(); // Dönüşüm ekledik
                  DateTime date = (benefit['date'] as Timestamp).toDate();
                  double carbonmultiplier = carbonmultipliers[veggie] ?? 1.0;
                  double watermultiplier = watermultipliers[veggie] ?? 1.0;
                  // Default multiplier is 1 if not found
                  double carbonSaved = weight * carbonmultiplier;
                  double waterSaved = weight * watermultiplier;

                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(veggie)),
                      DataCell(Text('$weight kg')),
                      DataCell(Text(date.toString())),
                      DataCell(Text(carbonSaved.toString())),
                      DataCell(Text(waterSaved.toString())),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
