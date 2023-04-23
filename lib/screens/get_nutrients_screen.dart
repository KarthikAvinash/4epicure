import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import '../widgets/pie_graph.dart';

class getNutrientsScreen extends StatefulWidget {
  const getNutrientsScreen({super.key});

  @override
  State<getNutrientsScreen> createState() => _getNutrientsScreenState();
}

final _formKey = GlobalKey<FormState>();

final _ingredientController = TextEditingController();
final _quantityController = TextEditingController();

File? _imageFile;
List<String> _ingredients = [];
String? _calories;
String? _protein;
String? _carbs;
String? _fat;

class _getNutrientsScreenState extends State<getNutrientsScreen> {
  @override
  final Map<String, dynamic> nutrients = {};

  void _addIngredient() {
    setState(() {
      final ingredient = _ingredientController.text.trim();
      final quantity = _quantityController.text.trim();
      _ingredients.add('$quantity $ingredient');
      _ingredientController.clear();
      _quantityController.clear();
    });
  }

  Future<void> _getNutrientData() async {
    final apiKey = '27e2478852da65b9999df7eea78ec1e5';
    final ingr = _ingredients
        .map((ingredient) => Uri.encodeComponent(ingredient))
        .join('%0D%0A');
    final url =
        'https://api.edamam.com/api/nutrition-data?app_id=a91a4cfb&app_key=$apiKey&ingr=$ingr';
    final response = await http.get(Uri.parse(url));
    print(response.body);
    final nutrientData = json.decode(response.body);
    setState(() {
      _calories = nutrientData['calories'].toStringAsFixed(1);
      _protein = nutrientData['totalNutrients']['PROCNT']['quantity']
          .toStringAsFixed(1);
      _carbs = nutrientData['totalNutrients']['CHOCDF']['quantity']
          .toStringAsFixed(1);
      _fat =
          nutrientData['totalNutrients']['FAT']['quantity'].toStringAsFixed(1);
      _ingredientController.clear();
      _quantityController.clear();
      // _ingredients = {
      //   'protei' : _protein,

      // };
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _calories = null;
                _protein = null;
                _carbs = null;
                _fat = null;
                _ingredients.clear();
              });
              Navigator.of(context).pop();
            },
          ),
          title: Text('Get Nutrients'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ingredientController,
                            decoration: InputDecoration(
                              labelText: '<quantity> <unit> <ingredient>',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: _addIngredient,
                          child: Text('Add'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    if (_ingredients.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ingredients:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.0),
                          for (final ingredient in _ingredients)
                            Text('• $ingredient'),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _getNutrientData();
                        }
                      },
                      child: Text('Get Nutrient Information'),
                    ),
                    SizedBox(height: 16.0),
                    if (_calories != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nutrient Information:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.0),
                          Text('Calories: $_calories kcal'),
                          Text('Protein: $_protein g'),
                          Text('Carbs: $_carbs g'),
                          Text('Fat: $_fat g'),
                        ],
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
