import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodListPage extends StatefulWidget {
  @override
  _FoodListPageState createState() => _FoodListPageState();
}

Future<List<Map<String, dynamic>>> fetchVeggies() async {
  final veggieList = <Map<String, dynamic>>[];
  final querySnapshot =
      await FirebaseFirestore.instance.collection('vegie_food_advice').get();

  querySnapshot.docs.forEach((doc) {
    veggieList.add(doc.data());
  });

  return veggieList;
}

class _FoodListPageState extends State<FoodListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to use excess vegetables'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[300],
        elevation: 0, // Matlık için gerekli
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchVeggies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final veggies = snapshot.data;

          return ListView.builder(
            itemCount: veggies!.length,
            itemBuilder: (context, index) {
              final veggie = veggies[index];
              return ListTile(
                leading: Image.network(veggie['imageURL']),
                title: Text(veggie['name']),
                trailing: IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailsPage(veggie: veggie),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FoodDetailsPage extends StatelessWidget {
  final Map<String, dynamic> veggie;

  FoodDetailsPage({required this.veggie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(veggie['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(veggie['imageURL']),
            SizedBox(height: 8),
            Text(
              'Food Advices:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            ...veggie['food_advices']
                .map<Widget>((advice) => Text('• $advice'))
                .toList(),
            SizedBox(height: 8),
            Text(
              'Storage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(veggie['description']),
          ],
        ),
      ),
    );
  }
}
