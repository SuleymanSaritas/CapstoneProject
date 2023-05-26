import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../profile/my_benefit_history.dart';

class CompostSolutionPage extends StatelessWidget {
  final String? product;

  const CompostSolutionPage({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Product compost solutions, title and image url holding a dictionary
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
                  primary: Colors.deepPurple,
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
                  primary: Colors.deepPurple,
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
      await _addBenefitToCurrentUser(product!, weight, "Compost");
    }

    Map<String, List<dynamic>> compostSolutions = {
      'apple': [
        'Here is  a step-by-step guide on how to make compost from apple waste',
        [
          '1. Collect Apple Scraps: Gather apple cores, peels, and any other leftover apple parts. It is best to use organic apples to avoid introducing pesticides or other chemicals into your compost.',
          '2. Shred or Chop the Apple Scraps: If you have a large quantity of apple scraps, it is a good idea to shred or chop them into smaller pieces. This will help speed up the decomposition process.',
          '3. Mix with Other Organic Materials: Composting works best when you have a balanced mix of green and brown materials. Apple scraps fall into the "green" category, which is high in nitrogen. To balance this, add brown materials such as dry leaves, straw, or shredded newspaper. Aim for a ratio of roughly three parts brown material to one part green material.',
          '4. Add Additional Composting Ingredients: To enhance the composting process, you can add other organic materials such as grass clippings, vegetable scraps, coffee grounds, or eggshells. These will contribute to a diverse nutrient profile and help maintain the right moisture level. ',
          '5. Create Compost Pile or Bin: Choose a suitable location in your garden to create a compost pile or use a compost bin. Ideally, the site should be well-drained and easily accessible. ',
          '6. Layer the Compost Materials: Start by laying a layer of brown materials, such as dry leaves or straw, as the base of your compost pile. Then add a layer of apple scraps on top. Continue layering brown and green materials, ensuring each layer is relatively thin (about 3-4 inches thick). ',
          '7. Maintain Moisture: Compost needs moisture to break down properly. Ensure that the compost pile remains moist, similar to a damp sponge. If it is too dry, sprinkle some water; if it is too wet, add more dry materials to absorb excess moisture. ',
          '8. Turn the Compost Pile: Every few weeks, use a garden fork or shovel to turn the compost pile. This helps aerate the materials and speeds up decomposition. Turning also helps distribute moisture and promotes uniform decomposition. ',
          '9. Monitor the Composting Process: Over time, the compost pile will heat up as decomposition occurs. This is a sign that the composting process is happening. You may also notice the pile shrinking in size. If you are monitoring the internal temperature, aim for temperatures between 120-150°F (49-66°C) for optimal decomposition. ',
          '10. Allow for Decomposition: Depending on the environmental conditions and the size of the apple scraps, composting can take several months to a year. During this time, regularly turn the pile and monitor the moisture levels. The compost is ready to use when it has a dark, crumbly texture and a pleasant earthy smell. ',
          '11. Use the Finished Compost: Once the compost has fully decomposed, it can be used in your garden beds, potted plants, or as a top dressing for lawns. The rich nutrients will help improve soil structure, retain moisture, and nourish your plants. '
        ],
        'https://waste-management-world.com/imager/media/wasteManagementWorld/809110/3645_472cff0c4144c55bd3c7a71085cee21f.jpg'
      ],
      'onion': [
        'Here is  a step-by-step guide on how to make compost from onion waste',
        [
          '1. Collect onion scraps: Save onion peels, ends, and any other onion scraps from your kitchen. It is best to use organic onions to avoid introducing chemicals or pesticides into your compost.',
          '2. Prepare a compost bin: Choose a suitable composting container or bin. It can be a simple DIY bin made of wood or a ready-made compost bin. Ensure it has good drainage and aeration.',
          '3. Layer the compost bin: Start by creating a layer of carbon-rich "browns." This can include materials like dried leaves, straw, shredded newspaper, or cardboard. This layer helps create air pockets in the compost pile and prevents it from becoming too compacted.',
          '4. Add onion scraps: Place a layer of onion scraps on top of the browns. Spread them evenly to encourage decomposition.',
          '5. Add nitrogen-rich "greens": To balance the carbon-to-nitrogen ratio in your compost, add a layer of nitrogen-rich "greens." These can include materials like grass clippings, vegetable scraps, coffee grounds, or fresh green garden waste.',
          '6. Moisten the compost: To promote decomposition, the compost pile should be kept moist but not waterlogged. Use a garden hose or a watering can to add some water. The compost should be damp, similar to a squeezed-out sponge.',
          '7. Repeat the layering: Continue to alternate layers of browns and greens, including onion scraps, until you have used up all your materials. Aim for a ratio of approximately 3 parts browns to 1 part greens.',
          '8. Turn the compost: Every few weeks, use a garden fork or shovel to turn the compost. This helps aerate the pile, speeds up decomposition, and prevents odors. If you notice the pile becoming too dry, add a little water.',
          '9. Monitor the compost: Over time, the compost will break down into a dark, crumbly material. It should have an earthy smell. If the pile smells foul, it may be too wet or lack enough airflow. Adjust moisture levels or add more dry browns as needed.',
          '10. Harvest the compost: After several months to a year, depending on the conditions and the size of the onion scraps, your compost should be ready. It will have transformed into a nutrient-rich soil amendment. Use a screen or sifter to remove any larger pieces that have not fully decomposed.',
          '11. Use the compost: Apply the finished compost to your garden beds, containers, or plants. It will enrich the soil, improve moisture retention, and support plant growth.'
        ],
        'https://live-production.wcms.abc-cdn.net.au/8872b9d1df4c9e0f59621ebf58ca3d08?impolicy=wcms_crop_resize&cropH=719&cropW=1280&xPos=0&yPos=0&width=862&height=485'
      ],
      'bread': [
        'Here is how you can incorporate bread into your composting process:',
        [
          '1. Collect Bread Scraps: Gather any leftover bread, including stale bread, bread crusts, or even moldy bread. it is best to remove any packaging or non-organic materials before composting.',
          '2. Tear or Cut the Bread into Smaller Pieces: To speed up the decomposition process, tear or cut the bread into smaller pieces. This will increase the surface area and help the bread break down more quickly.',
          '3. Mix with Other Organic Materials: Like with any composting process, it is important to have a balance of green and brown materials. Bread is considered a high-nitrogen or "green" material. To balance this, add brown materials such as dry leaves, straw, or shredded newspaper. Aim for a ratio of approximately three parts brown material to one part green material.',
          '4. Add Additional Composting Ingredients: To enhance the composting process and create a nutrient-rich compost, you can add other organic materials. This includes things like fruit and vegetable scraps, coffee grounds, tea leaves, or eggshells. These additional ingredients will contribute to a diverse nutrient profile.',
          '5. Layer the Compost Materials: Start by creating a layer of brown materials, such as dry leaves or straw, as the base of your compost pile or bin. Then add a layer of bread scraps on top. Continue layering brown and green materials, ensuring each layer is relatively thin (about 3-4 inches thick).',
          '6. Maintain Moisture: Compost requires moisture to break down properly. Ensure that the compost pile remains moist, similar to a damp sponge. If it is too dry, sprinkle some water; if it is too wet, add more dry materials to absorb excess moisture.',
          '7. Turn the Compost Pile: Every few weeks, use a garden fork or shovel to turn the compost pile. This helps aerate the materials, distribute moisture, and promote uniform decomposition. Turning also helps accelerate the composting process.',
          '8. Monitor the Composting Process: Over time, the bread scraps will break down and contribute to the overall decomposition of the compost pile. Monitor the internal temperature of the pile, aiming for temperatures between 120-150°F (49-66°C) for optimal decomposition. Regularly turn the pile and adjust moisture levels as needed.',
          '9. Allow for Decomposition: Composting bread may take a bit longer than other organic materials due to its starchy nature. Depending on the environmental conditions and the size of the bread scraps, composting can take several months to a year. Be patient and continue regular maintenance.',
          '10. Use the Finished Compost: Once the compost has fully decomposed, it can be used in your garden beds, potted plants, or as a top dressing for lawns. The nutrients in the compost will enrich the soil and support healthy plant growth.'
        ],
        'https://www.bakeryandsnacks.com/var/wrbm_gb_food_pharma/storage/images/_aliases/wrbm_large/publications/food-beverage-nutrition/bakeryandsnacks.com/article/2022/02/15/ramping-up-the-bakery-waste-message/13242025-1-eng-GB/Ramping-up-the-bakery-waste-message.jpg'
      ]
    };

    // Get the compost solution, title and image url of the selected product
    List<dynamic> compostSolutionAndImage =
        compostSolutions[product] ?? ['', [], ''];

    return Scaffold(
      appBar: AppBar(
        title: Text('Compost Solution for $product'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(compostSolutionAndImage[2]), // display image url
              SizedBox(height: 8),
              Text(compostSolutionAndImage[0],
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Roboto')),
              SizedBox(height: 8),
              for (var step in compostSolutionAndImage[1])
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
