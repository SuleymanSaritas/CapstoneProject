import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lego_market_app/features/info/donation_screen.dart';

import '../add_product/add_product_screen.dart';
import 'food_advice_screen.dart';

class VeggieListPage extends StatefulWidget {
  @override
  _VeggieListPageState createState() => _VeggieListPageState();
}

class _VeggieListPageState extends State<VeggieListPage> {
  final _veggiesCollection =
      FirebaseFirestore.instance.collection('veggie_waste_solutions');
  String? _chosenVeggie;
  int? _condition, _color, _smell, _texture;

  final Map<String, Widget Function()> _solutionRoutes = {
    'Food': () => FoodListPage(),
    'Donate': () => DonationPage(),
    'Sell': () => AddProductPage(),
    'Recycle': () => DonationPage(),
    // Diğer çözümler ve sayfaları buraya ekleyin
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Advantage'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[300],
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _veggiesCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<String> veggieList = (snapshot.data != null)
              ? snapshot.data!.docs
                  .map((document) => document['name'].toString())
                  .toList()
              : [];

          List<DropdownMenuItem<int>> scoreItems =
              List<DropdownMenuItem<int>>.generate(
            9,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text((index + 1).toString()),
            ),
          );

          return ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose a Vegetable",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _chosenVeggie,
                    items: veggieList.map<DropdownMenuItem<String>>(
                      (String value) {
                        var document = snapshot.data!.docs
                            .firstWhere((doc) => doc['name'] == value);
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Image.network(
                                document['imageURL'],
                                width: 24,
                                height: 24,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 8),
                              Text(value),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                    hint: Text("Choose a Vegetable"),
                    onChanged: (String? value) {
                      setState(() {
                        _chosenVeggie = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Condition Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _condition,
                    items: scoreItems,
                    hint: Text("Condition Score"),
                    onChanged: (int? value) {
                      setState(() {
                        _condition = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Color Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _color,
                    items: scoreItems,
                    hint: Text("Color Score"),
                    onChanged: (int? value) {
                      setState(() {
                        _color = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smell Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _smell,
                    items: scoreItems,
                    hint: Text("Smell Score"),
                    onChanged: (int? value) {
                      setState(() {
                        _smell = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Texture Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _texture,
                    items: scoreItems,
                    hint: Text("Select Texture Score"),
                    onChanged: (int? value) {
                      setState(() {
                        _texture = value;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  int totalScore = _condition! + _color! + _smell! + _texture!;
                  DocumentSnapshot chosenVeggie = snapshot.data!.docs
                      .firstWhere(
                          (document) => document['name'] == _chosenVeggie);
                  List<String> solutions =
                      totalScore > chosenVeggie['threshold']
                          ? List<String>.from(chosenVeggie['best_option'])
                          : List<String>.from(chosenVeggie['worst_option']);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Solutions for $_chosenVeggie'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: solutions
                              .map((solution) => ElevatedButton(
                                    onPressed: () {
                                      if (_solutionRoutes
                                          .containsKey(solution)) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  _solutionRoutes[solution]!()),
                                        );
                                      }
                                    },
                                    child: Text(solution),
                                  ))
                              .toList(),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Get Solution'),
              ),
            ],
          );
        },
      ),
    );
  }
}
