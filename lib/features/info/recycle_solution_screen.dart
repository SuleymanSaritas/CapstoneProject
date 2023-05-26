// import 'package:flutter/material.dart';

// class RecycleSolutionPage extends StatelessWidget {
//   final String? product;

//   const RecycleSolutionPage({Key? key, required this.product})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Product recycling solutions and image url holding a dictionary
//     Map<String, List<String>> recycleSolutions = {
//       'bread': [
//         'How to recycle bread: \nRepurpose Stale Bread = If you have bread that has gone stale but is still edible, consider finding creative ways to repurpose it. Stale bread can be used to make breadcrumbs, croutons, bread pudding, French toast, or bread-based casseroles. By repurposing stale bread, you can extend its usefulness and reduce waste.',
//         'https://www.freepnglogos.com/uploads/bread-png/download-bread-clipart-png-image-pngimg-9.png'
//       ],
//       'apple': [
//         'How to recycle apple: \nMake Apple Cider or Sauce = If you have a surplus of apples, consider making homemade apple cider or applesauce. By processing the apples into delicious beverages or sauces, you can extend their lifespan and avoid wasting them. There are numerous recipes available online that guide you through the process of making these tasty treats.',
//         'https://w7.pngwing.com/pngs/736/5/png-transparent-sugar-apple-graphy-fruit-desktop-apple.png'
//       ],
//       'onion': [
//         'How to recycle onion:  \n1. Vermicomposting =  Another option is vermicomposting, which involves using worms to break down organic waste. Red worms, also known as red wigglers, can efficiently process onion scraps. Set up a vermicomposting bin and add onion waste along with other fruit and vegetable scraps. The worms will convert the waste into nutrient-rich vermicompost that can be used as a natural fertilizer. \n 2. Plant Growth Stimulant = Onions contain sulfur, which is beneficial for plant growth. You can create a natural plant growth stimulant by soaking onion peels in water for a few days. The resulting liquid can be used as a nutrient-rich spray for your plants, promoting their health and growth.',
//         'https://www.freepnglogos.com/uploads/onion-png/onion-images-usseekm-3.png'
//       ],
//     };

//     // Get the recycle solution and image url of the selected product
//     List<String> recycleSolutionAndImage =
//         recycleSolutions[product] ?? ['', ''];
//     List<String> solutionParts = recycleSolutionAndImage[0].split(':');

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recycle Solution for $product'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Image.network(recycleSolutionAndImage[1]), // display image url
//               SizedBox(height: 8),
//               Directionality(
//                 textDirection: TextDirection.ltr,
//                 child: RichText(
//                   text: TextSpan(
//                     style: DefaultTextStyle.of(context).style,
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: solutionParts[0] + ':',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                               color: Colors.black,
//                               fontFamily: 'Roboto')),
//                       TextSpan(
//                           text: solutionParts[1].replaceAll('\\n', '\n'),
//                           style: TextStyle(
//                               fontWeight: FontWeight.normal,
//                               fontSize: 18,
//                               color: Colors.black,
//                               fontFamily: 'Roboto')),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../profile/my_benefit_history.dart';

class RecycleSolutionPage extends StatelessWidget {
  final String? product;

  const RecycleSolutionPage({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Product recycling solutions and image url holding a dictionary
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
                      SizedBox(
                          width:
                              10), // Bu kod metinle resim arasında biraz boşluk bırakır.
                      Image.asset('assets/images/leaf.png',
                          width: 20,
                          height:
                              20), // Yolu ve boyutu kendi logonuza göre ayarlayın
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
      await _addBenefitToCurrentUser(product!, weight, 'Recycle');
    }

    Map<String, List<dynamic>> recycleSolutions = {
      'bread': [
        'How to recycle bread:',
        [
          ' Repurpose Stale Bread : ',
          ' If you have bread that has gone stale but is still edible, consider finding creative ways to repurpose it.',
          ' Stale bread can be used to make breadcrumbs, croutons, bread pudding, French toast, or bread-based casseroles.',
          ' By repurposing stale bread, you can extend its usefulness and reduce waste.'
        ],
        'https://www.freepnglogos.com/uploads/bread-png/download-bread-clipart-png-image-pngimg-9.png'
      ],
      'apple': [
        'How to recycle apple:',
        [
          'Make Apple Cider or Sauce :',
          'If you have a surplus of apples, consider making homemade apple cider or applesauce.',
          'By processing the apples into delicious beverages or sauces, you can extend their lifespan and avoid wasting them.',
          'There are numerous recipes available online that guide you through the process of making these tasty treats.'
        ],
        'https://w7.pngwing.com/pngs/736/5/png-transparent-sugar-apple-graphy-fruit-desktop-apple.png'
      ],
      'onion': [
        'How to recycle onion:',
        [
          '1. Vermicomposting :',
          'Another option is vermicomposting, which involves using worms to break down organic waste.',
          'Red worms, also known as red wigglers, can efficiently process onion scraps.',
          'Set up a vermicomposting bin and add onion waste along with other fruit and vegetable scraps.',
          'The worms will convert the waste into nutrient-rich vermicompost that can be used as a natural fertilizer.',
          '2. Plant Growth Stimulant :',
          'Onions contain sulfur, which is beneficial for plant growth.',
          'You can create a natural plant growth stimulant by soaking onion peels in water for a few days.',
          'The resulting liquid can be used as a nutrient-rich spray for your plants, promoting their health and growth.',
        ],
        'https://www.freepnglogos.com/uploads/onion-png/onion-images-usseekm-3.png'
      ],
    };

    // Get the recycle solution and image url of the selected product
    List<dynamic> recycleSolutionAndImage =
        recycleSolutions[product] ?? ['', [], ''];

    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Solution for $product'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(recycleSolutionAndImage[2]), // display image url
              SizedBox(height: 8),
              Text(recycleSolutionAndImage[0],
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Roboto')),
              SizedBox(height: 8),
              for (var step in recycleSolutionAndImage[1])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    step,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontFamily: 'Roboto'),
                  ),
                ),
            ],
          ),
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
