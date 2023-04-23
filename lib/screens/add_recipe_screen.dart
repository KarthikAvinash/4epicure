// TODO Implement this library.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class CreateRecipeScreen extends StatefulWidget {
  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  List<String> _ingredients = [];
  List<String> _steps = [];
  String? _calories;
  String? _protein;
  String? _carbs;
  String? _fat;

  final _ingredientController = TextEditingController();
  final _quantityController = TextEditingController();
  final _stepController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();



  void _addIngredient() {
    setState(() {
      final ingredient = _ingredientController.text.trim();
      final quantity = _quantityController.text.trim();
      _ingredients.add('$quantity $ingredient');
      _ingredientController.clear();
      _quantityController.clear();
    });
  }

  void _addStep() {
    setState(() {
      _steps.add(_stepController.text);
      _stepController.clear();
    });
  }
// xxx
  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _imageFile = File(pickedFile.path);
      final imagePath = _imageFile!.path;
      print(imagePath);
    });
  }
}
//  xx

  Future<void> _getNutrientData() async {
    final apiKey = '27e2478852da65b9999df7eea78ec1e5';
  final ingr = _ingredients.map((ingredient) => Uri.encodeComponent(ingredient)).join('%0D%0A');
    final url = 'https://api.edamam.com/api/nutrition-data?app_id=a91a4cfb&app_key=$apiKey&ingr=$ingr';
    final response = await http.get(Uri.parse(url));
    print(response.body);
    final nutrientData = json.decode(response.body);
    setState(() {
      _calories = nutrientData['calories'].toStringAsFixed(1);
      _protein = nutrientData['totalNutrients']['PROCNT']['quantity'].toStringAsFixed(1);
      _carbs = nutrientData['totalNutrients']['CHOCDF']['quantity'].toStringAsFixed(1);
      _fat = nutrientData['totalNutrients']['FAT']['quantity'].toStringAsFixed(1);
    });
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_imageFile != null) ...[
                  Image.file(_imageFile!),
                  SizedBox(height: 16.0),
                ],
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Add Photo'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller:_titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Text('Ingredients', style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 16.0),
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
            if(_ingredients.isNotEmpty) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  for (final ingredient in _ingredients)
                    Text('• $ingredient'),
                ],
              ),
              SizedBox(height: 16.0),
            ],
            Text('Steps', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stepController,
                    decoration: InputDecoration(
                      labelText: 'Add Step',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _addStep,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_steps.isNotEmpty) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  for (var i = 0; i < _steps.length; i++)
                    Text('${i + 1}. ${_steps[i]}'),
                ],
              ),
              SizedBox(height: 16.0),
            ],
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _getNutrientData();
                }
              },
              child: Text('Get Nutrient Information'),
            ),
            SizedBox(height: 16.0),
            if (_calories != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nutrient Information:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text('Calories: $_calories kcal'),
                  Text('Protein: $_protein g'),
                  Text('Carbs: $_carbs g'),
                  Text('Fat: $_fat g'),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  ),
);
  }
}