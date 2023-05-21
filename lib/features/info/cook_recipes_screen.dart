import 'package:flutter/material.dart';

class CookRecipesPage extends StatelessWidget {
  final String? product;

  const CookRecipesPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        // More recipes for chicken...
      ],
      // More products here...
    };

    // Get the list of recipes for the selected product
    List<Map<String, dynamic>> recipesForProduct = cookRecipes[product] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Cook Recipes for $product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: recipesForProduct.length,
          itemBuilder: (context, index) {
            return Card(
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
                            fontFamily: 'Roboto')),
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
                              fontFamily: 'Roboto'),
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
                              fontFamily: 'Roboto'),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
