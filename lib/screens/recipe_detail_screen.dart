import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart';

// void sendData(String title, String quantity, String unit) async {
//   var url = Uri.parse(
//       'https://recipenutrition.pythonanywhere.com/users/${user_id}/grocery-items/');
//   var response = await http
//       .post(url, body: {'title': title, 'quantity': quantity, 'unit': unit});
//   print('Response status: ${response.statusCode}');
//   print('Response body: ${response.body}');
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void sendData(BuildContext context, String title, String quantity, String unit) async {
  var url = Uri.parse(
      'https://recipenutrition.pythonanywhere.com/users/${user_id}/grocery-items/');
  var response = await http
      .post(url, body: {'title': title, 'quantity': quantity, 'unit': unit});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 201) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success!'),
          content: Text('$title has been added to your cart.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class RecipePage extends StatelessWidget {
  static const routeName = '/recipe-detail';
  List<List<String>> separateIngredientsAndQuantities(
      List<dynamic> ingredientsWithQty) {
    List<String> ingredients = [];
    List<String> quantities = [];

    for (int i = 0; i < ingredientsWithQty.length; i++) {
      String ingredient = ingredientsWithQty[i]['name'];
      String quantity =
          '${ingredientsWithQty[i]['quantity']} ${ingredientsWithQty[i]['unit']}';
      ingredients.add(ingredient);
      quantities.add(quantity);
    }
    return [ingredients, quantities];
  }

  final String recipeName;
  final String recipeImage;
  final List<dynamic> ingredientsWithQty;
  final List<dynamic> recipeSteps;
  final String description;
  RecipePage({
    required this.recipeName,
    required this.recipeImage,
    required this.ingredientsWithQty,
    required this.recipeSteps,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final List<List<String>> separatedIngredientsAndQuantities =
        separateIngredientsAndQuantities(ingredientsWithQty);
    final List<String> Ingredients = separatedIngredientsAndQuantities[0];
    final List<String> Quantities = separatedIngredientsAndQuantities[1];
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Recipe image
            Card(
              elevation: 5,
              child: Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  recipeImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Recipe description card
            Card(
              margin: EdgeInsets.all(20),
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipe description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Ingredients card
            Card(
              margin: EdgeInsets.all(20),
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Ingredients',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Qty',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Cart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: Ingredients.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    Ingredients[index],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              Quantities[index],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                String str = Quantities[index];
                                String part1 =
                                    str.substring(0, str.indexOf(' '));
                                String part2 =
                                    str.substring(str.indexOf(' ') + 1);

                                sendData(context,
                                    Ingredients[index], part1, part2);
                              },
                              icon: Icon(Icons.add_shopping_cart),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ), // Recipe steps card
            Card(
              margin: EdgeInsets.all(20),
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipe steps',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: recipeSteps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ${recipeSteps[index]['step']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              if (recipeSteps[index]['image_url'] != null)
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  child: Image.network(
                                    recipeSteps[index]['image_url']!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
