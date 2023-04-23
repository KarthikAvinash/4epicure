import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/grocery_item.dart';
import 'package:shimmer/shimmer.dart';
import '../globals.dart';

class GroceryScreen extends StatefulWidget {
  GroceryScreen();

  @override
  _GroceryScreenState createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _fetchGroceryItems();
  }

  Future<void> _fetchGroceryItems() async {
    try {
      final response = await http.get(Uri.parse(
          'https://recipenutrition.pythonanywhere.com/grocery-items/get-usr-grocery/${user_id}/'));
      final responseData = json.decode(response.body) as List<dynamic>;
      print("@@@@@@@@@");
      if (response.statusCode == 200) {
        // final jsonResponse = json.decode(response.body);
        print(responseData);
        setState(() {
          _groceryItems = List<GroceryItem>.from(
              responseData.map((item) => GroceryItem.fromJson(item)));
        });
      } else {
        throw Exception('Failed to load grocery items');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load grocery items'),
      ));
    }
  }

  Future<bool> deleteRecipe(int recipeId) async {
    print("ID:==========>${recipeId}");
    final url = Uri.parse(
        'https://recipenutrition.pythonanywhere.com/grocery/delete/${recipeId}/');
    final response = await http.delete(url);
    if (response.statusCode == 204) {
      print('Recipe deleted successfully!');
      return true;
    } else {
      print('Failed to delete recipe: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
      ),
      body: _groceryItems.isEmpty
          ? _buildShimmerEffect()
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) async {
                    final recipeDeleted =
                        await deleteRecipe(_groceryItems[index].id);
                    if (!recipeDeleted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to delete recipe!'),
                      ));
                    } else {
                      setState(() {
                        _groceryItems.removeAt(index);
                      });
                      print('Deleted recipe successfully!');
                    }
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Card(
                    key: ValueKey<int>(_groceryItems[index].id),
                    child: ListTile(
                      title: Text(_groceryItems[index].title),
                      subtitle: Text(
                          '${_groceryItems[index].quantity} ${_groceryItems[index].units}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildShimmerEffect() {
    if (_groceryItems.isEmpty) {
      return Center(
        child: Text(
          'No groceries yet',
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              title: SizedBox(
                height: 70,
                child: Container(color: Colors.white),
              ),
            );
          },
        ),
      );
    }
  }

  void _showEditDialog(int index) async {
    final quantityController =
        TextEditingController(text: _groceryItems[index].quantity.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Quantity'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  _groceryItems[index].quantity = quantityController.text;
                });
                // Call a function to update the database with the new quantity value.
                _updateQuantityInDatabase(index, _groceryItems[index].quantity);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateQuantityInDatabase(int index, String newQuantity) async {
    final item = _groceryItems[index];
    final url =
        'https://recipenutrition.pythonanywhere.com/grocery-items/${user_id}/${item.id}/modify/';
    final response = await http.patch(Uri.parse(url),
        body: json.encode({
          'id': item.id,
          'user': user_id,
          'title': item.title,
          'quantity': newQuantity,
          'unit': item.units
        }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      setState(() {
        _groceryItems[index].quantity = newQuantity;
      });
    } else {
      throw Exception('Failed to update quantity in database');
    }
  }
}
