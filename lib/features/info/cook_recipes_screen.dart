import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../profile/my_benefit_history.dart';

class CookRecipesPage extends StatelessWidget {
  final String? product;

  const CookRecipesPage({Key? key, required this.product}) : super(key: key);

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
      await _addBenefitToCurrentUser(product!, weight, 'Cook');
    }

    // Recipes for each product, each recipe being a map with title, ingredients, steps and image url
    Map<String, List<Map<String, dynamic>>> cookRecipes = {
      'onion': [
        {
          'title': 'French Onion Soup',
          'ingredients': [
            'Ingredients',
            '* 4 large onions, thinly sliced',
            '* 4 tablespoons butter',
            '* 4 cups beef or vegetable broth',
            '* 2 cups water',
            '* 1/2 cup red wine (optional)',
            '* 1 teaspoon Worcestershire sauce',
            '* Salt and pepper to taste',
            '* Baguette slices',
            '* Gruyere or Swiss cheese, grated',
          ],
          'steps': [
            'Instructions:',
            ' Melt the butter in a large pot over medium heat. Add the sliced onions and cook until they caramelize and turn golden brown, stirring occasionally (about 30-40 minutes).',
            ' Add the broth, water, red wine (if using), and Worcestershire sauce to the pot. Season with salt and pepper. Simmer for another 20-30 minutes.',
            ' Meanwhile, preheat the oven to 350°F (175°C). Place the baguette slices on a baking sheet and toast them until crisp.',
            ' Ladle the soup into oven-safe bowls. Top each bowl with a few toasted baguette slices and sprinkle grated cheese over the top.',
            ' Place the bowls on a baking sheet and broil in the oven until the cheese is melted and bubbly.',
            ' Serve hot and enjoy!',
          ],
          'imageUrl':
              'https://pepperscale.com/wp-content/uploads/2017/01/Spicy-French-Onion-Soup-300x200.jpeg',
        },
        {
          'title': 'Caramelized Onion Tart',
          'ingredients': [
            'Ingredients',
            '* 1 sheet of puff pastry, thawed',
            '* 4 large onions, thinly sliced',
            '* 2 tablespoons olive oil',
            '* 2 tablespoons butter',
            '* 1 teaspoon sugar',
            '* Salt and pepper to taste',
            '* 1/2 cup crème fraîche or sour cream',
            '* Fresh thyme leaves (optional)',
          ],
          'steps': [
            'Instructions:',
            ' Preheat the oven to 400°F (200°C). Roll out the puff pastry sheet and place it on a baking sheet.',
            ' In a large skillet, heat the olive oil and butter over medium heat. Add the sliced onions and sauté until they become soft and caramelized (about 20-25 minutes).',
            ' Sprinkle sugar over the onions and continue cooking for another 5 minutes until they become golden brown. Season with salt and pepper.',
            ' Spread the caramelized onions evenly over the puff pastry, leaving a small border around the edges.',
            ' Bake in the preheated oven for 15-20 minutes or until the pastry is golden brown.',
            ' Remove from the oven and let it cool slightly. Dollop crème fraîche or sour cream over the tart and sprinkle with fresh thyme leaves, if desired.',
            ' Cut into slices and serve warm.',
          ],
          'imageUrl':
              'https://img.taste.com.au/Xm8JrIu-/w643-h428-cfill-q90/taste/2016/11/caramelised-onion-and-blue-cheese-tarts-21163-1.jpeg',
        },
      ],
      'apple': [
        {
          'title': 'Classic Apple Pie',
          'ingredients': [
            'Ingredients',
            '* 2 ½ cups all-purpose flour',
            '* 1 cup unsalted butter, cold and cubed',
            '* 1 teaspoon salt',
            '* 1 tablespoon granulated sugar',
            '* 6-7 tablespoons ice water',
            '* 6-7 cups apples, peeled, cored, and sliced',
            '* 1 cup granulated sugar',
            '* ¼ cup all-purpose flour',
            '* 1 teaspoon ground cinnamon',
            '* ¼ teaspoon ground nutmeg',
            '* 2 tablespoons butter, cold and cubed',
            '* 1 egg, beaten (for egg wash)',
            '* 1 tablespoon granulated sugar (for sprinkling)',
          ],
          'steps': [
            'Instructions:',
            'In a large mixing bowl, combine the flour, salt, and sugar. Add the cold cubed butter and mix with a pastry cutter or your hands until the mixture resembles coarse crumbs.',
            'Gradually add ice water, one tablespoon at a time, and mix until the dough comes together. Divide the dough in half, shape into disks, wrap in plastic wrap, and refrigerate for at least 1 hour.',
            'Preheat the oven to 425°F (220°C).',
            'In a separate bowl, combine the sliced apples, sugar, flour, cinnamon, and nutmeg. Toss until the apples are well coated.',
            'Roll out one of the dough disks on a lightly floured surface and transfer it to a pie dish. Pour the apple mixture into the pie crust and dot with the cold cubed butter.',
            'Roll out the second dough disk and place it over the apples. Trim the excess dough and crimp the edges to seal. Cut a few slits on the top crust to allow steam to escape.',
            'Brush the top crust with the beaten egg and sprinkle with sugar.',
            'Place the pie on a baking sheet to catch any drips and bake for 45-50 minutes, or until the crust is golden brown and the apples are tender.',
            'Allow the pie to cool before serving.',
          ],
          'imageUrl':
              'https://img.taste.com.au/K3ExWmsZ/w720-h480-cfill-q80/taste/2016/11/classic-apple-pie-84181-1.jpeg',
        },
        {
          'title': 'Baked Cinnamon Apples',
          'ingredients': [
            'Ingredients',
            '* 4 large apples, cored and halved',
            '* 2 tablespoons butter, melted',
            '* 2 tablespoons brown sugar',
            '* 1 teaspoon ground cinnamon',
            '* 1/4 teaspoon ground nutmeg',
            '* 1/4 cup raisins or chopped nuts (optional)',
            '* Vanilla ice cream or whipped cream for serving',
          ],
          'steps': [
            'Instructions:',
            'Preheat the oven to 375°F (190°C).',
            ' In a small bowl, combine the melted butter, brown sugar, cinnamon, and nutmeg.',
            ' Place the apple halves in a baking dish. Spoon the butter mixture over each apple half, making sure to coat them evenly.',
            ' If desired, sprinkle raisins or chopped nuts over the apples.',
            ' Bake in the preheated oven for about 25-30 minutes, or until the apples are tender and slightly',
          ],
          'imageUrl':
              'https://www.allrecipes.com/thmb/xqx44oIci-lZtUVo3sQ5kRrNNEc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/228683-delicious-cinnamon-baked-apples-ddmfs-Step3-1422-32a76471778b47e9a3018cd0fb75ad53.jpg',
        },
      ],
      'bread': [
        {
          'title': 'Croutons',
          'ingredients': [
            'Ingredients',
            '* Medium-quality bread, sliced or cubed',
            '* Olive oil',
            '* Salt and pepper',
            '* Optional seasonings: garlic powder, dried herbs (such as thyme or rosemary), grated Parmesan cheese',
          ],
          'steps': [
            'Instructions:',
            'Preheat the oven to 350°F (175°C).',
            'Cut the bread into small cubes or slice it into bite-sized pieces.',
            'Toss the bread with olive oil, salt, pepper, and any desired seasonings in a bowl until evenly coated.',
            'Spread the bread cubes in a single layer on a baking sheet.',
            'Bake for about 10-15 minutes or until the croutons are golden brown and crispy.',
            'Allow them to cool and use them to top salads, soups, or as a crunchy addition to your favorite dishes',
          ],
          'imageUrl':
              'https://www.thespruceeats.com/thmb/Cm8H9g2b1S4-X2RyUQTzf7VwX-M=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/135575225-589cb6cc5f9b58819c146104.jpg',
        },
        {
          'title': 'Bread Crumbs',
          'ingredients': [
            'Ingredients',
            '* Medium-quality bread, sliced',
            '* Olive oil or melted butter',
          ],
          'steps': [
            'Instructions:',
            'Preheat the oven to 300°F (150°C).',
            'Tear the bread into smaller pieces and place them in a food processor or blender.',
            'Pulse until the bread turns into coarse crumbs.',
            'Spread the breadcrumbs in a single layer on a baking sheet.',
            'Drizzle olive oil or melted butter over the breadcrumbs and toss to coat evenly.',
            'Bake for about 15-20 minutes, stirring occasionally, until the breadcrumbs are dry and crispy.',
            'Allow them to cool and store in an airtight container.',
            'Use the breadcrumbs as a coating for chicken or fish, sprinkle on top of casseroles, or use them in meatball or meatloaf recipes.',
          ],
          'imageUrl':
              'https://www.wikihow.com/images/thumb/f/fe/Make-Bread-Crumbs-with-Stale-Bread-Step-2-Version-3.jpg/550px-nowatermark-Make-Bread-Crumbs-with-Stale-Bread-Step-2-Version-3.jpg',
        },
      ],

      // More products here...
    };

    // Get the list of recipes for the selected product
    List<Map<String, dynamic>> recipesForProduct = cookRecipes[product] ?? [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text('Cook Recipes for $product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: recipesForProduct.length,
          itemBuilder: (context, index) {
            return Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network(recipesForProduct[index]
                        ['imageUrl']), // display image url
                    SizedBox(height: 8),
                    Text(recipesForProduct[index]['title'],
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Lato')),
                    SizedBox(height: 8),
                    for (var ingredient in recipesForProduct[index]
                        ['ingredients'])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          ingredient,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontFamily: 'Lato'),
                        ),
                      ),
                    SizedBox(height: 8),
                    for (var step in recipesForProduct[index]['steps'])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          step,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontFamily: 'Lato'),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
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
